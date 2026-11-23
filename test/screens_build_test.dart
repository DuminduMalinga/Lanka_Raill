import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';
import 'package:lankarail/core/router/app_router.dart';
import 'package:lankarail/core/router/app_routes.dart';
import 'package:lankarail/core/state/app_preferences.dart';
import 'package:lankarail/core/state/ui_view_state.dart';
import 'package:lankarail/features/announcements/presentation/announcement_details_screen.dart';
import 'package:lankarail/features/announcements/presentation/announcements_screen.dart';
import 'package:lankarail/features/auth/presentation/forgot_password_screen.dart';
import 'package:lankarail/features/auth/presentation/sign_in_screen.dart';
import 'package:lankarail/features/auth/presentation/sign_up_screen.dart';
import 'package:lankarail/features/explore/presentation/destination_categories_screen.dart';
import 'package:lankarail/features/explore/presentation/destination_details_screen.dart';
import 'package:lankarail/features/explore/presentation/destination_gallery_screen.dart';
import 'package:lankarail/features/explore/presentation/explore_screen.dart';
import 'package:lankarail/features/home/presentation/home_screen.dart';
import 'package:lankarail/features/journey/presentation/journey_search_screen.dart';
import 'package:lankarail/features/journey/presentation/search_results_screen.dart';
import 'package:lankarail/features/journey/presentation/station_picker_screen.dart';
import 'package:lankarail/features/lines/presentation/line_details_screen.dart';
import 'package:lankarail/features/lines/presentation/railway_lines_screen.dart';
import 'package:lankarail/features/maps/presentation/nearby_stations_screen.dart';
import 'package:lankarail/features/maps/presentation/route_map_screen.dart';
import 'package:lankarail/features/onboarding/presentation/language_select_screen.dart';
import 'package:lankarail/features/onboarding/presentation/onboarding_screen.dart';
import 'package:lankarail/features/onboarding/presentation/splash_screen.dart';
import 'package:lankarail/features/onboarding/presentation/welcome_screen.dart';
import 'package:lankarail/features/profile/presentation/profile_screen.dart';
import 'package:lankarail/features/saved/presentation/favorite_destinations_screen.dart';
import 'package:lankarail/features/saved/presentation/favorite_trains_screen.dart';
import 'package:lankarail/features/saved/presentation/saved_screen.dart';
import 'package:lankarail/features/settings/presentation/about_screen.dart';
import 'package:lankarail/features/settings/presentation/help_feedback_screen.dart';
import 'package:lankarail/features/settings/presentation/language_settings_screen.dart';
import 'package:lankarail/features/settings/presentation/notification_settings_screen.dart';
import 'package:lankarail/features/settings/presentation/settings_screen.dart';
import 'package:lankarail/features/settings/presentation/theme_settings_screen.dart';
import 'package:lankarail/features/stations/presentation/station_details_screen.dart';
import 'package:lankarail/features/stations/presentation/station_directory_screen.dart';
import 'package:lankarail/features/trains/presentation/all_trains_screen.dart';
import 'package:lankarail/features/trains/presentation/classes_facilities_screen.dart';
import 'package:lankarail/features/trains/presentation/stop_timeline_screen.dart';
import 'package:lankarail/features/trains/presentation/train_details_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'helpers/pump_app.dart';

/// Route → screen type expected on top after navigating there.
const Map<String, Type> _screens = {
  AppRoutes.splash: SplashScreen,
  AppRoutes.welcome: WelcomeScreen,
  AppRoutes.onboarding: OnboardingScreen,
  AppRoutes.languageSelect: LanguageSelectScreen,
  AppRoutes.signIn: SignInScreen,
  AppRoutes.signUp: SignUpScreen,
  AppRoutes.forgotPassword: ForgotPasswordScreen,
  AppRoutes.home: HomeScreen,
  AppRoutes.trains: AllTrainsScreen,
  AppRoutes.explore: ExploreScreen,
  AppRoutes.saved: SavedScreen,
  AppRoutes.profile: ProfileScreen,
  AppRoutes.journeySearch: JourneySearchScreen,
  AppRoutes.departureStation: StationPickerScreen,
  AppRoutes.arrivalStation: StationPickerScreen,
  AppRoutes.homeStationPicker: StationPickerScreen,
  AppRoutes.searchResults: SearchResultsScreen,
  AppRoutes.trainDetails: TrainDetailsScreen,
  AppRoutes.stopTimeline: StopTimelineScreen,
  AppRoutes.routeMap: RouteMapScreen,
  AppRoutes.classesFacilities: ClassesFacilitiesScreen,
  AppRoutes.railwayLines: RailwayLinesScreen,
  AppRoutes.lineDetails: LineDetailsScreen,
  AppRoutes.stationDirectory: StationDirectoryScreen,
  AppRoutes.stationDetails: StationDetailsScreen,
  AppRoutes.nearbyStations: NearbyStationsScreen,
  AppRoutes.destinationCategories: DestinationCategoriesScreen,
  AppRoutes.destinationDetails: DestinationDetailsScreen,
  AppRoutes.destinationGallery: DestinationGalleryScreen,
  AppRoutes.favoriteTrains: FavoriteTrainsScreen,
  AppRoutes.favoriteDestinations: FavoriteDestinationsScreen,
  AppRoutes.announcements: AnnouncementsScreen,
  AppRoutes.announcementDetails: AnnouncementDetailsScreen,
  AppRoutes.settings: SettingsScreen,
  AppRoutes.languageSettings: LanguageSettingsScreen,
  AppRoutes.themeSettings: ThemeSettingsScreen,
  AppRoutes.notificationSettings: NotificationSettingsScreen,
  AppRoutes.helpFeedback: HelpFeedbackScreen,
  AppRoutes.about: AboutScreen,
};

/// Screens that expose content / empty / loading states.
const Set<String> _dataDriven = {
  AppRoutes.home,
  AppRoutes.trains,
  AppRoutes.explore,
  AppRoutes.saved,
  AppRoutes.journeySearch,
  AppRoutes.departureStation,
  AppRoutes.searchResults,
  AppRoutes.trainDetails,
  AppRoutes.stopTimeline,
  AppRoutes.routeMap,
  AppRoutes.classesFacilities,
  AppRoutes.railwayLines,
  AppRoutes.lineDetails,
  AppRoutes.stationDirectory,
  AppRoutes.stationDetails,
  AppRoutes.nearbyStations,
  AppRoutes.destinationCategories,
  AppRoutes.destinationDetails,
  AppRoutes.destinationGallery,
  AppRoutes.favoriteTrains,
  AppRoutes.favoriteDestinations,
  AppRoutes.announcements,
  AppRoutes.announcementDetails,
};

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test-key',
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
        autoRefreshToken: false,
        detectSessionInUri: false,
      ),
      debug: false,
    );
  });

  test('every route has a screen test', () {
    final routed = {...fullScreenRoutes.keys, ...tabRoutes.keys};
    expect(routed, _screens.keys.toSet());
  });

  group('screen builds', () {
    for (final MapEntry(key: path, value: type) in _screens.entries) {
      testWidgets('$type at $path', (tester) async {
        await pumpRoute(tester, path);
        expect(find.byType(type), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('UI states', () {
    for (final path in _dataDriven) {
      for (final state in [UiViewState.empty, UiViewState.loading]) {
        testWidgets('$path · ${state.name}', (tester) async {
          await pumpRoute(tester, path, state: state);
          expect(find.byType(_screens[path]!), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  group('Sinhala locale', () {
    for (final path in _screens.keys) {
      testWidgets('si $path', (tester) async {
        await pumpRoute(tester, path, language: AppLanguage.sinhala);
        expect(find.byType(_screens[path]!), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('small phone + large text', () {
    for (final path in _screens.keys) {
      testWidgets('320x640 @1.5x $path', (tester) async {
        await pumpRoute(
          tester,
          path,
          size: const Size(320, 640),
          textScale: 1.5,
        );
        expect(find.byType(_screens[path]!), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  testWidgets('splash advances to welcome', (tester) async {
    await pumpRoute(tester, AppRoutes.splash);
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
