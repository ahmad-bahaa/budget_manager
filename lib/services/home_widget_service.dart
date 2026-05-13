import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  static const String _groupId = 'group.com.ninjageeksco.budget_manager'; // For iOS App Groups
  static const String _androidWidgetName = 'BudgetWidgetProvider';

  static Future<void> updateWidget({
    required List<Map<String, dynamic>> categoriesData,
  }) async {
    try {
      debugPrint('Updating HomeWidget with categories data');
      
      final String encodedData = jsonEncode(categoriesData);

      await HomeWidget.saveWidgetData<String>('categories_data', encodedData);

      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: 'BudgetWidget',
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
