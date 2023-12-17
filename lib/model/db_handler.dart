import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'task_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  //database creation
  initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    final database = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, desc TEXT NOT NULL, dateandtime TEXT NOT NULL )',
        );
      },
      version: 1,
    );
    return database;
  }

  //insert data into database
  Future<void> insertTask(Task task) async {
    // Get a reference to the database.
    final db = await _db;

    if (db != null) {
      await db.insert(
        'todo',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  //getting data from database
  Future<List<Task>> getDataList() async {
    final db = await this.db;

    if (db != null) {
      final List<Map<String, dynamic>> maps = await db.query('todo');
      return List.generate(maps.length, (i) {
        return Task(
          id: maps[i]['id'] as int,
          title: maps[i]['title'] as String,
          desc: maps[i]['desc'] as String,
          dateandtime: maps[i]['dateandtime'] as String,
        );
      });
    } else {
      return [];
    }
  }

  //update task function
  Future<void> updateTask(Task task) async {
    // Get a reference to the database.
    final db = await this.db;

    if (db != null) {
      await db.update(
        'todo',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    }
  }

  //delete task function
  Future<void> deleteTask(int id) async {
    // Get a reference to the database.
    final db = await this.db;

    if (db != null) {
      await db.delete(
        'todo',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}
