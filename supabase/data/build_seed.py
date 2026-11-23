"""Builds supabase/seed/02_timetable_and_photos.sql from the data files here.

    python supabase/data/build_seed.py

Inputs
  seat61_timetable_2026-06-10.json  stop times copied from seat61.com/SriLanka.htm
                                    (page "last updated 10 June 2026")
  wikimedia_photos.psv              Wikimedia Commons photos with licence + author
"""

import json
import pathlib

HERE = pathlib.Path(__file__).parent
OUT = HERE.parent / "seed" / "02_timetable_and_photos.sql"
SOURCE = "seat61.com/SriLanka.htm (page updated 2026-06-10)"
NL = "\n"

# seat61 row label -> our station code
STATION = {
    "Colombo Fort": "FOT", "Colombo Maradana": "MDA", "Peradeniya Junction": "PDA",
    "Kandy": "KDT", "Hatton": "HTN", "Nanuoya": "NOA", "Haputale": "HPT",
    "Elle": "ELL", "Badulla": "BAD", "Mount Lavinia": "MLV", "Kalutara South": "KTS",
    "Bentota": "BNT", "Galle": "GLE", "Matara": "MTR", "Beliaththa": "BLT",
    "Habarana": "HBN", "Galoya Jn.": "GOY", "Polonnaruwa": "PLN", "Batticaloa": "BCO",
    "Trincomalee": "TCO", "Anuradhapura": "ANP", "Vavuniya": "VNA",
    "Kilinochchi": "KLN", "Pallai": "PAL", "Jaffna": "JFN", "Talaimannar Pier": "TLP",
}

# Stations the timetable needs that the reference seed does not have yet.
# Coordinates are approximate (map centre of the town / station).
NEW_STATIONS = [
    ("KTS", "Kalutara South", "කළුතර දකුණ", "Coastal Line", "Kalutara", 6.5746, 79.9608),
    ("BLT", "Beliatta", "බෙලිඅත්ත", "Coastal Line", "Hambantota", 6.0478, 80.7339),
    ("GOY", "Gal Oya Junction", "ගල්ඔය හන්දිය", "Batticaloa Line", "Polonnaruwa", 8.0805, 80.9461),
    ("KLN", "Kilinochchi", "කිලිනොච්චි", "Northern Line", "Kilinochchi", 9.3870, 80.4040),
    ("PAL", "Pallai", "පල්ලේ", "Northern Line", "Kilinochchi", 9.6060, 80.3260),
    ("TLP", "Talaimannar Pier", "තලේමන්නාරම තොටුපළ", "Mannar Line", "Mannar", 9.0856, 79.7269),
]

# Names from seat61 footnotes and Wikipedia; everything else is "<from> – <to>".
NAMES = {
    "1001": ("Dunhinda Odyssey", "දුන්හිඳ ඔඩිසි", "Express"),
    "1005": ("Podi Menike", "පොඩි මැණිකේ", "Express"),
    "1006": ("Podi Menike", "පොඩි මැණිකේ", "Express"),
    "1015": ("Udarata Menike", "උඩරට මැණිකේ", "Express"),
    "1016": ("Udarata Menike", "උඩරට මැණිකේ", "Express"),
    "1045": ("Night Mail", "රාත්‍රී තැපැල් දුම්රිය", "Night Mail"),
    "1046": ("Night Mail", "රාත්‍රී තැපැල් දුම්රිය", "Night Mail"),
    "8058": ("Ruhunu Kumari", "රුහුණු කුමාරි", "Express"),
    "8059": ("Ruhunu Kumari", "රුහුණු කුමාරි", "Express"),
    "4077": ("Yal Devi", "යාල් දේවී", "Express"),
    "4078": ("Yal Devi", "යාල් දේවී", "Express"),
    "5003": ("Mannar Express", "මන්නාරම් එක්ස්ප්‍රස්", "Express"),
    "5004": ("Mannar Express", "මන්නාරම් එක්ස්ප්‍රස්", "Express"),
    "6011": ("Udaya Devi", "උදය දේවී", "Express"),
    "6012": ("Udaya Devi", "උදය දේවී", "Express"),
    "6079": ("Night Mail", "රාත්‍රී තැපැල් දුම්රිය", "Night Mail"),
    "6080": ("Night Mail", "රාත්‍රී තැපැල් දුම්රිය", "Night Mail"),
    "7083": ("Night Mail", "රාත්‍රී තැපැල් දුම්රිය", "Night Mail"),
    "7084": ("Night Mail", "රාත්‍රී තැපැල් දුම්රිය", "Night Mail"),
}

TRAIN_PHOTO = {  # photo target -> train numbers
    "Podi Menike": ["1005", "1006"], "Udarata Menike": ["1015", "1016"],
    "Yal Devi": ["4077", "4078"], "Udaya Devi": ["6011", "6012"],
    "Ruhunu Kumari": ["8058", "8059"],
}

# Train "6" is skipped: seat61 lists it leaving Elle (10:25) before Badulla (10:45).
SKIP = {"6"}

CLASS_NAMES = {"O": "Observation saloon", "1": "1st class", "2": "2nd class",
               "3": "3rd class", "Sleeper": "Sleeper berths"}


def q(v):
    if v is None:
        return "null"
    if isinstance(v, (int, float)):
        return str(v)
    return "'" + str(v).replace("'", "''") + "'"


def line_for(number):
    n = int(number)
    for lo, hi, name in ((8000, 9000, "Coastal Line"), (4000, 5000, "Northern Line"),
                         (5000, 6000, "Mannar Line"), (6000, 7000, "Batticaloa Line"),
                         (7000, 8000, "Trincomalee Line")):
        if lo <= n < hi:
            return name
    return "Main Line"


def station_of(label):
    base = label
    for cut in (" arr/dep", " arrive", " depart"):
        base = base.split(cut)[0]
    base = base.rstrip(":").strip()
    if base not in STATION:
        raise SystemExit(f"unknown station label: {label!r}")
    return STATION[base]


def to_min(hhmm):
    h, m = map(int, hhmm.split(":"))
    return h * 60 + m


def build_stops(train):
    """Merge 'Kandy arrive'/'Kandy depart' rows; set day_offset past midnight."""
    merged = []
    for label, time in train["stops"]:
        code = station_of(label)
        kind = "arr" if "arrive" in label else "dep" if "depart" in label else "both"
        if merged and merged[-1]["code"] == code:
            merged[-1]["dep" if kind == "dep" else "arr"] = time
            continue
        merged.append({"code": code, "arr": time if kind in ("arr", "both") else None,
                       "dep": time if kind in ("dep", "both") else None})
    merged[0]["arr"] = None
    merged[-1]["dep"] = None
    day, prev = 0, -1
    for s in merged:
        for key in ("arr", "dep"):
            if s[key] is None:
                continue
            t = to_min(s[key])
            if t < prev:
                day += 1
            prev = t
        s["day"] = day
    return merged


def classes(t):
    out = []
    for c in [x.strip() for x in t["res"].replace(".", ",").split(",") if x.strip() not in ("-", "")]:
        out.append((CLASS_NAMES[c] + ("" if c in ("O", "Sleeper") else " reserved"), True))
    for c in [x.strip() for x in t["unres"].replace(".", ",").split(",") if x.strip() not in ("-", "")]:
        out.append((CLASS_NAMES[c] + " unreserved", False))
    return out


def main():
    trains = [t for t in json.loads((HERE / "seat61_timetable_2026-06-10.json").read_text(encoding="utf-8"))
              if t["n"] not in SKIP]
    photos = [l.split("|") for l in (HERE / "wikimedia_photos.psv").read_text(encoding="utf-8").splitlines()
              if l and not l.startswith("#")]
    numbers = ", ".join(q(t["n"]) for t in trains)

    out = ["-- GENERATED by supabase/data/build_seed.py - do not edit by hand.",
           f"-- Timetable source: {SOURCE}.",
           "-- train_stops.verified_at stays null until checked against an official SLR timetable.",
           "begin;", ""]

    out.append("-- Stations the timetable needs")
    rows = [f"({q(c)},{q(en)},{q(si)},{q(line)},{q(dist)},{lat},{lng})" for c, en, si, line, dist, lat, lng in NEW_STATIONS]
    out.append("insert into public.stations (code, name_en, name_si, line_id, district, lat, lng, source)" + NL
               + "select v.c, v.en, v.si, l.id, v.d, v.lat, v.lng, 'seed-unverified' from (values" + NL
               + ("," + NL).join(rows) + NL + ") v(c, en, si, line, d, lat, lng)" + NL
               + "join public.railway_lines l on l.name_en = v.line on conflict (code) do nothing;")
    out.append("")

    out.append("-- Trains")
    rows = []
    for t in trains:
        stops = build_stops(t)
        en, si, typ = NAMES.get(t["n"], (None, None, "Train"))
        days = "Daily" if t["days"] == "daily" else ", ".join(x.strip() for x in t["days"].split(","))
        rows.append(f"({q(t['n'])},{q(en)},{q(si)},{q(typ)},{q(line_for(t['n']))},{q(days)},"
                    f"{q(stops[0]['code'])},{q(stops[-1]['code'])})")
    out.append("insert into public.trains (number, name_en, name_si, type, line_id, runs_on, source)" + NL
               + "select v.n, coalesce(v.en, a.name_en || ' – ' || b.name_en), v.si, v.typ, l.id, v.days, "
               + q(SOURCE) + NL + "from (values" + NL + ("," + NL).join(rows) + NL
               + ") v(n, en, si, typ, line, days, a, b)" + NL
               + "join public.railway_lines l on l.name_en = v.line" + NL
               + "join public.stations a on a.code = v.a join public.stations b on b.code = v.b" + NL
               + "on conflict (number) do update set name_en = excluded.name_en, name_si = excluded.name_si," + NL
               + "  type = excluded.type, line_id = excluded.line_id, runs_on = excluded.runs_on, source = excluded.source;")
    out.append("")

    out.append("-- Stop times (replaces existing stops for these trains)")
    out.append(f"delete from public.train_stops where train_id in (select id from public.trains where number in ({numbers}));")
    rows = [f"({q(t['n'])},{q(s['code'])},{i},{q(s['arr'])},{q(s['dep'])},{s['day']})"
            for t in trains for i, s in enumerate(build_stops(t), start=1)]
    out.append("insert into public.train_stops (train_id, station_id, stop_order, arrive_time, depart_time, day_offset, is_major, source)" + NL
               + "select t.id, s.id, v.o, v.a::time, v.d::time, v.dy, true, " + q(SOURCE) + NL
               + "from (values" + NL + ("," + NL).join(rows) + NL + ") v(n, c, o, a, d, dy)" + NL
               + "join public.trains t on t.number = v.n join public.stations s on s.code = v.c;")
    out.append("")

    out.append("-- Seat classes")
    out.append(f"delete from public.train_classes where train_id in (select id from public.trains where number in ({numbers}));")
    rows = [f"({q(t['n'])},{q(c)},{'true' if r else 'false'})" for t in trains for c, r in classes(t)]
    out.append("insert into public.train_classes (train_id, class_name, reservable)" + NL
               + "select t.id, v.c, v.r from (values" + NL + ("," + NL).join(rows) + NL + ") v(n, c, r)" + NL
               + "join public.trains t on t.number = v.n on conflict do nothing;")
    out.append("")

    out.append("-- Photos (Wikimedia Commons). URL and file page are rebuilt from the Commons path.")
    rows, order = [], {}
    for kind, target, path, thumb, lic, author in photos:
        order[target] = order.get(target, 0) + 1
        rows.append(f"({q(kind)},{q(target)},{q(path)},{'true' if thumb == '1' else 'false'},"
                    f"{q(author + ' · ' + lic + ' · Wikimedia Commons')},{order[target]})")
    out.append("create temp table _ph on commit drop as" + NL
               + "select v.*, 'https://upload.wikimedia.org/wikipedia/commons/' || case when v.thumb" + NL
               + "    then 'thumb/' || v.path || '/1280px-' || split_part(v.path, '/', 3) else v.path end as url," + NL
               + "  'https://commons.wikimedia.org/wiki/File:' || split_part(v.path, '/', 3) as page" + NL
               + "from (values" + NL + ("," + NL).join(rows) + NL + ") v(kind, target, path, thumb, credit, ord);")
    out.append("update public.destinations d set cover_photo_url = p.url, cover_photo_credit = p.credit, cover_photo_source_url = p.page" + NL
               + "from _ph p where p.kind = 'C' and p.target = 'd:' || d.name_en;")
    out.append("update public.stations s set photo_url = p.url, photo_credit = p.credit, photo_source_url = p.page" + NL
               + "from _ph p where p.kind = 'C' and p.target = 's:' || s.code;")
    trows = ", ".join(f"({q('t:' + name)},{q(n)})" for name, nums in TRAIN_PHOTO.items() for n in nums)
    out.append("update public.trains t set photo_url = p.url, photo_credit = p.credit, photo_source_url = p.page" + NL
               + f"from _ph p join (values {trows}) m(target, n) on m.target = p.target" + NL
               + "where p.kind = 'C' and t.number = m.n;")
    out.append("delete from public.destination_photos where destination_id in" + NL
               + "  (select d.id from public.destinations d join _ph p on p.kind = 'G' and p.target = d.name_en);")
    out.append("insert into public.destination_photos (destination_id, url, sort, credit, source_url)" + NL
               + "select d.id, p.url, p.ord, p.credit, p.page from _ph p join public.destinations d on d.name_en = p.target" + NL
               + "where p.kind = 'G' on conflict do nothing;")
    out.append("")
    out.append("commit;")
    OUT.write_text(NL.join(out) + NL, encoding="utf-8", newline=NL)
    print(f"wrote {OUT} ({len(trains)} trains, {len(photos)} photos)")


if __name__ == "__main__":
    main()
