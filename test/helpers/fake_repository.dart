import 'package:lankarail/data/ceylon_repository.dart';
import 'package:lankarail/data/models.dart';

/// Offline repository with a tiny, realistic data set for widget tests.
class FakeCeylonRepository implements CeylonRepository {
  static const _main = RailwayLine(
    id: 'line-main',
    name: LocalizedText('Main Line', 'ප්‍රධාන මාර්ගය'),
    description: LocalizedText('Colombo Fort to Badulla'),
    color: '#2E7D32',
    stationCount: 3,
  );

  static const _fot = Station(
    id: 'st-fot',
    code: 'FOT',
    name: LocalizedText('Colombo Fort', 'කොළඹ කොටුව'),
    lineId: 'line-main',
    lineName: LocalizedText('Main Line'),
    district: 'Colombo',
    lat: 6.9336,
    lng: 79.85,
  );
  static const _kdt = Station(
    id: 'st-kdt',
    code: 'KDT',
    name: LocalizedText('Kandy', 'මහනුවර'),
    lineId: 'line-main',
    lineName: LocalizedText('Main Line'),
    lat: 7.2919,
    lng: 80.6327,
  );
  static const _ell = Station(
    id: 'st-ell',
    code: 'ELL',
    name: LocalizedText('Ella', 'ඇල්ල'),
    lineId: 'line-main',
    lineName: LocalizedText('Main Line'),
    lat: 6.8768,
    lng: 81.0461,
  );

  static const _train = TrainSummary(
    id: 'tr-1005',
    number: '1005',
    name: LocalizedText('Podi Menike', 'පොඩි මැණිකේ'),
    type: 'Express',
    runsOn: 'Daily',
    lineId: 'line-main',
    originCode: 'FOT',
    originName: LocalizedText('Colombo Fort'),
    destinationCode: 'ELL',
    destinationName: LocalizedText('Ella'),
    departTime: '05:55',
    arriveTime: '16:18',
    arriveDay: 0,
    durationMinutes: 623,
    stopCount: 3,
    source: 'test data',
  );

  static const _stops = [
    TrainStop(order: 1, station: _fot, departTime: '05:55'),
    TrainStop(order: 2, station: _kdt, arriveTime: '08:48', departTime: '08:55'),
    TrainStop(order: 3, station: _ell, arriveTime: '16:18'),
  ];

  static const _category = DestinationCategory(
    id: 'cat-views',
    name: LocalizedText('Scenic views'),
    icon: 'landscape_outlined',
    count: 1,
  );

  static const _bridge = Destination(
    id: 'dest-nine-arch',
    name: LocalizedText('Nine Arch Bridge', 'නව ආරුක්කු පාලම'),
    description: LocalizedText('A colonial-era stone railway viaduct.'),
    categoryId: 'cat-views',
    categoryName: LocalizedText('Scenic views'),
    lat: 6.8768,
    lng: 81.0608,
    tags: ['Scenic view', 'Free entry'],
    nearestStations: [NearbyStation(station: _ell, km: 2.5)],
    photos: [Photo(url: 'https://example.com/a.jpg', credit: 'Test · CC0')],
  );

  static final _announcement = Announcement(
    id: 'ann-1',
    title: const LocalizedText('Hill country services still affected'),
    body: const LocalizedText('After cyclone damage in 2025, some routes run a reduced service.'),
    severity: AnnouncementSeverity.warning,
    startsAt: DateTime(2026, 11, 1),
  );

  @override
  Future<List<RailwayLine>> lines() async => const [_main];
  @override
  Future<List<Station>> stations() async => const [_fot, _kdt, _ell];
  @override
  Future<Station?> station(String id) async =>
      const [_fot, _kdt, _ell].where((s) => s.id == id).firstOrNull;
  @override
  Future<Station?> stationByCode(String code) async =>
      const [_fot, _kdt, _ell].where((s) => s.code == code).firstOrNull;
  @override
  Future<List<String>> stationFacilities(String stationId) async =>
      const ['Ticket counter'];

  @override
  Future<List<TrainSummary>> trains() async => const [_train];
  @override
  Future<TrainSummary?> train(String id) async => id == _train.id ? _train : null;
  @override
  Future<List<TrainStop>> trainStops(String trainId) async => _stops;
  @override
  Future<List<TrainClass>> trainClasses(String trainId) async => const [
    TrainClass(name: '2nd class reserved', reservable: true),
    TrainClass(name: '3rd class unreserved', reservable: false),
  ];
  @override
  Future<List<StationDeparture>> departuresFrom(String stationId) async => const [
    StationDeparture(train: _train, time: '05:55', isOrigin: true, isTerminus: false),
  ];
  @override
  Future<List<JourneyOption>> searchJourneys(String fromCode, String toCode) async => [
    JourneyOption(
      trainId: _train.id,
      trainNumber: '1005',
      trainName: _train.name,
      trainType: 'Express',
      runsOn: 'Daily',
      departTime: '05:55',
      arriveTime: '16:18',
      departDay: 0,
      arriveDay: 0,
      durationMinutes: 623,
      stopsBetween: 1,
      verified: false,
    ),
  ];

  @override
  Future<List<DestinationCategory>> categories() async => const [_category];
  @override
  Future<List<Destination>> destinations({String? categoryId}) async => const [_bridge];
  @override
  Future<Destination?> destination(String id) async => _bridge;
  @override
  Future<List<NearbyDestination>> destinationsNearStation(String stationId) async =>
      const [NearbyDestination(destination: _bridge, km: 2.5)];

  @override
  Future<List<Announcement>> announcements() async => [_announcement];

  @override
  Future<Profile?> profile() async => null;
  @override
  Future<void> updateProfile({String? displayName, String? language}) async {}

  final sentFeedback = <String>[];

  /// When set, [sendFeedback] throws it (to test the failure messages).
  Object? feedbackError;

  @override
  Future<void> sendFeedback({
    required int rating,
    required String message,
    String? appVersion,
  }) async {
    final error = feedbackError;
    if (error != null) throw error;
    sentFeedback.add(message);
  }
  @override
  Future<Set<String>> favoriteTrainIds() async => {};
  @override
  Future<Set<String>> favoriteStationIds() async => {};
  @override
  Future<Set<String>> favoriteDestinationIds() async => {};
  @override
  Future<void> setFavoriteTrain(String trainId, bool saved) async {}
  @override
  Future<void> setFavoriteStation(String stationId, bool saved) async {}
  @override
  Future<void> setFavoriteDestination(String destinationId, bool saved) async {}
}
