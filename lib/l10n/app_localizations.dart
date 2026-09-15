import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Eat Better'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Eat Better'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal nutrition mentor'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your meal and let us help you understand what you are eating.'**
  String get welcomeDescription;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @getToKnowYou.
  ///
  /// In en, this message translates to:
  /// **'Let’s get to know you'**
  String get getToKnowYou;

  /// No description provided for @personalizeNutritionPlan.
  ///
  /// In en, this message translates to:
  /// **'We’ll use this to personalize your nutrition plan.'**
  String get personalizeNutritionPlan;

  /// No description provided for @howOldAreYou.
  ///
  /// In en, this message translates to:
  /// **'How old are you?'**
  String get howOldAreYou;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @tellUsMore.
  ///
  /// In en, this message translates to:
  /// **'Tell us a little more'**
  String get tellUsMore;

  /// No description provided for @sexDescription.
  ///
  /// In en, this message translates to:
  /// **'We use this information to make your nutrition calculations more accurate.'**
  String get sexDescription;

  /// No description provided for @whatIsYourSex.
  ///
  /// In en, this message translates to:
  /// **'What is your sex?'**
  String get whatIsYourSex;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @tellUsAboutYourBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your body'**
  String get tellUsAboutYourBody;

  /// No description provided for @heightDescription.
  ///
  /// In en, this message translates to:
  /// **'Your height helps us personalize your nutrition plan.'**
  String get heightDescription;

  /// No description provided for @howTallAreYou.
  ///
  /// In en, this message translates to:
  /// **'How tall are you?'**
  String get howTallAreYou;

  /// No description provided for @heightUnit.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get heightUnit;

  /// No description provided for @weightDescription.
  ///
  /// In en, this message translates to:
  /// **'Your weight helps us personalize your nutrition plan.'**
  String get weightDescription;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'What is your current weight?'**
  String get currentWeight;

  /// No description provided for @weightUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get weightUnit;

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Your activity level'**
  String get activityLevel;

  /// No description provided for @activityDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the option that best describes your usual activity.'**
  String get activityDescription;

  /// No description provided for @notVeryActive.
  ///
  /// In en, this message translates to:
  /// **'Not very active'**
  String get notVeryActive;

  /// No description provided for @littleOrNoExercise.
  ///
  /// In en, this message translates to:
  /// **'Little or no exercise'**
  String get littleOrNoExercise;

  /// No description provided for @lightlyActive.
  ///
  /// In en, this message translates to:
  /// **'Lightly active'**
  String get lightlyActive;

  /// No description provided for @exerciseOneToThreeDays.
  ///
  /// In en, this message translates to:
  /// **'Exercise 1–3 days per week'**
  String get exerciseOneToThreeDays;

  /// No description provided for @moderatelyActive.
  ///
  /// In en, this message translates to:
  /// **'Moderately active'**
  String get moderatelyActive;

  /// No description provided for @exerciseThreeToFiveDays.
  ///
  /// In en, this message translates to:
  /// **'Exercise 3–5 days per week'**
  String get exerciseThreeToFiveDays;

  /// No description provided for @veryActive.
  ///
  /// In en, this message translates to:
  /// **'Very active'**
  String get veryActive;

  /// No description provided for @hardExerciseSixToSevenDays.
  ///
  /// In en, this message translates to:
  /// **'Hard exercise 6–7 days per week'**
  String get hardExerciseSixToSevenDays;

  /// No description provided for @extremelyActive.
  ///
  /// In en, this message translates to:
  /// **'Extremely active'**
  String get extremelyActive;

  /// No description provided for @veryHardTraining.
  ///
  /// In en, this message translates to:
  /// **'Very hard training or physical job'**
  String get veryHardTraining;
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
