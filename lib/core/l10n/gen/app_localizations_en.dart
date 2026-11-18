// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CeylonGO';

  @override
  String get appTagline => 'Explore Sri Lanka. Travel by Train.';

  @override
  String get appSubtitle => 'Sri Lanka Railway Companion';

  @override
  String get back => 'Back';

  @override
  String get share => 'Share';

  @override
  String get save => 'Save';

  @override
  String get seeAll => 'See all';

  @override
  String get viewAll => 'View all';

  @override
  String get continueLabel => 'Continue';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get swapStations => 'Swap stations';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get today => 'Today';

  @override
  String get verified => 'Verified';

  @override
  String get scenic => 'Scenic';

  @override
  String get photo => 'Photo';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get limited => 'Limited';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get km => 'km';

  @override
  String get arrow => '→';

  @override
  String openItem(String name) {
    return 'Open $name';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navTrains => 'Trains';

  @override
  String get navExplore => 'Explore';

  @override
  String get navSaved => 'Saved';

  @override
  String get navProfile => 'Profile';

  @override
  String get mainNavigation => 'Main';

  @override
  String previewState(String state) {
    return 'UI state: $state';
  }

  @override
  String get previewContent => 'Content';

  @override
  String get previewEmpty => 'Empty';

  @override
  String get previewLoading => 'Loading';

  @override
  String get loading => 'Loading';

  @override
  String get emptyTrainsTitle => 'No direct trains for this choice';

  @override
  String get emptyTrainsBody =>
      'Try another date or time, or change at Colombo Fort or Polgahawela.';

  @override
  String get emptyStationsTitle => 'No stations found';

  @override
  String get emptyStationsBody => 'Try a different name or station code.';

  @override
  String get emptyLinesTitle => 'No railway lines yet';

  @override
  String get emptyLinesBody => 'Lines and their stations will appear here.';

  @override
  String get emptyPlacesTitle => 'No places yet';

  @override
  String get emptyPlacesBody =>
      'Destinations near each station will appear here.';

  @override
  String get emptySavedTitle => 'Nothing saved yet';

  @override
  String get emptySavedBody =>
      'Tap the bookmark on a train, station or place to keep it here.';

  @override
  String get emptyAnnouncementsTitle => 'No announcements';

  @override
  String get emptyAnnouncementsBody =>
      'Verified notices from Sri Lanka Railways will appear here.';

  @override
  String get emptyGalleryTitle => 'No photos yet';

  @override
  String get emptyGalleryBody => 'Be the first to add a photo of this place.';

  @override
  String get emptyDetailsTitle => 'Details unavailable';

  @override
  String get emptyDetailsBody =>
      'We couldn\'t load this right now. Please try again shortly.';

  @override
  String get emptyRecentTitle => 'No recent searches';

  @override
  String get emptyRecentBody => 'Your last journeys will show up here.';

  @override
  String get emptyStopsTitle => 'No stops to show';

  @override
  String get emptyStopsBody => 'Stop times for this train will appear here.';

  @override
  String get splashContinue => 'Continue to welcome';

  @override
  String get welcomePhotoPlace => 'Nine Arch Bridge, Ella';

  @override
  String get welcomePhotoLine => 'Main Line';

  @override
  String get welcomeLanguageChip => 'EN · සිං';

  @override
  String get welcomeChangeLanguage => 'Change language';

  @override
  String get welcomeBody =>
      'Timetables, routes and stations for every line — plus the places worth stepping off for.';

  @override
  String get getStarted => 'Get started';

  @override
  String get welcomeImageAlt =>
      'Blue train crossing the Nine Arch Bridge near Ella';

  @override
  String get mistyImageAlt =>
      'Misty hill-country railway with a train waiting beside curving tracks';

  @override
  String get onboardingTitle1 => 'Every train, every station';

  @override
  String get onboardingBody1 =>
      'Search timetables across Sri Lanka’s railway lines — from Colombo Fort to Badulla, Jaffna and Matara.';

  @override
  String get onboardingTitle2 => 'Ride the scenic routes';

  @override
  String get onboardingBody2 =>
      'Find destinations near each station, from the Nine Arch Bridge to Galle Fort, with walking times from the platform.';

  @override
  String get onboardingTitle3 => 'Verified announcements';

  @override
  String get onboardingBody3 =>
      'Get official schedule changes and save your favourite trains, stations and places for quick access.';

  @override
  String get onboardingNextStop => 'Next stop';

  @override
  String get onboardingNextStopValue => 'Ella · 12 min';

  @override
  String get onboardingDistance => 'Nine Arch Bridge · 2.1 km';

  @override
  String onboardingStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get languageTitleAlt => 'ඔබේ භාෂාව තෝරන්න';

  @override
  String get languageBody =>
      'Station names, timetables and announcements will appear in this language. Change it any time in Settings.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageEnglishSub => 'Recommended for international travellers';

  @override
  String get languageSinhala => 'සිංහල';

  @override
  String get languageSinhalaSub => 'Sinhala · ශ්‍රී ලාංකීය මගීන් සඳහා';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get languageTamilSub => 'Tamil';

  @override
  String get languageTamilNote =>
      'Tamil support is planned for a future release';

  @override
  String get appLanguage => 'App language';

  @override
  String get signInTitle => 'Welcome back';

  @override
  String get signInBody =>
      'Sign in to sync your saved trains, places and alerts.';

  @override
  String get google => 'Google';

  @override
  String get facebook => 'Facebook';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get signInDivider => 'or sign in with username';

  @override
  String get usernameOrEmail => 'Username or email';

  @override
  String get password => 'Password';

  @override
  String get showHidePassword => 'Show or hide password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get newToApp => 'New to CeylonGO?';

  @override
  String get createAccount => 'Create account';

  @override
  String get errUsernameOrEmail => 'Enter your username or email';

  @override
  String get errPassword => 'Enter your password';

  @override
  String get signUpTitle => 'Create your account';

  @override
  String get signUpBody => 'Save trains and get verified railway alerts.';

  @override
  String get signUpDivider => 'or sign up with email';

  @override
  String get email => 'Email';

  @override
  String get username => 'Username';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get agreeTerms => 'I agree to the Terms of use and Privacy policy';

  @override
  String get errAgree => 'Please accept to continue';

  @override
  String get errEmail => 'Enter a valid email address';

  @override
  String get errUsername => 'Use at least 3 characters';

  @override
  String get errPasswordLength => 'Use at least 8 characters';

  @override
  String get errPasswordMatch => 'Passwords do not match';

  @override
  String get pwTooShort => 'Too short · use at least 8 characters';

  @override
  String get pwStrong => 'Strong password';

  @override
  String get pwAddNumber => 'Add a number to make it stronger';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get resetTitle => 'Reset your password';

  @override
  String get resetBody =>
      'Enter your username or email, then choose a new password.';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get remembered => 'Remembered it?';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String get passwordUpdatedBody =>
      'You can now sign in with your new password.';

  @override
  String get greeting => 'Ayubowan,';

  @override
  String get homeTitle => 'Where to next?';

  @override
  String get findTrains => 'Find trains';

  @override
  String get announcements => 'Announcements';

  @override
  String get profile => 'Profile';

  @override
  String get quickTrains => 'Trains';

  @override
  String get quickLines => 'Lines';

  @override
  String get quickStations => 'Stations';

  @override
  String get quickExplore => 'Explore';

  @override
  String departingFrom(String station) {
    return 'Departing $station';
  }

  @override
  String platformShort(String number) {
    return 'Plat. $number';
  }

  @override
  String travelDateLabel(String date) {
    return 'Travel date: $date';
  }

  @override
  String get planJourney => 'Plan a journey';

  @override
  String get travelDate => 'Travel date';

  @override
  String get departureTime => 'Departure time';

  @override
  String get travelClass => 'Class';

  @override
  String get anyTime => 'Any time';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get night => 'Night';

  @override
  String get evening => 'Evening';

  @override
  String get classAll => 'All';

  @override
  String get class1stObservation => '1st · Observation';

  @override
  String get class2nd => '2nd';

  @override
  String get class3rd => '3rd';

  @override
  String get pickDate => 'Pick a date';

  @override
  String get searchTrains => 'Search trains';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get departureStation => 'Departure station';

  @override
  String get arrivalStation => 'Arrival station';

  @override
  String get searchStationsHint => 'Search 400+ stations';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String nearestStation(String name, String distance) {
    return 'Nearest: $name · $distance';
  }

  @override
  String get popular => 'Popular';

  @override
  String get allStations => 'All stations';

  @override
  String get confirmStation => 'Confirm station';

  @override
  String get filters => 'Filters';

  @override
  String get sortEarliest => 'Earliest';

  @override
  String get sortFastest => 'Fastest';

  @override
  String get sortScenic => 'Most scenic';

  @override
  String get sortObservation => 'Observation';

  @override
  String trainsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trains',
      one: '1 train',
    );
    return '$_temp0';
  }

  @override
  String dateAndCount(String date, String count) {
    return '$date · $count';
  }

  @override
  String get trainsEyebrow => 'Trains';

  @override
  String get findAvailableTrains => 'Find available trains';

  @override
  String get fromYourStation => 'From · your station';

  @override
  String get toDestination => 'To · destination';

  @override
  String get departed => 'Departed';

  @override
  String get direct => 'Direct';

  @override
  String stopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops',
      one: '1 stop',
    );
    return '$_temp0';
  }

  @override
  String get nextDay => '+1 day';

  @override
  String get sameStationError =>
      'Choose a destination different from your station.';

  @override
  String stillToDepart(int count) {
    return '$count still to depart today';
  }

  @override
  String get saveTrain => 'Save train';

  @override
  String get duration => 'Duration';

  @override
  String get distance => 'Distance';

  @override
  String get majorStops => 'Major stops';

  @override
  String get classes => 'Classes';

  @override
  String get stopTimeline => 'Stop timeline';

  @override
  String get stopTimelineSub => 'Every station with arrival times';

  @override
  String get routeMap => 'Route map';

  @override
  String get classesFacilities => 'Classes & facilities';

  @override
  String get scenicHighlights => 'Scenic highlights';

  @override
  String get allStops => 'All stops';

  @override
  String get touristStop => 'Tourist stop';

  @override
  String get highestPoint => 'Highest point';

  @override
  String get terminus => 'Terminus';

  @override
  String get mapLayers => 'Map layers';

  @override
  String get scenicStretch => 'Scenic stretch';

  @override
  String get journeyLower => 'journey';

  @override
  String get majorStopsLower => 'major stops';

  @override
  String get exploreStops => 'Explore stops';

  @override
  String get zoomIn => 'Zoom in';

  @override
  String get zoomOut => 'Zoom out';

  @override
  String get recenterMap => 'Re-centre map';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get mapLabel => 'Map of Sri Lanka';

  @override
  String get onThisTrain => 'On this train';

  @override
  String get notOnThisTrain => 'Not on this train';

  @override
  String get facilitiesOnBoard => 'Facilities on board';

  @override
  String get findTrainsWithClasses => 'Find trains with these classes';

  @override
  String get facilityFood => 'Food vendors';

  @override
  String get facilityToilets => 'Toilets';

  @override
  String get facilityLuggage => 'Luggage racks';

  @override
  String get facilityCharging => 'Charging';

  @override
  String get facilityStepFree => 'Step-free';

  @override
  String get facilityAirCon => 'Air-con';

  @override
  String get railwayLines => 'Railway lines';

  @override
  String get linesIntro =>
      'Every line starts from the Colombo network. Tap a line for its stations and trains.';

  @override
  String get saveLine => 'Save line';

  @override
  String get lineLength => 'Length';

  @override
  String get firstSection => 'First section';

  @override
  String get keyStations => 'Key stations';

  @override
  String get trainsOnLine => 'Trains on this line';

  @override
  String get placesAlongLine => 'Places along this line';

  @override
  String get mostScenic => 'Most scenic';

  @override
  String get stationDirectory => 'Station directory';

  @override
  String get searchByNameOrCode => 'Search by name or code';

  @override
  String get filterAll => 'All';

  @override
  String get filterMain => 'Main';

  @override
  String get filterCoastal => 'Coastal';

  @override
  String get filterNorthern => 'Northern';

  @override
  String get filterTouristStops => 'Tourist stops';

  @override
  String jumpToLetter(String letter) {
    return 'Jump to $letter';
  }

  @override
  String get saveStation => 'Save station';

  @override
  String get nextDepartures => 'Next departures';

  @override
  String toStation(String station) {
    return 'To $station';
  }

  @override
  String get nearbyPlaces => 'Nearby places';

  @override
  String get timetable => 'Timetable';

  @override
  String get directions => 'Directions';

  @override
  String nearPlace(String place) {
    return 'Near $place';
  }

  @override
  String get nearbyRailwayStations => 'Nearby railway stations';

  @override
  String get exploreEyebrow => 'Explore';

  @override
  String get exploreTitle => 'Places worth the journey';

  @override
  String get searchPlaces => 'Search places';

  @override
  String get catHillCountry => 'Hill country';

  @override
  String get catBeaches => 'Beaches';

  @override
  String get catHeritage => 'Heritage';

  @override
  String get catWildlife => 'Wildlife';

  @override
  String get featured => 'Featured';

  @override
  String get planTrip => 'Plan trip';

  @override
  String get easyByTrain => 'Easy by train from Colombo';

  @override
  String get destinationCategories => 'Destination categories';

  @override
  String get savePlace => 'Save place';

  @override
  String get gallery => 'Gallery';

  @override
  String get nearestStationLabel => 'Nearest station';

  @override
  String moreCount(int count) {
    return '$count more';
  }

  @override
  String trainsTo(String station) {
    return 'Trains to $station';
  }

  @override
  String galleryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return 'Gallery · $_temp0';
  }

  @override
  String get galleryAll => 'All';

  @override
  String get galleryTrains => 'Trains';

  @override
  String get galleryViews => 'Views';

  @override
  String get galleryTravellers => 'Travellers';

  @override
  String get yourPhoto => 'Your photo';

  @override
  String get addYourPhoto => 'Add your photo';

  @override
  String get savedTitle => 'Saved';

  @override
  String get savedSubtitle => 'Your trains, routes and places in one spot';

  @override
  String get statTrains => 'Trains';

  @override
  String get statRoutes => 'Routes';

  @override
  String get statStations => 'Stations';

  @override
  String get statPlaces => 'Places';

  @override
  String get savedTrains => 'Saved trains';

  @override
  String get savedPlaces => 'Saved places';

  @override
  String get nextDeparture => 'Next departure';

  @override
  String get favoriteTrainsTitle => 'Favorite trains & routes';

  @override
  String tabTrainsCount(int count) {
    return 'Trains · $count';
  }

  @override
  String tabRoutesCount(int count) {
    return 'Routes · $count';
  }

  @override
  String get savedAlertsBody =>
      'Get verified alerts when a saved train is delayed or rescheduled';

  @override
  String get alertsForSavedTrains => 'Alerts for saved trains';

  @override
  String get favoriteDestinationsTitle => 'Favorite destinations';

  @override
  String get gridView => 'Grid view';

  @override
  String allCount(int count) {
    return 'All · $count';
  }

  @override
  String get catCoast => 'Coast';

  @override
  String get planTripSaved => 'Plan a trip to saved places';

  @override
  String get notificationSettings => 'Notification settings';

  @override
  String get filterDelays => 'Delays';

  @override
  String get filterSchedule => 'Schedule changes';

  @override
  String get filterService => 'Service';

  @override
  String get verifiedSource => 'Verified · Sri Lanka Railways';

  @override
  String get typeScheduleChange => 'Schedule change';

  @override
  String get typeDelay => 'Delay';

  @override
  String get typeService => 'Service';

  @override
  String get announcement => 'Announcement';

  @override
  String get verifiedFromOfficial =>
      'Verified from the Sri Lanka Railways official notice';

  @override
  String get detailDates => 'Dates';

  @override
  String get detailSection => 'Section';

  @override
  String get detailAffectedTrains => 'Affected trains';

  @override
  String get detailExpectedDelay => 'Expected delay';

  @override
  String get viewOriginalNotice => 'View original notice';

  @override
  String get notifyMe => 'Notify me';

  @override
  String get settings => 'Settings';

  @override
  String get editProfile => 'Edit profile';

  @override
  String homeStationLabel(String station) {
    return 'Home station · $station';
  }

  @override
  String get statSavedTrains => 'Saved trains';

  @override
  String get statSavedPlaces => 'Saved places';

  @override
  String get savedRowSub => 'Trains, routes and places';

  @override
  String unreadCount(int count) {
    return '$count unread';
  }

  @override
  String get settingsRowSub => 'Language, theme, notifications';

  @override
  String get helpFeedback => 'Help & feedback';

  @override
  String get aboutApp => 'About CeylonGO';

  @override
  String get signOut => 'Sign out';

  @override
  String get sectionPreferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get notifications => 'Notifications';

  @override
  String notificationsOnCount(int count) {
    return '$count on';
  }

  @override
  String get sectionTravel => 'Travel';

  @override
  String get homeStation => 'Home station';

  @override
  String get preferredClass => 'Preferred class';

  @override
  String get sectionData => 'Data';

  @override
  String get offlineTimetables => 'Offline timetables';

  @override
  String get offlineTimetablesSub =>
      'Keep saved trains available without signal';

  @override
  String get clearSearchHistory => 'Clear search history';

  @override
  String get sectionSupport => 'Support';

  @override
  String versionShort(String version) {
    return 'v$version';
  }

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get sectionDisplay => 'Display';

  @override
  String get bilingualNames => 'Show station names in both languages';

  @override
  String get bilingualNamesSub => 'e.g. Ella · ඇල්ල';

  @override
  String get translateAnnouncements => 'Translate announcements';

  @override
  String get translateAnnouncementsSub =>
      'Show official notices in your app language';

  @override
  String get officialNamesNote =>
      'Official station names follow Sri Lanka Railways signage.';

  @override
  String get themeNote =>
      'System follows your phone’s setting. Maps and route views always use the dark forest palette for contrast outdoors.';

  @override
  String get sectionComfort => 'Comfort';

  @override
  String get largerText => 'Larger text';

  @override
  String get largerTextSub => 'Bigger timetable times and station names';

  @override
  String get highContrast => 'High-contrast mode';

  @override
  String get highContrastSub => 'Stronger colours for bright platforms';

  @override
  String get sectionRailwayUpdates => 'Railway updates';

  @override
  String get notifyVerified => 'Verified announcements';

  @override
  String get notifyVerifiedSub => 'Official notices from Sri Lanka Railways';

  @override
  String get notifyDelays => 'Delays on saved trains';

  @override
  String get notifyDelaysSub => 'Only for trains you’ve saved';

  @override
  String get notifySchedule => 'Schedule changes on saved lines';

  @override
  String get notifyScheduleSub => 'Track work, cancellations, new services';

  @override
  String get sectionTrips => 'Trips';

  @override
  String get notifyReminders => 'Departure reminders';

  @override
  String get notifyRemindersSub => '15 minutes before a saved train leaves';

  @override
  String get notifyInspiration => 'Travel inspiration';

  @override
  String get notifyInspirationSub => 'New places to visit by train';

  @override
  String get sectionQuietHours => 'Quiet hours';

  @override
  String get quietHoursRange => '22:00 – 06:00';

  @override
  String get quietHoursSub => 'Urgent delays still come through';

  @override
  String get quietHours => 'Quiet hours';

  @override
  String get searchHelp => 'Search help articles';

  @override
  String get faq1Q => 'How accurate are the timetables?';

  @override
  String get faq1A =>
      'Times come from the official railway timetable. Delays and changes appear under Announcements once verified.';

  @override
  String get faq2Q => 'Can I book tickets in CeylonGO?';

  @override
  String get faq2A =>
      'Not yet. Each train shows which classes can be reserved and where to book.';

  @override
  String get faq3Q => 'Does the app work offline?';

  @override
  String get faq3A =>
      'Yes, saved trains and their stops stay available without signal.';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get rating => 'Rating';

  @override
  String rateStars(int count) {
    return 'Rate $count out of 5';
  }

  @override
  String get yourMessage => 'Your message';

  @override
  String get messageHint =>
      'Tell us what to improve, or report a timetable error';

  @override
  String get emailUs => 'Email us';

  @override
  String get chat => 'Chat';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get aboutBody =>
      'CeylonGO helps locals and visitors find trains, understand routes and discover the places each station opens up — with announcements checked against official railway notices.';

  @override
  String get dataSource => 'Timetable data source';

  @override
  String get dataSourceValue => '[OFFICIAL SOURCE]';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get rateApp => 'Rate CeylonGO';

  @override
  String get notOfficial =>
      'Not an official Sri Lanka Railways app · © 2026 CeylonGO';
}
