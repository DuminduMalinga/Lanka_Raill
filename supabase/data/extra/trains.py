"""Curated Sri Lanka Railways timetable for CeylonGO.

Sources (fetched Nov 2026):
  * railway.gov.lk official PDFs — Yarl Devi (KKS → Mount Lavinia) and
    Night Mail (Colombo Fort → KKS): every stop, exact times.
  * traintimetable.lk route tables — times at the main stations for the
    other services. Where two tables disagreed we kept the value consistent
    with neighbouring stops; see the comment on each train.
  * Ada Derana (May 2026) — Yal Devi running days.

Times are local "HH:MM"; a stop earlier than the previous one is the next
day. Stop tuples: (station, arrive, depart) — use None for the first arrival
or last departure, or a single time for both.
"""

DAILY = [1, 2, 3, 4, 5, 6, 7]  # ISO weekdays, Monday = 1
WEEKDAYS = [1, 2, 3, 4, 5]
MON_SAT = [1, 2, 3, 4, 5, 6]
SUN_FRI = [7, 1, 2, 3, 4, 5]
THU_SAT = [4, 6]
FRI_SUN = [5, 7]
SAT_SUN = [6, 7]
MON_WED_FRI = [1, 3, 5]
TUE_THU_SUN = [2, 4, 7]
SAT = [6]
SUN = [7]

OFFICIAL = "railway.gov.lk"
TTLK = "traintimetable.lk"

# Classes offered, by service type (typical SLR consists).
CLASSES = {
    "intercity": ["1st AC", "2nd Reserved", "3rd Reserved"],
    "odyssey": ["1st Observation", "2nd Reserved"],
    "hill_express": ["1st Observation", "2nd Reserved", "3rd Reserved", "2nd", "3rd"],
    "express": ["2nd Reserved", "2nd", "3rd"],
    "night_mail": ["1st Sleeper", "2nd Reserved", "3rd Reserved", "2nd", "3rd"],
    "slow": ["2nd", "3rd"],
}


def T(number, name, kind, line, days, stops, source=TTLK, classes=None, note=None):
    return {
        "number": number, "name": name, "type": kind, "line": line,
        "days": days, "stops": stops, "source": source, "note": note,
        "classes": classes or CLASSES[{
            "Intercity": "intercity", "Odyssey": "odyssey",
            "Night Mail": "night_mail", "Slow": "slow", "Semi Express": "express",
            "Commuter": "slow",
        }.get(kind, "express")],
    }


TRAINS = [
    # ---------------- Main Line (Colombo ↔ Kandy ↔ Badulla) ----------------
    # Ella 15:55 chosen over 15:08 (31 min to Badulla matches other trains).
    T("1005", "Podi Menike", "Express", "main", DAILY, [
        ("Colombo Fort", None, "05:55"), ("Rambukkana", "07:28"),
        ("Kandy", "08:45", "08:55"), ("Hatton", "11:14"),
        ("Ella", "15:55"), ("Badulla", "16:26", None)],
        classes=CLASSES["hill_express"]),
    T("1006", "Podi Menike", "Express", "main", DAILY, [
        ("Badulla", None, "08:50"), ("Ella", "09:42"), ("Bandarawela", "10:11"),
        ("Nanu Oya", "12:14"), ("Hatton", "13:51"),
        ("Kandy", "16:23", "16:35"), ("Colombo Fort", "19:25", None)],
        classes=CLASSES["hill_express"]),
    T("1015", "Udarata Menike", "Express", "main", DAILY, [
        ("Colombo Fort", None, "08:30"), ("Rambukkana", "09:55"),
        ("Peradeniya Junction", "11:00"), ("Hatton", "13:19"),
        ("Nanu Oya", "14:54"), ("Ella", "17:10"), ("Badulla", "17:50", None)],
        classes=CLASSES["hill_express"]),
    T("1016", "Udarata Menike", "Express", "main", DAILY, [
        ("Badulla", None, "05:50"), ("Ella", "06:41"), ("Bandarawela", "07:20"),
        ("Nanu Oya", "09:23"), ("Hatton", "10:23"),
        ("Peradeniya Junction", "12:54"), ("Colombo Fort", "15:40", None)],
        classes=CLASSES["hill_express"]),
    T("1007", None, "Express", "main", DAILY, [
        ("Colombo Fort", None, "09:45"), ("Rambukkana", "11:19"),
        ("Hatton", "14:36"), ("Nanu Oya", "15:57"), ("Ella", "18:10"),
        ("Badulla", "18:50", None)]),
    T("1008", None, "Express", "main", DAILY, [
        ("Badulla", None, "10:20"), ("Ella", "11:14"), ("Bandarawela", "11:45"),
        ("Nanu Oya", "14:15"), ("Hatton", "15:05"), ("Colombo Fort", "20:30", None)]),
    T("1045", "Night Mail", "Night Mail", "main", DAILY, [
        ("Colombo Fort", None, "20:30"), ("Rambukkana", "22:18"),
        ("Hatton", "02:20"), ("Nanu Oya", "03:49"), ("Ella", "06:45"),
        ("Badulla", "07:32", None)]),
    T("1046", "Night Mail", "Night Mail", "main", DAILY, [
        ("Badulla", None, "18:30"), ("Ella", "19:24"), ("Bandarawela", "19:55"),
        ("Nanu Oya", "22:50"), ("Hatton", "00:35"), ("Colombo Fort", "06:00", None)]),
    T(None, "Ella Odyssey", "Odyssey", "main", THU_SAT, [
        ("Colombo Fort", None, "05:30"), ("Rambukkana", "06:58"),
        ("Hatton", "10:35"), ("Nanu Oya", "12:06"), ("Ella", "14:40"),
        ("Badulla", "16:01", None)],
        note="Special tourist train with observation saloons."),
    T(None, "Ella Odyssey", "Odyssey", "main", FRI_SUN, [
        ("Badulla", None, "08:00"), ("Ella", "08:56"), ("Nanu Oya", "11:32"),
        ("Hatton", "14:16"), ("Colombo Fort", "19:20", None)],
        note="Special tourist train with observation saloons."),
    T("1023", "Tikiri Menike", "Express", "main", DAILY, [
        ("Colombo Fort", None, "12:40"), ("Rambukkana", "14:21"),
        ("Kandy", "16:00"), ("Hatton", "20:03"), ("Nanu Oya", "21:27", None)]),
    T("1024", "Tikiri Menike", "Express", "main", DAILY, [
        ("Nanu Oya", None, "06:00"), ("Hatton", "07:20"), ("Kandy", "10:40"),
        ("Colombo Fort", "14:00", None)]),
    T("1009", None, "Intercity", "main", DAILY, [
        ("Colombo Fort", None, "07:00"), ("Kandy", "09:30", None)]),
    T("1030", None, "Intercity", "main", DAILY, [
        ("Kandy", None, "06:15"), ("Colombo Fort", "08:51", None)]),
    T("1029", None, "Intercity", "main", DAILY, [
        ("Colombo Fort", None, "15:35"), ("Kandy", "18:10", None)]),
    T("1010", None, "Intercity", "main", DAILY, [
        ("Kandy", None, "15:00"), ("Colombo Fort", "17:36", None)]),
    T("1035", "Senkadagala Menike", "Express", "main", DAILY, [
        ("Colombo Fort", None, "16:35"), ("Rambukkana", "18:15"),
        ("Kandy", "19:30", None)]),
    T("1036", None, "Express", "main", DAILY, [
        ("Kandy", None, "06:20"), ("Colombo Fort", "09:25", None)]),
    T("1039", None, "Express", "main", DAILY, [
        ("Colombo Fort", None, "17:55"), ("Rambukkana", "19:43"),
        ("Kandy", "21:15", None)]),
    T("1040", None, "Express", "main", MON_SAT, [
        ("Kandy", None, "05:00"), ("Colombo Fort", "08:05", None)]),
    T("1019", None, "Commuter", "matale", WEEKDAYS, [
        ("Colombo Fort", None, "10:35"), ("Rambukkana", "12:18"),
        ("Kandy", "13:50"), ("Matale", "15:30", None)]),

    # ---------------- Coastal Line ----------------
    T("8050", None, "Express", "coastal", DAILY, [
        ("Maradana", None, "06:25"), ("Colombo Fort", "06:50"),
        ("Ambalangoda", "08:48"), ("Galle", "09:30"), ("Matara", "10:45"),
        ("Beliatta", "11:21", None)]),
    T("8040", None, "Express", "coastal", MON_SAT, [
        ("Colombo Fort", None, "08:35"), ("Ambalangoda", "10:19"),
        ("Matara", "12:14", None)]),
    T("8085", "Rajarata Rajini", "Express", "coastal", DAILY, [
        ("Beliatta", None, "08:45"), ("Matara", "09:20"), ("Galle", "10:35"),
        ("Ambalangoda", "10:57"), ("Colombo Fort", "12:42", "13:45"),
        ("Anuradhapura", "18:22"), ("Vavuniya", "20:10", None)]),
    T("8086", "Rajarata Rajini", "Express", "coastal", DAILY, [
        ("Anuradhapura", None, "05:30"), ("Colombo Fort", "10:20", "10:30"),
        ("Ambalangoda", "12:12"), ("Galle", "12:50"), ("Matara", "13:55"),
        ("Beliatta", "14:30", None)]),
    T("8056", "Galu Kumari", "Express", "coastal", DAILY, [
        ("Maradana", None, "14:30"), ("Colombo Fort", "14:40"),
        ("Ambalangoda", "16:11"), ("Galle", "17:00"), ("Matara", "17:55"),
        ("Beliatta", "18:28", None)]),
    T("8057", "Galu Kumari", "Express", "coastal", DAILY, [
        ("Beliatta", None, "05:25"), ("Matara", "06:12"), ("Galle", "07:25"),
        ("Ambalangoda", "07:57"), ("Colombo Fort", "09:41"),
        ("Maradana", "09:47", None)]),
    T("8058", "Ruhunu Kumari", "Express", "coastal", DAILY, [
        ("Maradana", None, "15:40"), ("Colombo Fort", "15:50"),
        ("Ambalangoda", "17:09"), ("Galle", "17:57"), ("Matara", "18:52", None)]),
    T("8059", "Ruhunu Kumari", "Express", "coastal", DAILY, [
        ("Matara", None, "06:05"), ("Galle", "07:03"), ("Ambalangoda", "07:34"),
        ("Colombo Fort", "09:14"), ("Maradana", "09:21", None)]),
    T("8096", "Sagarika", "Express", "coastal", SUN_FRI, [
        ("Maradana", None, "16:40"), ("Colombo Fort", "16:47"),
        ("Ambalangoda", "18:19"), ("Galle", "19:00"), ("Matara", "19:41"),
        ("Beliatta", "20:13", None)]),
    T("8097", "Sagarika", "Express", "coastal", WEEKDAYS, [
        ("Beliatta", None, "04:15"), ("Matara", "04:49"), ("Galle", "05:57"),
        ("Ambalangoda", "06:26"), ("Colombo Fort", "08:20"),
        ("Maradana", "08:26", None)]),
    T(None, "Samudra Devi", "Express", "coastal", WEEKDAYS, [
        ("Colombo Fort", None, "17:32"), ("Ambalangoda", "19:19"),
        ("Galle", "20:25", None)]),
    T(None, "Samudra Devi", "Express", "coastal", MON_SAT, [
        ("Galle", None, "05:00"), ("Ambalangoda", "05:55"),
        ("Colombo Fort", "08:05"), ("Maradana", "08:11", None)]),
    T("8766", None, "Express", "coastal", WEEKDAYS, [
        ("Maradana", None, "18:10"), ("Colombo Fort", "18:16"),
        ("Ambalangoda", "20:07"), ("Matara", "21:55"), ("Beliatta", "22:30", None)]),

    # ---------------- Northern Line ----------------
    T("4077", "Yal Devi", "Express", "northern", MON_WED_FRI, [
        ("Colombo Fort", None, "05:45"), ("Anuradhapura", "09:45"),
        ("Kankesanthurai", "13:30", None)]),
    T("4078", "Yal Devi", "Express", "northern", TUE_THU_SUN, [
        ("Kankesanthurai", None, "13:40"), ("Chunnakam", "13:48"),
        ("Kondavil", "13:55"), ("Jaffna", "14:05"), ("Navatkuli", "14:12"),
        ("Chavakachcheri", "14:20"), ("Kodikamam", "14:27"), ("Palai", "14:39"),
        ("Elephant Pass", "14:51"), ("Paranthan", "14:58"),
        ("Kilinochchi", "15:04"), ("Ariviyal Nagar", "15:13"),
        ("Murukandi", "15:18"), ("Mankulam", "15:32"), ("Puliyankulam", "15:49"),
        ("Omanthai", "15:59"), ("Thandikulam", "16:08"), ("Vavuniya", "16:13"),
        ("Medawachchiya", "16:31"), ("Parasangaswewa", "16:42"),
        ("Anuradhapura", "17:00"), ("Thambuttegama", "17:46"),
        ("Galgamuwa", "18:17"), ("Maho", "18:52"), ("Kurunegala", "19:37"),
        ("Polgahawela", "20:01"), ("Mirigama", "20:23"), ("Veyangoda", "20:34"),
        ("Gampaha", "20:45"), ("Maradana", "21:15"), ("Colombo Fort", "21:23"),
        ("Bambalapitiya", "21:33"), ("Wellawatte", "21:40"),
        ("Dehiwala", "21:46"), ("Mount Lavinia", "21:49", None)],
        source=OFFICIAL),
    T("4089", "Night Mail", "Night Mail", "northern", DAILY, [
        ("Colombo Fort", None, "20:00"), ("Gampaha", "20:35"),
        ("Veyangoda", "20:46"), ("Polgahawela", "21:23"), ("Kurunegala", "21:48"),
        ("Maho", "22:29"), ("Ambanpola", "22:49"), ("Galgamuwa", "23:06"),
        ("Senarathgama", "23:23"), ("Thambuttegama", "23:39"), ("Talawa", "23:58"),
        ("Shrawasthipura", "00:13"), ("Anuradhapura", "00:30"),
        ("Parasangaswewa", "00:41"), ("Medawachchiya", "00:53"), ("Punewa", "01:00"),
        ("Irattaperiyakulam", "01:11"), ("Vavuniya", "01:17"),
        ("Thandikulam", "01:21"), ("Omanthai", "01:31"), ("Puliyankulam", "01:42"),
        ("Mankulam", "02:00"), ("Murukandi", "02:15"), ("Ariviyal Nagar", "02:20"),
        ("Kilinochchi", "02:30"), ("Paranthan", "02:36"), ("Elephant Pass", "02:44"),
        ("Palai", "02:57"), ("Eluthumadduval", "03:05"), ("Mirusuvil", "03:11"),
        ("Kodikamam", "03:16"), ("Meesalai", "03:21"), ("Sankathanai", "03:25"),
        ("Chavakachcheri", "03:29"), ("Thachchanthoppu", "03:36"),
        ("Navatkuli", "03:41"), ("Pungankulam", "03:48"), ("Jaffna", "03:56"),
        ("Kokuvil", "04:01"), ("Kondavil", "04:05"), ("Inuvil", "04:10"),
        ("Chunnakam", "04:15"), ("Mallakam", "04:19"), ("Tellippalai", "04:24"),
        ("Maviddapuram", "04:28"), ("Kankesanthurai", "04:32", None)],
        source=OFFICIAL),
    T(None, "Intercity Express", "Intercity", "northern", SAT_SUN, [
        ("Colombo Fort", None, "05:30"), ("Anuradhapura", "08:50"),
        ("Kankesanthurai", "11:40", None)]),
    T(None, "Intercity Express", "Intercity", "northern", SAT_SUN, [
        ("Jaffna", None, "12:30"), ("Anuradhapura", "15:45"),
        ("Colombo Fort", "19:20", None)]),

    # ---------------- East: Batticaloa & Trincomalee ----------------
    T("6011", "Udaya Devi", "Express", "batticaloa", DAILY, [
        ("Colombo Fort", None, "06:35"), ("Gal Oya", "12:15"),
        ("Batticaloa", "14:39", None)]),
    T("6012", "Udaya Devi", "Express", "batticaloa", DAILY, [
        ("Batticaloa", None, "06:10"), ("Colombo Fort", "15:05", None)]),
    T("6075", "Pulathisi", "Intercity", "batticaloa", DAILY, [
        ("Colombo Fort", None, "15:15"), ("Batticaloa", "22:25", None)]),
    T("6079", "Night Mail", "Night Mail", "batticaloa", DAILY, [
        ("Colombo Fort", None, "19:00"), ("Batticaloa", "03:48", None)]),
    T("6080", "Night Mail", "Night Mail", "batticaloa", DAILY, [
        ("Batticaloa", None, "20:15"), ("Colombo Fort", "04:55", None)]),
    T("7083", "Night Mail", "Night Mail", "trincomalee", DAILY, [
        ("Colombo Fort", None, "21:30"), ("Gal Oya", "03:24"),
        ("Trincomalee", "05:10", None)]),
    T("7084", "Night Mail", "Night Mail", "trincomalee", DAILY, [
        ("Trincomalee", None, "19:00"), ("Colombo Fort", "03:03", None)]),
    T("7078", None, "Express", "trincomalee", DAILY, [
        ("Trincomalee", None, "12:15"), ("Colombo Fort", "18:40", None)]),

    # ---------------- Puttalam Line ----------------
    T("3404", None, "Slow", "puttalam", DAILY, [
        ("Colombo Fort", None, "04:00"), ("Negombo", "05:20"),
        ("Puttalam", "08:18", None)]),
    T("3411", None, "Slow", "puttalam", DAILY, [
        ("Colombo Fort", None, "07:40"), ("Negombo", "09:26"),
        ("Puttalam", "12:38", None)]),
    T("3425", None, "Express", "puttalam", WEEKDAYS, [
        ("Colombo Fort", None, "17:18"), ("Negombo", "18:23"),
        ("Puttalam", "21:05", None)]),
    T("3808", None, "Express", "puttalam", WEEKDAYS, [
        ("Puttalam", None, "04:30"), ("Negombo", "07:13"),
        ("Colombo Fort", "08:20", None)]),
    T("3820", None, "Slow", "puttalam", WEEKDAYS, [
        ("Puttalam", None, "13:30"), ("Negombo", "16:50"),
        ("Colombo Fort", "18:37", None)]),

    # ---------------- Kelani Valley Line ----------------
    T(None, "Seethawaka Odyssey", "Odyssey", "kelani_valley", SAT, [
        ("Colombo Fort", None, "08:40"), ("Avissawella", "10:47", None)]),
    T(None, "Seethawaka Odyssey", "Odyssey", "kelani_valley", SAT, [
        ("Avissawella", None, "18:20"), ("Colombo Fort", "20:23", None)]),
    T(None, "Seethawaka Odyssey", "Odyssey", "kelani_valley", SUN, [
        ("Colombo Fort", None, "07:15"), ("Avissawella", "09:23", None)]),
    T(None, "Seethawaka Odyssey", "Odyssey", "kelani_valley", SUN, [
        ("Avissawella", None, "17:25"), ("Colombo Fort", "19:40", None)]),
    T("9254", None, "Slow", "kelani_valley", DAILY, [
        ("Colombo Fort", None, "08:30"), ("Avissawella", "11:54", None)]),
    T("9646", None, "Semi Express", "kelani_valley", DAILY, [
        ("Avissawella", None, "04:40"), ("Colombo Fort", "07:23", None)]),
]
