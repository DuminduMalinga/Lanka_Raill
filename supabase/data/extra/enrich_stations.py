"""Fetch coordinates + Sinhala names for every station into cache/stations.json.

Sources: Wikipedia (coordinates, Wikidata id) and Wikidata (Sinhala label,
elevation), falling back to OpenStreetMap Nominatim for coordinates.
Run: python tool/seed/enrich_stations.py
"""
import json
import pathlib
import time
import urllib.parse
import urllib.request

from stations import LINE_STATIONS, WIKI_TITLES

HERE = pathlib.Path(__file__).parent
CACHE = HERE / "cache" / "stations.json"
UA = {"User-Agent": "CeylonGO-seed/1.0 (open-source railway app; data build)"}


def get(url, params):
    q = url + "?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(q, headers=UA)
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.load(r)


def wiki_batch(titles):
    out = {}
    for i in range(0, len(titles), 40):
        chunk = titles[i:i + 40]
        d = get("https://en.wikipedia.org/w/api.php", {
            "action": "query", "format": "json", "redirects": 1,
            "prop": "coordinates|pageprops", "ppprop": "wikibase_item",
            "titles": "|".join(chunk),
        })
        q = d["query"]
        norm = {n["from"]: n["to"] for n in q.get("normalized", [])}
        redir = {n["from"]: n["to"] for n in q.get("redirects", [])}
        pages = {p["title"]: p for p in q["pages"].values()}
        for t in chunk:
            final = redir.get(norm.get(t, t), norm.get(t, t))
            p = pages.get(final)
            if p and "missing" not in p:
                c = (p.get("coordinates") or [{}])[0]
                out[t] = {"lat": c.get("lat"), "lng": c.get("lon"),
                          "qid": p.get("pageprops", {}).get("wikibase_item")}
        time.sleep(0.5)
    return out


def wikidata(qids):
    out = {}
    qids = [q for q in qids if q]
    for i in range(0, len(qids), 45):
        d = get("https://www.wikidata.org/w/api.php", {
            "action": "wbgetentities", "format": "json",
            "ids": "|".join(qids[i:i + 45]), "props": "labels|claims",
            "languages": "si|en",
        })
        for qid, e in d.get("entities", {}).items():
            si = e.get("labels", {}).get("si", {}).get("value")
            elev = None
            for c in e.get("claims", {}).get("P2044", []):
                try:
                    elev = round(float(c["mainsnak"]["datavalue"]["value"]["amount"]))
                except (KeyError, ValueError):
                    pass
            coord = None
            for c in e.get("claims", {}).get("P625", []):
                v = c["mainsnak"].get("datavalue", {}).get("value")
                if v:
                    coord = (v["latitude"], v["longitude"])
            out[qid] = {"si": si, "elev": elev, "coord": coord}
        time.sleep(0.5)
    return out


def nominatim(name):
    d = get("https://nominatim.openstreetmap.org/search", {
        "q": f"{name} railway station, Sri Lanka", "format": "json", "limit": 1,
    })
    time.sleep(1.1)  # Nominatim policy: max 1 request / second
    if d:
        return float(d[0]["lat"]), float(d[0]["lon"])
    return None


def main():
    names = sorted({n for line in LINE_STATIONS.values() for n, _ in line})
    cache = json.loads(CACHE.read_text("utf-8")) if CACHE.exists() else {}
    todo = [n for n in names if n not in cache or cache[n].get("lat") is None]
    titles = {n: WIKI_TITLES.get(n, f"{n} railway station") for n in todo}
    wiki = wiki_batch(list(titles.values()))
    wd = wikidata([w.get("qid") for w in wiki.values()])
    for n in todo:
        w = wiki.get(titles[n], {})
        e = wd.get(w.get("qid"), {})
        lat, lng = w.get("lat"), w.get("lng")
        if lat is None and e.get("coord"):
            lat, lng = e["coord"]
        source = "wikipedia" if lat is not None else None
        if lat is None:
            c = nominatim(n)
            if c:
                lat, lng = c
                source = "openstreetmap"
        cache[n] = {"lat": lat, "lng": lng, "si": e.get("si"),
                    "elev": e.get("elev"), "qid": w.get("qid"), "source": source}
        print(f"{n:24} {lat} {lng} {e.get('si')} [{source}]")
    CACHE.parent.mkdir(exist_ok=True)
    CACHE.write_text(json.dumps(cache, ensure_ascii=False, indent=1, sort_keys=True), "utf-8")
    missing = [n for n in names if cache[n]["lat"] is None]
    print("missing coords:", missing)


if __name__ == "__main__":
    main()
