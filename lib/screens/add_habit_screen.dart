import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  final Habit? habit;

  const AddHabitScreen({super.key, this.habit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final streakController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.habit != null) {
      titleController.text = widget.habit!.title;
      descriptionController.text = widget.habit!.description;

      if (widget.habit!.manualStreak != null) {
        streakController.text = widget.habit!.manualStreak.toString();
      }
    }
  }

  Future<void> _saveHabit() async {
    final db = await DatabaseHelper.instance.database;

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final manualStreak = streakController.text.isEmpty
        ? null
        : int.parse(streakController.text);

    if (title.isEmpty) return;

    if (widget.habit == null) {
      await db.insert('habits', {
        'title': title,
        'description': description,
        'manual_streak': manualStreak,
      });
    } else {
      await db.update(
        'habits',
        {
          'title': title,
          'description': description,
          'manual_streak': manualStreak,
        },
        where: 'id = ?',
        whereArgs: [widget.habit!.id],
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Habit" : "Add Habit"),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Habit Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: streakController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Set Current Streak (optional)",
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveHabit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(isEditing ? "Save Changes" : "Add Habit"),
            ),
          ],
        ),
      ),
    );
  }
}
