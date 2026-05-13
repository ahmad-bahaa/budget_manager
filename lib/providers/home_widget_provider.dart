import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/home_widget_service.dart';
import 'budget_providers.dart';

final homeWidgetSyncProvider = Provider<void>((ref) {
  final categoriesState = ref.watch(categoriesProvider);
  final transactionsState = ref.watch(transactionsProvider);
  final currency = ref.watch(currencyProvider);

  categoriesState.whenData((categories) {
    transactionsState.whenData((transactions) {
      final List<Map<String, dynamic>> categoriesData = [];

      for (var category in categories) {
        final spent = transactions
            .where((tx) => tx.categoryId == category.id)
            .fold(0.0, (sum, item) => sum + item.amount);
        
        final remaining = category.monthlyLimit - spent;
        
        categoriesData.add({
          'name': category.name,
          'remaining': '$currency${remaining.toStringAsFixed(0)}',
        });
      }

      // Sort by least remaining budget to show critical ones first
      // categoriesData.sort((a, b) => (double.tryParse(a['remaining'].substring(1)) ?? 0)
      //     .compareTo(double.tryParse(b['remaining'].substring(1)) ?? 0));

      HomeWidgetService.updateWidget(
        categoriesData: categoriesData,
      );
    });
  });
});
