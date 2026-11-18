import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Supported app languages (Tamil is planned per the design).
enum AppLanguage {
  english(Locale('en')),
  sinhala(Locale('si'));

  const AppLanguage(this.locale);
  final Locale locale;
}

/// Selected app language. UI state only — persistence is added later.
final appLanguageProvider = NotifierProvider<AppLanguageNotifier, AppLanguage>(
  AppLanguageNotifier.new,
);

class AppLanguageNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() => AppLanguage.english;

  void select(AppLanguage language) => state = language;
}

/// Selected theme mode (Light / Dark / System).
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void select(ThemeMode mode) => state = mode;
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

  @override
  bool build() => _onByDefault.contains(id);

  void toggle() => state = !state;
  void set(bool value) => state = value;
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

  @override
  int build() => _defaults[id] ?? 0;

  void select(int index) => state = index;
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
