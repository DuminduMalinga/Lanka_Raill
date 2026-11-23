-- Photo credits (Wikimedia Commons licences require attribution).
alter table public.stations           add column photo_credit text, add column photo_source_url text;
alter table public.trains             add column photo_credit text, add column photo_source_url text;
alter table public.destinations       add column cover_photo_credit text, add column cover_photo_source_url text;
alter table public.destination_photos add column credit text, add column source_url text;

-- Direct trains between two stations, in departure order.
-- Times are minutes since midnight of the departure day (day_offset applied),
-- so overnight trains sort and compute duration correctly.
create function public.search_journeys(from_code text, to_code text)
returns table (
  train_id uuid,
  train_number text,
  train_name_en text,
  train_name_si text,
  train_type text,
  runs_on text,
  depart_time time,
  arrive_time time,
  depart_day smallint,
  arrive_day smallint,
  duration_minutes integer,
  stops_between integer,
  verified boolean
)
language sql
stable
security invoker
set search_path = ''
as $$
  select
    t.id, t.number, t.name_en, t.name_si, t.type, t.runs_on,
    coalesce(a.depart_time, a.arrive_time),
    coalesce(b.arrive_time, b.depart_time),
    a.day_offset, b.day_offset,
    ((b.day_offset * 1440 + extract(epoch from coalesce(b.arrive_time, b.depart_time)) / 60)
     - (a.day_offset * 1440 + extract(epoch from coalesce(a.depart_time, a.arrive_time)) / 60))::integer,
    (b.stop_order - a.stop_order - 1)::integer,
    (a.verified_at is not null and b.verified_at is not null)
  from public.train_stops a
  join public.train_stops b on b.train_id = a.train_id and b.stop_order > a.stop_order
  join public.trains t on t.id = a.train_id
  join public.stations sa on sa.id = a.station_id and sa.code = from_code
  join public.stations sb on sb.id = b.station_id and sb.code = to_code
  order by coalesce(a.depart_time, a.arrive_time);
$$;
grant execute on function public.search_journeys(text, text) to anon, authenticated;

-- One row per train with its first and last stop, for list screens.
create view public.train_summaries
with (security_invoker = true) as
select
  t.id, t.number, t.name_en, t.name_si, t.type, t.runs_on, t.line_id,
  t.photo_url, t.photo_credit, t.verified_at, t.source,
  o.station_id  as origin_station_id,
  so.code       as origin_code,
  so.name_en    as origin_name_en,
  so.name_si    as origin_name_si,
  coalesce(o.depart_time, o.arrive_time) as depart_time,
  d.station_id  as destination_station_id,
  sd.code       as destination_code,
  sd.name_en    as destination_name_en,
  sd.name_si    as destination_name_si,
  coalesce(d.arrive_time, d.depart_time) as arrive_time,
  d.day_offset  as arrive_day,
  ((d.day_offset * 1440 + extract(epoch from coalesce(d.arrive_time, d.depart_time)) / 60)
   - (o.day_offset * 1440 + extract(epoch from coalesce(o.depart_time, o.arrive_time)) / 60))::integer
                as duration_minutes,
  (select count(*) from public.train_stops x where x.train_id = t.id)::integer as stop_count
from public.trains t
join lateral (select * from public.train_stops s where s.train_id = t.id order by stop_order limit 1) o on true
join lateral (select * from public.train_stops s where s.train_id = t.id order by stop_order desc limit 1) d on true
join public.stations so on so.id = o.station_id
join public.stations sd on sd.id = d.station_id;
grant select on public.train_summaries to anon, authenticated;
