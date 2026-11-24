-- search_journeys is callable by anyone, so bound the work it can be asked to
-- do: codes must look like station codes (2-8 characters), and at most 50
-- options are returned. (The running time is already capped by Supabase's
-- role timeouts: 3 s for anon, 8 s for signed-in users.)
create or replace function public.search_journeys(from_code text, to_code text)
 returns table(train_id uuid, train_number text, train_name_en text, train_name_si text, train_type text, runs_on text, depart_time time without time zone, arrive_time time without time zone, depart_day smallint, arrive_day smallint, duration_minutes integer, stops_between integer, verified boolean)
 language sql
 stable
 set search_path to ''
as $function$
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
  where char_length(from_code) between 2 and 8
    and char_length(to_code) between 2 and 8
  order by coalesce(a.depart_time, a.arrive_time)
  limit 50;
$function$;
