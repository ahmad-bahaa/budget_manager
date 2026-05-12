import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  static const String _groupId = 'group.com.ninjageeksco.budget_manager'; // For iOS App Groups
  static const String _androidWidgetName = 'BudgetWidgetProvider';

  static Future<void> updateWidget({
    required double remainingBudget,
    required String currency,
  }) async {
    try {
      debugPrint('Updating HomeWidget with remainingBudget: $remainingBudget');
      
      final budgetString = '$currency${remainingBudget.toStringAsFixed(2)}';

      await HomeWidget.saveWidgetData<String>('budget_value', budgetString);
      await HomeWidget.saveWidgetData<String>('currency', currency);

      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: 'BudgetWidget', // Name of the Widget in iOS
      );
    } catch (e) {
      debugPrint('Error updating HomeWidget: $e');
    }
  }

  static Future<void> init(Function(Uri?) onUriReceived) async {
    HomeWidget.setAppGroupId(_groupId);
    HomeWidget.initiallyLaunchedFromHomeWidget().then(onUriReceived);
    HomeWidget.widgetClicked.listen(onUriReceived);
  }
}
