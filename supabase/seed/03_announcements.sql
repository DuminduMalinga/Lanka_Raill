-- Service notices shown on Home and in Announcements.
-- Based on seat61.com/SriLanka.htm (page updated 2026-06-10). Inserted only
-- when the table is empty, so re-running never duplicates them.
insert into public.announcements (title_en, title_si, body_en, body_si, severity, starts_at)
select * from (values
('Hill country services still affected',
 'කඳුකර දුම්රිය සේවා තවමත් බාධිතයි',
 'After cyclone damage in 2025, full service has not been restored on some routes. Colombo – Kandy – Badulla (tea country) trains are still affected; Colombo – Galle – Matara, Batticaloa and Trincomalee services are running. Check railway.gov.lk or your station before travelling. (Reported by seat61.com, updated 10 June 2026.)',
 '2025 සුළි කුණාටු හානියෙන් පසු සමහර මාර්ගවල සම්පූර්ණ සේවාව තවමත් යථා තත්ත්වයට පත් කර නැත. කොළඹ – මහනුවර – බදුල්ල දුම්රිය සේවා තවමත් බාධිතයි; කොළඹ – ගාල්ල – මාතර, මඩකලපුව සහ ත්‍රිකුණාමලය සේවා ක්‍රියාත්මකයි. ගමනට පෙර railway.gov.lk හෝ ඔබේ දුම්රිය ස්ථානය පරීක්ෂා කරන්න.',
 'warning', now()),
('About these timetables',
 'මෙම කාලසටහන් ගැන',
 'Train times in CeylonGO come from the public timetable on seat61.com (updated 10 June 2026) and list main stations only. The official Sri Lanka Railways schedule site is currently unavailable. Always double-check times at the station.',
 'CeylonGO හි දුම්රිය වේලාවන් seat61.com හි පොදු කාලසටහනෙන් (2026 ජූනි 10 යාවත්කාලීන) ලබාගත් අතර ප්‍රධාන දුම්රිය ස්ථාන පමණක් දක්වයි. ශ්‍රී ලංකා දුම්රිය නිල කාලසටහන් වෙබ් අඩවිය දැනට ලබාගත නොහැක. සෑම විටම දුම්රිය ස්ථානයේදී වේලාවන් නැවත තහවුරු කරගන්න.',
 'info', now())
) v(a,b,c,d,e,f)
where not exists (select 1 from public.announcements);
