import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteHelper {
  static int dbVersion = 2;

  static final SqliteHelper _instance = SqliteHelper._constructor();
  late Database database;

  factory SqliteHelper() {
    return _instance;
  }

  SqliteHelper._constructor();

  static const String _databaseName = "grillin.db";

  static const String _categoryTableCreate =
      "CREATE TABLE categories (	categoryId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,	categoryName TEXT NOT NULL,	percentValue INTEGER,	addFromSavings NUMERIC)";

  static const String _ciclesTableCreate =
      "CREATE TABLE cicles (	cicleId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,	createdAt TEXT NOT NULL,	endedAt TEXT,	fixedIncome NUMERIC NOT NULL)";

  static const String _concpetsTableCreate =
      "CREATE TABLE concepts (	conceptId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,	conceptName TEXT NOT NULL,	createdAt TEXT,	categoryId INTEGER NOT NULL)";

  static const String _expensesTableCreate =
      "CREATE TABLE expenses (	expenseId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,	cicleId INTEGER NOT NULL,	categoryId INTEGER NOT NULL,	conceptId INTEGER NOT NULL,	amount NUMERIC NOT NULL,	createdAt TEXT)";

  static const String _insertDailyCategory =
      "INSERT INTO categories (categoryId,categoryName,percentValue,addFromSavings)	VALUES (0,'dailys',50,0);";
  static const String _insertPersonalsCategory =
      "INSERT INTO categories (categoryId,categoryName,percentValue,addFromSavings)	VALUES (1,'personals',30,0);";
  static const String _insertAchievementsCategory =
      "INSERT INTO categories (categoryId,categoryName,percentValue,addFromSavings)	VALUES (2,'achievements',20,0);";
  static const String _insertSavesCategory =
      "INSERT INTO categories (categoryId,categoryName,percentValue,addFromSavings)	VALUES (3,'saves',0,0);";
  static const String _insertTransfersConcept =
      "INSERT INTO concepts (conceptId,conceptName,createdAt,categoryId)	VALUES (0,'Transferencia de ahorros','2024-01-01 00:00:00.000',3);";
  static const String _insertCloseCicleConcept =
      "INSERT INTO concepts (conceptId,conceptName,createdAt,categoryId)	VALUES (1,'Cierre de ciclo','2024-01-01 00:00:00.000',3);";

  init() async {
    sqfliteFfiInit();
    final String databasesPath = await getDatabasesPath();
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}

    database = await openDatabase(
      _databaseName,
      version: 1,
      onCreate: (db, version) => _onCreate(db, version),
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute(_categoryTableCreate);
    await db.execute(_ciclesTableCreate);
    await db.execute(_concpetsTableCreate);
    await db.execute(_expensesTableCreate);
    await db.rawInsert(_insertDailyCategory);
    await db.rawInsert(_insertPersonalsCategory);
    await db.rawInsert(_insertAchievementsCategory);
    await db.rawInsert(_insertSavesCategory);
    await db.rawInsert(_insertTransfersConcept);
    await db.rawInsert(_insertCloseCicleConcept);
  }
}
