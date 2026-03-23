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


  Future<List<Map<String, dynamic>>> getHabitLogs(int habitId) async {
  final db = await database;
  return await db.query(
    'habit_logs',
    where: 'habit_id = ? AND completed = 1',
    whereArgs: [habitId],
    orderBy: 'date DESC',
  );
}

  Future<int> calculateStreak(int habitId) async {
  final logs = await getHabitLogs(habitId);

  if (logs.isEmpty) return 0;

  int streak = 0;
  DateTime today = DateTime.now();
  DateTime currentDay = DateTime(
    today.year,
    today.month,
    today.day,
  );

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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE habits(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            created_at TEXT
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
    );
  }
}
