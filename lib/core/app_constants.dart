class AppConstants {
  // App Titles
  static const String appName = 'Budget Manager';
  static const String dashboardTitle = 'Budget';

  // Screen Titles
  static const String addCategoryTitle = 'New Category';
  static const String editCategoryTitle = 'Edit Category';
  static const String addTransactionTitle = 'New Expense';
  static const String editTransactionTitle = 'Edit Transaction';
  static const String allTransactionsTitle = 'All Transactions';
  static const String settingsTitle = 'Settings';

  // Labels
  static const String categoryNameLabel = 'Category Name';
  static const String monthlyLimitLabel = 'Monthly Limit';
  static const String amountLabel = 'Amount';
  static const String categoryLabel = 'Category';
  static const String noteLabel = 'Note (Optional)';
  static const String dateLabel = 'Date:';
  static const String categoryBreakdownLabel = 'Category Breakdown';
  static const String transactionHistoryLabel = 'Transaction History';
  static const String budgetLabel = 'Budget';
  static const String spentLabel = 'Spent';
  static const String leftLabel = 'Left';
  static const String remainingLabel = 'Remaining:';
  static const String spentPrefix = 'Spent:';

  // Buttons & Actions
  static const String addCategoryAction = 'Add Category';
  static const String addExpenseAction = 'Add Expense';
  static const String createCategoryAction = 'Create Category';
  static const String saveChangesAction = 'Save Changes';
  static const String addTransactionAction = 'Add Transaction';
  static const String updateTransactionAction = 'Update Transaction';
  static const String chooseDateAction = 'Choose Date';
  static const String cancelAction = 'CANCEL';
  static const String deleteAction = 'DELETE';
  static const String editAction = 'Edit';

  // Placeholders & Hints
  static const String categoryNameHint = 'e.g. Groceries';
  static const String noTransactionsMessage = 'No transactions.';
  static const String noCategoriesMessage = 'No categories found.';
  static const String noCategoriesWarning = 'No categories found. Please add one first.';
  static const String setBudgetHint = 'Set a budget to see charts';
  static const String expenseSubtitle = 'Expense';

  // Dialogs & Messages
  static const String deleteCategoryTitle = 'Delete Category?';
  static const String deleteCategoryMessage = 'This will delete all transactions in this category.';
  static const String deleteTransactionTitle = 'Delete Transaction?';
  static const String deleteTransactionMessage = 'This action cannot be undone.';
  static const String categoryCreatedMessage = 'Category created successfully';
  static const String categoryUpdatedMessage = 'Category updated successfully';
  static const String transactionAddedMessage = 'Transaction added!';
  static const String transactionUpdatedMessage = 'Transaction updated!';
  static const String transactionDeletedMessage = 'Transaction deleted';

  // Validation
  static const String enterNameError = 'Please enter a name';
  static const String enterLimitError = 'Please enter a limit';
  static const String enterAmountError = 'Please enter an amount';
  static const String validNumberError = 'Please enter a valid number';
  static const String selectCategoryError = 'Please select a category';
}
