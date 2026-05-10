import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  DatabaseHelper();

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      if (kIsWeb) {
        // Add a timeout for web database initialization to avoid hanging forever
        _database = await _initDB('budget_tracker.db').timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception(
              'Database initialization timed out. Please ensure sqlite3.wasm is present in the web folder.',
            );
          },
        );
      } else {
        _database = await _initDB('budget_tracker.db');
      }
      return _database!;
    } catch (e) {
      debugPrint('Database Error: $e');
      rethrow;
    }
  }

  Future<Database> _initDB(String filePath) async {
    debugPrint('Initializing database at $filePath');
    if (kIsWeb) {
      debugPrint('Web environment detected, opening database...');
      return await openDatabase(
        filePath,
        version: 2,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
      );
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    debugPrint('Native environment, path: $path');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN is_recurring INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN recurrence_interval TEXT',
      );
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN last_processed_date TEXT',
      );
    }
  }

  // Enable foreign keys
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Create Categories Table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        monthly_limit REAL NOT NULL,
        color_hex TEXT NOT NULL,
        icon_code INTEGER NOT NULL
      )
    ''');

    // 2. Create Transactions Table
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        note TEXT,
        is_recurring INTEGER DEFAULT 0,
        recurrence_interval TEXT,
        last_processed_date TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    // Optional: Seed some initial categories for better UX
    await db.insert('categories', {
      'name': 'Food',
      'monthly_limit': 500.0,
      'color_hex': '0xFFFF5722',
      'icon_code': '57672',
    });
    await db.insert('categories', {
      'name': 'Rent',
      'monthly_limit': 1200.0,
      'color_hex': '0xFF3F51B5', // Indigo
      'icon_code': '57672',
    });
  }

  // ---------------------------------------------------------------------------
  // CRUD: Categories
  // ---------------------------------------------------------------------------

  // 1. Expose the database path getter
  Future<String> get dbPath async {
    if (kIsWeb) return 'budget_tracker.db';
    final dbPath = await getDatabasesPath();
    return join(
      dbPath,
      'budget_tracker.db',
    ); // Ensure this matches your existing initDB filename
  }

  // 2. method to close connection (Critical for Restore)
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null; // Reset the singleton
  }

  Future<int> createCategory(CategoryModel category) async {
    final db = await instance.database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await instance.database;
    final result = await db.query('categories', orderBy: 'name ASC');
    return result.map((json) => CategoryModel.fromMap(json)).toList();
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return CategoryModel.fromMap(result.first);
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // CRUD: Transactions
  // ---------------------------------------------------------------------------

  Future<int> createTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  /// Get all transactions sorted by date (newest first)
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await instance.database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  // /// Get transactions for a specific month
  // /// [month] should be DateTime(year, month)
  // Future<List<TransactionModel>> getTransactionsByMonth(DateTime month) async {
  //   final db = await instance.database;
  //
  //   // Construct start and end dates for the query
  //   final startOfMonth = DateTime(month.year, month.month, 1);
  //   final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
  //
  //   final result = await db.query(
  //     'transactions',
  //     where: 'date BETWEEN ? AND ?',
  //     whereArgs: [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
  //     orderBy: 'date DESC',
  //   );
  //
  //   return result.map((json) => TransactionModel.fromMap(json)).toList();
  // }

  /// Get transactions for a specific Cycle
  /// [Dau] should be Start day
  Future<List<TransactionModel>> getTransactionsByCycle(
    int day,
    DateTime month,
  ) async {
    final db = await instance.database;

    // Construct start and end dates for the query

    final currentDay = DateTime.now().day;

    final startOfMonth = day > currentDay
        ? DateTime(month.year, month.month - 1, day)
        : DateTime(month.year, month.month, day);
    final endOfMonth = day > currentDay
        ? DateTime(month.year, month.month, day)
        : DateTime(month.year, month.month + 1, day);

    final result = await db.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
      orderBy: 'date DESC',
    );

    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  // /// Get transactions specific to a category
  // Future<List<TransactionModel>> getTransactionsByCategory(int categoryId) async {
  //   final db = await instance.database;
  //   final result = await db.query(
  //     'transactions',
  //     where: 'category_id = ?',
  //     whereArgs: [categoryId],
  //     orderBy: 'date DESC',
  //   );
  //   return result.map((json) => TransactionModel.fromMap(json)).toList();
  // }

  Future<List<TransactionModel>> getTransactionsByCategory(
    int categoryId,
    int startDay,
    DateTime month,
  ) async {
    final db = await instance.database;
    // Construct start and end dates for the query
    final currentDay = DateTime.now().day.toInt();
    final startOfMonth = startDay > currentDay
        ? DateTime(month.year, month.month - 1, startDay)
        : DateTime(month.year, month.month, startDay);
    final endOfMonth = startDay > currentDay
        ? DateTime(month.year, month.month, startDay - 1)
        : DateTime(month.year, month.month + 1, startDay - 1);

    final result = await db.query(
      'transactions',
      where: 'category_id = ? AND date BETWEEN ? AND ?',
      whereArgs: [
        categoryId,
        startOfMonth.toIso8601String(),
        endOfMonth.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );

    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  Future<List<TransactionModel>> getRecurringTransactions() async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'is_recurring = 1',
    );
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  // Example of a JOIN query if you need transaction + category name in one go
  // This returns a raw Map, not a strict TransactionModel
  Future<List<Map<String, dynamic>>> getTransactionsWithCategoryNames() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT t.id, t.amount, t.date, t.note, c.name as category_name, c.color_hex 
      FROM transactions t
      INNER JOIN categories c ON t.category_id = c.id
      ORDER BY t.date DESC
    ''');
  }

  // Inside DatabaseHelper class

  // Generic Update
  Future<int> update(String table, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  // Generic Delete
  Future<int> delete(String table, int id) async {
    final db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
