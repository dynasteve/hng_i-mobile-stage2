import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product.dart';
import '../models/user.dart'; // ✅ NEW

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  static const String tableProducts = 'products';
  static const String tableUsers = 'users'; // ✅ NEW

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('storekeeper.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, fileName);
    return await openDatabase(dbPath, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    // Products table
    await db.execute('''
      CREATE TABLE $tableProducts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        quantity INTEGER,
        price REAL,
        imagePath TEXT
      )
    ''');

    // ✅ Users table
    await db.execute('''
      CREATE TABLE $tableUsers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // ✅ Handle version upgrades (add new tables)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableUsers(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL
        )
      ''');
    }
  }

  // -------------------- PRODUCT CRUD --------------------
  Future<Product> createProduct(Product product) async {
    final db = await instance.database;
    final id = await db.insert(tableProducts, product.toMap());
    product.id = id;
    return product;
  }

  Future<List<Product>> readAllProducts() async {
    final db = await instance.database;
    final result = await db.query(tableProducts, orderBy: 'id DESC');
    return result.map((json) => Product.fromMap(json)).toList();
  }

  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return await db.update(tableProducts, product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(tableProducts, where: 'id = ?', whereArgs: [id]);
  }

  // -------------------- USER AUTH HELPERS --------------------
  Future<int> insertUser(User user) async {
    final db = await instance.database;
    return await db.insert(tableUsers, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> userExists(String email) async {
    final db = await instance.database;
    final res = await db.query(tableUsers, where: 'email = ?', whereArgs: [email]);
    return res.isNotEmpty;
  }

  Future<User?> getUser(String email, String password) async {
    final db = await instance.database;
    final res = await db.query(
      tableUsers,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
