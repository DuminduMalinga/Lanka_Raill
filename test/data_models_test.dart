import 'package:flutter_test/flutter_test.dart';
import 'package:lankarail/data/models.dart';

void main() {
  group('runsOnDay', () {
    test('daily runs every day', () {
      for (var d = 1; d <= 7; d++) {
        expect(runsOnDay('Daily', d), isTrue);
      }
    });

    test('ranges and lists', () {
      expect(runsOnDay('Mon-Fri', DateTime.monday), isTrue);
      expect(runsOnDay('Mon-Fri', DateTime.saturday), isFalse);
      expect(runsOnDay('Sat, Sun', DateTime.sunday), isTrue);
      expect(runsOnDay('Sat, Sun', DateTime.wednesday), isFalse);
      expect(runsOnDay('Tue, Fri, Sun', DateTime.friday), isTrue);
      expect(runsOnDay('Tue, Fri, Sun', DateTime.thursday), isFalse);
      expect(runsOnDay('Mon-Fri, Sun', DateTime.sunday), isTrue);
      expect(runsOnDay('Mon-Fri, Sun', DateTime.saturday), isFalse);
      expect(runsOnDay('Mon-Sat', DateTime.saturday), isTrue);
    });
  });

  test('formatDuration', () {
    expect(formatDuration(45), '45m');
    expect(formatDuration(120), '2h');
    expect(formatDuration(623), '10h 23m');
  });

  test('JourneyOption parses the search_journeys row', () {
    final o = JourneyOption.fromJson({
      'train_id': 't1',
      'train_number': '1045',
      'train_name_en': 'Night Mail',
      'train_name_si': null,
      'train_type': 'Night Mail',
      'runs_on': 'Daily',
      'depart_time': '20:30:00',
      'arrive_time': '06:46:00',
      'depart_day': 0,
      'arrive_day': 1,
      'duration_minutes': 616,
      'stops_between': 4,
      'verified': false,
    });
    expect(o.departTime, '20:30');
    expect(o.arriveTime, '06:46');
    expect(o.arriveDay, 1);
    expect(o.departMinutes, 20 * 60 + 30);
    expect(o.runsOnDate(DateTime(2026, 11, 23)), isTrue);
  });

  test('Destination sorts nearest stations by distance', () {
    final d = Destination.fromJson({
      'id': 'd1',
      'name_en': 'Nine Arch Bridge',
      'name_si': null,
      'description_en': 'Viaduct',
      'description_si': null,
      'category_id': 'c1',
      'lat': 6.87,
      'lng': 81.06,
      'cover_photo_url': null,
      'cover_photo_credit': null,
      'destination_categories': {'name_en': 'Scenic views', 'name_si': null},
      'destination_tags': [
        {'tag': 'Free entry'},
      ],
      'destination_stations': [
        {
          'walk_km': 3.0,
          'stations': {'id': 's2', 'code': 'DDR', 'name_en': 'Demodara'},
        },
        {
          'walk_km': 2.5,
          'stations': {'id': 's1', 'code': 'ELL', 'name_en': 'Ella'},
        },
      ],
    });
    expect(d.nearest!.station.code, 'ELL');
    expect(d.tags, ['Free entry']);
    expect(d.categoryName!.en, 'Scenic views');
  });
}
