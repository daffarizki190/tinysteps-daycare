import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/activity_model.dart';
import '../models/photo_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tinysteps.db');
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
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // Activities table
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL
      )
    ''');

    // Photos table
    await db.execute('''
      CREATE TABLE photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageUrl TEXT NOT NULL,
        caption TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        taggedActivity TEXT
      )
    ''');

    // Seed dummy activities
    await _seedDummyActivities(db);
  }

  Future<void> _seedDummyActivities(Database db) async {
    final List<Map<String, dynamic>> dummyActivities = [
      {'title': 'Morning Circle', 'body': 'Sang songs and learned about colors.'},
      {'title': 'Art & Craft', 'body': 'Painted with water colors.'},
      {'title': 'Lunch Time', 'body': 'Ate rice, chicken, and broccoli.'},
      {'title': 'Nap Time', 'body': 'Slept peacefully for 1.5 hours.'},
    ];
    for (var activity in dummyActivities) {
      await db.insert('activities', activity);
    }
  }

  // --- Users ---
  Future<int> registerUser(String name, String email, String password) async {
    final db = await instance.database;
    try {
      return await db.insert('users', {
        'name': name,
        'email': email,
        'password': password,
      });
    } catch (e) {
      // Email might already exist
      return -1;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await instance.database;
    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // --- Activities ---
  Future<List<ActivityModel>> getActivities() async {
    final db = await instance.database;
    final result = await db.query('activities', orderBy: 'id DESC', limit: 8);
    return result.map((json) => ActivityModel.fromJson(json)).toList();
  }

  // --- Photos ---
  Future<List<PhotoModel>> getPhotos() async {
    final db = await instance.database;
    final result = await db.query('photos', orderBy: 'timestamp DESC');
    return result.map((json) => PhotoModel.fromJson(json)).toList();
  }

  Future<int> addPhoto(PhotoModel photo) async {
    final db = await instance.database;
    final data = photo.toJson();
    data.remove('id'); // DB auto-generates ID
    return await db.insert('photos', data);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
