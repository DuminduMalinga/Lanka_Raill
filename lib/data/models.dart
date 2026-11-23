import 'package:material_ui/material_ui.dart';

/// English / Sinhala text pair; picks Sinhala when the app is in Sinhala.
@immutable
class LocalizedText {
  const LocalizedText(this.en, [this.si]);

  final String en;
  final String? si;

  String of(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'si' && (si?.isNotEmpty ?? false) ? si! : en;
  }

  @override
  String toString() => en;
}

LocalizedText _text(Map<String, dynamic> j, String base) =>
    LocalizedText((j['${base}_en'] as String?) ?? '', j['${base}_si'] as String?);

double? _num(Object? v) => v == null ? null : (v as num).toDouble();

/// "HH:MM:SS" → "HH:MM".
String? _hhmm(Object? v) {
  if (v == null) return null;
  final s = v as String;
  return s.length >= 5 ? s.substring(0, 5) : s;
}

/// Minutes → "10h 25m".
String formatDuration(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}m';
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}

@immutable
class RailwayLine {
  const RailwayLine({
    required this.id,
    required this.name,
    this.description,
    this.color,
    this.stationCount = 0,
  });

  factory RailwayLine.fromJson(Map<String, dynamic> j) => RailwayLine(
    id: j['id'] as String,
    name: _text(j, 'name'),
    description: j['description_en'] == null ? null : _text(j, 'description'),
    color: j['color'] as String?,
    stationCount: (j['stations'] is List)
        ? ((j['stations'] as List).isNotEmpty
              ? ((j['stations'] as List).first['count'] as int? ?? 0)
              : 0)
        : 0,
  );

  final String id;
  final LocalizedText name;
  final LocalizedText? description;
  final String? color;
  final int stationCount;

  Color get colorValue {
    final hex = color?.replaceFirst('#', '');
    if (hex == null || hex.length != 6) return const Color(0xFF2E7D32);
    return Color(int.parse('FF$hex', radix: 16));
  }
}

@immutable
class Station {
  const Station({
    required this.id,
    required this.code,
    required this.name,
    this.lineId,
    this.lineName,
    this.district,
    this.elevationM,
    this.lat,
    this.lng,
    this.photoUrl,
    this.photoCredit,
  });

  factory Station.fromJson(Map<String, dynamic> j) {
    final line = j['railway_lines'] as Map<String, dynamic>?;
    return Station(
      id: j['id'] as String,
      code: j['code'] as String,
      name: _text(j, 'name'),
      lineId: j['line_id'] as String?,
      lineName: line == null ? null : _text(line, 'name'),
      district: j['district'] as String?,
      elevationM: j['elevation_m'] as int?,
      lat: _num(j['lat']),
      lng: _num(j['lng']),
      photoUrl: j['photo_url'] as String?,
      photoCredit: j['photo_credit'] as String?,
    );
  }

  final String id;
  final String code;
  final LocalizedText name;
  final String? lineId;
  final LocalizedText? lineName;
  final String? district;
  final int? elevationM;
  final double? lat;
  final double? lng;
  final String? photoUrl;
  final String? photoCredit;

  bool get hasLocation => lat != null && lng != null;
}

/// One train with its first and last stop (from the `train_summaries` view).
@immutable
class TrainSummary {
  const TrainSummary({
    required this.id,
    required this.number,
    required this.name,
    required this.type,
    required this.runsOn,
    required this.originCode,
    required this.originName,
    required this.destinationCode,
    required this.destinationName,
    required this.departTime,
    required this.arriveTime,
    required this.arriveDay,
    required this.durationMinutes,
    required this.stopCount,
    this.lineId,
    this.photoUrl,
    this.photoCredit,
    this.verified = false,
    this.source,
  });

  factory TrainSummary.fromJson(Map<String, dynamic> j) => TrainSummary(
    id: j['id'] as String,
    number: j['number'] as String,
    name: _text(j, 'name'),
    type: (j['type'] as String?) ?? 'Train',
    runsOn: (j['runs_on'] as String?) ?? 'Daily',
    lineId: j['line_id'] as String?,
    originCode: j['origin_code'] as String,
    originName: _text(j, 'origin_name'),
    destinationCode: j['destination_code'] as String,
    destinationName: _text(j, 'destination_name'),
    departTime: _hhmm(j['depart_time']) ?? '--:--',
    arriveTime: _hhmm(j['arrive_time']) ?? '--:--',
    arriveDay: (j['arrive_day'] as int?) ?? 0,
    durationMinutes: (j['duration_minutes'] as int?) ?? 0,
    stopCount: (j['stop_count'] as int?) ?? 0,
    photoUrl: j['photo_url'] as String?,
    photoCredit: j['photo_credit'] as String?,
    verified: j['verified_at'] != null,
    source: j['source'] as String?,
  );

  final String id;
  final String number;
  final LocalizedText name;
  final String type;
  final String runsOn;
  final String? lineId;
  final String originCode;
  final LocalizedText originName;
  final String destinationCode;
  final LocalizedText destinationName;
  final String departTime;
  final String arriveTime;
  final int arriveDay;
  final int durationMinutes;
  final int stopCount;
  final String? photoUrl;
  final String? photoCredit;
  final bool verified;
  final String? source;

  int get departMinutes => _minutes(departTime);
}

int _minutes(String hhmm) {
  final parts = hhmm.split(':');
  if (parts.length < 2) return 0;
  return (int.tryParse(parts[0]) ?? 0) * 60 + (int.tryParse(parts[1]) ?? 0);
}

@immutable
class TrainStop {
  const TrainStop({
    required this.order,
    required this.station,
    this.arriveTime,
    this.departTime,
    this.dayOffset = 0,
    this.isMajor = true,
  });

  factory TrainStop.fromJson(Map<String, dynamic> j) => TrainStop(
    order: j['stop_order'] as int,
    station: Station.fromJson(j['stations'] as Map<String, dynamic>),
    arriveTime: _hhmm(j['arrive_time']),
    departTime: _hhmm(j['depart_time']),
    dayOffset: (j['day_offset'] as int?) ?? 0,
    isMajor: (j['is_major'] as bool?) ?? true,
  );

  final int order;
  final Station station;
  final String? arriveTime;
  final String? departTime;
  final int dayOffset;
  final bool isMajor;

  String get displayTime => departTime ?? arriveTime ?? '--:--';
}

@immutable
class TrainClass {
  const TrainClass({required this.name, required this.reservable});

  factory TrainClass.fromJson(Map<String, dynamic> j) => TrainClass(
    name: j['class_name'] as String,
    reservable: (j['reservable'] as bool?) ?? false,
  );

  final String name;
  final bool reservable;
}

/// A train calling at a station (for "next departures").
@immutable
class StationDeparture {
  const StationDeparture({
    required this.train,
    required this.time,
    required this.isOrigin,
    required this.isTerminus,
  });

  final TrainSummary train;
  final String time;
  final bool isOrigin;
  final bool isTerminus;
}

/// One direct option from `search_journeys`.
@immutable
class JourneyOption {
  const JourneyOption({
    required this.trainId,
    required this.trainNumber,
    required this.trainName,
    required this.trainType,
    required this.runsOn,
    required this.departTime,
    required this.arriveTime,
    required this.departDay,
    required this.arriveDay,
    required this.durationMinutes,
    required this.stopsBetween,
    required this.verified,
  });

  factory JourneyOption.fromJson(Map<String, dynamic> j) => JourneyOption(
    trainId: j['train_id'] as String,
    trainNumber: j['train_number'] as String,
    trainName: LocalizedText(
      (j['train_name_en'] as String?) ?? '',
      j['train_name_si'] as String?,
    ),
    trainType: (j['train_type'] as String?) ?? 'Train',
    runsOn: (j['runs_on'] as String?) ?? 'Daily',
    departTime: _hhmm(j['depart_time']) ?? '--:--',
    arriveTime: _hhmm(j['arrive_time']) ?? '--:--',
    departDay: (j['depart_day'] as int?) ?? 0,
    arriveDay: (j['arrive_day'] as int?) ?? 0,
    durationMinutes: (j['duration_minutes'] as int?) ?? 0,
    stopsBetween: (j['stops_between'] as int?) ?? 0,
    verified: (j['verified'] as bool?) ?? false,
  );

  final String trainId;
  final String trainNumber;
  final LocalizedText trainName;
  final String trainType;
  final String runsOn;
  final String departTime;
  final String arriveTime;
  final int departDay;
  final int arriveDay;
  final int durationMinutes;
  final int stopsBetween;
  final bool verified;

  int get departMinutes => _minutes(departTime);

  /// Whether the train runs on [date] according to [runsOn]
  /// ("Daily", "Mon-Fri", "Sat, Sun", "Tue, Fri, Sun", "Mon-Fri, Sun").
  bool runsOnDate(DateTime date) => runsOnDay(runsOn, date.weekday);
}

const _dayIndex = {
  'mon': 1, 'tue': 2, 'wed': 3, 'thu': 4, 'fri': 5, 'sat': 6, 'sun': 7,
};

bool runsOnDay(String runsOn, int weekday) {
  final s = runsOn.toLowerCase().trim();
  if (s.isEmpty || s == 'daily') return true;
  for (final part in s.split(',')) {
    final p = part.trim();
    if (p.contains('-')) {
      final ends = p.split('-');
      final a = _dayIndex[ends[0].trim().substring(0, 3)];
      final b = _dayIndex[ends[1].trim().substring(0, 3)];
      if (a != null && b != null && weekday >= a && weekday <= b) return true;
    } else if (p.length >= 3 && _dayIndex[p.substring(0, 3)] == weekday) {
      return true;
    }
  }
  return false;
}

@immutable
class DestinationCategory {
  const DestinationCategory({
    required this.id,
    required this.name,
    this.icon,
    this.count = 0,
  });

  factory DestinationCategory.fromJson(Map<String, dynamic> j) =>
      DestinationCategory(
        id: j['id'] as String,
        name: _text(j, 'name'),
        icon: j['icon'] as String?,
        count: (j['destinations'] is List && (j['destinations'] as List).isNotEmpty)
            ? ((j['destinations'] as List).first['count'] as int? ?? 0)
            : 0,
      );

  final String id;
  final LocalizedText name;
  final String? icon;
  final int count;

  IconData get iconData => switch (icon?.replaceAll('_outlined', '')) {
    'landscape' => Icons.landscape_outlined,
    'water' => Icons.water_outlined,
    'terrain' => Icons.terrain_outlined,
    'account_balance' => Icons.account_balance_outlined,
    'temple_buddhist' => Icons.temple_buddhist_outlined,
    'beach_access' => Icons.beach_access_outlined,
    'pets' => Icons.pets_outlined,
    'eco' => Icons.eco_outlined,
    _ => Icons.place_outlined,
  };
}

@immutable
class NearbyStation {
  const NearbyStation({required this.station, this.km});
  final Station station;
  final double? km;
}

@immutable
class NearbyDestination {
  const NearbyDestination({required this.destination, this.km});
  final Destination destination;
  final double? km;
}

@immutable
class Photo {
  const Photo({required this.url, this.credit, this.sourceUrl});

  factory Photo.fromJson(Map<String, dynamic> j) => Photo(
    url: j['url'] as String,
    credit: j['credit'] as String?,
    sourceUrl: j['source_url'] as String?,
  );

  final String url;
  final String? credit;
  final String? sourceUrl;
}

@immutable
class Destination {
  const Destination({
    required this.id,
    required this.name,
    this.description,
    this.categoryId,
    this.categoryName,
    this.lat,
    this.lng,
    this.coverUrl,
    this.coverCredit,
    this.tags = const [],
    this.nearestStations = const [],
    this.photos = const [],
  });

  factory Destination.fromJson(Map<String, dynamic> j) {
    final cat = j['destination_categories'] as Map<String, dynamic>?;
    final tags = (j['destination_tags'] as List?) ?? const [];
    final near = (j['destination_stations'] as List?) ?? const [];
    final photos = (j['destination_photos'] as List?) ?? const [];
    return Destination(
      id: j['id'] as String,
      name: _text(j, 'name'),
      description: j['description_en'] == null ? null : _text(j, 'description'),
      categoryId: j['category_id'] as String?,
      categoryName: cat == null ? null : _text(cat, 'name'),
      lat: _num(j['lat']),
      lng: _num(j['lng']),
      coverUrl: j['cover_photo_url'] as String?,
      coverCredit: j['cover_photo_credit'] as String?,
      tags: [for (final t in tags) (t as Map<String, dynamic>)['tag'] as String],
      nearestStations: [
        for (final n in near)
          if ((n as Map<String, dynamic>)['stations'] != null)
            NearbyStation(
              station: Station.fromJson(n['stations'] as Map<String, dynamic>),
              km: _num(n['walk_km']),
            ),
      ]..sort((a, b) => (a.km ?? 999).compareTo(b.km ?? 999)),
      photos: [
        for (final p in photos) Photo.fromJson(p as Map<String, dynamic>),
      ],
    );
  }

  final String id;
  final LocalizedText name;
  final LocalizedText? description;
  final String? categoryId;
  final LocalizedText? categoryName;
  final double? lat;
  final double? lng;
  final String? coverUrl;
  final String? coverCredit;
  final List<String> tags;
  final List<NearbyStation> nearestStations;
  final List<Photo> photos;

  NearbyStation? get nearest =>
      nearestStations.isEmpty ? null : nearestStations.first;
}

enum AnnouncementSeverity { info, warning, critical }

@immutable
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.severity,
    required this.startsAt,
    this.endsAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
    id: j['id'] as String,
    title: _text(j, 'title'),
    body: _text(j, 'body'),
    severity: switch (j['severity']) {
      'warning' => AnnouncementSeverity.warning,
      'critical' => AnnouncementSeverity.critical,
      _ => AnnouncementSeverity.info,
    },
    startsAt: DateTime.parse(j['starts_at'] as String).toLocal(),
    endsAt: j['ends_at'] == null
        ? null
        : DateTime.parse(j['ends_at'] as String).toLocal(),
  );

  final String id;
  final LocalizedText title;
  final LocalizedText body;
  final AnnouncementSeverity severity;
  final DateTime startsAt;
  final DateTime? endsAt;
}

@immutable
class Profile {
  const Profile({
    required this.id,
    this.displayName,
    this.email,
    this.language = 'en',
    this.avatarUrl,
  });

  final String id;
  final String? displayName;
  final String? email;
  final String language;
  final String? avatarUrl;

  String get label {
    final n = displayName?.trim();
    if (n != null && n.isNotEmpty) return n;
    final e = email;
    if (e != null && e.contains('@')) return e.split('@').first;
    return 'Traveller';
  }

  String get initials {
    final parts = label.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return letters.isEmpty ? 'T' : letters;
  }
}
