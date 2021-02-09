import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'habit.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "GoodHabit.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Habit ("
          "id INTEGER PRIMARY KEY,"
          "text TEXT,"
          "category TEXT"
          ")");
    });
  }

  newHabit(Habit newHabit) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Habit");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Habit (id,text,category)"
        " VALUES (?,?,?)",
        [id, newHabit.text, newHabit.categoryString]);
    return raw;
  }

  updateHabit(Habit newHabit) async {
    final db = await database;
    var res = await db.update("Habit", newHabit.toMap(),
        where: "id = ?", whereArgs: [newHabit.id]);
    return res;
  }

  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    var res = await db.query("Habit");
    List<Habit> list =
        res.isNotEmpty ? res.map((c) => Habit.fromMap(c)).toList() : [];
    return list;
  }

  deleteHabit(int id) async {
    final db = await database;
    return db.delete("Habit", where: "id = ?", whereArgs: [id]);
  }
}
