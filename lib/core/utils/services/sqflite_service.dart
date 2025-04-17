import 'dart:developer';

import '/core/utils/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class SqfliteService {
  Database? _db;

  Future<Database?> _getDb() async {
    return _db ??= await _initSqflite();
  }

  Future<Database> _initSqflite() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, "jumaa.db");

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Constants.adsAr} (
      id TEXT NOT NULL,
      link TEXT NOT NULL,
      status INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL)
      ''');

    await db.execute('''
      CREATE TABLE ${Constants.azkarAr} (
      title TEXT NOT NULL,
      content TEXT NOT NULL
      ) 
      ''');
    await db.execute('''
      CREATE TABLE ${Constants.azkarEn} (
      title TEXT NOT NULL,
      content TEXT NOT NULL
      )
      ''');

    log("database was created.");
  }

  Future<void> add(
      {required String table, required Map<String, Object?> values}) async {
    final db = await _getDb();
    await db!.insert(table, values);
  }

  Future<List<Map>> get(String table) async {
    final db = await _getDb();
    return await db!.query(table);
  }

  Future<void> delete(String table) async {
    final db = await _getDb();
    await db!.delete(table);
  }

  Future<void> close() async {
    final db = await _getDb();
    await db!.close();
  }
}
