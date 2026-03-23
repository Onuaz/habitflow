import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../db/database_helper.dart';
import 'add_habit_screen.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  int streak = 0;

  @override
  void initState() {
    super.initState();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final db = DatabaseHelper.instance;
    final s = await db.calculateStreak(widget.habit.id!);
    setState(() {
      streak = s;
    });
  }

  Future<void> _markCompleted() async {
    final db = await DatabaseHelper.instance.database;

    await db.insert('habit_logs', {
      'habit_id': widget.habit.id,
      'date': DateTime.now().toIso8601String().substring(0, 10),
      'completed': 1,
    });

    _loadStreak();
  }

  Future<void> _deleteHabit() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('habits', where: 'id = ?', whereArgs: [widget.habit.id]);
    await db.delete('habit_logs', where: 'habit_id = ?', whereArgs: [widget.habit.id]);
    Navigator.pop(context);
  }

  void _editHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddHabitScreen(habit: widget.habit),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.habit.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.habit.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              "Current Streak: $streak days",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _markCompleted,
              child: const Text("Mark as Completed Today"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editHabit,
              child: const Text("Edit Habit"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteHabit,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete Habit"),
            ),
            ElevatedButton(
              onPressed: () async {
              final db = await DatabaseHelper.instance.database;

              await db.insert('habit_logs', {
                'habit_id': widget.habit.id,
                'date': DateTime.now().toIso8601String().substring(0, 10),
                'completed': 1,
              });

              _loadStreak();
              },
              child: const Text("Mark as Completed Today"),
            ),

            
          ],

        ),
      ),
    );
  }
}
