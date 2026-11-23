alter table public.railway_lines add constraint railway_lines_name_en_key unique (name_en);
alter table public.facilities add constraint facilities_name_en_key unique (name_en);
alter table public.destination_categories add constraint destination_categories_name_en_key unique (name_en);
alter table public.destinations add constraint destinations_name_en_key unique (name_en);
alter table public.destination_photos add constraint destination_photos_dest_url_key unique (destination_id, url);
alter table public.train_classes add constraint train_classes_train_class_key unique (train_id, class_name);
alter table public.train_highlights add constraint train_highlights_train_text_key unique (train_id, text_en);

insert into public.railway_lines (name_en, description_en) values
  ('Main Line',          'Colombo Fort to Badulla via Kandy (Peradeniya), Nanu Oya and Ella'),
  ('Matale Line',        'Peradeniya Junction to Matale via Kandy'),
  ('Coastal Line',       'Colombo Fort to Beliatta via Galle and Matara'),
  ('Puttalam Line',      'Ragama to Puttalam via Negombo and Chilaw'),
  ('Kelani Valley Line', 'Colombo (Maradana) to Avissawella'),
  ('Northern Line',      'Polgahawela to Kankesanthurai via Anuradhapura and Jaffna'),
  ('Mannar Line',        'Medawachchiya to Talaimannar'),
  ('Batticaloa Line',    'Maho to Batticaloa via Polonnaruwa'),
  ('Trincomalee Line',   'Gal Oya Junction to Trincomalee')
on conflict (name_en) do nothing;

insert into public.facilities (name_en, icon) values
  ('Ticket counter',   'confirmation_number_outlined'),
  ('Waiting room',     'chair_outlined'),
  ('Toilets',          'wc_outlined'),
  ('Drinking water',   'water_drop_outlined'),
  ('Food stalls',      'restaurant_outlined'),
  ('Parking',          'local_parking_outlined'),
  ('Tuk-tuk stand',    'local_taxi_outlined'),
  ('Wheelchair access','accessible_outlined'),
  ('ATM',              'atm_outlined')
on conflict (name_en) do nothing;

insert into public.destination_categories (name_en, icon) values
  ('Scenic views', 'landscape_outlined'),
  ('Waterfalls',   'water_outlined'),
  ('Hiking',       'terrain_outlined'),
  ('Heritage',     'account_balance_outlined'),
  ('Temples',      'temple_buddhist_outlined'),
  ('Beaches',      'beach_access_outlined'),
  ('Wildlife',     'pets_outlined'),
  ('Tea country',  'eco_outlined')
on conflict (name_en) do nothing;
