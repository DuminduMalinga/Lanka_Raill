"""Railway lines and stations of Sri Lanka used by CeylonGO.

Station order follows each line from its Colombo end. Coordinates and
Sinhala names are filled in by enrich.py (Wikipedia / Wikidata) and cached in
cache/stations.json so builds are reproducible offline.
"""

# id, name, colour (hex), from, to, length_km, description
LINES = [
    ("main", "Main Line", "#2F8F5B", "Colombo Fort", "Badulla", 290,
     "The hill-country line climbing from Colombo through Kandy's foothills, "
     "tea estates and cloud forest to Badulla."),
    ("coastal", "Coastal Line", "#7FD3E6", "Colombo Fort", "Beliatta", 195,
     "Hugs the south-west shoreline past beaches, fishing towns and Galle Fort."),
    ("northern", "Northern Line", "#E0A84B", "Polgahawela", "Kankesanthurai", 339,
     "Runs north from the Main Line through the dry zone and Anuradhapura to Jaffna."),
    ("matale", "Matale Line", "#B58BD8", "Kandy", "Matale", 27,
     "A short branch from Kandy north to Matale."),
    ("puttalam", "Puttalam Line", "#5BA4E6", "Ragama", "Puttalam", 133,
     "Coastal line north of Colombo through Negombo and Chilaw."),
    ("trincomalee", "Trincomalee Line", "#E07A5F", "Maho", "Trincomalee", 175,
     "Branches east from Maho via Gal Oya to the natural harbour of Trincomalee."),
    ("batticaloa", "Batticaloa Line", "#D4A373", "Gal Oya", "Batticaloa", 128,
     "From Gal Oya past Polonnaruwa to the eastern lagoon town of Batticaloa."),
    ("kelani_valley", "Kelani Valley Line", "#9CC069", "Maradana", "Avissawella", 59,
     "Suburban line east of Colombo into the Kelani valley."),
]

# Per line, ordered stations: (name, code). Junctions repeat on each line they
# serve; the station row is shared.
LINE_STATIONS = {
    "main": [
        ("Colombo Fort", "FOT"), ("Maradana", "MDA"), ("Ragama", "RGM"),
        ("Gampaha", "GPH"), ("Veyangoda", "VGD"), ("Mirigama", "MIR"),
        ("Polgahawela", "PLG"), ("Rambukkana", "RBK"), ("Kadugannawa", "KGW"),
        ("Peradeniya Junction", "PDA"), ("Kandy", "KDT"), ("Gampola", "GPL"),
        ("Nawalapitiya", "NVP"), ("Hatton", "HTN"), ("Talawakele", "TKL"),
        ("Great Western", "GWN"), ("Nanu Oya", "NOA"), ("Ambewela", "ABL"),
        ("Pattipola", "PPL"), ("Ohiya", "OHA"), ("Idalgashinna", "IGH"),
        ("Haputale", "HPT"), ("Diyatalawa", "DLA"), ("Bandarawela", "BDA"),
        ("Heel Oya", "HLO"), ("Ella", "ELL"), ("Demodara", "DDR"),
        ("Hali Ela", "HEA"), ("Badulla", "BAD"),
    ],
    "coastal": [
        ("Colombo Fort", "FOT"), ("Kollupitiya", "KOL"), ("Bambalapitiya", "BPT"),
        ("Wellawatte", "WWT"), ("Dehiwala", "DWL"), ("Mount Lavinia", "MLV"),
        ("Moratuwa", "MRT"), ("Panadura", "PND"), ("Kalutara South", "KTS"),
        ("Beruwala", "BRL"), ("Aluthgama", "ALT"), ("Bentota", "BEN"),
        ("Ambalangoda", "ABA"), ("Hikkaduwa", "HKD"), ("Galle", "GLE"),
        ("Unawatuna", "UNW"), ("Weligama", "WLM"), ("Matara", "MTR"),
        ("Beliatta", "BEL"),
    ],
    "northern": [
        ("Polgahawela", "PLG"), ("Kurunegala", "KRN"), ("Maho", "MHO"),
        ("Ambanpola", "APL"), ("Galgamuwa", "GLM"), ("Senarathgama", "SRG"),
        ("Thambuttegama", "TBM"), ("Talawa", "TLA"), ("Shrawasthipura", "SWP"),
        ("Anuradhapura", "ANP"), ("Parasangaswewa", "PSW"), ("Medawachchiya", "MWH"),
        ("Punewa", "PNW"), ("Irattaperiyakulam", "IPK"), ("Vavuniya", "VNA"),
        ("Thandikulam", "TDK"), ("Omanthai", "OMT"), ("Puliyankulam", "PYK"),
        ("Mankulam", "MKM"), ("Murukandi", "MKD"), ("Ariviyal Nagar", "AVN"),
        ("Kilinochchi", "KLN"), ("Paranthan", "PRN"), ("Elephant Pass", "EPS"),
        ("Palai", "PLI"), ("Eluthumadduval", "EMV"), ("Mirusuvil", "MSV"),
        ("Kodikamam", "KDK"), ("Meesalai", "MSL"), ("Sankathanai", "SKN"),
        ("Chavakachcheri", "CVK"), ("Thachchanthoppu", "TCT"), ("Navatkuli", "NVK"),
        ("Pungankulam", "PGK"), ("Jaffna", "JFN"), ("Kokuvil", "KKV"),
        ("Kondavil", "KDV"), ("Inuvil", "INV"), ("Chunnakam", "CNK"),
        ("Mallakam", "MLK"), ("Tellippalai", "TLP"), ("Maviddapuram", "MVP"),
        ("Kankesanthurai", "KKS"),
    ],
    "matale": [("Kandy", "KDT"), ("Katugastota", "KGT"), ("Matale", "MTL")],
    "puttalam": [
        ("Ragama", "RGM"), ("Ja-Ela", "JLA"), ("Seeduwa", "SED"),
        ("Katunayake", "KTN"), ("Negombo", "NGB"), ("Kochchikade", "KCH"),
        ("Chilaw", "CHL"), ("Puttalam", "PTM"),
    ],
    "trincomalee": [
        ("Maho", "MHO"), ("Habarana", "HBN"), ("Gal Oya", "GOA"),
        ("Kantale", "KTL"), ("China Bay", "CBY"), ("Trincomalee", "TCO"),
    ],
    "batticaloa": [
        ("Gal Oya", "GOA"), ("Polonnaruwa", "PRW"), ("Valaichchenai", "VCH"),
        ("Eravur", "ERV"), ("Batticaloa", "BCO"),
    ],
    "kelani_valley": [
        ("Maradana", "MDA"), ("Nugegoda", "NUG"), ("Maharagama", "MHG"),
        ("Homagama", "HMA"), ("Padukka", "PDK"), ("Avissawella", "AVS"),
    ],
}

# Wikipedia article titles where "<name> railway station" isn't the article.
WIKI_TITLES = {
    "Colombo Fort": "Fort railway station",
    "Peradeniya Junction": "Peradeniya Junction railway station",
    "Gal Oya": "Gal Oya Junction railway station",
}

# Short descriptions for the most-visited stations (shown on station details).
STATION_NOTES = {
    "Colombo Fort": "Sri Lanka's main railway hub, serving every line out of Colombo.",
    "Maradana": "Colombo's second terminus and starting point of the Kelani Valley Line.",
    "Kandy": "Hill capital, gateway to the Temple of the Sacred Tooth Relic.",
    "Peradeniya Junction": "Where the Main Line meets the Kandy branch; near the Royal Botanic Gardens.",
    "Hatton": "Base for Adam's Peak pilgrims and the Bogawantalawa tea valley.",
    "Nanu Oya": "Alight here for Nuwara Eliya, 8 km up the hill by bus or tuk-tuk.",
    "Pattipola": "Highest station on the network, close to Horton Plains.",
    "Ohiya": "Remote cloud-forest stop, a trailhead for Horton Plains.",
    "Haputale": "Ridge-top town with sweeping views south over the plains.",
    "Ella": "Backpacker favourite for Nine Arch Bridge, Ella Rock and Little Adam's Peak.",
    "Demodara": "Famous for the spiral loop where the line passes under itself.",
    "Badulla": "Eastern terminus of the Main Line.",
    "Galle": "Next to the UNESCO-listed Galle Fort.",
    "Matara": "Southern town at the end of most Coastal Line services.",
    "Beliatta": "Newest terminus on the southern extension of the Coastal Line.",
    "Anuradhapura": "Ancient capital and UNESCO World Heritage city.",
    "Jaffna": "Cultural capital of the north.",
    "Kankesanthurai": "Northern terminus of the network.",
    "Trincomalee": "Natural harbour town on the east coast.",
    "Batticaloa": "Lagoon town on the east coast.",
    "Negombo": "Beach town near Bandaranaike International Airport.",
    "Habarana": "Nearest station to Sigiriya and Minneriya.",
}
