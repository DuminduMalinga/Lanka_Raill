-- CeylonGO reference seed. Run after all migrations.
-- Stable data only: stations, train identities, destinations and their
-- tags / nearest stations, plus Sinhala names for lines, facilities and
-- categories. NO timetable times are seeded here —
-- those must be entered from the official Sri Lanka Railways timetable
-- (see supabase/README.md).
--
-- Every row is tagged source = 'seed-unverified'. Station codes and
-- coordinates are approximate; check each one, then set verified_at.
-- Safe to re-run: all inserts skip rows that already exist.

begin;

-- Sinhala names for the lines / facilities / categories created by
-- migration 20261120132152_seed_reference_data (fills empty values only).
update public.railway_lines l set name_si = v.si from (values
  ('Main Line','ප්‍රධාන මාර්ගය'),('Matale Line','මාතලේ මාර්ගය'),('Coastal Line','මුහුදුබඩ මාර්ගය'),
  ('Puttalam Line','පුත්තලම මාර්ගය'),('Kelani Valley Line','කැළණිවැලි මාර්ගය'),('Northern Line','උතුරු මාර්ගය'),
  ('Mannar Line','මන්නාරම මාර්ගය'),('Batticaloa Line','මඩකලපුව මාර්ගය'),('Trincomalee Line','ත්‍රිකුණාමලය මාර්ගය')
) v(en, si) where l.name_en = v.en and l.name_si is null;

update public.facilities f set name_si = v.si from (values
  ('Ticket counter','ටිකට් කවුළුව'),('Waiting room','පොරොත්තු කාමරය'),('Toilets','වැසිකිළි'),
  ('Drinking water','පානීය ජලය'),('Food stalls','ආහාර කඩ'),('Parking','වාහන නැවතුම'),
  ('Tuk-tuk stand','ත්‍රීරෝද රථ නැවතුම'),('Wheelchair access','රෝද පුටු පහසුකම'),('ATM','ATM')
) v(en, si) where f.name_en = v.en and f.name_si is null;

update public.destination_categories c set name_si = v.si from (values
  ('Scenic views','දර්ශනීය ස්ථාන'),('Waterfalls','දිය ඇලි'),('Hiking','කඳු නැගීම'),('Heritage','උරුමය'),
  ('Temples','විහාර හා දේවාල'),('Beaches','වෙරළ'),('Wildlife','වනජීවී'),('Tea country','තේ වතු ප්‍රදේශ')
) v(en, si) where c.name_en = v.en and c.name_si is null;

-- Stations ---------------------------------------------------------------
insert into public.stations (code, name_en, name_si, line_id, district, lat, lng, source)
select v.code, v.name_en, v.name_si, l.id, v.district, v.lat, v.lng, 'seed-unverified'
from (values
  -- Main Line
  ('FOT','Colombo Fort','කොළඹ කොටුව','Main Line','Colombo',6.9336,79.8500),
  ('MDA','Maradana','මරදාන','Main Line','Colombo',6.9290,79.8653),
  ('RGM','Ragama','රාගම','Main Line','Gampaha',7.0306,79.9200),
  ('PLG','Polgahawela','පොල්ගහවෙල','Main Line','Kurunegala',7.3333,80.3000),
  ('RBK','Rambukkana','රඹුක්කන','Main Line','Kegalle',7.3236,80.3925),
  ('PDA','Peradeniya','පේරාදෙණිය','Main Line','Kandy',7.2588,80.5969),
  ('GPL','Gampola','ගම්පොළ','Main Line','Kandy',7.1641,80.5767),
  ('HTN','Hatton','හැටන්','Main Line','Nuwara Eliya',6.8916,80.5955),
  ('TKL','Talawakele','තලවකැලේ','Main Line','Nuwara Eliya',6.9370,80.6576),
  ('NOA','Nanu Oya','නානුඔය','Main Line','Nuwara Eliya',6.9418,80.7461),
  ('PTP','Pattipola','පට්ටිපොල','Main Line','Nuwara Eliya',6.8564,80.8292),
  ('OHY','Ohiya','ඔහිය','Main Line','Badulla',6.8211,80.8411),
  ('HPT','Haputale','හපුතලේ','Main Line','Badulla',6.7680,80.9580),
  ('BDA','Bandarawela','බණ්ඩාරවෙල','Main Line','Badulla',6.8300,80.9870),
  ('ELL','Ella','ඇල්ල','Main Line','Badulla',6.8768,81.0461),
  ('DDR','Demodara','දෙමෝදර','Main Line','Badulla',6.9033,81.0617),
  ('BAD','Badulla','බදුල්ල','Main Line','Badulla',6.9897,81.0570),
  -- Matale Line
  ('KDT','Kandy','මහනුවර','Matale Line','Kandy',7.2919,80.6327),
  ('MTL','Matale','මාතලේ','Matale Line','Matale',7.4675,80.6234),
  -- Coastal Line
  ('MLV','Mount Lavinia','ගල්කිස්ස','Coastal Line','Colombo',6.8306,79.8633),
  ('ALT','Aluthgama','අළුත්ගම','Coastal Line','Kalutara',6.4314,79.9989),
  ('BNT','Bentota','බෙන්තොට','Coastal Line','Galle',6.4253,80.0000),
  ('HKD','Hikkaduwa','හික්කඩුව','Coastal Line','Galle',6.1395,80.1036),
  ('GLE','Galle','ගාල්ල','Coastal Line','Galle',6.0333,80.2140),
  ('UNW','Unawatuna','උණවටුන','Coastal Line','Galle',6.0186,80.2489),
  ('WLG','Weligama','වැලිගම','Coastal Line','Matara',5.9744,80.4290),
  ('MTR','Matara','මාතර','Coastal Line','Matara',5.9497,80.5428),
  -- Northern Line
  ('KUR','Kurunegala','කුරුණෑගල','Northern Line','Kurunegala',7.4863,80.3647),
  ('ANP','Anuradhapura','අනුරාධපුරය','Northern Line','Anuradhapura',8.3222,80.4140),
  ('VNA','Vavuniya','වවුනියාව','Northern Line','Vavuniya',8.7547,80.4980),
  ('JFN','Jaffna','යාපනය','Northern Line','Jaffna',9.6585,80.0110),
  -- Puttalam Line
  ('NGB','Negombo','මීගමුව','Puttalam Line','Gampaha',7.2080,79.8410),
  -- Batticaloa Line
  ('HBN','Habarana','හබරණ','Batticaloa Line','Anuradhapura',8.0390,80.7440),
  ('PLN','Polonnaruwa','පොළොන්නරුව','Batticaloa Line','Polonnaruwa',7.9396,81.0037),
  ('BCO','Batticaloa','මඩකලපුව','Batticaloa Line','Batticaloa',7.7170,81.6950),
  -- Trincomalee Line
  ('TCO','Trincomalee','ත්‍රිකුණාමලය','Trincomalee Line','Trincomalee',8.5810,81.2290)
) as v(code, name_en, name_si, line_name, district, lat, lng)
join public.railway_lines l on l.name_en = v.line_name
on conflict (code) do nothing;

-- Trains (identity only — no times) ---------------------------------------
insert into public.trains (number, name_en, name_si, type, line_id, source)
select v.number, v.name_en, v.name_si, v.type, l.id, 'seed-unverified'
from (values
  ('1005','Podi Menike','පොඩි මැණිකේ','Express','Main Line'),
  ('1006','Podi Menike','පොඩි මැණිකේ','Express','Main Line'),
  ('1015','Udarata Menike','උඩරට මැණිකේ','Express','Main Line'),
  ('1016','Udarata Menike','උඩරට මැණිකේ','Express','Main Line')
) as v(number, name_en, name_si, type, line_name)
join public.railway_lines l on l.name_en = v.line_name
on conflict (number) do nothing;

-- Destinations -----------------------------------------------------------
insert into public.destinations (name_en, name_si, category_id, description_en, lat, lng, source)
select v.name_en, v.name_si, c.id, v.description_en, v.lat, v.lng, 'seed-unverified'
from (values
  ('Nine Arch Bridge','නව ආරුක්කු පාලම','Scenic views',
   'A colonial-era stone railway viaduct between Ella and Demodara, set among jungle and tea. Arrive before a scheduled train to watch it cross.',6.8768,81.0608),
  ('Little Adam''s Peak','පුංචි ශ්‍රී පාදය','Hiking',
   'A short, easy hike near Ella through tea estates to a summit with wide views of Ella Gap.',6.8669,81.0590),
  ('Ravana Falls','රාවණා ඇල්ල','Waterfalls',
   'A tiered waterfall beside the Ella–Wellawaya road, one of the most visited falls in the country.',6.8410,81.0540),
  ('Horton Plains','හෝර්ටන් තැන්න','Wildlife',
   'A high-altitude national park of grassland and cloud forest, home to the World''s End escarpment and Baker''s Falls.',6.8020,80.8060),
  ('Temple of the Sacred Tooth Relic','ශ්‍රී දළදා මාළිගාව','Temples',
   'The Buddhist temple in Kandy that houses the relic of the tooth of the Buddha, part of the Sacred City of Kandy World Heritage Site.',7.2936,80.6413),
  ('Royal Botanic Gardens, Peradeniya','පේරාදෙණිය රාජකීය උද්භිද උද්‍යානය','Scenic views',
   'Large botanic gardens beside the Mahaweli river near Kandy, known for orchids, palm avenues and giant fig trees.',7.2690,80.5960),
  ('Galle Fort','ගාල්ල කොටුව','Heritage',
   'A fortified old town on the southern coast, first built by the Portuguese and extended by the Dutch. A UNESCO World Heritage Site.',6.0260,80.2170),
  ('Unawatuna Beach','උණවටුන වෙරළ','Beaches',
   'A sheltered, crescent-shaped bay east of Galle, popular for swimming and snorkelling.',6.0100,80.2490),
  ('Mount Lavinia Beach','ගල්කිස්ස වෙරළ','Beaches',
   'A city beach just south of Colombo, a short walk from Mount Lavinia station.',6.8340,79.8620),
  ('Sigiriya','සීගිරිය','Heritage',
   'A 5th-century rock fortress rising above the plains, with frescoes and water gardens. A UNESCO World Heritage Site.',7.9570,80.7603),
  ('Ancient City of Polonnaruwa','පුරාණ පොළොන්නරු නගරය','Heritage',
   'Ruins of the medieval capital, including the Gal Vihara rock-cut Buddha statues. A UNESCO World Heritage Site.',7.9403,81.0188),
  ('Sacred City of Anuradhapura','අනුරාධපුර පූජා නගරය','Heritage',
   'The ancient capital with great stupas and the Sri Maha Bodhi tree. A UNESCO World Heritage Site.',8.3450,80.3960),
  ('Jaffna Fort','යාපනය කොටුව','Heritage',
   'A star-shaped Dutch-era fort by the Jaffna lagoon.',9.6620,80.0080)
) as v(name_en, name_si, cat, description_en, lat, lng)
join public.destination_categories c on c.name_en = v.cat
on conflict (name_en) do nothing;

-- Destination tags -------------------------------------------------------
insert into public.destination_tags (destination_id, tag)
select d.id, v.tag
from (values
  ('Nine Arch Bridge','Scenic view'), ('Nine Arch Bridge','Free entry'), ('Nine Arch Bridge','Easy walk'),
  ('Little Adam''s Peak','Easy hike'), ('Little Adam''s Peak','Free entry'),
  ('Ravana Falls','Roadside'), ('Ravana Falls','Free entry'),
  ('Horton Plains','National park'), ('Horton Plains','Ticketed'),
  ('Temple of the Sacred Tooth Relic','UNESCO'), ('Temple of the Sacred Tooth Relic','Dress code'),
  ('Galle Fort','UNESCO'), ('Galle Fort','Free entry'),
  ('Sigiriya','UNESCO'), ('Sigiriya','Ticketed'),
  ('Ancient City of Polonnaruwa','UNESCO'), ('Ancient City of Polonnaruwa','Ticketed'),
  ('Sacred City of Anuradhapura','UNESCO')
) as v(dest, tag)
join public.destinations d on d.name_en = v.dest
on conflict do nothing;

-- Nearest stations (approx. km by road/path, >= straight line)----------------------
insert into public.destination_stations (destination_id, station_id, walk_km)
select d.id, s.id, v.km
from (values
  ('Nine Arch Bridge','ELL',2.5), ('Nine Arch Bridge','DDR',3.0),
  ('Little Adam''s Peak','ELL',4.0),
  ('Ravana Falls','ELL',6.0),
  ('Horton Plains','OHY',11.0), ('Horton Plains','PTP',10.0),
  ('Temple of the Sacred Tooth Relic','KDT',1.2),
  ('Royal Botanic Gardens, Peradeniya','PDA',1.2),
  ('Galle Fort','GLE',1.0),
  ('Unawatuna Beach','UNW',1.0),
  ('Mount Lavinia Beach','MLV',0.5),
  ('Sigiriya','HBN',17.0),
  ('Ancient City of Polonnaruwa','PLN',3.0),
  ('Sacred City of Anuradhapura','ANP',3.5),
  ('Jaffna Fort','JFN',1.5)
) as v(dest, code, km)
join public.destinations d on d.name_en = v.dest
join public.stations s on s.code = v.code
on conflict do nothing;

commit;
