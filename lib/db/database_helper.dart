import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB('expense.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          amount REAL,
          type TEXT,
          date TEXT,
          category TEXT
        )
        ''');
      },
    );
  }

  Future<int> insert(TransactionModel t) async {
    final db = await instance.database;
    return db.insert('transactions', t.toMap());
  }

  Future<List<TransactionModel>> getAll() async {
    final db = await instance.database;
    final res = await db.query('transactions', orderBy: 'id DESC');
    return res.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<int> update(TransactionModel t) async {
    final db = await instance.database;
    return db.update('transactions', t.toMap(),
        where: 'id=?', whereArgs: [t.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete('transactions', where: 'id=?', whereArgs: [id]);
  }
}
