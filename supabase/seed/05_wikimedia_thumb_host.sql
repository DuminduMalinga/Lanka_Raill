-- Serve Wikimedia Commons photos from thumb.wikimedia.org.
-- upload.wikimedia.org answers app requests with 429 Too Many Requests, so
-- photos linked there showed as blank placeholders in the app. The thumbnail
-- host serves the same images. Originals become standard 960px thumbnails.
-- Safe to re-run (only rewrites upload.wikimedia.org URLs).
create or replace function pg_temp.wm(u text) returns text language sql immutable as $$
  select case
    when u like 'https://upload.wikimedia.org/wikipedia/commons/thumb/%'
      then replace(u, 'https://upload.wikimedia.org/', 'https://thumb.wikimedia.org/')
    when u ~ '^https://upload\.wikimedia\.org/wikipedia/commons/[0-9a-f]/[0-9a-f]{2}/[^/]+$'
      then regexp_replace(u,
        '^https://upload\.wikimedia\.org/wikipedia/commons/([0-9a-f])/([0-9a-f]{2})/([^/]+)$',
        'https://thumb.wikimedia.org/wikipedia/commons/thumb/\1/\2/\3/960px-\3')
    else u
  end
$$;

update public.destination_photos set url = pg_temp.wm(url) where url like 'https://upload.wikimedia.org/%';
update public.destinations set cover_photo_url = pg_temp.wm(cover_photo_url) where cover_photo_url like 'https://upload.wikimedia.org/%';
update public.stations set photo_url = pg_temp.wm(photo_url) where photo_url like 'https://upload.wikimedia.org/%';
update public.trains set photo_url = pg_temp.wm(photo_url) where photo_url like 'https://upload.wikimedia.org/%';
