-- Staging table for timetable CSV imports (Table Editor -> Import CSV).
-- Uses human keys (train number, station code) instead of UUIDs.
-- RLS on with no policies: only the dashboard / service role can use it.
create table public.timetable_import (
  train_number text not null,
  station_code text not null,
  stop_order   integer not null,
  arrive_time  time,
  depart_time  time,
  day_offset   smallint not null default 0,
  is_major     boolean not null default false,
  source       text not null,
  primary key (train_number, stop_order)
);
alter table public.timetable_import enable row level security;
revoke all on public.timetable_import from anon, authenticated;

-- Moves staged rows into train_stops, replacing each imported train's stops.
-- Fails (and changes nothing) if a train number or station code is unknown.
create function public.import_timetable()
returns table (train_number text, stops_loaded bigint)
language plpgsql
set search_path = ''
as $$
declare missing text;
begin
  select string_agg(distinct 'train ' || i.train_number, ', ') into missing
  from public.timetable_import i
  where not exists (select 1 from public.trains t where t.number = i.train_number);
  if missing is not null then
    raise exception 'Unknown trains (add them to public.trains first): %', missing;
  end if;

  select string_agg(distinct 'station ' || i.station_code, ', ') into missing
  from public.timetable_import i
  where not exists (select 1 from public.stations s where s.code = i.station_code);
  if missing is not null then
    raise exception 'Unknown station codes (add them to public.stations first): %', missing;
  end if;

  delete from public.train_stops ts
  using public.trains t
  where ts.train_id = t.id
    and t.number in (select distinct i.train_number from public.timetable_import i);

  insert into public.train_stops
    (train_id, station_id, stop_order, arrive_time, depart_time, day_offset, is_major, source)
  select t.id, s.id, i.stop_order, i.arrive_time, i.depart_time, i.day_offset, i.is_major, i.source
  from public.timetable_import i
  join public.trains t on t.number = i.train_number
  join public.stations s on s.code = i.station_code;

  return query
    select i.train_number, count(*) from public.timetable_import i group by i.train_number;

  delete from public.timetable_import;
end;
$$;
revoke execute on function public.import_timetable() from public, anon, authenticated;
