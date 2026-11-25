-- Each profile photo change wrote a new <uid>/avatar-<timestamp>.<ext> object and
-- old ones were never deleted, so one account could upload unlimited 2 MB
-- files. A user may now write exactly one object, <uid>/avatar; the app
-- overwrites it (upsert) and stores a cache-busting version in the URL.
-- Reading own objects is allowed so the app can overwrite (upsert) and tidy
-- up files left by older versions; the bucket stays public by URL.
drop policy if exists "Avatar insert own folder" on storage.objects;
drop policy if exists "Avatar update own folder" on storage.objects;
drop policy if exists "Avatar delete own folder" on storage.objects;

create policy "Avatar select own folder" on storage.objects for select to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);

create policy "Avatar insert own file" on storage.objects for insert to authenticated
  with check (bucket_id = 'avatars' and name = (select auth.uid())::text || '/avatar');

create policy "Avatar update own file" on storage.objects for update to authenticated
  using (bucket_id = 'avatars' and name = (select auth.uid())::text || '/avatar')
  with check (bucket_id = 'avatars' and name = (select auth.uid())::text || '/avatar');

create policy "Avatar delete own folder" on storage.objects for delete to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);
