import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';
import '../models/reservation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('laundry.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        roomNumber TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE reservations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId INTEGER NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        FOREIGN KEY (studentId) REFERENCES students (id)
      )
    ''');
  }

  Future<bool> hasWeeklyReservation(int studentId) async {
    final db = await database;
    final DateTime now = DateTime.now();
    final DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
    final DateTime weekEnd = weekStart.add(const Duration(days: 7));

    final List<Map<String, dynamic>> result = await db.query(
      'reservations',
      where: 'studentId = ? AND date BETWEEN ? AND ?',
      whereArgs: [
        studentId,
        weekStart.toIso8601String(),
        weekEnd.toIso8601String(),
      ],
    );

    return result.isNotEmpty;
  }

  Future<int> createReservation(Reservation reservation) async {
    final db = await database;
    return await db.insert('reservations', reservation.toMap());
  }

  Future<int> createStudent(Student student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }
}