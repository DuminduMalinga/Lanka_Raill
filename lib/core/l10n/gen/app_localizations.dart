import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CeylonGO'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Explore Sri Lanka. Travel by Train.'**
  String get appTagline;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka Railway Companion'**
  String get appSubtitle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @swapStations.
  ///
  /// In en, this message translates to:
  /// **'Swap stations'**
  String get swapStations;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @scenic.
  ///
  /// In en, this message translates to:
  /// **'Scenic'**
  String get scenic;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @limited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get limited;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @arrow.
  ///
  /// In en, this message translates to:
  /// **'→'**
  String get arrow;

  /// No description provided for @openItem.
  ///
  /// In en, this message translates to:
  /// **'Open {name}'**
  String openItem(String name);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTrains.
  ///
  /// In en, this message translates to:
  /// **'Trains'**
  String get navTrains;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @mainNavigation.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get mainNavigation;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @emptyTrainsTitle.
  ///
  /// In en, this message translates to:
  /// **'No direct trains for this choice'**
  String get emptyTrainsTitle;

  /// No description provided for @emptyTrainsBody.
  ///
  /// In en, this message translates to:
  /// **'Try another date or time, or change at Colombo Fort or Polgahawela.'**
  String get emptyTrainsBody;

  /// No description provided for @emptyStationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No stations found'**
  String get emptyStationsTitle;

  /// No description provided for @emptyStationsBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different name or station code.'**
  String get emptyStationsBody;

  /// No description provided for @emptyLinesTitle.
  ///
  /// In en, this message translates to:
  /// **'No railway lines yet'**
  String get emptyLinesTitle;

  /// No description provided for @emptyLinesBody.
  ///
  /// In en, this message translates to:
  /// **'Lines and their stations will appear here.'**
  String get emptyLinesBody;

  /// No description provided for @emptyPlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'No places yet'**
  String get emptyPlacesTitle;

  /// No description provided for @emptyPlacesBody.
  ///
  /// In en, this message translates to:
  /// **'Destinations near each station will appear here.'**
  String get emptyPlacesBody;

  /// No description provided for @emptySavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get emptySavedTitle;

  /// No description provided for @emptySavedBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark on a train, station or place to keep it here.'**
  String get emptySavedBody;

  /// No description provided for @emptyAnnouncementsTitle.
  ///
  /// In en, this message translates to:
  /// **'No announcements'**
  String get emptyAnnouncementsTitle;

  /// No description provided for @emptyAnnouncementsBody.
  ///
  /// In en, this message translates to:
  /// **'Verified notices from Sri Lanka Railways will appear here.'**
  String get emptyAnnouncementsBody;

  /// No description provided for @emptyGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'No photos yet'**
  String get emptyGalleryTitle;

  /// No description provided for @emptyGalleryBody.
  ///
  /// In en, this message translates to:
  /// **'Be the first to add a photo of this place.'**
  String get emptyGalleryBody;

  /// No description provided for @emptyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details unavailable'**
  String get emptyDetailsTitle;

  /// No description provided for @emptyDetailsBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this right now. Please try again shortly.'**
  String get emptyDetailsBody;

  /// No description provided for @emptyRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'No recent searches'**
  String get emptyRecentTitle;

  /// No description provided for @emptyRecentBody.
  ///
  /// In en, this message translates to:
  /// **'Your last journeys will show up here.'**
  String get emptyRecentBody;

  /// No description provided for @emptyStopsTitle.
  ///
  /// In en, this message translates to:
  /// **'No stops to show'**
  String get emptyStopsTitle;

  /// No description provided for @emptyStopsBody.
  ///
  /// In en, this message translates to:
  /// **'Stop times for this train will appear here.'**
  String get emptyStopsBody;

  /// No description provided for @splashContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue to welcome'**
  String get splashContinue;

  /// No description provided for @welcomePhotoPlace.
  ///
  /// In en, this message translates to:
  /// **'Nine Arch Bridge, Ella'**
  String get welcomePhotoPlace;

  /// No description provided for @welcomePhotoLine.
  ///
  /// In en, this message translates to:
  /// **'Main Line'**
  String get welcomePhotoLine;

  /// No description provided for @welcomeLanguageChip.
  ///
  /// In en, this message translates to:
  /// **'EN · සිං'**
  String get welcomeLanguageChip;

  /// No description provided for @welcomeChangeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get welcomeChangeLanguage;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Timetables, routes and stations for every line — plus the places worth stepping off for.'**
  String get welcomeBody;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @welcomeImageAlt.
  ///
  /// In en, this message translates to:
  /// **'Blue train crossing the Nine Arch Bridge near Ella'**
  String get welcomeImageAlt;

  /// No description provided for @mistyImageAlt.
  ///
  /// In en, this message translates to:
  /// **'Misty hill-country railway with a train waiting beside curving tracks'**
  String get mistyImageAlt;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Every train, every station'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Search timetables across Sri Lanka’s railway lines — from Colombo Fort to Badulla, Jaffna and Matara.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Ride the scenic routes'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Find destinations near each station, from the Nine Arch Bridge to Galle Fort, with walking times from the platform.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Verified announcements'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Get official schedule changes and save your favourite trains, stations and places for quick access.'**
  String get onboardingBody3;

  /// No description provided for @onboardingImageAlt1.
  ///
  /// In en, this message translates to:
  /// **'Blue train crossing the Nine Arch Bridge through misty forest'**
  String get onboardingImageAlt1;

  /// No description provided for @onboardingImageAlt2.
  ///
  /// In en, this message translates to:
  /// **'Hill-country railway station beside a misty pine forest'**
  String get onboardingImageAlt2;

  /// No description provided for @onboardingImageAlt3.
  ///
  /// In en, this message translates to:
  /// **'Passenger train curving through green tea country'**
  String get onboardingImageAlt3;

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStep(int current, int total);

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageTitle;

  /// No description provided for @languageTitleAlt.
  ///
  /// In en, this message translates to:
  /// **'ඔබේ භාෂාව තෝරන්න'**
  String get languageTitleAlt;

  /// No description provided for @languageBody.
  ///
  /// In en, this message translates to:
  /// **'Station names, timetables and announcements will appear in this language. Change it any time in Settings.'**
  String get languageBody;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageEnglishSub.
  ///
  /// In en, this message translates to:
  /// **'Recommended for international travellers'**
  String get languageEnglishSub;

  /// No description provided for @languageSinhala.
  ///
  /// In en, this message translates to:
  /// **'සිංහල'**
  String get languageSinhala;

  /// No description provided for @languageSinhalaSub.
  ///
  /// In en, this message translates to:
  /// **'Sinhala · ශ්‍රී ලාංකීය මගීන් සඳහා'**
  String get languageSinhalaSub;

  /// No description provided for @languageTamil.
  ///
  /// In en, this message translates to:
  /// **'தமிழ்'**
  String get languageTamil;

  /// No description provided for @languageTamilSub.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get languageTamilSub;

  /// No description provided for @languageTamilNote.
  ///
  /// In en, this message translates to:
  /// **'Tamil support is planned for a future release'**
  String get languageTamilNote;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get signInTitle;

  /// No description provided for @signInBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your saved trains, places and alerts.'**
  String get signInBody;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @signInDivider.
  ///
  /// In en, this message translates to:
  /// **'or sign in with username'**
  String get signInDivider;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get usernameOrEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @showHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Show or hide password'**
  String get showHidePassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @newToApp.
  ///
  /// In en, this message translates to:
  /// **'New to CeylonGO?'**
  String get newToApp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @errUsernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your username or email'**
  String get errUsernameOrEmail;

  /// No description provided for @errPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get errPassword;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signUpTitle;

  /// No description provided for @signUpBody.
  ///
  /// In en, this message translates to:
  /// **'Save trains and get verified railway alerts.'**
  String get signUpBody;

  /// No description provided for @signUpDivider.
  ///
  /// In en, this message translates to:
  /// **'or sign up with email'**
  String get signUpDivider;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of use and Privacy policy'**
  String get agreeTerms;

  /// No description provided for @errAgree.
  ///
  /// In en, this message translates to:
  /// **'Please accept to continue'**
  String get errAgree;

  /// No description provided for @errEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get errEmail;

  /// No description provided for @errUsername.
  ///
  /// In en, this message translates to:
  /// **'Use at least 3 characters'**
  String get errUsername;

  /// No description provided for @errPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get errPasswordLength;

  /// No description provided for @errPasswordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errPasswordMatch;

  /// No description provided for @pwTooShort.
  ///
  /// In en, this message translates to:
  /// **'Too short · use at least 8 characters'**
  String get pwTooShort;

  /// No description provided for @pwStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong password'**
  String get pwStrong;

  /// No description provided for @pwAddNumber.
  ///
  /// In en, this message translates to:
  /// **'Add a number to make it stronger'**
  String get pwAddNumber;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetTitle;

  /// No description provided for @resetBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your username or email, then choose a new password.'**
  String get resetBody;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @remembered.
  ///
  /// In en, this message translates to:
  /// **'Remembered it?'**
  String get remembered;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @passwordUpdatedBody.
  ///
  /// In en, this message translates to:
  /// **'You can now sign in with your new password.'**
  String get passwordUpdatedBody;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Ayubowan,'**
  String get greeting;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to next?'**
  String get homeTitle;

  /// No description provided for @findTrains.
  ///
  /// In en, this message translates to:
  /// **'Find trains'**
  String get findTrains;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @quickTrains.
  ///
  /// In en, this message translates to:
  /// **'Trains'**
  String get quickTrains;

  /// No description provided for @quickLines.
  ///
  /// In en, this message translates to:
  /// **'Lines'**
  String get quickLines;

  /// No description provided for @quickStations.
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get quickStations;

  /// No description provided for @quickExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get quickExplore;

  /// No description provided for @departingFrom.
  ///
  /// In en, this message translates to:
  /// **'Departing {station}'**
  String departingFrom(String station);

  /// No description provided for @platformShort.
  ///
  /// In en, this message translates to:
  /// **'Plat. {number}'**
  String platformShort(String number);

  /// No description provided for @travelDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Travel date: {date}'**
  String travelDateLabel(String date);

  /// No description provided for @planJourney.
  ///
  /// In en, this message translates to:
  /// **'Plan a journey'**
  String get planJourney;

  /// No description provided for @travelDate.
  ///
  /// In en, this message translates to:
  /// **'Travel date'**
  String get travelDate;

  /// No description provided for @departureTime.
  ///
  /// In en, this message translates to:
  /// **'Departure time'**
  String get departureTime;

  /// No description provided for @travelClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get travelClass;

  /// No description provided for @anyTime.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get anyTime;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @classAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get classAll;

  /// No description provided for @class1stObservation.
  ///
  /// In en, this message translates to:
  /// **'1st · Observation'**
  String get class1stObservation;

  /// No description provided for @class2nd.
  ///
  /// In en, this message translates to:
  /// **'2nd'**
  String get class2nd;

  /// No description provided for @class3rd.
  ///
  /// In en, this message translates to:
  /// **'3rd'**
  String get class3rd;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get pickDate;

  /// No description provided for @searchTrains.
  ///
  /// In en, this message translates to:
  /// **'Search trains'**
  String get searchTrains;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @departureStation.
  ///
  /// In en, this message translates to:
  /// **'Departure station'**
  String get departureStation;

  /// No description provided for @arrivalStation.
  ///
  /// In en, this message translates to:
  /// **'Arrival station'**
  String get arrivalStation;

  /// No description provided for @searchStationsHint.
  ///
  /// In en, this message translates to:
  /// **'Search stations by name or code'**
  String get searchStationsHint;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @nearestStation.
  ///
  /// In en, this message translates to:
  /// **'Nearest: {name} · {distance}'**
  String nearestStation(String name, String distance);

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @allStations.
  ///
  /// In en, this message translates to:
  /// **'All stations'**
  String get allStations;

  /// No description provided for @confirmStation.
  ///
  /// In en, this message translates to:
  /// **'Confirm station'**
  String get confirmStation;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @sortEarliest.
  ///
  /// In en, this message translates to:
  /// **'Earliest'**
  String get sortEarliest;

  /// No description provided for @sortFastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest'**
  String get sortFastest;

  /// No description provided for @sortScenic.
  ///
  /// In en, this message translates to:
  /// **'Most scenic'**
  String get sortScenic;

  /// No description provided for @sortObservation.
  ///
  /// In en, this message translates to:
  /// **'Observation'**
  String get sortObservation;

  /// No description provided for @trainsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 train} other{{count} trains}}'**
  String trainsCount(int count);

  /// No description provided for @dateAndCount.
  ///
  /// In en, this message translates to:
  /// **'{date} · {count}'**
  String dateAndCount(String date, String count);

  /// No description provided for @trainsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Trains'**
  String get trainsEyebrow;

  /// No description provided for @findAvailableTrains.
  ///
  /// In en, this message translates to:
  /// **'Find available trains'**
  String get findAvailableTrains;

  /// No description provided for @fromYourStation.
  ///
  /// In en, this message translates to:
  /// **'From · your station'**
  String get fromYourStation;

  /// No description provided for @toDestination.
  ///
  /// In en, this message translates to:
  /// **'To · destination'**
  String get toDestination;

  /// No description provided for @departed.
  ///
  /// In en, this message translates to:
  /// **'Departed'**
  String get departed;

  /// No description provided for @direct.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get direct;

  /// No description provided for @stopsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Direct} =1{1 stop} other{{count} stops}}'**
  String stopsCount(int count);

  /// No description provided for @nextDay.
  ///
  /// In en, this message translates to:
  /// **'+1 day'**
  String get nextDay;

  /// No description provided for @sameStationError.
  ///
  /// In en, this message translates to:
  /// **'Choose a destination different from your station.'**
  String get sameStationError;

  /// No description provided for @stillToDepart.
  ///
  /// In en, this message translates to:
  /// **'{count} still to depart today'**
  String stillToDepart(int count);

  /// No description provided for @saveTrain.
  ///
  /// In en, this message translates to:
  /// **'Save train'**
  String get saveTrain;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @majorStops.
  ///
  /// In en, this message translates to:
  /// **'Major stops'**
  String get majorStops;

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classes;

  /// No description provided for @stopTimeline.
  ///
  /// In en, this message translates to:
  /// **'Stop timeline'**
  String get stopTimeline;

  /// No description provided for @stopTimelineSub.
  ///
  /// In en, this message translates to:
  /// **'Every station with arrival times'**
  String get stopTimelineSub;

  /// No description provided for @routeMap.
  ///
  /// In en, this message translates to:
  /// **'Route map'**
  String get routeMap;

  /// No description provided for @classesFacilities.
  ///
  /// In en, this message translates to:
  /// **'Classes & facilities'**
  String get classesFacilities;

  /// No description provided for @scenicHighlights.
  ///
  /// In en, this message translates to:
  /// **'Scenic highlights'**
  String get scenicHighlights;

  /// No description provided for @allStops.
  ///
  /// In en, this message translates to:
  /// **'All stops'**
  String get allStops;

  /// No description provided for @touristStop.
  ///
  /// In en, this message translates to:
  /// **'Tourist stop'**
  String get touristStop;

  /// No description provided for @highestPoint.
  ///
  /// In en, this message translates to:
  /// **'Highest point'**
  String get highestPoint;

  /// No description provided for @terminus.
  ///
  /// In en, this message translates to:
  /// **'Terminus'**
  String get terminus;

  /// No description provided for @mapLayers.
  ///
  /// In en, this message translates to:
  /// **'Map layers'**
  String get mapLayers;

  /// No description provided for @scenicStretch.
  ///
  /// In en, this message translates to:
  /// **'Scenic stretch'**
  String get scenicStretch;

  /// No description provided for @journeyLower.
  ///
  /// In en, this message translates to:
  /// **'journey'**
  String get journeyLower;

  /// No description provided for @majorStopsLower.
  ///
  /// In en, this message translates to:
  /// **'major stops'**
  String get majorStopsLower;

  /// No description provided for @exploreStops.
  ///
  /// In en, this message translates to:
  /// **'Explore stops'**
  String get exploreStops;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOut;

  /// No description provided for @recenterMap.
  ///
  /// In en, this message translates to:
  /// **'Re-centre map'**
  String get recenterMap;

  /// No description provided for @mapAttribution.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get mapAttribution;

  /// No description provided for @mapLabel.
  ///
  /// In en, this message translates to:
  /// **'Map of Sri Lanka'**
  String get mapLabel;

  /// No description provided for @onThisTrain.
  ///
  /// In en, this message translates to:
  /// **'On this train'**
  String get onThisTrain;

  /// No description provided for @notOnThisTrain.
  ///
  /// In en, this message translates to:
  /// **'Not on this train'**
  String get notOnThisTrain;

  /// No description provided for @facilitiesOnBoard.
  ///
  /// In en, this message translates to:
  /// **'Facilities on board'**
  String get facilitiesOnBoard;

  /// No description provided for @findTrainsWithClasses.
  ///
  /// In en, this message translates to:
  /// **'Find trains with these classes'**
  String get findTrainsWithClasses;

  /// No description provided for @facilityFood.
  ///
  /// In en, this message translates to:
  /// **'Food vendors'**
  String get facilityFood;

  /// No description provided for @facilityToilets.
  ///
  /// In en, this message translates to:
  /// **'Toilets'**
  String get facilityToilets;

  /// No description provided for @facilityLuggage.
  ///
  /// In en, this message translates to:
  /// **'Luggage racks'**
  String get facilityLuggage;

  /// No description provided for @facilityCharging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get facilityCharging;

  /// No description provided for @facilityStepFree.
  ///
  /// In en, this message translates to:
  /// **'Step-free'**
  String get facilityStepFree;

  /// No description provided for @facilityAirCon.
  ///
  /// In en, this message translates to:
  /// **'Air-con'**
  String get facilityAirCon;

  /// No description provided for @railwayLines.
  ///
  /// In en, this message translates to:
  /// **'Railway lines'**
  String get railwayLines;

  /// No description provided for @linesIntro.
  ///
  /// In en, this message translates to:
  /// **'Every line starts from the Colombo network. Tap a line for its stations and trains.'**
  String get linesIntro;

  /// No description provided for @saveLine.
  ///
  /// In en, this message translates to:
  /// **'Save line'**
  String get saveLine;

  /// No description provided for @lineLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get lineLength;

  /// No description provided for @firstSection.
  ///
  /// In en, this message translates to:
  /// **'First section'**
  String get firstSection;

  /// No description provided for @keyStations.
  ///
  /// In en, this message translates to:
  /// **'Key stations'**
  String get keyStations;

  /// No description provided for @trainsOnLine.
  ///
  /// In en, this message translates to:
  /// **'Trains on this line'**
  String get trainsOnLine;

  /// No description provided for @placesAlongLine.
  ///
  /// In en, this message translates to:
  /// **'Places along this line'**
  String get placesAlongLine;

  /// No description provided for @mostScenic.
  ///
  /// In en, this message translates to:
  /// **'Most scenic'**
  String get mostScenic;

  /// No description provided for @stationDirectory.
  ///
  /// In en, this message translates to:
  /// **'Station directory'**
  String get stationDirectory;

  /// No description provided for @searchByNameOrCode.
  ///
  /// In en, this message translates to:
  /// **'Search by name or code'**
  String get searchByNameOrCode;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterMain.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get filterMain;

  /// No description provided for @filterCoastal.
  ///
  /// In en, this message translates to:
  /// **'Coastal'**
  String get filterCoastal;

  /// No description provided for @filterNorthern.
  ///
  /// In en, this message translates to:
  /// **'Northern'**
  String get filterNorthern;

  /// No description provided for @filterTouristStops.
  ///
  /// In en, this message translates to:
  /// **'Tourist stops'**
  String get filterTouristStops;

  /// No description provided for @jumpToLetter.
  ///
  /// In en, this message translates to:
  /// **'Jump to {letter}'**
  String jumpToLetter(String letter);

  /// No description provided for @saveStation.
  ///
  /// In en, this message translates to:
  /// **'Save station'**
  String get saveStation;

  /// No description provided for @nextDepartures.
  ///
  /// In en, this message translates to:
  /// **'Next departures'**
  String get nextDepartures;

  /// No description provided for @toStation.
  ///
  /// In en, this message translates to:
  /// **'To {station}'**
  String toStation(String station);

  /// No description provided for @nearbyPlaces.
  ///
  /// In en, this message translates to:
  /// **'Nearby places'**
  String get nearbyPlaces;

  /// No description provided for @timetable.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get timetable;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @nearPlace.
  ///
  /// In en, this message translates to:
  /// **'Near {place}'**
  String nearPlace(String place);

  /// No description provided for @nearbyRailwayStations.
  ///
  /// In en, this message translates to:
  /// **'Nearby railway stations'**
  String get nearbyRailwayStations;

  /// No description provided for @exploreEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreEyebrow;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Places worth the journey'**
  String get exploreTitle;

  /// No description provided for @searchPlaces.
  ///
  /// In en, this message translates to:
  /// **'Search places'**
  String get searchPlaces;

  /// No description provided for @catHillCountry.
  ///
  /// In en, this message translates to:
  /// **'Hill country'**
  String get catHillCountry;

  /// No description provided for @catBeaches.
  ///
  /// In en, this message translates to:
  /// **'Beaches'**
  String get catBeaches;

  /// No description provided for @catHeritage.
  ///
  /// In en, this message translates to:
  /// **'Heritage'**
  String get catHeritage;

  /// No description provided for @catWildlife.
  ///
  /// In en, this message translates to:
  /// **'Wildlife'**
  String get catWildlife;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @planTrip.
  ///
  /// In en, this message translates to:
  /// **'Plan trip'**
  String get planTrip;

  /// No description provided for @easyByTrain.
  ///
  /// In en, this message translates to:
  /// **'Easy by train from Colombo'**
  String get easyByTrain;

  /// No description provided for @destinationCategories.
  ///
  /// In en, this message translates to:
  /// **'Destination categories'**
  String get destinationCategories;

  /// No description provided for @savePlace.
  ///
  /// In en, this message translates to:
  /// **'Save place'**
  String get savePlace;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @nearestStationLabel.
  ///
  /// In en, this message translates to:
  /// **'Nearest station'**
  String get nearestStationLabel;

  /// No description provided for @moreCount.
  ///
  /// In en, this message translates to:
  /// **'{count} more'**
  String moreCount(int count);

  /// No description provided for @trainsTo.
  ///
  /// In en, this message translates to:
  /// **'Trains to {station}'**
  String trainsTo(String station);

  /// No description provided for @galleryCount.
  ///
  /// In en, this message translates to:
  /// **'Gallery · {count, plural, =1{1 photo} other{{count} photos}}'**
  String galleryCount(int count);

  /// No description provided for @galleryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get galleryAll;

  /// No description provided for @galleryTrains.
  ///
  /// In en, this message translates to:
  /// **'Trains'**
  String get galleryTrains;

  /// No description provided for @galleryViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get galleryViews;

  /// No description provided for @galleryTravellers.
  ///
  /// In en, this message translates to:
  /// **'Travellers'**
  String get galleryTravellers;

  /// No description provided for @yourPhoto.
  ///
  /// In en, this message translates to:
  /// **'Your photo'**
  String get yourPhoto;

  /// No description provided for @addYourPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add your photo'**
  String get addYourPhoto;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your trains, routes and places in one spot'**
  String get savedSubtitle;

  /// No description provided for @statTrains.
  ///
  /// In en, this message translates to:
  /// **'Trains'**
  String get statTrains;

  /// No description provided for @statRoutes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get statRoutes;

  /// No description provided for @statStations.
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get statStations;

  /// No description provided for @statPlaces.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get statPlaces;

  /// No description provided for @savedTrains.
  ///
  /// In en, this message translates to:
  /// **'Saved trains'**
  String get savedTrains;

  /// No description provided for @savedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Saved places'**
  String get savedPlaces;

  /// No description provided for @nextDeparture.
  ///
  /// In en, this message translates to:
  /// **'Next departure'**
  String get nextDeparture;

  /// No description provided for @favoriteTrainsTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite trains & routes'**
  String get favoriteTrainsTitle;

  /// No description provided for @tabTrainsCount.
  ///
  /// In en, this message translates to:
  /// **'Trains · {count}'**
  String tabTrainsCount(int count);

  /// No description provided for @tabRoutesCount.
  ///
  /// In en, this message translates to:
  /// **'Routes · {count}'**
  String tabRoutesCount(int count);

  /// No description provided for @savedAlertsBody.
  ///
  /// In en, this message translates to:
  /// **'Get verified alerts when a saved train is delayed or rescheduled'**
  String get savedAlertsBody;

  /// No description provided for @alertsForSavedTrains.
  ///
  /// In en, this message translates to:
  /// **'Alerts for saved trains'**
  String get alertsForSavedTrains;

  /// No description provided for @favoriteDestinationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite destinations'**
  String get favoriteDestinationsTitle;

  /// No description provided for @gridView.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get gridView;

  /// No description provided for @allCount.
  ///
  /// In en, this message translates to:
  /// **'All · {count}'**
  String allCount(int count);

  /// No description provided for @catCoast.
  ///
  /// In en, this message translates to:
  /// **'Coast'**
  String get catCoast;

  /// No description provided for @planTripSaved.
  ///
  /// In en, this message translates to:
  /// **'Plan a trip to saved places'**
  String get planTripSaved;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettings;

  /// No description provided for @filterDelays.
  ///
  /// In en, this message translates to:
  /// **'Delays'**
  String get filterDelays;

  /// No description provided for @filterSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule changes'**
  String get filterSchedule;

  /// No description provided for @filterService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get filterService;

  /// No description provided for @verifiedSource.
  ///
  /// In en, this message translates to:
  /// **'Verified · Sri Lanka Railways'**
  String get verifiedSource;

  /// No description provided for @typeScheduleChange.
  ///
  /// In en, this message translates to:
  /// **'Schedule change'**
  String get typeScheduleChange;

  /// No description provided for @typeDelay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get typeDelay;

  /// No description provided for @typeService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get typeService;

  /// No description provided for @announcement.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get announcement;

  /// No description provided for @verifiedFromOfficial.
  ///
  /// In en, this message translates to:
  /// **'Verified from the Sri Lanka Railways official notice'**
  String get verifiedFromOfficial;

  /// No description provided for @detailDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get detailDates;

  /// No description provided for @detailSection.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get detailSection;

  /// No description provided for @detailAffectedTrains.
  ///
  /// In en, this message translates to:
  /// **'Affected trains'**
  String get detailAffectedTrains;

  /// No description provided for @detailExpectedDelay.
  ///
  /// In en, this message translates to:
  /// **'Expected delay'**
  String get detailExpectedDelay;

  /// No description provided for @viewOriginalNotice.
  ///
  /// In en, this message translates to:
  /// **'View original notice'**
  String get viewOriginalNotice;

  /// No description provided for @notifyMe.
  ///
  /// In en, this message translates to:
  /// **'Notify me'**
  String get notifyMe;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayNameLabel;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @photoPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the camera or gallery. Check the app\'s photo/camera permission.'**
  String get photoPickFailed;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @profileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your profile. Please try again.'**
  String get profileSaveFailed;

  /// No description provided for @profileSignInToEdit.
  ///
  /// In en, this message translates to:
  /// **'Sign in to edit your profile'**
  String get profileSignInToEdit;

  /// No description provided for @homeStationLabel.
  ///
  /// In en, this message translates to:
  /// **'Home station · {station}'**
  String homeStationLabel(String station);

  /// No description provided for @statSavedTrains.
  ///
  /// In en, this message translates to:
  /// **'Saved trains'**
  String get statSavedTrains;

  /// No description provided for @statSavedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Saved places'**
  String get statSavedPlaces;

  /// No description provided for @savedRowSub.
  ///
  /// In en, this message translates to:
  /// **'Trains, routes and places'**
  String get savedRowSub;

  /// No description provided for @unreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String unreadCount(int count);

  /// No description provided for @settingsRowSub.
  ///
  /// In en, this message translates to:
  /// **'Language, theme, notifications'**
  String get settingsRowSub;

  /// No description provided for @helpFeedback.
  ///
  /// In en, this message translates to:
  /// **'Help & feedback'**
  String get helpFeedback;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About CeylonGO'**
  String get aboutApp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @sectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get sectionPreferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsOnCount.
  ///
  /// In en, this message translates to:
  /// **'{count} on'**
  String notificationsOnCount(int count);

  /// No description provided for @sectionTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get sectionTravel;

  /// No description provided for @homeStation.
  ///
  /// In en, this message translates to:
  /// **'Home station'**
  String get homeStation;

  /// No description provided for @preferredClass.
  ///
  /// In en, this message translates to:
  /// **'Preferred class'**
  String get preferredClass;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get sectionData;

  /// No description provided for @offlineTimetables.
  ///
  /// In en, this message translates to:
  /// **'Offline timetables'**
  String get offlineTimetables;

  /// No description provided for @offlineTimetablesSub.
  ///
  /// In en, this message translates to:
  /// **'Keep saved trains available without signal'**
  String get offlineTimetablesSub;

  /// No description provided for @clearSearchHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear search history'**
  String get clearSearchHistory;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get sectionSupport;

  /// No description provided for @versionShort.
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String versionShort(String version);

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @sectionDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get sectionDisplay;

  /// No description provided for @bilingualNames.
  ///
  /// In en, this message translates to:
  /// **'Show station names in both languages'**
  String get bilingualNames;

  /// No description provided for @bilingualNamesSub.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ella · ඇල්ල'**
  String get bilingualNamesSub;

  /// No description provided for @translateAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Translate announcements'**
  String get translateAnnouncements;

  /// No description provided for @translateAnnouncementsSub.
  ///
  /// In en, this message translates to:
  /// **'Show official notices in your app language'**
  String get translateAnnouncementsSub;

  /// No description provided for @officialNamesNote.
  ///
  /// In en, this message translates to:
  /// **'Official station names follow Sri Lanka Railways signage.'**
  String get officialNamesNote;

  /// No description provided for @themeNote.
  ///
  /// In en, this message translates to:
  /// **'System follows your phone’s setting. Maps and route views always use the dark forest palette for contrast outdoors.'**
  String get themeNote;

  /// No description provided for @sectionComfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get sectionComfort;

  /// No description provided for @largerText.
  ///
  /// In en, this message translates to:
  /// **'Larger text'**
  String get largerText;

  /// No description provided for @largerTextSub.
  ///
  /// In en, this message translates to:
  /// **'Bigger timetable times and station names'**
  String get largerTextSub;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High-contrast mode'**
  String get highContrast;

  /// No description provided for @highContrastSub.
  ///
  /// In en, this message translates to:
  /// **'Stronger colours for bright platforms'**
  String get highContrastSub;

  /// No description provided for @sectionRailwayUpdates.
  ///
  /// In en, this message translates to:
  /// **'Railway updates'**
  String get sectionRailwayUpdates;

  /// No description provided for @notifyVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified announcements'**
  String get notifyVerified;

  /// No description provided for @notifyVerifiedSub.
  ///
  /// In en, this message translates to:
  /// **'Official notices from Sri Lanka Railways'**
  String get notifyVerifiedSub;

  /// No description provided for @notifyDelays.
  ///
  /// In en, this message translates to:
  /// **'Delays on saved trains'**
  String get notifyDelays;

  /// No description provided for @notifyDelaysSub.
  ///
  /// In en, this message translates to:
  /// **'Only for trains you’ve saved'**
  String get notifyDelaysSub;

  /// No description provided for @notifySchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule changes on saved lines'**
  String get notifySchedule;

  /// No description provided for @notifyScheduleSub.
  ///
  /// In en, this message translates to:
  /// **'Track work, cancellations, new services'**
  String get notifyScheduleSub;

  /// No description provided for @sectionTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get sectionTrips;

  /// No description provided for @notifyReminders.
  ///
  /// In en, this message translates to:
  /// **'Departure reminders'**
  String get notifyReminders;

  /// No description provided for @notifyRemindersSub.
  ///
  /// In en, this message translates to:
  /// **'15 minutes before a saved train leaves'**
  String get notifyRemindersSub;

  /// No description provided for @notifyInspiration.
  ///
  /// In en, this message translates to:
  /// **'Travel inspiration'**
  String get notifyInspiration;

  /// No description provided for @notifyInspirationSub.
  ///
  /// In en, this message translates to:
  /// **'New places to visit by train'**
  String get notifyInspirationSub;

  /// No description provided for @sectionQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours'**
  String get sectionQuietHours;

  /// No description provided for @quietHoursRange.
  ///
  /// In en, this message translates to:
  /// **'22:00 – 06:00'**
  String get quietHoursRange;

  /// No description provided for @quietHoursSub.
  ///
  /// In en, this message translates to:
  /// **'Urgent delays still come through'**
  String get quietHoursSub;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours'**
  String get quietHours;

  /// No description provided for @searchHelp.
  ///
  /// In en, this message translates to:
  /// **'Search help articles'**
  String get searchHelp;

  /// No description provided for @faq1Q.
  ///
  /// In en, this message translates to:
  /// **'How accurate are the timetables?'**
  String get faq1Q;

  /// No description provided for @faq1A.
  ///
  /// In en, this message translates to:
  /// **'Times are compiled from published timetables (seat61.com and traintimetable.lk), as the official online schedule is unavailable. Services can change, especially after the 2025 cyclone damage — check at the station before you travel. Changes appear under Announcements.'**
  String get faq1A;

  /// No description provided for @faq2Q.
  ///
  /// In en, this message translates to:
  /// **'Can I book tickets in CeylonGO?'**
  String get faq2Q;

  /// No description provided for @faq2A.
  ///
  /// In en, this message translates to:
  /// **'Not yet. Each train shows which classes can be reserved and where to book.'**
  String get faq2A;

  /// No description provided for @faq3Q.
  ///
  /// In en, this message translates to:
  /// **'Does the app work offline?'**
  String get faq3Q;

  /// No description provided for @faq3A.
  ///
  /// In en, this message translates to:
  /// **'Yes, saved trains and their stops stay available without signal.'**
  String get faq3A;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @rateStars.
  ///
  /// In en, this message translates to:
  /// **'Rate {count} out of 5'**
  String rateStars(int count);

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get yourMessage;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what to improve, or report a timetable error'**
  String get messageHint;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email us'**
  String get emailUs;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'CeylonGO helps locals and visitors find trains, understand routes and discover the places each station opens up — with announcements checked against official railway notices.'**
  String get aboutBody;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Timetable data source'**
  String get dataSource;

  /// No description provided for @dataSourceValue.
  ///
  /// In en, this message translates to:
  /// **'[OFFICIAL SOURCE]'**
  String get dataSourceValue;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate CeylonGO'**
  String get rateApp;

  /// No description provided for @notOfficial.
  ///
  /// In en, this message translates to:
  /// **'Not an official Sri Lanka Railways app · © 2026 CeylonGO'**
  String get notOfficial;

  /// No description provided for @loadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this'**
  String get loadErrorTitle;

  /// No description provided for @loadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get loadErrorBody;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @timetableSourceNote.
  ///
  /// In en, this message translates to:
  /// **'Times from {source}. Always check at the station.'**
  String timetableSourceNote(String source);

  /// No description provided for @photoCredit.
  ///
  /// In en, this message translates to:
  /// **'Photo: {credit}'**
  String photoCredit(String credit);

  /// No description provided for @signInToSave.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save trains, stations and places.'**
  String get signInToSave;

  /// No description provided for @savedToast.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedToast;

  /// No description provided for @removedToast.
  ///
  /// In en, this message translates to:
  /// **'Removed from saved'**
  String get removedToast;

  /// No description provided for @runsOn.
  ///
  /// In en, this message translates to:
  /// **'Runs {days}'**
  String runsOn(String days);

  /// No description provided for @nextDayShort.
  ///
  /// In en, this message translates to:
  /// **'+1 day'**
  String get nextDayShort;

  /// No description provided for @notRunningOnDate.
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t run on this day'**
  String get notRunningOnDate;

  /// No description provided for @stationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 station} other{{count} stations}}'**
  String stationsCount(int count);

  /// No description provided for @placesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 place} other{{count} places}}'**
  String placesCount(int count);

  /// No description provided for @approxKm.
  ///
  /// In en, this message translates to:
  /// **'≈{km} km'**
  String approxKm(String km);

  /// No description provided for @facilitiesNotListed.
  ///
  /// In en, this message translates to:
  /// **'Facilities for this station aren\'t listed yet.'**
  String get facilitiesNotListed;

  /// No description provided for @noDeparturesTitle.
  ///
  /// In en, this message translates to:
  /// **'No departures listed'**
  String get noDeparturesTitle;

  /// No description provided for @noDeparturesBody.
  ///
  /// In en, this message translates to:
  /// **'No trains in our timetable depart from this station.'**
  String get noDeparturesBody;

  /// No description provided for @checkEmailConfirm.
  ///
  /// In en, this message translates to:
  /// **'Account created. Check your email to confirm it, then sign in.'**
  String get checkEmailConfirm;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for {email}, a reset link is on its way.'**
  String resetLinkSent(String email);

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @signInForSaved.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep your saved trains and places on every device.'**
  String get signInForSaved;

  /// No description provided for @classesNotListed.
  ///
  /// In en, this message translates to:
  /// **'Seat classes aren\'t listed for this train.'**
  String get classesNotListed;

  /// No description provided for @reservedSeats.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get reservedSeats;

  /// No description provided for @unreservedSeats.
  ///
  /// In en, this message translates to:
  /// **'Unreserved'**
  String get unreservedSeats;

  /// No description provided for @noStationsMatch.
  ///
  /// In en, this message translates to:
  /// **'No stations match your search'**
  String get noStationsMatch;

  /// No description provided for @enterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password.'**
  String get enterEmailPassword;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match.'**
  String get passwordsDontMatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @trainNumber.
  ///
  /// In en, this message translates to:
  /// **'Train #{number}'**
  String trainNumber(String number);

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on map'**
  String get viewOnMap;

  /// No description provided for @dataSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Data and photos'**
  String get dataSourceTitle;

  /// No description provided for @dataSourceBody.
  ///
  /// In en, this message translates to:
  /// **'Timetables: seat61.com (updated 10 June 2026), main stations only. Photos: Wikimedia Commons, credited on each photo. Station coordinates are approximate.'**
  String get dataSourceBody;

  /// No description provided for @destinationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 destination} other{{count} destinations}}'**
  String destinationsCount(int count);

  /// No description provided for @fromTo.
  ///
  /// In en, this message translates to:
  /// **'{from} → {to}'**
  String fromTo(String from, String to);

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Showing all stations — location isn\'t available.'**
  String get locationUnavailable;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @searchHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'Search history cleared'**
  String get searchHistoryCleared;

  /// No description provided for @feedbackSent.
  ///
  /// In en, this message translates to:
  /// **'Thanks — your feedback was sent.'**
  String get feedbackSent;

  /// No description provided for @feedbackEmpty.
  ///
  /// In en, this message translates to:
  /// **'Write a message first.'**
  String get feedbackEmpty;

  /// No description provided for @feedbackFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send feedback. Check your connection and try again.'**
  String get feedbackFailed;

  /// No description provided for @feedbackTooMany.
  ///
  /// In en, this message translates to:
  /// **'You\'ve sent a lot of feedback recently. Please try again in a little while.'**
  String get feedbackTooMany;

  /// No description provided for @authErrInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authErrInvalidCredentials;

  /// No description provided for @authErrEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email first. Check your inbox for the link.'**
  String get authErrEmailNotConfirmed;

  /// No description provided for @authErrAccountExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists. Try signing in instead.'**
  String get authErrAccountExists;

  /// No description provided for @authErrWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'That password is too easy to guess. Use a longer one that isn\'t common.'**
  String get authErrWeakPassword;

  /// No description provided for @authErrRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a few minutes and try again.'**
  String get authErrRateLimited;

  /// No description provided for @authErrInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authErrInvalidEmail;

  /// No description provided for @authErrSamePassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a password different from your current one.'**
  String get authErrSamePassword;

  /// No description provided for @authErrLinkExpired.
  ///
  /// In en, this message translates to:
  /// **'That sign-in link has expired. Please try again.'**
  String get authErrLinkExpired;

  /// No description provided for @authErrBlocked.
  ///
  /// In en, this message translates to:
  /// **'This account can\'t sign in right now.'**
  String get authErrBlocked;

  /// No description provided for @authErrOffline.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server. Check your internet connection and try again.'**
  String get authErrOffline;

  /// No description provided for @authErrGeneric.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign you in. Please try again.'**
  String get authErrGeneric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
