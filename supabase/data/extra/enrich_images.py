"""Fetch freely licensed photos for each destination from Wikimedia Commons.

Only Public Domain / CC0 / CC BY / CC BY-SA images are kept, with author,
licence and source page stored so the app can credit them.
Writes cache/images.json. Run: python tool/seed/enrich_images.py
"""
import html
import json
import pathlib
import re
import time
import urllib.error
import urllib.parse
import urllib.request

from destinations import DESTINATIONS

HERE = pathlib.Path(__file__).parent
CACHE = HERE / "cache" / "images.json"
UA = {"User-Agent": "CeylonGO-seed/1.0 (open-source railway app; data build)"}
OK_LICENCE = re.compile(r"^(public domain|pd|cc0|cc by(-sa)? [0-9.]+)", re.I)
PER_PLACE = 4


def get(params, tries=5):
    q = "https://commons.wikimedia.org/w/api.php?" + urllib.parse.urlencode(params)
    for attempt in range(tries):
        try:
            with urllib.request.urlopen(urllib.request.Request(q, headers=UA), timeout=60) as r:
                return json.load(r)
        except (urllib.error.HTTPError, urllib.error.URLError) as e:
            retryable = getattr(e, "code", 429) == 429
            if not retryable or attempt == tries - 1:
                raise
            wait = 15 * (attempt + 1)
            if isinstance(e, urllib.error.HTTPError):
                wait = int(e.headers.get("Retry-After") or 0) or wait
            time.sleep(wait)


def clean(s):
    return html.unescape(re.sub(r"<[^>]+>", "", s or "")).strip()


def search(query):
    d = get({
        "action": "query", "format": "json", "generator": "search",
        "gsrsearch": f"{query} filetype:bitmap", "gsrnamespace": 6, "gsrlimit": 20,
        "prop": "imageinfo", "iiprop": "url|size|extmetadata|mime", "iiurlwidth": 1280,
    })
    pages = sorted(d.get("query", {}).get("pages", {}).values(), key=lambda p: p.get("index", 99))
    out = []
    for p in pages:
        ii = (p.get("imageinfo") or [{}])[0]
        meta = ii.get("extmetadata", {})
        lic = clean(meta.get("LicenseShortName", {}).get("value"))
        if ii.get("mime") not in ("image/jpeg", "image/png") or not OK_LICENCE.match(lic):
            continue
        if ii.get("width", 0) < 1000 or ii.get("width", 0) < ii.get("height", 1):
            continue  # want landscape photos that look good in headers
        out.append({
            "url": ii.get("thumburl") or ii["url"],
            "page": ii.get("descriptionurl"),
            "title": p["title"].removeprefix("File:"),
            "author": clean(meta.get("Artist", {}).get("value"))[:120] or "Unknown",
            "licence": lic,
            "caption": clean(meta.get("ImageDescription", {}).get("value"))[:200],
        })
        if len(out) >= PER_PLACE:
            break
    return out


def main():
    cache = json.loads(CACHE.read_text("utf-8")) if CACHE.exists() else {}
    for d in DESTINATIONS:
        if cache.get(d["id"]):
            continue
        imgs = search(d["commons"])
        cache[d["id"]] = imgs
        print(f'{d["id"]:22} {len(imgs)} images  {imgs[0]["licence"] if imgs else "-"}')
        CACHE.parent.mkdir(exist_ok=True)
        CACHE.write_text(json.dumps(cache, ensure_ascii=False, indent=1), "utf-8")
        time.sleep(3)
    print("without images:", [k for k, v in cache.items() if not v])


if __name__ == "__main__":
    main()
