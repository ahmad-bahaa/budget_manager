import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/budget_analysis_model.dart';

class GeminiBudgetService {
  final String apiKey;

  GeminiBudgetService({required this.apiKey});

  Future<BudgetAnalysisModel?> analyzeBudget(
    Map<int, double> categoryBudgets,
  ) async {
    if (apiKey.isEmpty) return null;

    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );

    final budgetData = categoryBudgets.entries
        .map((e) => 'Category ID ${e.key}: ${e.value}')
        .join(', ');

    final prompt =
        '''
      I am a budget manager. Here is my current monthly distribution: $budgetData. 
      Analyze if this is optimal for a balanced 50/30/20 rule or general financial health. 
      Suggest a better distribution if needed. 
      You MUST return the response ONLY as a JSON object in this format: 
      {
        "analysis": "string",
        "suggestions": {
          "category_id": amount,
          ...
        }
      }
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        final Map<String, dynamic> jsonResponse = json.decode(response.text!);
        return BudgetAnalysisModel.fromJson(jsonResponse);
      }
    } catch (e) {
      print('Error calling Gemini: $e');
    }
    return null;
  }
}
