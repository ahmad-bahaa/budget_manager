class BudgetCycleUtils {
  static Map<String, DateTime> getCycleBoundaries(int startDay) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    if (now.day >= startDay) {
      // We are in the cycle that started this month
      startDate = DateTime(now.year, now.month, startDay);
      // End is the day before the start day of the next month
      endDate = DateTime(
        now.year,
        now.month + 1,
        startDay,
      ).subtract(const Duration(seconds: 1));
    } else {
      // We are in the cycle that started last month
      startDate = DateTime(now.year, now.month - 1, startDay);
      endDate = DateTime(
        now.year,
        now.month,
        startDay,
      ).subtract(const Duration(seconds: 1));
    }

    return {'start': startDate, 'end': endDate};
  }
}
