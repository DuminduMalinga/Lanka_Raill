-- In-app feedback (Help & feedback screen). Anyone can submit; nobody can
-- read it back through the API — review it in the dashboard.
create table public.feedback (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete set null default auth.uid(),
  rating smallint check (rating between 1 and 5),
  message text not null check (char_length(btrim(message)) between 1 and 4000),
  app_version text,
  created_at timestamptz not null default now()
);

alter table public.feedback enable row level security;

create policy "Anyone can send feedback" on public.feedback
  for insert to anon, authenticated
  with check (user_id is null or user_id = (select auth.uid()));

revoke select, update, delete on public.feedback from anon, authenticated;
