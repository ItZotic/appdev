class SavingsGoal {
  SavingsGoal({
    required this.title,
    required this.target,
    required this.saved,
    required this.deadline,
  });

  final String title;
  final double target;
  double saved;
  final DateTime deadline;

  double get progress => target == 0 ? 0 : (saved / target).clamp(0, 1);
  double get remaining => (target - saved).clamp(0, target);
}
