class BudgetAnalysisModel {
  final String analysis;
  final Map<int, double> suggestions;

  BudgetAnalysisModel({required this.analysis, required this.suggestions});

  factory BudgetAnalysisModel.fromJson(Map<String, dynamic> json) {
    final suggestionsMap = <int, double>{};
    if (json['suggestions'] != null) {
      (json['suggestions'] as Map<String, dynamic>).forEach((key, value) {
        final id = int.tryParse(key);
        if (id != null) {
          suggestionsMap[id] = (value as num).toDouble();
        }
      });
    }
    return BudgetAnalysisModel(
      analysis: json['analysis'] ?? '',
      suggestions: suggestionsMap,
    );
  }
}
