import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'image_type.dart';
import 'models.dart';

/// Everything the app reads from or writes to the backend.
/// Thrown when the database refuses feedback because the sender has sent too
/// much recently.
class FeedbackRateLimitedException implements Exception {
  const FeedbackRateLimitedException();
}

abstract class CeylonRepository {
  Future<List<RailwayLine>> lines();
  Future<List<Station>> stations();
  Future<Station?> station(String id);
  Future<Station?> stationByCode(String code);
  Future<List<String>> stationFacilities(String stationId);

  Future<List<TrainSummary>> trains();
  Future<TrainSummary?> train(String id);
  Future<List<TrainStop>> trainStops(String trainId);
  Future<List<TrainClass>> trainClasses(String trainId);
  Future<List<StationDeparture>> departuresFrom(String stationId);
  Future<List<JourneyOption>> searchJourneys(String fromCode, String toCode);

  Future<List<DestinationCategory>> categories();
  Future<List<Destination>> destinations({String? categoryId});
  Future<Destination?> destination(String id);
  Future<List<NearbyDestination>> destinationsNearStation(String stationId);

  Future<List<Announcement>> announcements();

  // Signed-in user data. All return empty / no-op when signed out.
  Future<Profile?> profile();
  Future<void> updateProfile({String? displayName, String? language});
  Future<void> uploadAvatar(Uint8List bytes);

  /// Permanently deletes the signed-in user's account and photo (server
  /// side); the caller should then sign out locally.
  Future<void> deleteAccount();
  Future<Set<String>> favoriteTrainIds();
  Future<Set<String>> favoriteStationIds();
  Future<Set<String>> favoriteDestinationIds();
  Future<void> setFavoriteTrain(String trainId, bool saved);
  Future<void> setFavoriteStation(String stationId, bool saved);
  Future<void> setFavoriteDestination(String destinationId, bool saved);

  /// Sends in-app feedback (works signed in or out).
  Future<void> sendFeedback({
    required int rating,
    required String message,
    String? appVersion,
  });
}

/// Supabase implementation (public reads via RLS, user rows via auth.uid()).
class SupabaseCeylonRepository implements CeylonRepository {
  SupabaseCeylonRepository(this._db);

  final SupabaseClient _db;

  static const _stationCols =
      'id, code, name_en, name_si, line_id, district, elevation_m, lat, lng, '
      'photo_url, photo_credit, railway_lines(name_en, name_si)';
  static const _destinationCols =
      'id, name_en, name_si, description_en, description_si, category_id, lat, lng, '
      'cover_photo_url, cover_photo_credit, '
      'destination_categories(name_en, name_si), destination_tags(tag), '
      'destination_stations(walk_km, stations($_stationCols))';

  String? get _uid => _db.auth.currentUser?.id;

  List<Map<String, dynamic>> _rows(Object data) =>
      (data as List).cast<Map<String, dynamic>>();

  @override
  Future<List<RailwayLine>> lines() async {
    final data = await _db
        .from('railway_lines')
        .select('id, name_en, name_si, color, description_en, description_si, stations(count)')
        .order('name_en', ascending: true);
    return _rows(data).map(RailwayLine.fromJson).toList();
  }

  @override
  Future<List<Station>> stations() async {
    final data = await _db.from('stations').select(_stationCols).order('name_en', ascending: true);
    return _rows(data).map(Station.fromJson).toList();
  }

  @override
  Future<Station?> station(String id) async {
    final data = await _db.from('stations').select(_stationCols).eq('id', id).maybeSingle();
    return data == null ? null : Station.fromJson(data);
  }

  @override
  Future<Station?> stationByCode(String code) async {
    final data = await _db.from('stations').select(_stationCols).eq('code', code).maybeSingle();
    return data == null ? null : Station.fromJson(data);
  }

  @override
  Future<List<String>> stationFacilities(String stationId) async {
    final data = await _db
        .from('station_facilities')
        .select('facilities(name_en)')
        .eq('station_id', stationId);
    return [
      for (final r in _rows(data))
        if (r['facilities'] != null) (r['facilities'] as Map)['name_en'] as String,
    ];
  }

  @override
  Future<List<TrainSummary>> trains() async {
    final data = await _db.from('train_summaries').select().order('depart_time', ascending: true);
    return _rows(data).map(TrainSummary.fromJson).toList();
  }

  @override
  Future<TrainSummary?> train(String id) async {
    final data = await _db.from('train_summaries').select().eq('id', id).maybeSingle();
    return data == null ? null : TrainSummary.fromJson(data);
  }

  @override
  Future<List<TrainStop>> trainStops(String trainId) async {
    final data = await _db
        .from('train_stops')
        .select('stop_order, arrive_time, depart_time, day_offset, is_major, stations($_stationCols)')
        .eq('train_id', trainId)
        .order('stop_order', ascending: true);
    return _rows(data).map(TrainStop.fromJson).toList();
  }

  @override
  Future<List<TrainClass>> trainClasses(String trainId) async {
    final data = await _db
        .from('train_classes')
        .select('class_name, reservable')
        .eq('train_id', trainId);
    return _rows(data).map(TrainClass.fromJson).toList();
  }

  @override
  Future<List<StationDeparture>> departuresFrom(String stationId) async {
    final stops = _rows(await _db
        .from('train_stops')
        .select('train_id, stop_order, arrive_time, depart_time')
        .eq('station_id', stationId));
    if (stops.isEmpty) return const [];
    final ids = stops.map((s) => s['train_id'] as String).toSet().toList();
    final trains = {
      for (final t in _rows(await _db.from('train_summaries').select().inFilter('id', ids)))
        t['id'] as String: TrainSummary.fromJson(t),
    };
    final out = <StationDeparture>[];
    for (final s in stops) {
      final t = trains[s['train_id']];
      final dep = s['depart_time'] as String?;
      if (t == null || dep == null) continue; // terminates here
      out.add(StationDeparture(
        train: t,
        time: dep.substring(0, 5),
        isOrigin: s['arrive_time'] == null,
        isTerminus: false,
      ));
    }
    out.sort((a, b) => a.time.compareTo(b.time));
    return out;
  }

  @override
  Future<List<JourneyOption>> searchJourneys(String fromCode, String toCode) async {
    final data = await _db.rpc('search_journeys', params: {'from_code': fromCode, 'to_code': toCode});
    return _rows(data).map(JourneyOption.fromJson).toList();
  }

  @override
  Future<List<DestinationCategory>> categories() async {
    final data = await _db
        .from('destination_categories')
        .select('id, name_en, name_si, icon, destinations(count)')
        .order('name_en', ascending: true);
    return _rows(data).map(DestinationCategory.fromJson).toList();
  }

  @override
  Future<List<Destination>> destinations({String? categoryId}) async {
    var q = _db.from('destinations').select(_destinationCols);
    if (categoryId != null) q = q.eq('category_id', categoryId);
    final data = await q.order('name_en', ascending: true);
    return _rows(data).map(Destination.fromJson).toList();
  }

  @override
  Future<Destination?> destination(String id) async {
    final data = await _db
        .from('destinations')
        .select('$_destinationCols, destination_photos(url, credit, source_url, sort)')
        .eq('id', id)
        .order('sort', referencedTable: 'destination_photos', ascending: true)
        .maybeSingle();
    return data == null ? null : Destination.fromJson(data);
  }

  @override
  Future<List<NearbyDestination>> destinationsNearStation(String stationId) async {
    final data = await _db
        .from('destination_stations')
        .select('walk_km, destinations($_destinationCols)')
        .eq('station_id', stationId)
        .order('walk_km', ascending: true);
    return [
      for (final r in _rows(data))
        if (r['destinations'] != null)
          NearbyDestination(
            destination: Destination.fromJson(r['destinations'] as Map<String, dynamic>),
            km: (r['walk_km'] as num?)?.toDouble(),
          ),
    ];
  }

  @override
  Future<List<Announcement>> announcements() async {
    final now = DateTime.now().toUtc().toIso8601String();
    final data = await _db
        .from('announcements')
        .select()
        .lte('starts_at', now)
        .or('ends_at.is.null,ends_at.gt.$now')
        .order('starts_at', ascending: false);
    return _rows(data).map(Announcement.fromJson).toList();
  }

  @override
  Future<Profile?> profile() async {
    final user = _db.auth.currentUser;
    if (user == null) return null;
    final row = await _db.from('profiles').select().eq('id', user.id).maybeSingle();
    final meta = user.userMetadata ?? const {};
    return Profile(
      id: user.id,
      email: user.email,
      displayName: (row?['display_name'] as String?) ??
          (meta['display_name'] as String?) ??
          (meta['full_name'] as String?) ??
          (meta['name'] as String?),
      language: (row?['language'] as String?) ?? 'en',
      // Own upload first, then the Google/Facebook photo from sign-in.
      avatarUrl: _nonEmpty(row?['avatar_url'] as String?) ??
          _nonEmpty(meta['avatar_url'] as String?) ??
          _nonEmpty(meta['picture'] as String?),
    );
  }

  static String? _nonEmpty(String? v) => (v == null || v.isEmpty) ? null : v;

  @override
  Future<void> uploadAvatar(Uint8List bytes) async {
    final uid = _uid;
    if (uid == null) throw const AuthException('Sign in to change your photo');
    // Judge the file by its bytes, not its name or the type the picker reports.
    final type = detectImageType(bytes);
    if (type == null || bytes.length > maxAvatarBytes) {
      throw const FormatException('Not a supported profile photo');
    }
    // One fixed file per user, overwritten on every change: the storage policy
    // only allows this exact name, so an account can never pile up files.
    final path = '$uid/avatar';
    final storage = _db.storage.from('avatars');
    await storage.uploadBinary(
      path,
      bytes,
      fileOptions: FileOptions(contentType: type, upsert: true),
    );
    // The URL never changes, so add a version to make apps fetch the new photo.
    final url = '${storage.getPublicUrl(path)}?v=${DateTime.now().millisecondsSinceEpoch}';
    await _db.from('profiles').upsert({'id': uid, 'avatar_url': url});
    await _removeOldAvatars(storage, uid);
  }

  @override
  Future<void> deleteAccount() async {
    // The user's session token is sent automatically; the function only ever
    // deletes the account that token belongs to. Throws on any failure.
    await _db.functions.invoke('delete-account');
  }

  /// Deletes pictures left in the user's folder by older versions of the app,
  /// which named each upload with a timestamp. Best effort.
  Future<void> _removeOldAvatars(StorageFileApi storage, String uid) async {
    try {
      final files = await storage.list(path: uid);
      final old = [
        for (final f in files)
          if (f.name != 'avatar') '$uid/${f.name}',
      ];
      if (old.isNotEmpty) await storage.remove(old);
    } catch (_) {
      // Tidying up must never make saving the profile fail.
    }
  }

  @override
  Future<void> sendFeedback({
    required int rating,
    required String message,
    String? appVersion,
  }) async {
    try {
      await _db.from('feedback').insert({
        'rating': rating,
        'message': message,
        'app_version': ?appVersion,
      });
    } on PostgrestException catch (e) {
      // The database limits how much one sender can send (SQLSTATE FB429).
      if (e.code == 'FB429') throw const FeedbackRateLimitedException();
      rethrow;
    }
  }

  @override
  Future<void> updateProfile({String? displayName, String? language}) async {
    final uid = _uid;
    if (uid == null) return;
    await _db.from('profiles').upsert({
      'id': uid,
      'display_name': ?displayName,
      'language': ?language,
    });
  }

  Future<Set<String>> _ids(String table, String column) async {
    final uid = _uid;
    if (uid == null) return {};
    final data = await _db.from(table).select(column).eq('user_id', uid);
    return {for (final r in _rows(data)) r[column] as String};
  }

  Future<void> _set(String table, String column, String id, bool saved) async {
    final uid = _uid;
    if (uid == null) throw const AuthException('Sign in to save items');
    if (saved) {
      await _db.from(table).upsert({'user_id': uid, column: id});
    } else {
      await _db.from(table).delete().eq('user_id', uid).eq(column, id);
    }
  }

  @override
  Future<Set<String>> favoriteTrainIds() => _ids('favorite_trains', 'train_id');
  @override
  Future<Set<String>> favoriteStationIds() => _ids('favorite_stations', 'station_id');
  @override
  Future<Set<String>> favoriteDestinationIds() => _ids('favorite_destinations', 'destination_id');
  @override
  Future<void> setFavoriteTrain(String trainId, bool saved) =>
      _set('favorite_trains', 'train_id', trainId, saved);
  @override
  Future<void> setFavoriteStation(String stationId, bool saved) =>
      _set('favorite_stations', 'station_id', stationId, saved);
  @override
  Future<void> setFavoriteDestination(String destinationId, bool saved) =>
      _set('favorite_destinations', 'destination_id', destinationId, saved);
}
