import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/announcements/presentation/announcement_details_screen.dart';
import '../../features/announcements/presentation/announcements_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/explore/presentation/destination_categories_screen.dart';
import '../../features/explore/presentation/destination_details_screen.dart';
import '../../features/explore/presentation/destination_gallery_screen.dart';
import '../../features/explore/presentation/explore_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/journey/presentation/journey_search_screen.dart';
import '../../features/journey/presentation/search_results_screen.dart';
import '../../features/journey/presentation/station_picker_screen.dart';
import '../../features/lines/presentation/line_details_screen.dart';
import '../../features/lines/presentation/railway_lines_screen.dart';
import '../../features/maps/presentation/nearby_stations_screen.dart';
import '../../features/maps/presentation/route_map_screen.dart';
import '../../features/onboarding/presentation/language_select_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/saved/presentation/favorite_destinations_screen.dart';
import '../../features/saved/presentation/favorite_trains_screen.dart';
import '../../features/saved/presentation/saved_screen.dart';
import '../../features/settings/presentation/about_screen.dart';
import '../../features/settings/presentation/legal_screen.dart';
import '../../features/settings/presentation/help_feedback_screen.dart';
import '../../features/settings/presentation/language_settings_screen.dart';
import '../../features/settings/presentation/notification_settings_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/theme_settings_screen.dart';
import '../../features/stations/presentation/station_details_screen.dart';
import '../../features/stations/presentation/station_directory_screen.dart';
import '../../features/trains/presentation/all_trains_screen.dart';
import '../../features/trains/presentation/classes_facilities_screen.dart';
import '../../features/trains/presentation/stop_timeline_screen.dart';
import '../../features/trains/presentation/train_details_screen.dart';
import 'app_routes.dart';
import 'app_shell.dart';

/// Every full-screen (non-tab) route: path → screen builder.
///
/// Exposed so widget tests can build each screen through the router.
/// Builds a screen from the route state (`?id=` selects the item).
typedef RouteScreenBuilder = Widget Function(BuildContext, GoRouterState);

final Map<String, RouteScreenBuilder> fullScreenRoutes = {
  AppRoutes.splash: (_, s) => const SplashScreen(),
  AppRoutes.welcome: (_, s) => const WelcomeScreen(),
  AppRoutes.onboarding: (_, s) => const OnboardingScreen(),
  AppRoutes.languageSelect: (_, s) => const LanguageSelectScreen(),
  AppRoutes.signIn: (_, s) => const SignInScreen(),
  AppRoutes.signUp: (_, s) => const SignUpScreen(),
  AppRoutes.forgotPassword: (_, s) => ForgotPasswordScreen(
    updateMode: s.uri.queryParameters['mode'] == 'update',
  ),
  AppRoutes.journeySearch: (_, s) => const JourneySearchScreen(),
  AppRoutes.departureStation: (_, s) =>
      const StationPickerScreen(kind: StationPickerKind.departure),
  AppRoutes.arrivalStation: (_, s) =>
      const StationPickerScreen(kind: StationPickerKind.arrival),
  AppRoutes.homeStationPicker: (_, s) =>
      const StationPickerScreen(kind: StationPickerKind.home),
  AppRoutes.searchResults: (_, s) => const SearchResultsScreen(),
  AppRoutes.trainDetails: (_, s) => TrainDetailsScreen(trainId: s.uri.queryParameters['id']),
  AppRoutes.stopTimeline: (_, s) => StopTimelineScreen(trainId: s.uri.queryParameters['id']),
  AppRoutes.routeMap: (_, s) => RouteMapScreen(trainId: s.uri.queryParameters['id']),
  AppRoutes.classesFacilities: (_, s) => ClassesFacilitiesScreen(trainId: s.uri.queryParameters['id']),
  AppRoutes.railwayLines: (_, s) => const RailwayLinesScreen(),
  AppRoutes.lineDetails: (_, s) => LineDetailsScreen(lineId: s.uri.queryParameters['id']),
  AppRoutes.stationDirectory: (_, s) => const StationDirectoryScreen(),
  AppRoutes.stationDetails: (_, s) => StationDetailsScreen(stationId: s.uri.queryParameters['id']),
  AppRoutes.nearbyStations: (_, s) =>
      NearbyStationsScreen(destinationId: s.uri.queryParameters['id']),
  AppRoutes.destinationCategories: (_, s) => DestinationCategoriesScreen(categoryId: s.uri.queryParameters['id']),
  AppRoutes.destinationDetails: (_, s) => DestinationDetailsScreen(destinationId: s.uri.queryParameters['id']),
  AppRoutes.destinationGallery: (_, s) => DestinationGalleryScreen(destinationId: s.uri.queryParameters['id']),
  AppRoutes.favoriteTrains: (_, s) => const FavoriteTrainsScreen(),
  AppRoutes.favoriteDestinations: (_, s) => const FavoriteDestinationsScreen(),
  AppRoutes.announcements: (_, s) => const AnnouncementsScreen(),
  AppRoutes.announcementDetails: (_, s) => AnnouncementDetailsScreen(announcementId: s.uri.queryParameters['id']),
  AppRoutes.settings: (_, s) => const SettingsScreen(),
  AppRoutes.languageSettings: (_, s) => const LanguageSettingsScreen(),
  AppRoutes.themeSettings: (_, s) => const ThemeSettingsScreen(),
  AppRoutes.notificationSettings: (_, s) => const NotificationSettingsScreen(),
  AppRoutes.helpFeedback: (_, s) => const HelpFeedbackScreen(),
  AppRoutes.about: (_, s) => const AboutScreen(),
  AppRoutes.privacy: (_, s) => const LegalScreen(doc: LegalDoc.privacy),
  AppRoutes.terms: (_, s) => const LegalScreen(doc: LegalDoc.terms),
};

/// Bottom-navigation tabs in display order: path → screen builder.
final Map<String, WidgetBuilder> tabRoutes = {
  AppRoutes.home: (_) => const HomeScreen(),
  AppRoutes.trains: (_) => const AllTrainsScreen(),
  AppRoutes.explore: (_) => const ExploreScreen(),
  AppRoutes.saved: (_) => const SavedScreen(),
  AppRoutes.profile: (_) => const ProfileScreen(),
};

/// Builds the app router. [initialLocation] is configurable for tests.
GoRouter createAppRouter({String initialLocation = AppRoutes.splash}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          for (final entry in tabRoutes.entries)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: entry.key,
                  builder: (context, state) => entry.value(context),
                ),
              ],
            ),
        ],
      ),
      for (final entry in fullScreenRoutes.entries)
        GoRoute(
          path: entry.key,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => entry.value(context, state),
        ),
    ],
  );
}
