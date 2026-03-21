class HabitLog {
  final int? id;
  final int habitId;
  final String date;
  final int completed;

  HabitLog({
    this.id,
    required this.habitId,
    required this.date,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'date': date,
      'completed': completed,
    };
  }

  factory HabitLog.fromMap(Map<String, dynamic> map) {
    return HabitLog(
      id: map['id'],
      habitId: map['habit_id'],
      date: map['date'],
      completed: map['completed'],
    );
  }
}
