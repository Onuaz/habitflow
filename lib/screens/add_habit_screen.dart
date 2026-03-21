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
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      titleController.text = widget.habit!.title;
      descController.text = widget.habit!.description;
    }
  }

  Future<void> _saveHabit() async {
    final db = await DatabaseHelper.instance.database;

    if (widget.habit == null) {
      await db.insert('habits', {
        'title': titleController.text,
        'description': descController.text,
        'created_at': DateTime.now().toIso8601String(),
      });
    } else {
      await db.update(
        'habits',
        {
          'title': titleController.text,
          'description': descController.text,
        },
        where: 'id = ?',
        whereArgs: [widget.habit!.id],
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? "Add Habit" : "Edit Habit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Habit Title"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveHabit,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
