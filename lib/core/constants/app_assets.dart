/// Bundled asset paths.
abstract final class AppAssets {
  static const String nineArchBridge = 'assets/images/nine_arch_bridge.jpg';
  static const String mistyHillTrain = 'assets/images/misty_hill_train.jpg';
  static const String onboardingBridge =
      'assets/images/onboarding_nine_arch_bridge.jpg';
  static const String onboardingStation =
      'assets/images/onboarding_misty_station.jpg';
  static const String onboardingTeaCountry =
      'assets/images/onboarding_tea_country_train.jpg';
  static const String logoMark = 'assets/icons/logo_mark.svg';
}

/// Non-translatable constants.
abstract final class AppConstants {
  static const String version = '1.0.0';
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgentPackage = 'com.example.lankarail';

  /// Rough centre of Sri Lanka for the default map camera.
  static const double sriLankaLat = 7.8731;
  static const double sriLankaLng = 80.7718;
  static const double defaultMapZoom = 7.2;
}
