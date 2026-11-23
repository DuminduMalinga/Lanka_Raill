-- Track where each row came from and when a person checked it
alter table public.stations     add column source text, add column verified_at timestamptz;
alter table public.trains       add column source text, add column verified_at timestamptz;
alter table public.train_stops  add column source text, add column verified_at timestamptz;
alter table public.destinations add column source text, add column verified_at timestamptz;

-- Stop times must move forward along a train's route
alter table public.train_stops
  add constraint train_stops_order_positive check (stop_order > 0);

-- Public bucket for station / train / destination photos.
-- Public = anyone can view by URL; uploads only via dashboard or service role.
-- NOTE: superseded by the destination-/station-/train-photos buckets; this
-- 'photos' bucket is empty and can be deleted from the Storage dashboard.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('photos', 'photos', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;
