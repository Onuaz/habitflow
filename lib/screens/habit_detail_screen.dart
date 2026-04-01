import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/habit.dart';
import 'add_habit_screen.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  int streak = 0;
  Map<String, bool> weekStatus = {};

  @override
  void initState() {
    super.initState();
    _loadStreak();
    _loadWeekStatus();
  }

  Future<void> _loadStreak() async {
    final s = await DatabaseHelper.instance.calculateStreak(widget.habit.id!);
    setState(() => streak = s as int);
  }

  Future<void> _loadWeekStatus() async {
    final status =
        await DatabaseHelper.instance.getLast7DaysStatus(widget.habit.id!);
    setState(() => weekStatus = status);
  }

  Future<void> _toggleDay(String date, bool completed) async {
    final db = await DatabaseHelper.instance.database;

    if (completed) {
      await db.delete(
        'habit_logs',
        where: 'habit_id = ? AND date = ?',
        whereArgs: [widget.habit.id, date],
      );
    } else {
      await db.insert('habit_logs', {
        'habit_id': widget.habit.id,
        'date': date,
        'completed': 1,
      });
    }

    await _loadWeekStatus();
    await _loadStreak();
  }

  void _editHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddHabitScreen(habit: widget.habit),
      ),
    ).then((_) {
      _loadStreak();
      _loadWeekStatus();
    });
  }

  Future<void> _deleteHabit() async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [widget.habit.id],
    );

    await db.delete(
      'habit_logs',
      where: 'habit_id = ?',
      whereArgs: [widget.habit.id],
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final sortedDates = weekStatus.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.title),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editHabit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteHabit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.habit.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Streak Display
            Text(
              "🔥 $streak‑day streak",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF43A047),
              ),
            ),

            const SizedBox(height: 24),

            // Weekly Tracker
            const Text(
              "This Week",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: sortedDates.map((date) {
                final completed = weekStatus[date] ?? false;
                final parsed = DateTime.parse(date);
                final dayLabel =
                    ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                        [parsed.weekday % 7];

                return GestureDetector(
                  onTap: () => _toggleDay(date, completed),
                  child: Column(
                    children: [
                      Text(dayLabel),
                      const SizedBox(height: 6),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: completed
                              ? const Color(0xFF43A047)
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
