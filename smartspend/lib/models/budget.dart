class BudgetCategory {
  BudgetCategory({
    required this.name,
    required this.limit,
    required this.spent,
  });

  final String name;
  final double limit;
  double spent;

  double get percentageUsed => limit == 0 ? 0 : (spent / limit).clamp(0, 1);
  double get remaining => (limit - spent).clamp(0, limit);
}
