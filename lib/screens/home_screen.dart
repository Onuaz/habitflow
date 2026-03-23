import 'package:flutter/material.dart';
import 'package:habitflow/widgets/habit_card.dart';
import '../db/database_helper.dart';
import '../models/habit.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('habits');
    setState(() {
      habits = result.map((e) => Habit.fromMap(e)).toList();
    });
  }

  void _navigateToAddHabit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddHabitScreen()),
    );
    _loadHabits();
  }

  void _navigateToDetail(Habit habit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: habit)),
    );
    _loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HabitFlow")),
      body: habits.isEmpty
          ? const Center(child: Text("No habits yet. Add one!"))
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return HabitCard(
                  habit: habit,
                  onTap: () => _navigateToDetail(habit),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}

