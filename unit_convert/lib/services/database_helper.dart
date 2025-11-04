import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/conversion_history.dart';

class DatabaseHelper {
  static const _databaseName = 'unit_converter.db';
  static const _databaseVersion = 2;

  static const tableUsers = 'users';
  static const tableConversions = 'conversions';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableConversions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        input_value REAL NOT NULL,
        from_unit TEXT NOT NULL,
        to_unit TEXT NOT NULL,
        result REAL NOT NULL,
        timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES $tableUsers (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create conversions table
      await db.execute('''
        CREATE TABLE $tableConversions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          type TEXT NOT NULL,
          input_value REAL NOT NULL,
          from_unit TEXT NOT NULL,
          to_unit TEXT NOT NULL,
          result REAL NOT NULL,
          timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES $tableUsers (id) ON DELETE CASCADE
        )
      ''');
    }
  }

  // User operations
  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert(tableUsers, user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> isUsernameTaken(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      where: 'username = ?',
      whereArgs: [username],
    );
    return maps.isNotEmpty;
  }

  Future<List<User>> getAllUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableUsers);
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<int> updateUser(User user) async {
    Database db = await database;
    return await db.update(
      tableUsers,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      tableUsers,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Conversion operations
  Future<int> insertConversion(int userId, ConversionHistory conversion) async {
    Database db = await database;
    return await db.insert(tableConversions, {
      'user_id': userId,
      'type': conversion.type,
      'input_value': conversion.inputValue,
      'from_unit': conversion.fromUnit,
      'to_unit': conversion.toUnit,
      'result': conversion.result,
      'timestamp': conversion.timestamp.toIso8601String(),
    });
  }

  Future<List<ConversionHistory>> getConversionsByUser(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableConversions,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return ConversionHistory(
        type: maps[i]['type'],
        inputValue: maps[i]['input_value'],
        fromUnit: maps[i]['from_unit'],
        toUnit: maps[i]['to_unit'],
        result: maps[i]['result'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }

  Future<int> deleteConversionsByUser(int userId) async {
    Database db = await database;
    return await db.delete(
      tableConversions,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getConversionStats(int userId) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT type, COUNT(*) as count
      FROM $tableConversions
      WHERE user_id = ?
      GROUP BY type
      ORDER BY count DESC
    ''', [userId]);
  }

  Future<List<Map<String, dynamic>>> getAllConversionsWithUsers() async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT
        c.id as conversion_id,
        c.user_id,
        c.type,
        c.input_value,
        c.from_unit,
        c.to_unit,
        c.result,
        c.timestamp,
        u.username
      FROM $tableConversions c
      INNER JOIN $tableUsers u ON c.user_id = u.id
      ORDER BY c.timestamp DESC
    ''');
  }

  Future<Map<String, dynamic>> getConversionStatsByUser() async {
    Database db = await database;
    final results = await db.rawQuery('''
      SELECT
        u.username,
        COUNT(c.id) as total_conversions,
        GROUP_CONCAT(DISTINCT c.type) as conversion_types
      FROM $tableUsers u
      LEFT JOIN $tableConversions c ON u.id = c.user_id
      GROUP BY u.id, u.username
      ORDER BY total_conversions DESC
    ''');

    return {
      'userStats': results,
      'totalUsers': results.length,
      'totalConversions': results.fold<int>(0, (sum, user) => sum + (user['total_conversions'] as int)),
    };
  }

  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}