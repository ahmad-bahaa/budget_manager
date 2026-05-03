// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مدير الميزانية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get remaining => 'المتبقي';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get dashboardTitle => 'الميزانية';

  @override
  String get addCategoryTitle => 'فئة جديدة';

  @override
  String get pickAColor => 'Pick a Color';

  @override
  String get editCategoryTitle => 'تعديل الفئة';

  @override
  String get addTransactionTitle => 'مصروف جديد';

  @override
  String get editTransactionTitle => 'تعديل العملية';

  @override
  String get allTransactionsTitle => 'كل العمليات';

  @override
  String get categoryNameLabel => 'اسم الفئة';

  @override
  String get monthlyLimitLabel => 'الحد الشهري';

  @override
  String get amountLabel => 'المبلغ';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get noteLabel => 'ملاحظة (اختياري)';

  @override
  String get dateLabel => 'التاريخ:';

  @override
  String get categoryBreakdownLabel => 'تفاصيل الفئات';

  @override
  String get transactionHistoryLabel => 'سجل العمليات';

  @override
  String get budgetLabel => 'الميزانية';

  @override
  String get spentLabel => 'المصروف';

  @override
  String get leftLabel => 'المتبقي';

  @override
  String get remainingLabel => 'المتبقي:';

  @override
  String get spentPrefix => 'المصروف:';

  @override
  String get addCategoryAction => 'إضافة فئة';

  @override
  String get createCategoryAction => 'إنشاء فئة';

  @override
  String get saveChangesAction => 'حفظ التغييرات';

  @override
  String get addTransactionAction => 'إضافة عملية';

  @override
  String get updateTransactionAction => 'تحديث العملية';

  @override
  String get chooseDateAction => 'اختر التاريخ';

  @override
  String get cancelAction => 'إلغاء';

  @override
  String get deleteAction => 'حذف';

  @override
  String get editAction => 'تعديل';

  @override
  String get categoryNameHint => 'مثلاً: البقالة';

  @override
  String get noTransactionsMessage => 'لا توجد عمليات.';

  @override
  String get noCategoriesMessage => 'لم يتم العثور على فئات.';

  @override
  String get noCategoriesWarning =>
      'لم يتم العثور على فئات. يرجى إضافة فئة أولاً.';

  @override
  String get setBudgetHint => 'حدد ميزانية لرؤية المخططات';

  @override
  String get expenseSubtitle => 'مصروف';

  @override
  String get deleteCategoryTitle => 'حذف الفئة؟';

  @override
  String get deleteCategoryMessage =>
      'سيؤدي هذا إلى حذف جميع العمليات في هذه الفئة.';

  @override
  String get deleteTransactionTitle => 'حذف العملية؟';

  @override
  String get deleteTransactionMessage => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get categoryCreatedMessage => 'تم إنشاء الفئة بنجاح';

  @override
  String get categoryUpdatedMessage => 'تم تحديث الفئة بنجاح';

  @override
  String get transactionAddedMessage => 'تمت إضافة العملية!';

  @override
  String get transactionUpdatedMessage => 'تم تحديث العملية!';

  @override
  String get transactionDeletedMessage => 'تم حذف العملية';

  @override
  String get enterNameError => 'يرجى إدخال اسم';

  @override
  String get enterLimitError => 'يرجى إدخال حد';

  @override
  String get enterAmountError => 'يرجى إدخال مبلغ';

  @override
  String get validNumberError => 'يرجى إدخال رقم صالح';

  @override
  String get selectCategoryError => 'يرجى اختيار فئة';

  @override
  String get budgetOverview => 'نظرة عامة على الميزانية';

  @override
  String get totalSpent => 'إجمالي المصروف';

  @override
  String get used => 'مستخدم';

  @override
  String get left => 'متبقي';

  @override
  String get localization => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get french => 'الفرنسية';

  @override
  String get spanish => 'الإسبانية';

  @override
  String get currencySymbol => 'رمز العملة';

  @override
  String currentValue(String value) {
    return 'الحالي: $value';
  }

  @override
  String get monthlyCycleStart => 'بداية الدورة الشهرية';

  @override
  String currentCycleDay(int day) {
    return 'اليوم الحالي: $day من الشهر';
  }

  @override
  String day(int day) {
    return 'يوم $day';
  }

  @override
  String get dateFormat => 'تنسيق التاريخ';

  @override
  String get appearance => 'المظهر';

  @override
  String get appTheme => 'سمة التطبيق';

  @override
  String get systemDefault => 'تلقائي حسب النظام';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get primaryColor => 'اللون الأساسي';

  @override
  String get tapToChangeStyle => 'اضغط لتغيير نمط التطبيق';

  @override
  String get dataManagement => 'إدارة البيانات';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get backupSubtitle => 'احفظ بياناتك في ملف';

  @override
  String get restoreData => 'استعادة البيانات';

  @override
  String get restoreSubtitle => 'استيراد البيانات من ملف نسخ احتياطي';

  @override
  String get restoreBackupTitle => 'استعادة النسخة الاحتياطية؟';

  @override
  String get restoreWarning =>
      '⚠️ تحذير: سيؤدي هذا إلى استبدال جميع البيانات الحالية على هذا الجهاز بملف النسخ الاحتياطي. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get restore => 'استعادة';

  @override
  String get developerInfo => 'معلومات المطور';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get settingsShowcaseDescription =>
      'اضغط لفتح الإعدادات وتغيير تفضيلاتك مثل الدورة الشهرية المخصصة والعملة';

  @override
  String get budgetShowcaseDescription =>
      'هنا لمتابعة إجمالي الميزانية التي تم تحديدها عند إضافة الفئات';

  @override
  String get expensesShowcaseDescription => 'اضغط هنا لمشاهدة جميع مصروفاتك';

  @override
  String get addCategoryShowcaseDescription => 'اضغط هنا لإضافة فئة جديدة';

  @override
  String errorLabel(String error) {
    return 'خطأ: $error';
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
  String get savingsGoals => 'أهداف الادخار';

  @override
  String get setFirstGoal => 'حدد هدفك الأول للادخار!';

  @override
  String get createGoal => 'إنشاء هدف';

  @override
  String get newGoal => 'هدف جديد';

  @override
  String get goalTitle => 'عنوان الهدف';

  @override
  String get targetAmount => 'المبلغ المستهدف';

  @override
  String get saveGoal => 'حفظ الهدف';

  @override
  String get addFunds => 'إضافة أموال';

  @override
  String get howMuchToAdd => 'كم تود أن تضيف؟';

  @override
  String get confirm => 'تأكيد';

  @override
  String fundsAddedMessage(String amount) {
    return 'رائع! أنت الآن أقرب بـ $amount من هدفك!';
  }

  @override
  String get macBookHint => 'مثلاً: ماك بوك جديد';

  @override
  String get cloudSync => 'مزامنة سحابية';

  @override
  String get cloudSyncSubtitle => 'زامن بياناتك مع جوجل درايف';

  @override
  String get signInWithGoogle => 'تسجيل الدخول بجوجل';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get syncNow => 'زامن الآن';

  @override
  String lastSynced(String time) {
    return 'آخر مزامنة: $time';
  }

  @override
  String get syncing => 'جاري المزامنة...';

  @override
  String get syncSuccess => 'تمت المزامنة بنجاح!';

  @override
  String syncError(String error) {
    return 'فشلت المزامنة: $error';
  }

  @override
  String get noInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get privacyDescription =>
      'يتم تخزين بياناتك في مجلد \'بيانات التطبيق\' الخاص بك على جوجل درايف، ولا يمكن لأحد الوصول إليه غير هذا التطبيق.';
}
