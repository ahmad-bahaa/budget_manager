import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/home_widget_service.dart';
import 'budget_providers.dart';

final homeWidgetSyncProvider = Provider<void>((ref) {
  final totalBudget = ref.watch(totalBudgetProvider);
  final transactionsState = ref.watch(transactionsProvider);
  final currency = ref.watch(currencyProvider);

  transactionsState.whenData((transactions) {
    final totalSpent = transactions.fold(0.0, (sum, item) => sum + item.amount);
    final remaining = totalBudget - totalSpent;
    
    HomeWidgetService.updateWidget(
      remainingBudget: remaining,
      currency: currency,
    );
  });
});
