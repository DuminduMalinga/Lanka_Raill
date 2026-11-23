"""Places worth stepping off the train for.

Coordinates are the attraction itself; distance to the nearest station is
computed at build time. Photos are fetched from Wikimedia Commons by
enrich_images.py using `commons` (a search query) and cached with credits.

Categories: hill, beaches, heritage, wildlife, north, views.
"""

DESTINATIONS = [
    {
        "id": "nine-arch-bridge", "name": "Nine Arch Bridge", "category": "views",
        "station": "Ella", "lat": 6.8768, "lng": 81.0608, "featured": True,
        "tagline": "Colonial-era stone viaduct in the tea hills",
        "description": "Built in 1921 entirely of stone, brick and cement without steel, "
                       "the 91 m bridge curves between Ella and Demodara. Time a visit for a "
                       "train crossing - the Podi Menike and Udarata Menike both pass in the morning.",
        "tips": ["Walk along the tracks from Ella station (about 40 min)",
                 "Arrive before 9 am to beat the crowds"],
        "commons": "Nine Arch Bridge Ella",
    },
    {
        "id": "little-adams-peak", "name": "Little Adam's Peak", "category": "hill",
        "station": "Ella", "lat": 6.8695, "lng": 81.0597,
        "tagline": "Easy sunrise hike above Ella Gap",
        "description": "A gentle 45-minute climb through tea gardens to a grassy summit "
                       "with views down the Ella Gap to the southern plains.",
        "tips": ["Start before sunrise for cool air and clear views"],
        "commons": "Little Adam's Peak Ella",
    },
    {
        "id": "ella-rock", "name": "Ella Rock", "category": "hill",
        "station": "Ella", "lat": 6.8566, "lng": 81.0426,
        "tagline": "Steeper half-day hike with a huge view",
        "description": "Follow the railway south from Ella then climb through eucalyptus "
                       "forest to a cliff edge 1,040 m up.",
        "tips": ["Allow 4 hours return", "Take water - there's little shade at the top"],
        "commons": "Ella Rock Sri Lanka",
    },
    {
        "id": "demodara-loop", "name": "Demodara Loop", "category": "views",
        "station": "Demodara", "lat": 6.9017, "lng": 81.0547,
        "tagline": "Where the line spirals under itself",
        "description": "An engineering curiosity: the track loops round a hill and passes "
                       "beneath itself, tunnelling right under Demodara station.",
        "tips": ["Sit on the left heading towards Badulla"],
        "commons": "Demodara railway station loop",
    },
    {
        "id": "temple-of-the-tooth", "name": "Temple of the Sacred Tooth Relic",
        "category": "heritage", "station": "Kandy", "lat": 7.2936, "lng": 80.6413,
        "featured": True,
        "tagline": "Kandy's revered lakeside temple",
        "description": "Sri Lanka's most important Buddhist shrine sits beside Kandy Lake "
                       "inside the old royal palace complex. Evening puja draws drummers and devotees.",
        "tips": ["Dress modestly - shoulders and knees covered",
                 "Puja times: around 5:30 am, 9:30 am and 6:30 pm"],
        "commons": "Temple of the Tooth Kandy",
    },
    {
        "id": "peradeniya-gardens", "name": "Royal Botanic Gardens, Peradeniya",
        "category": "wildlife", "station": "Peradeniya Junction",
        "lat": 7.2687, "lng": 80.5966,
        "tagline": "147 acres of orchids, palms and giant bamboo",
        "description": "Founded in 1843, the gardens hold over 4,000 species, an orchid "
                       "house and a famous avenue of royal palms.",
        "tips": ["Peradeniya station is a 10-minute walk away"],
        "commons": "Royal Botanical Gardens Peradeniya",
    },
    {
        "id": "horton-plains", "name": "Horton Plains & World's End", "category": "wildlife",
        "station": "Ohiya", "lat": 6.8020, "lng": 80.8050,
        "tagline": "Misty plateau ending at an 870 m drop",
        "description": "A national park of grassland and cloud forest at over 2,000 m. "
                       "The 9 km loop passes Baker's Falls and the sheer cliff of World's End.",
        "tips": ["Be at World's End before 10 am, when cloud rolls in",
                 "Ohiya and Pattipola stations are the nearest"],
        "commons": "World's End Horton Plains",
    },
    {
        "id": "nuwara-eliya", "name": "Nuwara Eliya & Gregory Lake", "category": "hill",
        "station": "Nanu Oya", "lat": 6.9580, "lng": 80.7754,
        "tagline": "Cool-climate 'Little England'",
        "description": "Colonial bungalows, a racecourse and tea estates surround the "
                       "boating lake in Sri Lanka's highest town.",
        "tips": ["Take a bus or tuk-tuk 8 km up from Nanu Oya station"],
        "commons": "Gregory Lake Nuwara Eliya",
    },
    {
        "id": "liptons-seat", "name": "Lipton's Seat", "category": "hill",
        "station": "Haputale", "lat": 6.7656, "lng": 80.9692,
        "tagline": "Tea baron's lookout over seven provinces",
        "description": "Sir Thomas Lipton surveyed his Dambatenne estate from this "
                       "1,970 m viewpoint. Walk up through the tea from the factory.",
        "tips": ["Go at dawn - mist usually covers the view by mid-morning"],
        "commons": "Lipton's Seat Haputale",
    },
    {
        "id": "adams-peak", "name": "Adam's Peak (Sri Pada)", "category": "hill",
        "station": "Hatton", "lat": 6.8096, "lng": 80.4994,
        "tagline": "Overnight pilgrim climb to a sacred summit",
        "description": "Thousands of pilgrims climb 5,500 steps by night between December "
                       "and May to watch sunrise from the 2,243 m peak.",
        "tips": ["Bus from Hatton to Dalhousie (about 1.5 h)",
                 "Season runs from Unduvap Poya (Dec) to Vesak (May)"],
        "commons": "Adam's Peak Sri Pada",
    },
    {
        "id": "galle-fort", "name": "Galle Fort", "category": "heritage",
        "station": "Galle", "lat": 6.0275, "lng": 80.2170, "featured": True,
        "tagline": "UNESCO-listed ramparts by the sea",
        "description": "A 17th-century Dutch fortified town of lanes, churches and "
                       "boutiques, ringed by walls you can walk at sunset.",
        "tips": ["The station is a 5-minute walk across the cricket ground"],
        "commons": "Galle Fort lighthouse",
    },
    {
        "id": "unawatuna", "name": "Unawatuna Beach", "category": "beaches",
        "station": "Unawatuna", "lat": 6.0100, "lng": 80.2493,
        "tagline": "Sheltered bay for swimming and snorkelling",
        "description": "A crescent of sand protected by a reef, lined with cafes, and a "
                       "short hop from Galle.",
        "tips": ["Calmest seas November to April"],
        "commons": "Unawatuna beach",
    },
    {
        "id": "hikkaduwa", "name": "Hikkaduwa", "category": "beaches",
        "station": "Hikkaduwa", "lat": 6.1377, "lng": 80.0995,
        "tagline": "Surf breaks, coral and sea turtles",
        "description": "A lively beach town with a coral sanctuary, surf breaks and "
                       "turtles feeding in the shallows.",
        "tips": ["The station is a few minutes' walk from the beach"],
        "commons": "Hikkaduwa beach",
    },
    {
        "id": "bentota", "name": "Bentota", "category": "beaches",
        "station": "Bentota", "lat": 6.4202, "lng": 79.9980,
        "tagline": "Wide golden beach and river lagoon",
        "description": "Long sands where the Bentota river meets the sea - good for "
                       "watersports and river safaris.",
        "tips": ["Some express trains stop at Aluthgama instead"],
        "commons": "Bentota beach",
    },
    {
        "id": "mirissa", "name": "Mirissa", "category": "beaches",
        "station": "Weligama", "lat": 5.9462, "lng": 80.4598,
        "tagline": "Palm-fringed bay and whale watching",
        "description": "A laid-back bay famed for blue-whale trips between November and April.",
        "tips": ["Weligama station is 6 km away by tuk-tuk"],
        "commons": "Mirissa beach",
    },
    {
        "id": "anuradhapura", "name": "Sacred City of Anuradhapura", "category": "heritage",
        "station": "Anuradhapura", "lat": 8.3500, "lng": 80.3964,
        "tagline": "Ancient capital of giant stupas",
        "description": "Capital for over a millennium, home to the Ruwanwelisaya and "
                       "Jetavanaramaya stupas and the sacred Sri Maha Bodhi tree.",
        "tips": ["Hire a bicycle to cover the sprawling site"],
        "commons": "Ruwanwelisaya Anuradhapura",
    },
    {
        "id": "polonnaruwa", "name": "Ancient City of Polonnaruwa", "category": "heritage",
        "station": "Polonnaruwa", "lat": 7.9403, "lng": 81.0188,
        "tagline": "Medieval capital and the Gal Vihara Buddhas",
        "description": "Well-preserved 12th-century palaces and temples, crowned by the "
                       "rock-cut Buddhas of Gal Vihara.",
        "tips": ["Buy the ticket at the museum near the entrance"],
        "commons": "Gal Vihara Polonnaruwa",
    },
    {
        "id": "sigiriya", "name": "Sigiriya Rock Fortress", "category": "heritage",
        "station": "Habarana", "lat": 7.9570, "lng": 80.7603,
        "tagline": "5th-century palace atop a 200 m rock",
        "description": "Climb past frescoes and the Lion Gate to the ruins of King "
                       "Kashyapa's sky palace.",
        "tips": ["Habarana station is about 20 km away by bus or taxi"],
        "commons": "Sigiriya rock",
    },
    {
        "id": "minneriya", "name": "Minneriya National Park", "category": "wildlife",
        "station": "Habarana", "lat": 8.0330, "lng": 80.8500,
        "tagline": "'The Gathering' of wild elephants",
        "description": "Hundreds of elephants converge on the reservoir in the dry season "
                       "(July to October).",
        "tips": ["Jeep safaris leave from Habarana in the afternoon"],
        "commons": "Minneriya elephants",
    },
    {
        "id": "jaffna-fort", "name": "Jaffna Fort", "category": "north",
        "station": "Jaffna", "lat": 9.6619, "lng": 80.0085,
        "tagline": "Star-shaped Dutch fort on the lagoon",
        "description": "Built by the Portuguese and rebuilt by the Dutch in 1680, the fort "
                       "looks over Jaffna lagoon.",
        "tips": ["Combine with the nearby Jaffna Public Library"],
        "commons": "Jaffna Fort",
    },
    {
        "id": "nallur-kovil", "name": "Nallur Kandaswamy Kovil", "category": "north",
        "station": "Jaffna", "lat": 9.6747, "lng": 80.0296,
        "tagline": "Golden-towered Hindu temple",
        "description": "The heart of Jaffna's Tamil Hindu culture; the 25-day festival in "
                       "August draws huge crowds.",
        "tips": ["Men remove shirts before entering"],
        "commons": "Nallur Kandaswamy temple",
    },
    {
        "id": "trincomalee", "name": "Koneswaram & Trincomalee", "category": "north",
        "station": "Trincomalee", "lat": 8.5816, "lng": 81.2450,
        "tagline": "Clifftop temple above a natural harbour",
        "description": "The Koneswaram temple stands on Swami Rock, with Nilaveli and "
                       "Uppuveli beaches a short ride north.",
        "tips": ["Beaches are calmest May to September"],
        "commons": "Koneswaram temple Trincomalee",
    },
    {
        "id": "pasikudah", "name": "Pasikudah", "category": "beaches",
        "station": "Valaichchenai", "lat": 7.9300, "lng": 81.5600,
        "tagline": "Shallow turquoise bay on the east coast",
        "description": "Waist-deep water stretches far offshore - ideal for families.",
        "tips": ["Best May to September"],
        "commons": "Pasikudah beach",
    },
    {
        "id": "negombo", "name": "Negombo Lagoon & Beach", "category": "beaches",
        "station": "Negombo", "lat": 7.2083, "lng": 79.8358,
        "tagline": "Fishing town near the airport",
        "description": "Outrigger canoes, a busy fish market and Dutch canals - an easy "
                       "first or last stop.",
        "tips": ["The airport is 20 minutes away"],
        "commons": "Negombo beach",
    },
    {
        "id": "pinnawala", "name": "Pinnawala Elephant Orphanage", "category": "wildlife",
        "station": "Rambukkana", "lat": 7.3008, "lng": 80.3887,
        "tagline": "Bath time for rescued elephants",
        "description": "Watch the herd cross the road to bathe in the Maha Oya river twice a day.",
        "tips": ["Rambukkana station is about 3 km away"],
        "commons": "Pinnawala Elephant Orphanage",
    },
    {
        "id": "galle-face", "name": "Galle Face Green", "category": "heritage",
        "station": "Colombo Fort", "lat": 6.9271, "lng": 79.8449,
        "tagline": "Colombo's seafront promenade",
        "description": "A half-kilometre oceanfront lawn where Colombo comes to fly kites "
                       "and eat street food at sunset.",
        "tips": ["A short walk from Fort and Kollupitiya stations"],
        "commons": "Galle Face Green Colombo",
    },
    {
        "id": "dunhinda-falls", "name": "Dunhinda Falls", "category": "wildlife",
        "station": "Badulla", "lat": 7.0237, "lng": 81.0573,
        "tagline": "Misty 64 m waterfall near Badulla",
        "description": "A short forest trail leads to one of Sri Lanka's most beautiful falls.",
        "tips": ["About 6 km from Badulla station"],
        "commons": "Dunhinda Falls",
    },
]
