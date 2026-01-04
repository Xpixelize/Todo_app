import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/Todoes.models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  static const String _dbName = 'notes.db';
  static const String _tableName = 'todos';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        createdAt TEXT
      )
    ''');
  }

  // INSERT
  Future<int> C(Todelist todo) async {
    final db = await database;
    return await db.insert(_tableName, todo.Todemap());
  }

  // READ
  Future<List<Todelist>> getTodos() async {
    final db = await database;
    final data = await db.query(_tableName);

    return data.map((e) => Todelist.fromMap(e)).toList();
  }

  // UPDATE
  Future<int> updateTodo(Todelist todo) async {
    final db = await database;
    return await db.update(
      _tableName,
      todo.Todemap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // DELETE
  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  } 
}
