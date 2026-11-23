import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'prefs.dart';

/// Supported app languages (Tamil is planned per the design).
enum AppLanguage {
  english(Locale('en')),
  sinhala(Locale('si'));

  const AppLanguage(this.locale);
  final Locale locale;
}

/// Selected app language, saved on the device.
final appLanguageProvider = NotifierProvider<AppLanguageNotifier, AppLanguage>(
  AppLanguageNotifier.new,
);

class AppLanguageNotifier extends Notifier<AppLanguage> {
  static const _key = 'pref.language';

  @override
  AppLanguage build() => AppLanguage.values.firstWhere(
    (l) => l.name == Prefs.getString(_key),
    orElse: () => AppLanguage.english,
  );

  void select(AppLanguage language) {
    state = language;
    Prefs.setString(_key, language.name);
  }
}

/// Selected theme mode (Light / Dark / System).
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'pref.theme';

  @override
  ThemeMode build() => ThemeMode.values.firstWhere(
    (m) => m.name == Prefs.getString(_key),
    orElse: () => ThemeMode.system,
  );

  void select(ThemeMode mode) {
    state = mode;
    Prefs.setString(_key, mode.name);
  }
}

/// Generic on/off UI toggle keyed by a stable id (switches, checkboxes).
final uiToggleProvider =
    NotifierProvider.family<UiToggleNotifier, bool, String>(
      UiToggleNotifier.new,
    );

class UiToggleNotifier extends Notifier<bool> {
  UiToggleNotifier(this.id);

  final String id;

  /// Design defaults for toggles that start switched on.
  static const Set<String> _onByDefault = {
    UiToggles.offlineTimetables,
    UiToggles.savedTrainAlerts,
    UiToggles.bilingualNames,
    UiToggles.translateAnnouncements,
    UiToggles.notifyVerified,
    UiToggles.notifyDelays,
    UiToggles.notifySchedule,
    UiToggles.notifyReminders,
    UiToggles.quietHours,
    UiToggles.agreeTerms,
  };

  /// Toggles that are per-screen UI state rather than saved settings.
  static const Set<String> _transient = {UiToggles.agreeTerms};

  String get _key => 'pref.toggle.$id';

  @override
  bool build() => Prefs.getBool(_key) ?? _onByDefault.contains(id);

  void toggle() => set(!state);
  void set(bool value) {
    state = value;
    if (!_transient.contains(id)) Prefs.setBool(_key, value);
  }
}

/// Index of the selected option in a chip row / segmented control.
final uiSelectionProvider =
    NotifierProvider.family<UiSelectionNotifier, int, String>(
      UiSelectionNotifier.new,
    );

class UiSelectionNotifier extends Notifier<int> {
  UiSelectionNotifier(this.id);

  final String id;

  static const Map<String, int> _defaults = {
    UiSelections.stopFilter: 1,
    UiSelections.feedbackRating: 4,
  };

  /// Selections remembered between launches.
  static const Set<String> _saved = {UiSelections.travelClass};

  String get _key => 'pref.selection.$id';

  @override
  int build() =>
      (_saved.contains(id) ? Prefs.getInt(_key) : null) ?? _defaults[id] ?? 0;

  void select(int index) {
    state = index;
    if (_saved.contains(id)) Prefs.setInt(_key, index);
  }
}

/// The user's home station (station code), saved on the device. Used as the
/// default departure station in the journey planner.
final homeStationProvider = NotifierProvider<HomeStationNotifier, String>(
  HomeStationNotifier.new,
);

class HomeStationNotifier extends Notifier<String> {
  static const _key = 'pref.homeStation';
  static const fallback = 'FOT';

  @override
  String build() => Prefs.getString(_key) ?? fallback;

  void select(String code) {
    state = code;
    Prefs.setString(_key, code);
  }
}

/// Stable ids for [uiToggleProvider].
abstract final class UiToggles {
  static const String offlineTimetables = 'offlineTimetables';
  static const String savedTrainAlerts = 'savedTrainAlerts';
  static const String bilingualNames = 'bilingualNames';
  static const String translateAnnouncements = 'translateAnnouncements';
  static const String largerText = 'largerText';
  static const String highContrast = 'highContrast';
  static const String notifyVerified = 'notifyVerified';
  static const String notifyDelays = 'notifyDelays';
  static const String notifySchedule = 'notifySchedule';
  static const String notifyReminders = 'notifyReminders';
  static const String notifyInspiration = 'notifyInspiration';
  static const String quietHours = 'quietHours';
  static const String agreeTerms = 'agreeTerms';
}

/// Stable ids for [uiSelectionProvider].
abstract final class UiSelections {
  static const String travelDate = 'travelDate';
  static const String departureSlot = 'departureSlot';
  static const String travelClass = 'travelClass';
  static const String resultsSort = 'resultsSort';
  static const String stopFilter = 'stopFilter';
  static const String stationFilter = 'stationFilter';
  static const String popularStation = 'popularStation';
  static const String exploreCategory = 'exploreCategory';
  static const String galleryFilter = 'galleryFilter';
  static const String favoriteTab = 'favoriteTab';
  static const String favoriteDestFilter = 'favoriteDestFilter';
  static const String announcementFilter = 'announcementFilter';
  static const String onboardingStep = 'onboardingStep';
  static const String helpFaqOpen = 'helpFaqOpen';
  static const String feedbackRating = 'feedbackRating';
  static const String trainsDate = 'trainsDate';
  static const String trainsSlot = 'trainsSlot';
  static const String stationPick = 'stationPick';
}
