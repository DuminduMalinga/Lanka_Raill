-- Reference data ---------------------------------------------------------
create table public.railway_lines (
  id uuid primary key default gen_random_uuid(),
  name_en text not null,
  name_si text,
  color text,
  description_en text,
  description_si text,
  created_at timestamptz not null default now()
);

create table public.stations (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name_en text not null,
  name_si text,
  line_id uuid references public.railway_lines(id) on delete set null,
  district text,
  elevation_m integer,
  lat double precision,
  lng double precision,
  photo_url text,
  created_at timestamptz not null default now()
);
create index stations_line_id_idx on public.stations(line_id);

create table public.facilities (
  id uuid primary key default gen_random_uuid(),
  name_en text not null,
  name_si text,
  icon text
);

create table public.station_facilities (
  station_id uuid not null references public.stations(id) on delete cascade,
  facility_id uuid not null references public.facilities(id) on delete cascade,
  primary key (station_id, facility_id)
);
create index station_facilities_facility_idx on public.station_facilities(facility_id);

create table public.trains (
  id uuid primary key default gen_random_uuid(),
  number text not null unique,
  name_en text not null,
  name_si text,
  type text,
  line_id uuid references public.railway_lines(id) on delete set null,
  runs_on text default 'Daily',
  distance_km numeric,
  photo_url text,
  created_at timestamptz not null default now()
);
create index trains_line_id_idx on public.trains(line_id);

create table public.train_classes (
  id uuid primary key default gen_random_uuid(),
  train_id uuid not null references public.trains(id) on delete cascade,
  class_name text not null,
  reservable boolean not null default false,
  facilities text
);
create index train_classes_train_idx on public.train_classes(train_id);

create table public.train_stops (
  id uuid primary key default gen_random_uuid(),
  train_id uuid not null references public.trains(id) on delete cascade,
  station_id uuid not null references public.stations(id) on delete cascade,
  stop_order integer not null,
  arrive_time time,
  depart_time time,
  is_major boolean not null default false,
  unique (train_id, stop_order),
  unique (train_id, station_id)
);
create index train_stops_station_idx on public.train_stops(station_id);

create table public.train_highlights (
  id uuid primary key default gen_random_uuid(),
  train_id uuid not null references public.trains(id) on delete cascade,
  text_en text not null,
  text_si text
);
create index train_highlights_train_idx on public.train_highlights(train_id);

create table public.destination_categories (
  id uuid primary key default gen_random_uuid(),
  name_en text not null,
  name_si text,
  icon text
);

create table public.destinations (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.destination_categories(id) on delete set null,
  name_en text not null,
  name_si text,
  description_en text,
  description_si text,
  lat double precision,
  lng double precision,
  cover_photo_url text,
  created_at timestamptz not null default now()
);
create index destinations_category_idx on public.destinations(category_id);

create table public.destination_photos (
  id uuid primary key default gen_random_uuid(),
  destination_id uuid not null references public.destinations(id) on delete cascade,
  url text not null,
  sort integer not null default 0
);
create index destination_photos_dest_idx on public.destination_photos(destination_id);

create table public.destination_tags (
  destination_id uuid not null references public.destinations(id) on delete cascade,
  tag text not null,
  primary key (destination_id, tag)
);

create table public.destination_stations (
  destination_id uuid not null references public.destinations(id) on delete cascade,
  station_id uuid not null references public.stations(id) on delete cascade,
  walk_km numeric,
  primary key (destination_id, station_id)
);
create index destination_stations_station_idx on public.destination_stations(station_id);

create table public.announcements (
  id uuid primary key default gen_random_uuid(),
  title_en text not null,
  title_si text,
  body_en text,
  body_si text,
  severity text not null default 'info' check (severity in ('info','warning','critical')),
  train_id uuid references public.trains(id) on delete set null,
  starts_at timestamptz not null default now(),
  ends_at timestamptz
);
create index announcements_train_idx on public.announcements(train_id);

-- User data --------------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  language text not null default 'en',
  avatar_url text,
  created_at timestamptz not null default now()
);

create table public.favorite_trains (
  user_id uuid not null references auth.users(id) on delete cascade,
  train_id uuid not null references public.trains(id) on delete cascade,
  primary key (user_id, train_id)
);
create index favorite_trains_train_idx on public.favorite_trains(train_id);

create table public.favorite_stations (
  user_id uuid not null references auth.users(id) on delete cascade,
  station_id uuid not null references public.stations(id) on delete cascade,
  primary key (user_id, station_id)
);
create index favorite_stations_station_idx on public.favorite_stations(station_id);

create table public.favorite_destinations (
  user_id uuid not null references auth.users(id) on delete cascade,
  destination_id uuid not null references public.destinations(id) on delete cascade,
  primary key (user_id, destination_id)
);
create index favorite_destinations_dest_idx on public.favorite_destinations(destination_id);

-- Auto-create profile on signup
create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, new.raw_user_meta_data ->> 'display_name');
  return new;
end;
$$;
revoke execute on function public.handle_new_user() from public, anon, authenticated;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- RLS: public read-only reference tables ---------------------------------
do $$
declare t text;
begin
  foreach t in array array[
    'railway_lines','stations','facilities','station_facilities','trains',
    'train_classes','train_stops','train_highlights','destination_categories',
    'destinations','destination_photos','destination_tags','destination_stations',
    'announcements'
  ] loop
    execute format('alter table public.%I enable row level security', t);
    execute format('create policy "Public read" on public.%I for select to anon, authenticated using (true)', t);
  end loop;
end $$;

-- RLS: per-user tables ---------------------------------------------------
alter table public.profiles enable row level security;
create policy "Own profile select" on public.profiles for select to authenticated using ((select auth.uid()) = id);
create policy "Own profile insert" on public.profiles for insert to authenticated with check ((select auth.uid()) = id);
create policy "Own profile update" on public.profiles for update to authenticated using ((select auth.uid()) = id) with check ((select auth.uid()) = id);

do $$
declare t text;
begin
  foreach t in array array['favorite_trains','favorite_stations','favorite_destinations'] loop
    execute format('alter table public.%I enable row level security', t);
    execute format('create policy "Own rows select" on public.%I for select to authenticated using ((select auth.uid()) = user_id)', t);
    execute format('create policy "Own rows insert" on public.%I for insert to authenticated with check ((select auth.uid()) = user_id)', t);
    execute format('create policy "Own rows delete" on public.%I for delete to authenticated using ((select auth.uid()) = user_id)', t);
  end loop;
end $$;
