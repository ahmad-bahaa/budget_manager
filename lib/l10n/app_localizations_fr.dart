// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Gestionnaire de budget';

  @override
  String get settings => 'Paramètres';

  @override
  String get addExpense => 'Ajouter une dépense';

  @override
  String get remaining => 'Restant';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get dashboardTitle => 'Budget';

  @override
  String get addCategoryTitle => 'Nouvelle catégorie';

  @override
  String get pickAColor => 'Choisir une couleur';

  @override
  String get editCategoryTitle => 'Modifier la catégorie';

  @override
  String get addTransactionTitle => 'Nouvelle dépense';

  @override
  String get editTransactionTitle => 'Modifier la transaction';

  @override
  String get allTransactionsTitle => 'Toutes les transactions';

  @override
  String get categoryNameLabel => 'Nom de la catégorie';

  @override
  String get monthlyLimitLabel => 'Limite mensuelle';

  @override
  String get amountLabel => 'Montant';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get noteLabel => 'Note (facultatif)';

  @override
  String get dateLabel => 'Date :';

  @override
  String get categoryBreakdownLabel => 'Répartition par catégorie';

  @override
  String get transactionHistoryLabel => 'Historique des transactions';

  @override
  String get budgetLabel => 'Budget';

  @override
  String get spentLabel => 'Dépensé';

  @override
  String get leftLabel => 'Restant';

  @override
  String get remainingLabel => 'Restant :';

  @override
  String get spentPrefix => 'Dépensé :';

  @override
  String get addCategoryAction => 'Ajouter une catégorie';

  @override
  String get createCategoryAction => 'Créer une catégorie';

  @override
  String get saveChangesAction => 'Enregistrer les modifications';

  @override
  String get addTransactionAction => 'Ajouter une transaction';

  @override
  String get updateTransactionAction => 'Mettre à jour la transaction';

  @override
  String get chooseDateAction => 'Choisir une date';

  @override
  String get cancelAction => 'ANNULER';

  @override
  String get deleteAction => 'SUPPRIMER';

  @override
  String get editAction => 'Modifier';

  @override
  String get categoryNameHint => 'ex: Courses';

  @override
  String get noTransactionsMessage => 'Aucune transaction.';

  @override
  String get noCategoriesMessage => 'Aucune catégorie trouvée.';

  @override
  String get noCategoriesWarning => 'Aucune catégorie trouvée. Veuillez d\'abord en ajouter une.';

  @override
  String get setBudgetHint => 'Définissez un budget pour voir les graphiques';

  @override
  String get expenseSubtitle => 'Dépense';

  @override
  String get deleteCategoryTitle => 'Supprimer la catégorie ?';

  @override
  String get deleteCategoryMessage => 'Cela supprimera toutes les transactions de cette catégorie.';

  @override
  String get deleteTransactionTitle => 'Supprimer la transaction ?';

  @override
  String get deleteTransactionMessage => 'Cette action ne peut pas être annulée.';

  @override
  String get categoryCreatedMessage => 'Catégorie créée avec succès';

  @override
  String get categoryUpdatedMessage => 'Catégorie mise à jour avec succès';

  @override
  String get transactionAddedMessage => 'Transaction ajoutée !';

  @override
  String get transactionUpdatedMessage => 'Transaction mise à jour !';

  @override
  String get transactionDeletedMessage => 'Transaction supprimée';

  @override
  String get enterNameError => 'Veuillez entrer un nom';

  @override
  String get enterLimitError => 'Veuillez entrer une limite';

  @override
  String get enterAmountError => 'Veuillez entrer un montant';

  @override
  String get validNumberError => 'Veuillez entrer un nombre valide';

  @override
  String get selectCategoryError => 'Veuillez sélectionner une catégorie';

  @override
  String get budgetOverview => 'Aperçu du budget';

  @override
  String get totalSpent => 'Total dépensé';

  @override
  String get used => 'utilisé';

  @override
  String get left => 'restant';

  @override
  String get localization => 'Localisation';

  @override
  String get english => 'Anglais';

  @override
  String get arabic => 'Arabe';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Espagnol';

  @override
  String get currencySymbol => 'Symbole de la devise';

  @override
  String currentValue(String value) {
    return 'Actuel : $value';
  }

  @override
  String get monthlyCycleStart => 'Début du cycle mensuel';

  @override
  String currentCycleDay(int day) {
    return 'Jour actuel : $day du mois';
  }

  @override
  String day(int day) {
    return 'Jour $day';
  }

  @override
  String get dateFormat => 'Format de date';

  @override
  String get appearance => 'Apparence';

  @override
  String get appTheme => 'Thème de l\'application';

  @override
  String get systemDefault => 'Défaut du système';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get primaryColor => 'Couleur primaire';

  @override
  String get tapToChangeStyle => 'Appuyez pour changer le style';

  @override
  String get dataManagement => 'Gestion des données';

  @override
  String get backupData => 'Sauvegarder les données';

  @override
  String get backupSubtitle => 'Enregistrer vos données dans un fichier';

  @override
  String get restoreData => 'Restaurer les données';

  @override
  String get restoreSubtitle => 'Importer des données depuis un fichier de sauvegarde';

  @override
  String get restoreBackupTitle => 'Restaurer la sauvegarde ?';

  @override
  String get restoreWarning => '⚠️ Avertissement : Cela écrasera toutes les données actuelles sur cet appareil. Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get restore => 'Restaurer';

  @override
  String get developerInfo => 'Infos développeur';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get settingsShowcaseDescription => 'Appuyez pour ouvrir les paramètres et modifier vos préférences telles que le cycle mensuel personnalisé et la devise';

  @override
  String get budgetShowcaseDescription => 'Ici pour suivre le budget total défini lors de l\'ajout de catégories';

  @override
  String get expensesShowcaseDescription => 'Cliquez ici pour voir toutes vos dépenses';

  @override
  String get addCategoryShowcaseDescription => 'Cliquez ici pour ajouter une nouvelle catégorie';

  @override
  String errorLabel(String error) {
    return 'Erreur : $error';
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
  String get selectImageSource => 'Sélectionner la source de l\'image';

  @override
  String get cameraSource => 'Appareil photo';

  @override
  String get gallerySource => 'Galerie';
}
