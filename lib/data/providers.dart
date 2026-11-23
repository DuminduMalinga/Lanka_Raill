import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'ceylon_repository.dart';
import 'models.dart';

/// Backend access. Tests override this with an in-memory fake.
final repositoryProvider = Provider<CeylonRepository>(
  (ref) => SupabaseCeylonRepository(Supabase.instance.client),
);

/// Current signed-in user id (null when signed out). Rebuilds on auth changes.
final currentUserIdProvider = StreamProvider<String?>((ref) async* {
  final auth = Supabase.instance.client.auth;
  yield auth.currentUser?.id;
  await for (final state in auth.onAuthStateChange) {
    yield state.session?.user.id;
  }
});

final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(currentUserIdProvider).value != null,
);

// ── Reference data ────────────────────────────────────────────────────────

final linesProvider = FutureProvider<List<RailwayLine>>(
  (ref) => ref.watch(repositoryProvider).lines(),
);

final stationsProvider = FutureProvider<List<Station>>(
  (ref) => ref.watch(repositoryProvider).stations(),
);

final stationProvider = FutureProvider.family<Station?, String>(
  (ref, id) => ref.watch(repositoryProvider).station(id),
);

final stationByCodeProvider = FutureProvider.family<Station?, String>((
  ref,
  code,
) async {
  final all = await ref.watch(stationsProvider.future);
  for (final s in all) {
    if (s.code == code) return s;
  }
  return ref.watch(repositoryProvider).stationByCode(code);
});

final stationFacilitiesProvider = FutureProvider.family<List<String>, String>(
  (ref, id) => ref.watch(repositoryProvider).stationFacilities(id),
);

final trainsProvider = FutureProvider<List<TrainSummary>>(
  (ref) => ref.watch(repositoryProvider).trains(),
);

final trainProvider = FutureProvider.family<TrainSummary?, String>(
  (ref, id) => ref.watch(repositoryProvider).train(id),
);

final trainStopsProvider = FutureProvider.family<List<TrainStop>, String>(
  (ref, id) => ref.watch(repositoryProvider).trainStops(id),
);

final trainClassesProvider = FutureProvider.family<List<TrainClass>, String>(
  (ref, id) => ref.watch(repositoryProvider).trainClasses(id),
);

final departuresProvider =
    FutureProvider.family<List<StationDeparture>, String>(
      (ref, stationId) =>
          ref.watch(repositoryProvider).departuresFrom(stationId),
    );

final categoriesProvider = FutureProvider<List<DestinationCategory>>(
  (ref) => ref.watch(repositoryProvider).categories(),
);

final destinationsProvider =
    FutureProvider.family<List<Destination>, String?>(
      (ref, categoryId) =>
          ref.watch(repositoryProvider).destinations(categoryId: categoryId),
    );

final destinationProvider = FutureProvider.family<Destination?, String>(
  (ref, id) => ref.watch(repositoryProvider).destination(id),
);

final destinationsNearStationProvider =
    FutureProvider.family<List<NearbyDestination>, String>(
      (ref, id) => ref.watch(repositoryProvider).destinationsNearStation(id),
    );

final announcementsProvider = FutureProvider<List<Announcement>>(
  (ref) => ref.watch(repositoryProvider).announcements(),
);

final profileProvider = FutureProvider<Profile?>((ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(repositoryProvider).profile();
});

// ── Journey planner ───────────────────────────────────────────────────────

/// Selected route and date for the journey planner.
class JourneyQuery {
  const JourneyQuery({
    required this.fromCode,
    required this.toCode,
    required this.date,
  });

  final String fromCode;
  final String toCode;
  final DateTime date;

  JourneyQuery copyWith({String? fromCode, String? toCode, DateTime? date}) =>
      JourneyQuery(
        fromCode: fromCode ?? this.fromCode,
        toCode: toCode ?? this.toCode,
        date: date ?? this.date,
      );
}

final journeyProvider = NotifierProvider<JourneyNotifier, JourneyQuery>(
  JourneyNotifier.new,
);

class JourneyNotifier extends Notifier<JourneyQuery> {
  @override
  JourneyQuery build() {
    final now = DateTime.now();
    return JourneyQuery(
      fromCode: 'FOT',
      toCode: 'ELL',
      date: DateTime(now.year, now.month, now.day),
    );
  }

  void setFrom(String code) => state = code == state.toCode
      ? state.copyWith(fromCode: code, toCode: state.fromCode)
      : state.copyWith(fromCode: code);

  void setTo(String code) => state = code == state.fromCode
      ? state.copyWith(toCode: code, fromCode: state.toCode)
      : state.copyWith(toCode: code);

  void swap() =>
      state = state.copyWith(fromCode: state.toCode, toCode: state.fromCode);

  void setDate(DateTime date) =>
      state = state.copyWith(date: DateTime(date.year, date.month, date.day));

  void set(String fromCode, String toCode) =>
      state = state.copyWith(fromCode: fromCode, toCode: toCode);
}

final journeyResultsProvider = FutureProvider<List<JourneyOption>>((ref) {
  final q = ref.watch(journeyProvider);
  return ref.watch(repositoryProvider).searchJourneys(q.fromCode, q.toCode);
});

// ── Recent searches (kept on the device) ──────────────────────────────────

class RecentSearch {
  const RecentSearch(this.fromCode, this.toCode, this.at);
  final String fromCode;
  final String toCode;
  final DateTime at;

  Map<String, Object> toJson() => {
    'f': fromCode,
    't': toCode,
    'at': at.toIso8601String(),
  };
  static RecentSearch fromJson(Map<String, dynamic> j) => RecentSearch(
    j['f'] as String,
    j['t'] as String,
    DateTime.parse(j['at'] as String),
  );
}

final recentSearchesProvider =
    AsyncNotifierProvider<RecentSearchesNotifier, List<RecentSearch>>(
      RecentSearchesNotifier.new,
    );

class RecentSearchesNotifier extends AsyncNotifier<List<RecentSearch>> {
  static const _key = 'recent_searches_v1';

  @override
  Future<List<RecentSearch>> build() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return const [];
      return (jsonDecode(raw) as List)
          .map((e) => RecentSearch.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> add(String fromCode, String toCode) async {
    final current = state.value ?? const <RecentSearch>[];
    final next = [
      RecentSearch(fromCode, toCode, DateTime.now()),
      ...current.where((r) => !(r.fromCode == fromCode && r.toCode == toCode)),
    ].take(6).toList();
    state = AsyncData(next);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _key,
        jsonEncode(next.map((r) => r.toJson()).toList()),
      );
    } catch (_) {
      // Recent searches are a convenience; ignore storage failures.
    }
  }
}

// ── Favourites (per signed-in user) ───────────────────────────────────────

enum FavoriteKind { train, station, destination }

final favoritesProvider =
    AsyncNotifierProvider.family<FavoritesNotifier, Set<String>, FavoriteKind>(
      FavoritesNotifier.new,
    );

class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  FavoritesNotifier(this.kind);

  final FavoriteKind kind;

  @override
  Future<Set<String>> build() {
    ref.watch(currentUserIdProvider);
    final repo = ref.watch(repositoryProvider);
    return switch (kind) {
      FavoriteKind.train => repo.favoriteTrainIds(),
      FavoriteKind.station => repo.favoriteStationIds(),
      FavoriteKind.destination => repo.favoriteDestinationIds(),
    };
  }

  /// Saves or removes [id]; throws [AuthException] when signed out.
  Future<void> toggle(String id) async {
    final current = {...?state.value};
    final saved = !current.contains(id);
    final repo = ref.read(repositoryProvider);
    state = AsyncData(saved ? ({...current, id}) : (current..remove(id)));
    try {
      await switch (kind) {
        FavoriteKind.train => repo.setFavoriteTrain(id, saved),
        FavoriteKind.station => repo.setFavoriteStation(id, saved),
        FavoriteKind.destination => repo.setFavoriteDestination(id, saved),
      };
    } catch (_) {
      state = AsyncData(saved ? (current..remove(id)) : ({...current, id}));
      rethrow;
    }
  }
}

// ── Fallbacks when a detail route is opened without `?id=` ────────────────

/// [id] if given, otherwise Podi Menike (#1005) or the first train.
final trainIdProvider = FutureProvider.family<String?, String?>((ref, id) async {
  if (id != null) return id;
  final all = await ref.watch(trainsProvider.future);
  if (all.isEmpty) return null;
  return all.firstWhere((t) => t.number == '1005', orElse: () => all.first).id;
});

/// [id] if given, otherwise Colombo Fort or the first station.
final stationIdProvider = FutureProvider.family<String?, String?>((ref, id) async {
  if (id != null) return id;
  final all = await ref.watch(stationsProvider.future);
  if (all.isEmpty) return null;
  return all.firstWhere((s) => s.code == 'FOT', orElse: () => all.first).id;
});

final destinationIdProvider = FutureProvider.family<String?, String?>((ref, id) async {
  if (id != null) return id;
  final all = await ref.watch(destinationsProvider(null).future);
  return all.isEmpty ? null : all.first.id;
});

final lineIdProvider = FutureProvider.family<String?, String?>((ref, id) async {
  if (id != null) return id;
  final all = await ref.watch(linesProvider.future);
  if (all.isEmpty) return null;
  return all.firstWhere((l) => l.name.en == 'Main Line', orElse: () => all.first).id;
});

final announcementIdProvider = FutureProvider.family<String?, String?>((ref, id) async {
  if (id != null) return id;
  final all = await ref.watch(announcementsProvider.future);
  return all.isEmpty ? null : all.first.id;
});

/// Resolves an optional id, then loads the item with [load].
AsyncValue<T?> resolved<T>(
  WidgetRef ref,
  AsyncValue<String?> id,
  AsyncValue<T?> Function(String id) load,
) {
  return switch (id) {
    AsyncData(value: final v?) => load(v),
    AsyncData() => const AsyncData(null),
    AsyncError(:final error, :final stackTrace) => AsyncError(error, stackTrace),
    _ => const AsyncLoading(),
  };
}

// ── Saved items (favourites joined with their records) ────────────────────

class SavedItems {
  const SavedItems({
    required this.trains,
    required this.stations,
    required this.destinations,
  });

  final List<TrainSummary> trains;
  final List<Station> stations;
  final List<Destination> destinations;

  bool get isEmpty => trains.isEmpty && stations.isEmpty && destinations.isEmpty;
}

final savedItemsProvider = FutureProvider<SavedItems>((ref) async {
  final trainIds = await ref.watch(favoritesProvider(FavoriteKind.train).future);
  final stationIds = await ref.watch(
    favoritesProvider(FavoriteKind.station).future,
  );
  final destIds = await ref.watch(
    favoritesProvider(FavoriteKind.destination).future,
  );
  final trains = trainIds.isEmpty
      ? const <TrainSummary>[]
      : (await ref.watch(trainsProvider.future))
            .where((t) => trainIds.contains(t.id))
            .toList();
  final stations = stationIds.isEmpty
      ? const <Station>[]
      : (await ref.watch(stationsProvider.future))
            .where((s) => stationIds.contains(s.id))
            .toList();
  final destinations = destIds.isEmpty
      ? const <Destination>[]
      : (await ref.watch(destinationsProvider(null).future))
            .where((d) => destIds.contains(d.id))
            .toList();
  return SavedItems(
    trains: trains,
    stations: stations,
    destinations: destinations,
  );
});
