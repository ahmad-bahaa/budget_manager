import 'dart:convert';
import 'package:budget_manager/services/shared_preferences.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/savings_goal_model.dart';

final savingsGoalsProvider =
    StateNotifierProvider<SavingsGoalNotifier, List<SavingsGoalModel>>((ref) {
      return SavingsGoalNotifier();
    });

class SavingsGoalNotifier extends StateNotifier<List<SavingsGoalModel>> {
  SavingsGoalNotifier() : super([]) {
    _loadGoals();
  }

  static const _storageKey = 'savings_goals';

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final String? goalsJson = prefs.getString(_storageKey);
    if (goalsJson != null) {
      try {
        final List<dynamic> decoded = json.decode(goalsJson);
        state = decoded.map((item) => SavingsGoalModel.fromMap(item)).toList();
      } catch (e) {
        state = [];
      }
    }
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(
      state.map((goal) => goal.toMap()).toList(),
    );
    await prefs.setString(_storageKey, encoded);
    await PreferencesService().updateLastUpdated();
  }

  void addGoal(SavingsGoalModel goal) {
    state = [...state, goal];
    _saveGoals();
  }

  void addFunds(String goalId, double amount) {
    state = [
      for (final goal in state)
        if (goal.id == goalId)
          goal.copyWith(
            savedAmount: (goal.savedAmount + amount).clamp(
              0,
              goal.targetAmount,
            ),
          )
        else
          goal,
    ];
    _saveGoals();
  }

  void deleteGoal(String goalId) {
    state = state.where((goal) => goal.id != goalId).toList();
    _saveGoals();
  }
}
