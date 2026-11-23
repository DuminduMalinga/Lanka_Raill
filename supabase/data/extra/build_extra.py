"""Builds supabase/seed/04_stations_routes_destinations.sql.

Adds to the existing data without overwriting it:
  * station coordinates from Wikipedia/Wikidata/OpenStreetMap for the
    existing (approximate) stations, plus ~70 more stations with Sinhala names
  * Puttalam and Kelani Valley Line trains (traintimetable.lk)
  * the operating names of numbered trains that are listed as "A – B"
  * 16 more destinations with Wikimedia Commons photos and credits

Rows are matched on natural keys (station code, train number, destination
name), so the file is safe to re-run.

    python supabase/data/extra/enrich_stations.py   # refresh cache/stations.json
    python supabase/data/extra/enrich_images.py     # refresh cache/images.json
    python supabase/data/extra/build_extra.py
"""
import json
import math
import pathlib
import re

from destinations import DESTINATIONS
from stations import LINE_STATIONS, STATION_NOTES  # noqa: F401  (notes kept for reference)
from trains import TRAINS

HERE = pathlib.Path(__file__).parent
OUT = HERE.parent.parent / "seed" / "04_stations_routes_destinations.sql"
COORDS = json.loads((HERE / "cache" / "stations.json").read_text("utf-8"))
IMAGES = json.loads((HERE / "cache" / "images.json").read_text("utf-8"))
TT_SOURCE = "traintimetable.lk (fetched 2026-11-23)"
# Prefer this photo as the cover (by title fragment).
COVER_FIRST = {"galle-face": "Colombo Galle Face Green"}
SKIP_PHOTO = re.compile(r"logo|resort|hotel|flag", re.I)

LINE_NAMES = {
    "main": "Main Line", "coastal": "Coastal Line", "northern": "Northern Line",
    "matale": "Matale Line", "puttalam": "Puttalam Line",
    "trincomalee": "Trincomalee Line", "batticaloa": "Batticaloa Line",
    "kelani_valley": "Kelani Valley Line",
}

# Stations already in the database: our name -> their code (their codes win).
EXISTING = {
    "Aluthgama": "ALT", "Anuradhapura": "ANP", "Badulla": "BAD", "Batticaloa": "BCO",
    "Bandarawela": "BDA", "Beliatta": "BLT", "Bentota": "BNT", "Demodara": "DDR",
    "Ella": "ELL", "Colombo Fort": "FOT", "Galle": "GLE", "Gal Oya": "GOY",
    "Gampola": "GPL", "Habarana": "HBN", "Hikkaduwa": "HKD", "Haputale": "HPT",
    "Hatton": "HTN", "Jaffna": "JFN", "Kandy": "KDT", "Kilinochchi": "KLN",
    "Kalutara South": "KTS", "Kurunegala": "KUR", "Maradana": "MDA",
    "Mount Lavinia": "MLV", "Matale": "MTL", "Matara": "MTR", "Negombo": "NGB",
    "Nanu Oya": "NOA", "Ohiya": "OHY", "Palai": "PAL", "Peradeniya Junction": "PDA",
    "Polgahawela": "PLG", "Polonnaruwa": "PLN", "Pattipola": "PTP",
    "Rambukkana": "RBK", "Ragama": "RGM", "Trincomalee": "TCO", "Talawakele": "TKL",
    "Unawatuna": "UNW", "Vavuniya": "VNA", "Weligama": "WLG",
}
TAKEN = set(EXISTING.values()) | {"TLP"}  # TLP = Talaimannar Pier

# Operating names for trains the timetable lists only by number.
TRAIN_NAMES = {
    "8085": ("Rajarata Rajini", "රජරට රැජිනි"), "8086": ("Rajarata Rajini", "රජරට රැජිනි"),
    "8056": ("Galu Kumari", "ගාලු කුමාරි"), "8057": ("Galu Kumari", "ගාලු කුමාරි"),
    "8096": ("Sagarika", "සාගරිකා"), "8097": ("Sagarika", "සාගරිකා"),
    "1023": ("Tikiri Menike", "ටිකිරි මැණිකේ"), "1024": ("Tikiri Menike", "ටිකිරි මැණිකේ"),
    "1035": ("Senkadagala Menike", "සෙංකඩගල මැණිකේ"),
    "6075": ("Pulathisi", "පුලතිසි"), "6076": ("Pulathisi", "පුලතිසි"),
}

# New routes to add (lines the database had no trains for).
NEW_TRAIN_LINES = {"puttalam", "kelani_valley"}

# Our category -> destination_categories.name_en, with per-place overrides.
CATEGORY = {"hill": "Hiking", "beaches": "Beaches", "heritage": "Heritage",
            "wildlife": "Wildlife", "north": "Temples", "views": "Scenic views"}
CATEGORY_OVERRIDE = {
    "nuwara-eliya": "Tea country", "liptons-seat": "Tea country",
    "dunhinda-falls": "Waterfalls", "jaffna-fort": "Heritage",
    "galle-face": "Scenic views",
}
# Existing destinations under another name — skipped.
DEST_EXISTS = {"nine-arch-bridge", "little-adams-peak", "horton-plains",
               "temple-of-the-tooth", "peradeniya-gardens", "galle-fort", "unawatuna",
               "anuradhapura", "polonnaruwa", "sigiriya", "jaffna-fort"}

DAYS = {
    (1, 2, 3, 4, 5, 6, 7): "Daily", (1, 2, 3, 4, 5): "Mon-Fri", (1, 2, 3, 4, 5, 6): "Mon-Sat",
    (6, 7): "Sat, Sun", (6,): "Sat", (7,): "Sun",
}


def q(v):
    if v is None:
        return "null"
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return repr(v)
    return "'" + str(v).replace("'", "''") + "'"


def km(a, b):
    la1, lo1, la2, lo2 = map(math.radians, (*a, *b))
    h = math.sin((la2 - la1) / 2) ** 2 + math.cos(la1) * math.cos(la2) * math.sin((lo2 - lo1) / 2) ** 2
    return 2 * 6371 * math.asin(math.sqrt(h))


def thumb_url(url):
    """Commons photo URL on thumb.wikimedia.org (upload.wikimedia.org answers
    app requests with 429). Originals become standard 960px thumbnails."""
    url = url.split("?")[0].replace("https://upload.wikimedia.org/", "https://thumb.wikimedia.org/")
    m = re.match(r"^(https://thumb\.wikimedia\.org/wikipedia/commons/)([0-9a-f]/[0-9a-f]{2}/)([^/]+)$", url)
    return f"{m[1]}thumb/{m[2]}{m[3]}/960px-{m[3]}" if m else url


def strip_si(si):
    if not si:
        return None
    suffix = r"\s*දුම්රිය\s*(ස්ථානය|නැවතුම්පොළ|මංසන්ධිය|පොළ)\s*$"
    return re.sub(suffix, "", si).strip() or None


def station_rows():
    rows, codes = [], {}
    for line_id, members in LINE_STATIONS.items():
        for name, my_code in members:
            if name in codes:
                continue
            code = EXISTING.get(name)
            if code is None:
                code = my_code
                if code in TAKEN or code in codes.values():
                    code = code[:2] + "X"
                    assert code not in TAKEN and code not in codes.values(), name
            codes[name] = code
            c = COORDS[name]
            rows.append({
                "code": code, "name": name, "si": strip_si(c.get("si")),
                "line": LINE_NAMES[line_id], "lat": round(c["lat"], 6),
                "lng": round(c["lng"], 6), "elev": c.get("elev"),
                "source": c.get("source") or "openstreetmap", "existing": name in EXISTING,
            })
    return rows, codes


def build():
    stations, codes = station_rows()
    sql = ["-- Generated by supabase/data/extra/build_extra.py - do not edit by hand.\n",
           "-- Additive: matches existing rows on natural keys and never deletes.\n\n"]

    # ---- stations ----------------------------------------------------------
    vals = ",\n  ".join(
        f"({q(s['code'])}, {q(s['name'])}, {q(s['si'])}, {q(s['line'])}, "
        f"{q(s['elev'])}, {s['lat']}, {s['lng']}, {q(s['source'])})" for s in stations)
    sql.append(f"""-- Stations: precise coordinates for existing rows, new rows for the rest.
insert into public.stations (code, name_en, name_si, line_id, elevation_m, lat, lng, source)
select v.code, v.name_en, v.name_si, l.id, v.elevation_m, v.lat, v.lng, v.source
from (values
  {vals}
) as v(code, name_en, name_si, line_name, elevation_m, lat, lng, source)
left join public.railway_lines l on l.name_en = v.line_name
on conflict (code) do update set
  lat = excluded.lat,
  lng = excluded.lng,
  name_si = coalesce(public.stations.name_si, excluded.name_si),
  elevation_m = coalesce(public.stations.elevation_m, excluded.elevation_m),
  source = excluded.source || ' coordinates';

""")

    # ---- train names -----------------------------------------------------------
    for num, (en, si) in TRAIN_NAMES.items():
        sql.append(f"update public.trains set name_en = {q(en)}, name_si = coalesce(name_si, {q(si)})\n"
                   f"  where number = {q(num)} and name_en like '% – %';\n")
    sql.append("\n")

    # ---- new routes ------------------------------------------------------------
    for t in TRAINS:
        if t["line"] not in NEW_TRAIN_LINES or not t["number"]:
            continue
        first, last = t["stops"][0][0], t["stops"][-1][0]
        name = t["name"] or f"{first} – {last}"
        runs = DAYS[tuple(sorted(t["days"]))]
        kind = "Express" if t["type"] == "Express" else "Train"
        sql.append(f"""insert into public.trains (number, name_en, type, line_id, runs_on, source)
select {q(t['number'])}, {q(name)}, {q(kind)}, id, {q(runs)}, {q(TT_SOURCE)}
from public.railway_lines where name_en = {q(LINE_NAMES[t['line']])}
on conflict (number) do nothing;
""")
        prev, day = -1, 0
        stop_vals = []
        for i, s in enumerate(t["stops"], start=1):
            arr, dep = (s[1], s[1]) if len(s) == 2 else (s[1], s[2])
            mins = [int(x[:2]) * 60 + int(x[3:]) for x in (arr or dep, dep or arr)]
            if mins[0] < prev:
                day += 1
            prev = mins[-1]
            stop_vals.append(f"({i}, {q(codes[s[0]])}, {q(arr)}, {q(dep)}, {day})")
        sql.append(f"""insert into public.train_stops (train_id, station_id, stop_order, arrive_time, depart_time, day_offset, is_major, source)
select t.id, s.id, v.stop_order, v.arr::time, v.dep::time, v.day, true, {q(TT_SOURCE)}
from (values {', '.join(stop_vals)}) as v(stop_order, code, arr, dep, day)
join public.trains t on t.number = {q(t['number'])}
join public.stations s on s.code = v.code
on conflict (train_id, stop_order) do nothing;
insert into public.train_classes (train_id, class_name, reservable)
select id, c, false from public.trains, unnest(array['2nd class', '3rd class']) c
where number = {q(t['number'])}
on conflict (train_id, class_name) do nothing;

""")

    # ---- destinations -----------------------------------------------------------
    added = 0
    for d in DESTINATIONS:
        if d["id"] in DEST_EXISTS:
            continue
        photos = [dict(p, url=thumb_url(p["url"]),
                       author=p["author"].splitlines()[0].strip().rstrip(",") or "Unknown")
                  for p in IMAGES.get(d["id"], []) if not SKIP_PHOTO.search(p["title"])]
        photos.sort(key=lambda p: COVER_FIRST.get(d["id"], "") not in p["title"])
        if not photos:
            continue
        added += 1
        cat = CATEGORY_OVERRIDE.get(d["id"], CATEGORY[d["category"]])
        cover = photos[0]
        credit = lambda p: f"{p['author']} · {p['licence']} · Wikimedia Commons"  # noqa: E731
        desc = d["description"]
        if d.get("tips"):
            desc += "\n\nTip: " + " · ".join(d["tips"])
        st_name = d["station"]
        st = COORDS[st_name]
        walk = round(km((d["lat"], d["lng"]), (st["lat"], st["lng"])), 1)
        sql.append(f"""-- {d['name']}
insert into public.destinations (category_id, name_en, description_en, lat, lng,
  cover_photo_url, cover_photo_credit, cover_photo_source_url, source)
select c.id, {q(d['name'])}, {q(desc)}, {d['lat']}, {d['lng']},
  {q(cover['url'])}, {q(credit(cover))}, {q(cover['page'])}, 'ceylongo-curated (Wikipedia)'
from public.destination_categories c where c.name_en = {q(cat)}
on conflict (name_en) do nothing;
insert into public.destination_stations (destination_id, station_id, walk_km)
select d.id, s.id, {walk} from public.destinations d, public.stations s
where d.name_en = {q(d['name'])} and s.code = {q(codes[st_name])}
on conflict do nothing;
insert into public.destination_photos (destination_id, url, sort, credit, source_url)
select d.id, v.url, v.sort, v.credit, v.source_url
from public.destinations d, (values
  {(','+chr(10)+'  ').join(f"({q(p['url'])}, {i}, {q(credit(p))}, {q(p['page'])})" for i, p in enumerate(photos))}
) as v(url, sort, credit, source_url)
where d.name_en = {q(d['name'])}
on conflict (destination_id, url) do nothing;
""")
        tag = {"Tea country": "Tea country", "Hiking": "Hike", "Beaches": "Beach",
               "Wildlife": "Nature", "Temples": "Temple", "Heritage": "Heritage",
               "Scenic views": "Scenic view", "Waterfalls": "Waterfall"}[cat]
        sql.append(f"""insert into public.destination_tags (destination_id, tag)
select id, {q(tag)} from public.destinations where name_en = {q(d['name'])}
on conflict do nothing;

""")
    OUT.write_text("".join(sql), "utf-8")
    new = sum(1 for s in stations if not s["existing"])
    print(f"{len(stations)} stations ({new} new), "
          f"{sum(1 for t in TRAINS if t['line'] in NEW_TRAIN_LINES and t['number'])} new trains, "
          f"{len(TRAIN_NAMES)} renamed, {added} destinations -> {OUT.name}")


if __name__ == "__main__":
    build()
