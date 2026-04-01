class Habit {
  int? id;
  String title;
  String description;
  int? manualStreak;

  Habit({
    this.id,
    required this.title,
    required this.description,
    this.manualStreak,
  });

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      manualStreak: map['manual_streak'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'manual_streak': manualStreak,
    };
  }
}
