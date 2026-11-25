/// Route paths for every screen in the app.
abstract final class AppRoutes {
  // Onboarding & auth
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String languageSelect = '/language';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';

  // Bottom navigation tabs
  static const String home = '/home';
  static const String trains = '/trains';
  static const String explore = '/explore';
  static const String saved = '/saved';
  static const String profile = '/profile';

  // Journey
  static const String journeySearch = '/journey';
  static const String departureStation = '/journey/departure';
  static const String arrivalStation = '/journey/arrival';
  static const String searchResults = '/journey/results';

  // Trains
  static const String trainDetails = '/train';
  static const String stopTimeline = '/train/stops';
  static const String routeMap = '/train/map';
  static const String classesFacilities = '/train/classes';

  // Lines & stations
  static const String railwayLines = '/lines';
  static const String lineDetails = '/lines/details';
  static const String stationDirectory = '/stations';
  static const String stationDetails = '/stations/details';
  static const String nearbyStations = '/stations/nearby';

  // Destinations
  static const String destinationCategories = '/destinations/categories';
  static const String destinationDetails = '/destinations/details';
  static const String destinationGallery = '/destinations/gallery';

  // Saved
  static const String favoriteTrains = '/saved/trains';
  static const String favoriteDestinations = '/saved/places';

  // Announcements
  static const String announcements = '/announcements';
  static const String announcementDetails = '/announcements/details';

  // Settings
  static const String settings = '/settings';
  static const String homeStationPicker = '/settings/home-station';
  static const String languageSettings = '/settings/language';
  static const String themeSettings = '/settings/theme';
  static const String notificationSettings = '/settings/notifications';
  static const String helpFeedback = '/settings/help';
  static const String about = '/settings/about';
  static const String privacy = '/settings/privacy';
  static const String terms = '/settings/terms';

  /// Detail route for one item, e.g. `AppRoutes.withId(trainDetails, id)`.
  static String withId(String route, String id) =>
      '$route?id=${Uri.encodeQueryComponent(id)}';
}
