import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<bool> isCompletedToday(int habitId) async {
    final db = await database;
    String today = DateTime.now().toIso8601String().substring(0, 10);

    final logs = await db.query(
      'habit_logs',
      where: 'habit_id = ? AND date = ? AND completed = 1',
      whereArgs: [habitId, today],
    );

    return logs.isNotEmpty;
  }

  Future<Map<String, bool>> getLast7DaysStatus(int habitId) async {
    final db = await database;

    DateTime today = DateTime.now();
    Map<String, bool> result = {};

    for (int i = 0; i < 7; i++) {
      DateTime day = today.subtract(Duration(days: i));
      String dateString = day.toIso8601String().substring(0, 10);

      final logs = await db.query(
        'habit_logs',
        where: 'habit_id = ? AND date = ? AND completed = 1',
        whereArgs: [habitId, dateString],
      );

      result[dateString] = logs.isNotEmpty;
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getHabitLogs(int habitId) async {
    final db = await database;
    return await db.query(
      'habit_logs',
      where: 'habit_id = ? AND completed = 1',
      whereArgs: [habitId],
      orderBy: 'date DESC',
    );
  }

  Future<Object> calculateStreak(int habitId) async {
    final db = await database;

    // Check manual streak override
    final habit = await db.query(
      'habits',
      where: 'id = ?',
      whereArgs: [habitId],
    );

    final manual = habit.first['manual_streak'];
    if (manual != null) return manual;

    // Otherwise calculate normally
    final logs = await getHabitLogs(habitId);
    if (logs.isEmpty) return 0;

    int streak = 0;
    DateTime today = DateTime.now();
    DateTime currentDay = DateTime(today.year, today.month, today.day);

    for (var log in logs) {
      DateTime logDate = DateTime.parse(log['date']);

      if (logDate == currentDay) {
        streak++;
        currentDay = currentDay.subtract(const Duration(days: 1));
      } else if (logDate == currentDay.subtract(const Duration(days: 1))) {
        streak++;
        currentDay = currentDay.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'habits.db');

    return await openDatabase(
      path,
      version: 2, // bumped from 1 → 2
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE habits (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            manual_streak INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE habit_logs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            habit_id INTEGER,
            date TEXT,
            completed INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE habits ADD COLUMN manual_streak INTEGER',
          );
        }
      },
    );
  }
}
