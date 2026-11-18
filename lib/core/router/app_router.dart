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
final Map<String, WidgetBuilder> fullScreenRoutes = {
  AppRoutes.splash: (_) => const SplashScreen(),
  AppRoutes.welcome: (_) => const WelcomeScreen(),
  AppRoutes.onboarding: (_) => const OnboardingScreen(),
  AppRoutes.languageSelect: (_) => const LanguageSelectScreen(),
  AppRoutes.signIn: (_) => const SignInScreen(),
  AppRoutes.signUp: (_) => const SignUpScreen(),
  AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
  AppRoutes.journeySearch: (_) => const JourneySearchScreen(),
  AppRoutes.departureStation: (_) =>
      const StationPickerScreen(kind: StationPickerKind.departure),
  AppRoutes.arrivalStation: (_) =>
      const StationPickerScreen(kind: StationPickerKind.arrival),
  AppRoutes.searchResults: (_) => const SearchResultsScreen(),
  AppRoutes.trainDetails: (_) => const TrainDetailsScreen(),
  AppRoutes.stopTimeline: (_) => const StopTimelineScreen(),
  AppRoutes.routeMap: (_) => const RouteMapScreen(),
  AppRoutes.classesFacilities: (_) => const ClassesFacilitiesScreen(),
  AppRoutes.railwayLines: (_) => const RailwayLinesScreen(),
  AppRoutes.lineDetails: (_) => const LineDetailsScreen(),
  AppRoutes.stationDirectory: (_) => const StationDirectoryScreen(),
  AppRoutes.stationDetails: (_) => const StationDetailsScreen(),
  AppRoutes.nearbyStations: (_) => const NearbyStationsScreen(),
  AppRoutes.destinationCategories: (_) => const DestinationCategoriesScreen(),
  AppRoutes.destinationDetails: (_) => const DestinationDetailsScreen(),
  AppRoutes.destinationGallery: (_) => const DestinationGalleryScreen(),
  AppRoutes.favoriteTrains: (_) => const FavoriteTrainsScreen(),
  AppRoutes.favoriteDestinations: (_) => const FavoriteDestinationsScreen(),
  AppRoutes.announcements: (_) => const AnnouncementsScreen(),
  AppRoutes.announcementDetails: (_) => const AnnouncementDetailsScreen(),
  AppRoutes.settings: (_) => const SettingsScreen(),
  AppRoutes.languageSettings: (_) => const LanguageSettingsScreen(),
  AppRoutes.themeSettings: (_) => const ThemeSettingsScreen(),
  AppRoutes.notificationSettings: (_) => const NotificationSettingsScreen(),
  AppRoutes.helpFeedback: (_) => const HelpFeedbackScreen(),
  AppRoutes.about: (_) => const AboutScreen(),
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
          builder: (context, state) => entry.value(context),
        ),
    ],
  );
}
