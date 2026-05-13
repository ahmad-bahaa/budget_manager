import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/budget_analysis_model.dart';
import '../models/category_model.dart';

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

  Future<Map<String, dynamic>?> parseReceiptText(String ocrText,) async {
    if (apiKey.isEmpty || ocrText.isEmpty) return null;

    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );
    final prompt = '''
      Analyze this OCR text from a receipt 
      and extract the total amount, date, and a brief description of items bought.
      OCR Text:
      $ocrText
      
      Return ONLY a JSON object:
      {
        "amount": double,
        "date": "ISO8601 string or null",
        "description": "string"
      }
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        return json.decode(response.text!);
      }
    } catch (e) {
      print('Error calling Gemini for receipt parsing: $e');
    }
    return null;
  }

  Future<int?> suggestCategory(
    String note,
    List<CategoryModel> categories,
  ) async {
    if (apiKey.isEmpty || note.isEmpty) return null;

    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );

    final categoriesData = categories
        .map((c) => '{"id": ${c.id}, "name": "${c.name}"}')
        .join(', ');

    final prompt = '''
      Given the following transaction note: "$note", 
      and these available categories: [$categoriesData], 
      which category ID best fits this transaction?
      Return the response as a JSON object: {"category_id": id}
      If none fit well, return {"category_id": null}.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        final Map<String, dynamic> jsonResponse = json.decode(response.text!);
        return jsonResponse['category_id'] as int?;
      }
    } catch (e) {
      print('Error calling Gemini for category suggestion: $e');
    }
    return null;
  }
}
