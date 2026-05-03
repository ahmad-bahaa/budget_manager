import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

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
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Manager'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get dashboardTitle;

  /// No description provided for @addCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get addCategoryTitle;

  /// No description provided for @pickAColor.
  ///
  /// In en, this message translates to:
  /// **'Pick a Color'**
  String get pickAColor;

  /// No description provided for @editCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategoryTitle;

  /// No description provided for @addTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'New Expense'**
  String get addTransactionTitle;

  /// No description provided for @editTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransactionTitle;

  /// No description provided for @allTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'All Transactions'**
  String get allTransactionsTitle;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryNameLabel;

  /// No description provided for @monthlyLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly Limit'**
  String get monthlyLimitLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (Optional)'**
  String get noteLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get dateLabel;

  /// No description provided for @categoryBreakdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Category Breakdown'**
  String get categoryBreakdownLabel;

  /// No description provided for @transactionHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistoryLabel;

  /// No description provided for @budgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetLabel;

  /// No description provided for @spentLabel.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spentLabel;

  /// No description provided for @leftLabel.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get leftLabel;

  /// No description provided for @remainingLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining:'**
  String get remainingLabel;

  /// No description provided for @spentPrefix.
  ///
  /// In en, this message translates to:
  /// **'Spent:'**
  String get spentPrefix;

  /// No description provided for @addCategoryAction.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategoryAction;

  /// No description provided for @createCategoryAction.
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get createCategoryAction;

  /// No description provided for @saveChangesAction.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesAction;

  /// No description provided for @addTransactionAction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransactionAction;

  /// No description provided for @updateTransactionAction.
  ///
  /// In en, this message translates to:
  /// **'Update Transaction'**
  String get updateTransactionAction;

  /// No description provided for @chooseDateAction.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get chooseDateAction;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancelAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteAction;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Groceries'**
  String get categoryNameHint;

  /// No description provided for @noTransactionsMessage.
  ///
  /// In en, this message translates to:
  /// **'No transactions.'**
  String get noTransactionsMessage;

  /// No description provided for @noCategoriesMessage.
  ///
  /// In en, this message translates to:
  /// **'No categories found.'**
  String get noCategoriesMessage;

  /// No description provided for @noCategoriesWarning.
  ///
  /// In en, this message translates to:
  /// **'No categories found. Please add one first.'**
  String get noCategoriesWarning;

  /// No description provided for @setBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'Set a budget to see charts'**
  String get setBudgetHint;

  /// No description provided for @expenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseSubtitle;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Category?'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all transactions in this category.'**
  String get deleteCategoryMessage;

  /// No description provided for @deleteTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction?'**
  String get deleteTransactionTitle;

  /// No description provided for @deleteTransactionMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteTransactionMessage;

  /// No description provided for @categoryCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Category created successfully'**
  String get categoryCreatedMessage;

  /// No description provided for @categoryUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get categoryUpdatedMessage;

  /// No description provided for @transactionAddedMessage.
  ///
  /// In en, this message translates to:
  /// **'Transaction added!'**
  String get transactionAddedMessage;

  /// No description provided for @transactionUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Transaction updated!'**
  String get transactionUpdatedMessage;

  /// No description provided for @transactionDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeletedMessage;

  /// No description provided for @enterNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get enterNameError;

  /// No description provided for @enterLimitError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a limit'**
  String get enterLimitError;

  /// No description provided for @enterAmountError.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get enterAmountError;

  /// No description provided for @validNumberError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get validNumberError;

  /// No description provided for @selectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategoryError;

  /// No description provided for @budgetOverview.
  ///
  /// In en, this message translates to:
  /// **'Budget Overview'**
  String get budgetOverview;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get used;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get left;

  /// No description provided for @localization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localization;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'Currency Symbol'**
  String get currencySymbol;

  /// No description provided for @currentValue.
  ///
  /// In en, this message translates to:
  /// **'Current: {value}'**
  String currentValue(String value);

  /// No description provided for @monthlyCycleStart.
  ///
  /// In en, this message translates to:
  /// **'Monthly Cycle Start'**
  String get monthlyCycleStart;

  /// No description provided for @currentCycleDay.
  ///
  /// In en, this message translates to:
  /// **'Current day: {day} of the month'**
  String currentCycleDay(int day);

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String day(int day);

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get dateFormat;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appTheme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get appTheme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @primaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColor;

  /// No description provided for @tapToChangeStyle.
  ///
  /// In en, this message translates to:
  /// **'Tap to change app style'**
  String get tapToChangeStyle;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @backupData.
  ///
  /// In en, this message translates to:
  /// **'Backup Data'**
  String get backupData;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save your data to a file'**
  String get backupSubtitle;

  /// No description provided for @restoreData.
  ///
  /// In en, this message translates to:
  /// **'Restore Data'**
  String get restoreData;

  /// No description provided for @restoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import data from a backup file'**
  String get restoreSubtitle;

  /// No description provided for @restoreBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup?'**
  String get restoreBackupTitle;

  /// No description provided for @restoreWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Warning: This will overwrite all current data on this device with the backup file. This action cannot be undone.'**
  String get restoreWarning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @developerInfo.
  ///
  /// In en, this message translates to:
  /// **'Developer Info'**
  String get developerInfo;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @settingsShowcaseDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap to open settings and change your preferences such as custom monthly cycle and Currency'**
  String get settingsShowcaseDescription;

  /// No description provided for @budgetShowcaseDescription.
  ///
  /// In en, this message translates to:
  /// **'Here to track total budget that has been set when you add categories'**
  String get budgetShowcaseDescription;

  /// No description provided for @expensesShowcaseDescription.
  ///
  /// In en, this message translates to:
  /// **'Click here to see all your Expenses'**
  String get expensesShowcaseDescription;

  /// No description provided for @addCategoryShowcaseDescription.
  ///
  /// In en, this message translates to:
  /// **'Click here to add a new category'**
  String get addCategoryShowcaseDescription;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorLabel(String error);

  /// No description provided for @percentFormat.
  ///
  /// In en, this message translates to:
  /// **'({value}%)'**
  String percentFormat(String value);

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percentage(String value);

  /// No description provided for @savingsGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get savingsGoals;

  /// No description provided for @setFirstGoal.
  ///
  /// In en, this message translates to:
  /// **'Set your first savings goal!'**
  String get setFirstGoal;

  /// No description provided for @createGoal.
  ///
  /// In en, this message translates to:
  /// **'Create Goal'**
  String get createGoal;

  /// No description provided for @newGoal.
  ///
  /// In en, this message translates to:
  /// **'New Goal'**
  String get newGoal;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal Title'**
  String get goalTitle;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target Amount'**
  String get targetAmount;

  /// No description provided for @saveGoal.
  ///
  /// In en, this message translates to:
  /// **'Save Goal'**
  String get saveGoal;

  /// No description provided for @addFunds.
  ///
  /// In en, this message translates to:
  /// **'Add Funds'**
  String get addFunds;

  /// No description provided for @howMuchToAdd.
  ///
  /// In en, this message translates to:
  /// **'How much would you like to add?'**
  String get howMuchToAdd;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @fundsAddedMessage.
  ///
  /// In en, this message translates to:
  /// **'Awesome! You are {amount} closer to your goal!'**
  String fundsAddedMessage(String amount);

  /// No description provided for @macBookHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. New MacBook'**
  String get macBookHint;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSync;

  /// No description provided for @cloudSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync your data with Google Drive'**
  String get cloudSyncSubtitle;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @lastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last Synced: {time}'**
  String lastSynced(String time);

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// No description provided for @syncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sync completed successfully!'**
  String get syncSuccess;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {error}'**
  String syncError(String error);

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @privacyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored in your private Google Drive \'App Data\' folder, accessible only by this app.'**
  String get privacyDescription;
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
      <String>['ar', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
