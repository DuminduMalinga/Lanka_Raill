# CeylonGO data (Supabase)

Project: **Lanka_Rail** (`prcmausakhaswaidsamz`).

```
supabase/
  migrations/   schema, in the order applied to the live project
  seed/         reference data (stations, destinations, …) — safe to re-run
  templates/    empty CSVs with the right headers for Table Editor imports
```

## What is already loaded

| Data | Status |
|---|---|
| Railway lines, facilities, destination categories | Loaded, English + Sinhala |
| 36 stations (codes, Sinhala names, coordinates) | Loaded, `source = 'seed-unverified'` — **check codes and coordinates** |
| Trains 1005/1006 Podi Menike, 1015/1016 Udarata Menike | Identity only, no times |
| 13 destinations with tags and nearest stations | Loaded, `seed-unverified` |
| **Timetable (`train_stops`)** | **Empty** — must come from an official source |
| Photos | None uploaded yet |

## Entering the timetable

Times must come from an official Sri Lanka Railways source (printed
timetable, station notice, or the SLR schedule site once it is back). Do not
copy from booking or blog sites — they disagree with each other.

1. Make sure every train exists in `trains` (Table Editor, or import
   `templates/trains.csv`).
2. Fill in `templates/timetable_import.csv`, one row per stop:

   | column | example | notes |
   |---|---|---|
   | `train_number` | `1005` | must match `trains.number` |
   | `station_code` | `ELL` | must match `stations.code` |
   | `stop_order` | `1`, `2`, `3` … | origin is 1 |
   | `arrive_time` | `14:05` | empty at the origin |
   | `depart_time` | `14:08` | empty at the destination |
   | `day_offset` | `0` | `1` for stops after midnight on overnight trains |
   | `is_major` | `true` | shown in the short stop list |
   | `source` | `SLR timetable 2025-12-02, p.14` | where you read it |

3. Dashboard → Table Editor → `timetable_import` → **Insert → Import data
   from CSV**.
4. SQL Editor:

   ```sql
   select * from import_timetable();   -- replaces the stops of each imported train
   select * from timetable_issues;     -- must return no rows before publishing
   ```

   `import_timetable()` refuses unknown train numbers or station codes and
   changes nothing in that case.
5. After a second person has checked the times against the source:

   ```sql
   update train_stops set verified_at = now()
   where train_id = (select id from trains where number = '1005');
   ```

## Verifying stations and destinations

```sql
-- what still needs checking
select code, name_en, lat, lng from stations where verified_at is null order by code;

-- after checking one
update stations set verified_at = now(), source = 'checked on map' where code = 'ELL';
```

## Photos

Buckets (public read, uploads from the dashboard only):
`destination-photos`, `station-photos`, `train-photos`.

1. Storage → bucket → upload (JPEG/PNG/WebP, max 5 MB). Use paths like
   `nine-arch-bridge/01.jpg`.
2. Copy the public URL and add it:

   ```sql
   insert into destination_photos (destination_id, url, sort)
   select id, '<public url>', 1 from destinations where name_en = 'Nine Arch Bridge';
   update destinations set cover_photo_url = '<public url>' where name_en = 'Nine Arch Bridge';
   ```

Only upload photos you took or have the rights to use.

The empty `photos` bucket is a leftover and can be deleted from Storage.
