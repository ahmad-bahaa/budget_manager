import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

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
  String get noCategoriesWarning => 'No se encontraron categorías. Por favor, añada una primero.';

  @override
  String get setBudgetHint => 'Establezca un presupuesto para ver los gráficos';

  @override
  String get expenseSubtitle => 'Gasto';

  @override
  String get deleteCategoryTitle => '¿Eliminar categoría?';

  @override
  String get deleteCategoryMessage => 'Esto eliminará todas las transacciones de esta categoría.';

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
  String currentValue(String value) => 'Actual: $value';

  @override
  String get monthlyCycleStart => 'Inicio del ciclo mensual';

  @override
  String currentCycleDay(int day) => 'Día actual: $day del mes';

  @override
  String day(int day) => 'Día $day';

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
  String get restoreWarning => '⚠️ Advertencia: Esto sobrescribirá todos los datos actuales. Esta acción es irreversible.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get restore => 'Restaurar';

  @override
  String get developerInfo => 'Información del desarrollador';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get settingsShowcaseDescription => 'Toca para abrir los ajustes y cambiar tus preferencias, como el ciclo mensual personalizado y la moneda';

  @override
  String get budgetShowcaseDescription => 'Aquí para realizar un seguimiento del presupuesto total que se ha establecido al añadir categorías';

  @override
  String get expensesShowcaseDescription => 'Haz clic aquí para ver todos tus gastos';

  @override
  String get addCategoryShowcaseDescription => 'Haz clic aquí para añadir una nueva categoría';

  @override
  String errorLabel(String error) => 'Error: $error';

  @override
  String percentFormat(String value) => '($value%)';

  @override
  String get savingsGoals => 'Objetivos de Ahorro';

  @override
  String get setFirstGoal => '¡Establece tu primer objetivo de ahorro!';

  @override
  String get createGoal => 'Crear Objetivo';

  @override
  String get newGoal => 'Nuevo Objetivo';

  @override
  String get goalTitle => 'Título del Objetivo';

  @override
  String get targetAmount => 'Cantidad Objetivo';

  @override
  String get saveGoal => 'Guardar Objetivo';

  @override
  String get addFunds => 'Añadir Fondos';

  @override
  String get howMuchToAdd => '¿Cuánto te gustaría añadir?';

  @override
  String get confirm => 'Confirmar';

  @override
  String fundsAddedMessage(String amount) => '¡Genial! ¡Estás $amount más cerca de tu objetivo!';

  @override
  String get macBookHint => 'ej. Nuevo MacBook';
}
