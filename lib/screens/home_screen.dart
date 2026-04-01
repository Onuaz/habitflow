import 'package:flutter/material.dart';
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
    final data = await db.query('habits');

    setState(() {
      habits = data.map((e) => Habit.fromMap(e)).toList();
    });
  }

  Future<Object> _getStreak(int habitId) async {
    return await DatabaseHelper.instance.calculateStreak(habitId);
  }

  Future<bool> _completedToday(int habitId) async {
    return await DatabaseHelper.instance.isCompletedToday(habitId);
  }

  void _openAddHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddHabitScreen()),
    ).then((_) => _loadHabits());
  }

  void _openDetail(Habit habit) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: habit)),
    ).then((_) => _loadHabits());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HabitFlow"),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddHabit,
        backgroundColor: const Color(0xFF43A047),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];

          return FutureBuilder(
            future: Future.wait([
              _getStreak(habit.id!),
              _completedToday(habit.id!),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final streak = snapshot.data![0] as int;
              final completedToday = snapshot.data![1] as bool;

              return Card(
                color: const Color(0xFFF1F6FB),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  onTap: () => _openDetail(habit),
                  title: Text(
                    habit.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                  subtitle: Text(
                    "🔥 $streak‑day streak",
                    style: const TextStyle(
                      color: Color(0xFF43A047),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: completedToday
                          ? const Color(0xFF43A047)
                          : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
