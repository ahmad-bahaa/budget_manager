import 'package:budget_manager/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../l10n/app_localizations.dart';
import '../models/budget_analysis_model.dart';
import '../models/category_model.dart';
import '../providers/api_key_provider.dart';
import '../providers/budget_providers.dart';
import '../services/gemini_budget_service.dart';

class AIAdvisorScreen extends ConsumerStatefulWidget {
  const AIAdvisorScreen({super.key});

  @override
  ConsumerState<AIAdvisorScreen> createState() => _AIAdvisorScreenState();
}

class _AIAdvisorScreenState extends ConsumerState<AIAdvisorScreen> {
  bool _isLoading = true;
  BudgetAnalysisModel? _analysis;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAnalysis();
  }

  Future<void> _fetchAnalysis() async {
    final apiKey = ref.read(apiKeyProvider);
    if (apiKey.isEmpty) {
      setState(() {
        _error = 'Please set your Gemini API key in Settings first.';
        _isLoading = false;
      });
      return;
    }

    final categories = ref.read(categoriesProvider).value ?? [];
    if (categories.isEmpty) {
      setState(() {
        _error = 'Add some categories first to get an analysis.';
        _isLoading = false;
      });
      return;
    }

    final categoryBudgets = {
      for (var c in categories)
        if (c.id != null) c.id!: c.monthlyLimit,
    };

    try {
      final service = GeminiBudgetService(apiKey: apiKey);
      final result = await service.analyzeBudget(categoryBudgets);
      if (mounted) {
        setState(() {
          _analysis = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error =
              'Failed to fetch AI analysis. Please check your connection and API key.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = ref.read(apiKeyProvider);
    final l10n = AppLocalizations.of(context)!;
    final categories = ref.watch(categoriesProvider).value ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('AI Budget Advisor'), centerTitle: true),
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
          ? _buildErrorState(_error!, apiKey)
          : _buildAnalysisContent(categories, l10n, apiKey),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, String apiKey) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => apiKey.isEmpty
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsScreen()),
                    )
                  : Navigator.pop(context),
              child: Text(apiKey.isEmpty ? 'Set API Key' : 'Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisContent(
    List<CategoryModel> categories,
    AppLocalizations l10n,
    String apiKey,
  ) {
    if (_analysis == null)
      return _buildErrorState('Something went wrong.', apiKey);

    final currency = ref.watch(currencyProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 0,
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.psychology, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'AI Analysis',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _analysis!.analysis,
                          style: const TextStyle(fontSize: 15, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Proposed Changes',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final suggested =
                        _analysis!.suggestions[category.id] ??
                        category.monthlyLimit;
                    final isDifference =
                        (suggested - category.monthlyLimit).abs() > 0.01;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: category.color.withValues(
                              alpha: 0.2,
                            ),
                            child: Icon(
                              category.icon,
                              color: category.color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Current: $currency${category.monthlyLimit.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$currency${suggested.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDifference
                                      ? Colors.green[700]
                                      : null,
                                ),
                              ),
                              if (isDifference)
                                Text(
                                  'Suggested',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () => _applySuggestions(categories),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply Suggestions'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _applySuggestions(List<CategoryModel> categories) async {
    try {
      for (var category in categories) {
        final suggested = _analysis!.suggestions[category.id];
        if (suggested != null &&
            (suggested - category.monthlyLimit).abs() > 0.01) {
          await ref
              .read(categoriesProvider.notifier)
              .updateCategory(category.copyWith(monthlyLimit: suggested));
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Budget successfully optimized by AI!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to apply some suggestions. Please try again.',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
