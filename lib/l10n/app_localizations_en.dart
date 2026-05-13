// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Budget Manager';

  @override
  String get settings => 'Settings';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get remaining => 'Remaining';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get dashboardTitle => 'Budget';

  @override
  String get addCategoryTitle => 'New Category';

  @override
  String get pickAColor => 'Pick a Color';

  @override
  String get editCategoryTitle => 'Edit Category';

  @override
  String get addTransactionTitle => 'New Expense';

  @override
  String get editTransactionTitle => 'Edit Transaction';

  @override
  String get allTransactionsTitle => 'All Transactions';

  @override
  String get categoryNameLabel => 'Category Name';

  @override
  String get monthlyLimitLabel => 'Monthly Limit';

  @override
  String get amountLabel => 'Amount';

  @override
  String get categoryLabel => 'Category';

  @override
  String get noteLabel => 'Note (Optional)';

  @override
  String get dateLabel => 'Date:';

  @override
  String get categoryBreakdownLabel => 'Category Breakdown';

  @override
  String get transactionHistoryLabel => 'Transaction History';

  @override
  String get budgetLabel => 'Budget';

  @override
  String get spentLabel => 'Spent';

  @override
  String get leftLabel => 'Left';

  @override
  String get remainingLabel => 'Remaining:';

  @override
  String get spentPrefix => 'Spent:';

  @override
  String get addCategoryAction => 'Add Category';

  @override
  String get createCategoryAction => 'Create Category';

  @override
  String get saveChangesAction => 'Save Changes';

  @override
  String get addTransactionAction => 'Add Transaction';

  @override
  String get updateTransactionAction => 'Update Transaction';

  @override
  String get chooseDateAction => 'Choose Date';

  @override
  String get cancelAction => 'CANCEL';

  @override
  String get deleteAction => 'DELETE';

  @override
  String get editAction => 'Edit';

  @override
  String get categoryNameHint => 'e.g. Groceries';

  @override
  String get noTransactionsMessage => 'No transactions.';

  @override
  String get noCategoriesMessage => 'No categories found.';

  @override
  String get noCategoriesWarning => 'No categories found. Please add one first.';

  @override
  String get setBudgetHint => 'Set a budget to see charts';

  @override
  String get expenseSubtitle => 'Expense';

  @override
  String get deleteCategoryTitle => 'Delete Category?';

  @override
  String get deleteCategoryMessage => 'This will delete all transactions in this category.';

  @override
  String get deleteTransactionTitle => 'Delete Transaction?';

  @override
  String get deleteTransactionMessage => 'This action cannot be undone.';

  @override
  String get categoryCreatedMessage => 'Category created successfully';

  @override
  String get categoryUpdatedMessage => 'Category updated successfully';

  @override
  String get transactionAddedMessage => 'Transaction added!';

  @override
  String get transactionUpdatedMessage => 'Transaction updated!';

  @override
  String get transactionDeletedMessage => 'Transaction deleted';

  @override
  String get enterNameError => 'Please enter a name';

  @override
  String get enterLimitError => 'Please enter a limit';

  @override
  String get enterAmountError => 'Please enter an amount';

  @override
  String get validNumberError => 'Please enter a valid number';

  @override
  String get selectCategoryError => 'Please select a category';

  @override
  String get budgetOverview => 'Budget Overview';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get used => 'used';

  @override
  String get left => 'left';

  @override
  String get localization => 'Localization';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get french => 'French';

  @override
  String get spanish => 'Spanish';

  @override
  String get currencySymbol => 'Currency Symbol';

  @override
  String currentValue(String value) {
    return 'Current: $value';
  }

  @override
  String get monthlyCycleStart => 'Monthly Cycle Start';

  @override
  String currentCycleDay(int day) {
    return 'Current day: $day of the month';
  }

  @override
  String day(int day) {
    return 'Day $day';
  }

  @override
  String get dateFormat => 'Date Format';

  @override
  String get appearance => 'Appearance';

  @override
  String get appTheme => 'App Theme';

  @override
  String get systemDefault => 'System Default';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get primaryColor => 'Primary Color';

  @override
  String get tapToChangeStyle => 'Tap to change app style';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get backupData => 'Backup Data';

  @override
  String get backupSubtitle => 'Save your data to a file';

  @override
  String get restoreData => 'Restore Data';

  @override
  String get restoreSubtitle => 'Import data from a backup file';

  @override
  String get restoreBackupTitle => 'Restore Backup?';

  @override
  String get restoreWarning => '⚠️ Warning: This will overwrite all current data on this device with the backup file. This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get restore => 'Restore';

  @override
  String get developerInfo => 'Developer Info';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get settingsShowcaseDescription => 'Tap to open settings and change your preferences such as custom monthly cycle and Currency';

  @override
  String get budgetShowcaseDescription => 'Here to track total budget that has been set when you add categories';

  @override
  String get expensesShowcaseDescription => 'Click here to see all your Expenses';

  @override
  String get addCategoryShowcaseDescription => 'Click here to add a new category';

  @override
  String errorLabel(String error) {
    return 'Error: $error';
  }

  @override
  String percentFormat(String value) {
    return '($value%)';
  }

  @override
  String percentage(String value) {
    return '$value%';
  }

  @override
  String get savingsGoals => 'Savings Goals';

  @override
  String get setFirstGoal => 'Set your first savings goal!';

  @override
  String get createGoal => 'Create Goal';

  @override
  String get newGoal => 'New Goal';

  @override
  String get goalTitle => 'Goal Title';

  @override
  String get targetAmount => 'Target Amount';

  @override
  String get saveGoal => 'Save Goal';

  @override
  String get addFunds => 'Add Funds';

  @override
  String get howMuchToAdd => 'How much would you like to add?';

  @override
  String get confirm => 'Confirm';

  @override
  String fundsAddedMessage(String amount) {
    return 'Awesome! You are $amount closer to your goal!';
  }

  @override
  String get macBookHint => 'e.g. New MacBook';

  @override
  String get cloudSync => 'Cloud Sync';

  @override
  String get cloudSyncSubtitle => 'Sync your data with Google Database';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signOut => 'Sign Out';

  @override
  String get syncNow => 'Sync Now';

  @override
  String lastSynced(String time) {
    return 'Last Synced: $time';
  }

  @override
  String get syncing => 'Syncing...';

  @override
  String get syncSuccess => 'Sync completed successfully!';

  @override
  String syncError(String error) {
    return 'Sync failed: $error';
  }

  @override
  String get noInternet => 'No internet connection';

  @override
  String get privacyDescription => 'Your data is stored in A private Google Database, accessible only by this app.';

  @override
  String get selectImageSource => 'Select Image Source';

  @override
  String get cameraSource => 'Camera';

  @override
  String get gallerySource => 'Gallery';
}
