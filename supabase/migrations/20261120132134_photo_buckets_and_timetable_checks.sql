-- Overnight trains: which day (0 = departure day) each time falls on.
alter table public.train_stops
  add column day_offset smallint not null default 0 check (day_offset between 0 and 2),
  add constraint train_stops_stop_order_positive check (stop_order > 0);

-- Photo buckets: public read by URL, uploads only with the service role.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('destination-photos', 'destination-photos', true, 5242880, array['image/jpeg','image/png','image/webp']),
  ('station-photos',     'station-photos',     true, 5242880, array['image/jpeg','image/png','image/webp']),
  ('train-photos',       'train-photos',       true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;

-- Timetable problems to fix before publishing. Admin only.
create view public.timetable_issues
with (security_invoker = true) as
with s as (
  select
    ts.*,
    t.number as train_number,
    t.name_en as train_name,
    st.code as station_code,
    count(*) over (partition by ts.train_id) as stop_count,
    row_number() over (partition by ts.train_id order by ts.stop_order) as seq,
    case when ts.arrive_time is not null
      then ts.day_offset * 1440 + extract(epoch from ts.arrive_time) / 60 end as arr_min,
    case when ts.depart_time is not null
      then ts.day_offset * 1440 + extract(epoch from ts.depart_time) / 60 end as dep_min
  from public.train_stops ts
  join public.trains t on t.id = ts.train_id
  join public.stations st on st.id = ts.station_id
),
o as (
  select s.*,
    lag(coalesce(dep_min, arr_min)) over (partition by train_id order by stop_order) as prev_min,
    lag(station_code) over (partition by train_id order by stop_order) as prev_code
  from s
)
select train_number, train_name, stop_order, station_code, 'Origin has no departure time' as issue
  from o where seq = 1 and depart_time is null
union all
select train_number, train_name, stop_order, station_code, 'Destination has no arrival time'
  from o where seq = stop_count and stop_count > 1 and arrive_time is null
union all
select train_number, train_name, stop_order, station_code, 'Intermediate stop has no times'
  from o where seq > 1 and seq < stop_count and arrive_time is null and depart_time is null
union all
select train_number, train_name, stop_order, station_code, 'Departs before it arrives'
  from o where arr_min is not null and dep_min is not null and dep_min < arr_min
union all
select train_number, train_name, stop_order, station_code,
       'Earlier than previous stop ' || prev_code || ' (set day_offset if past midnight)'
  from o where prev_min is not null and coalesce(arr_min, dep_min) < prev_min
union all
select train_number, train_name, stop_order, station_code, 'Dwell longer than 60 min (check)'
  from o where dep_min - arr_min > 60
union all
select train_number, train_name, stop_order, station_code, 'Gap of more than 5 h from previous stop (check)'
  from o where prev_min is not null and coalesce(arr_min, dep_min) - prev_min > 300
union all
select t.number, t.name_en, null, null, 'Train has fewer than 2 stops'
  from public.trains t
  where (select count(*) from public.train_stops ts where ts.train_id = t.id) < 2;

revoke all on public.timetable_issues from anon, authenticated;
