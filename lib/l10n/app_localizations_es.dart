// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Gestor de Presupuesto';

  @override
  String get settings => 'Ajustes';

  @override
  String get addExpense => 'Añadir gasto';

  @override
  String get remaining => 'Restante';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get dashboardTitle => 'Presupuesto';

  @override
  String get addCategoryTitle => 'Nueva categoría';

  @override
  String get pickAColor => 'Elige un color';

  @override
  String get editCategoryTitle => 'Editar categoría';

  @override
  String get addTransactionTitle => 'Nuevo gasto';

  @override
  String get editTransactionTitle => 'Editar transacción';

  @override
  String get allTransactionsTitle => 'Todas las transacciones';

  @override
  String get categoryNameLabel => 'Nombre de la categoría';

  @override
  String get monthlyLimitLabel => 'Límite mensual';

  @override
  String get amountLabel => 'Cantidad';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get noteLabel => 'Nota (opcional)';

  @override
  String get dateLabel => 'Fecha:';

  @override
  String get categoryBreakdownLabel => 'Desglose por categoría';

  @override
  String get transactionHistoryLabel => 'Historial de transacciones';

  @override
  String get budgetLabel => 'Presupuesto';

  @override
  String get spentLabel => 'Gastado';

  @override
  String get leftLabel => 'Restante';

  @override
  String get remainingLabel => 'Restante:';

  @override
  String get spentPrefix => 'Gastado:';

  @override
  String get addCategoryAction => 'Añadir categoría';

  @override
  String get createCategoryAction => 'Crear categoría';

  @override
  String get saveChangesAction => 'Guardar cambios';

  @override
  String get addTransactionAction => 'Añadir transacción';

  @override
  String get updateTransactionAction => 'Actualizar transacción';

  @override
  String get chooseDateAction => 'Elegir fecha';

  @override
  String get cancelAction => 'CANCELAR';

  @override
  String get deleteAction => 'ELIMINAR';

  @override
  String get editAction => 'Editar';

  @override
  String get categoryNameHint => 'ej. Comestibles';

  @override
  String get noTransactionsMessage => 'No hay transacciones.';

  @override
  String get noCategoriesMessage => 'No se encontraron categorías.';

  @override
  String get noCategoriesWarning =>
      'No se encontraron categorías. Por favor, añada una primero.';

  @override
  String get setBudgetHint => 'Establezca un presupuesto para ver los gráficos';

  @override
  String get expenseSubtitle => 'Gasto';

  @override
  String get deleteCategoryTitle => '¿Eliminar categoría?';

  @override
  String get deleteCategoryMessage =>
      'Esto eliminará todas las transacciones de esta categoría.';

  @override
  String get deleteTransactionTitle => '¿Eliminar transacción?';

  @override
  String get deleteTransactionMessage => 'Esta acción no se puede deshacer.';

  @override
  String get categoryCreatedMessage => 'Categoría creada con éxito';

  @override
  String get categoryUpdatedMessage => 'Categoría actualizada con éxito';

  @override
  String get transactionAddedMessage => '¡Transacción añadida!';

  @override
  String get transactionUpdatedMessage => '¡Transacción actualizada!';

  @override
  String get transactionDeletedMessage => 'Transacción eliminada';

  @override
  String get enterNameError => 'Por favor, introduzca un nombre';

  @override
  String get enterLimitError => 'Por favor, introduzca un límite';

  @override
  String get enterAmountError => 'Por favor, introduzca una cantidad';

  @override
  String get validNumberError => 'Por favor, introduzca un número válido';

  @override
  String get selectCategoryError => 'Por favor, seleccione una categoría';

  @override
  String get budgetOverview => 'Resumen del presupuesto';

  @override
  String get totalSpent => 'Total gastado';

  @override
  String get used => 'usado';

  @override
  String get left => 'restante';

  @override
  String get localization => 'Localización';

  @override
  String get english => 'Inglés';

  @override
  String get arabic => 'Árabe';

  @override
  String get french => 'Francés';

  @override
  String get spanish => 'Español';

  @override
  String get currencySymbol => 'Símbolo de moneda';

  @override
  String currentValue(String value) {
    return 'Actual: $value';
  }

  @override
  String get monthlyCycleStart => 'Inicio del ciclo mensual';

  @override
  String currentCycleDay(int day) {
    return 'Día actual: $day del mes';
  }

  @override
  String day(int day) {
    return 'Día $day';
  }

  @override
  String get dateFormat => 'Formato de fecha';

  @override
  String get appearance => 'Apariencia';

  @override
  String get appTheme => 'Tema de la aplicación';

  @override
  String get systemDefault => 'Sistema predeterminado';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get primaryColor => 'Color primario';

  @override
  String get tapToChangeStyle => 'Toca para cambiar el estilo';

  @override
  String get dataManagement => 'Gestión de datos';

  @override
  String get backupData => 'Copia de seguridad';

  @override
  String get backupSubtitle => 'Guarde sus datos en un archivo';

  @override
  String get restoreData => 'Restaurar datos';

  @override
  String get restoreSubtitle => 'Importar datos desde un archivo';

  @override
  String get restoreBackupTitle => '¿Restaurar copia de seguridad?';

  @override
  String get restoreWarning =>
      '⚠️ Advertencia: Esto sobrescribirá todos los datos actuales. Esta acción es irreversible.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get restore => 'Restaurar';

  @override
  String get developerInfo => 'Información del desarrollador';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get settingsShowcaseDescription =>
      'Toca para abrir los ajustes y cambiar tus preferencias, como el ciclo mensual personalizado y la moneda';

  @override
  String get budgetShowcaseDescription =>
      'Aquí para realizar un seguimiento del presupuesto total que se ha establecido al añadir categorías';

  @override
  String get expensesShowcaseDescription =>
      'Haz clic aquí para ver todos tus gastos';

  @override
  String get addCategoryShowcaseDescription =>
      'Haz clic aquí para añadir una nueva categoría';

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
  String get cloudSyncSubtitle => 'Sync your data with Google Drive';

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
  String get privacyDescription =>
      'Your data is stored in your private Google Drive \'App Data\' folder, accessible only by this app.';
}
