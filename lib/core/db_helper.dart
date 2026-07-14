import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/task_params.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/features/home/data/task_model.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper instance = DbHelper._();

  Database? myDb;

  static final String snoColumn = "s_no";
  static final String tableName = "tasks";
  static final String titleColumn = "title";
  static final String descColumn = "desc";
  static final String priorityColumn = "priority";
  static final String categoryColumn = "category";
  static final String notesColumn = "notes";
  static final String statusColumn = "status";
  static final String pinColumn = "pin";
  static final String startTimeColumn = "start_time";
  static final String endTimeColumn = "end_time";
  static final String dateColumn = "date";

  Future<Database> getDb() async {
    if (myDb != null) {
      return myDb!;
    } else {
      myDb = await openDb();
      return myDb!;
    }
  }

  Future<Database> openDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, "task.db");
    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        db.execute(
          "create table $tableName($snoColumn integer primary key autoincrement,$titleColumn text not null,$descColumn text not null,$priorityColumn text not null,$categoryColumn text not null,$notesColumn text not null,$dateColumn text not null,$startTimeColumn text not null,$endTimeColumn text not null,$statusColumn integer not null,$pinColumn integer not null )",
        );
      },
      version: 1,
    );
  }

  Future<int> addTask({required TaskParams params}) async {
    var db = await getDb();
    int id = await db.insert(tableName, {
      titleColumn: params.title,
      descColumn: params.desc,
      priorityColumn: params.priority,
      categoryColumn: params.category,
      notesColumn: params.notes,
      statusColumn: params.status,
      pinColumn: params.pin,
      startTimeColumn: params.startTime,
      endTimeColumn: params.endTime,
      dateColumn: params.date,
    });

    // print(id);

    return id;
  }

  Future<List<TaskModel>> fetchAllTasks() async {
    var db = await getDb();
    final DateTime now = DateTime.now();
    final today = now.toString().split(" ")[0];

    final response = await db.query(
      tableName,
      where: "$dateColumn=?",
      whereArgs: [today],
    );

    return response.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<int> fetchTodayTasks() async {
    var db = await getDb();
    final DateTime now = DateTime.now();
    final today = now.toString().split(" ")[0];
    final response = await db.query(
      tableName,
      where: "$dateColumn = ?",
      whereArgs: [today],
    );

    return response.length;
  }

  Future<int> fetchTodayPendingTasks() async {
    var db = await getDb();
    final DateTime now = DateTime.now();
    final today = now.toString().split(" ")[0];
    final response = await db.query(
      tableName,
      where: "$dateColumn=? and $statusColumn=?",
      whereArgs: [today, 0],
    );
    return response.length;
  }

  Future<int> fetchTodayCompletedTasks() async {
    var db = await getDb();
    final DateTime now = DateTime.now();
    final today = now.toString().split(" ")[0];
    final response = await db.query(
      tableName,
      where: "$dateColumn=? and $statusColumn=?",
      whereArgs: [today, 1],
    );

    return response.length;
  }

  Future<int> fetchOverDueTasks() async {
    var db = await getDb();
    final DateTime now = DateTime.now();
    final today = now.toString().split(" ")[0];
    final time = time24(TimeOfDay.now());

    final response = await db.query(
      tableName,
      where: "$dateColumn=? and $endTimeColumn<? and $statusColumn=?",
      whereArgs: [today, time, 0],
    );
    return response.length;
  }

  Future<bool> deleteTask({required int sno}) async {
    var db = await getDb();

    int rowsEffected = await db.delete(
      tableName,
      where: "$snoColumn=?",
      whereArgs: [sno],
    );

    return rowsEffected > 0;
  }

  Future<List<TaskModel>> fetchCategoryBasedTasks({
    required String category,
  }) async {
    var db = await getDb();
    final DateTime now = DateTime.now();
    final today = now.toString().split(" ")[0];

    final response = await db.query(
      tableName,
      where: "$categoryColumn=? and $dateColumn=?",
      whereArgs: [category, today],
    );

    return response.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<List<TaskModel>> fetchTasksByDate({required String date}) async {
    var db = await getDb();
    final response = await db.query(
      tableName,
      where: "$dateColumn=?",
      whereArgs: [date],
    );

    return response.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<bool> pinTask({required int sno, required int pin}) async {
    var db = await getDb();
    int rowsEffected = await db.update(
      tableName,
      {pinColumn: pin},
      where: "$snoColumn=?",
      whereArgs: [sno],
    );

    return rowsEffected > 0;
  }

  Future<List<TaskModel>> fetchPinnedTasks() async {
    var db = await getDb();

    final response = await db.query(
      tableName,
      where: "$pinColumn=?",
      whereArgs: [1],
    );

    return response.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<bool> markTaskComplete({required int sno}) async {
    var db = await getDb();
    int rowsEffected = await db.update(
      tableName,
      {statusColumn: 1},
      where: "$snoColumn=?",
      whereArgs: [sno],
    );

    return rowsEffected > 0;
  }

  Future<int> fetchPriorityTasks({required String priority}) async {
    var db = await getDb();
    final response = await db.query(
      tableName,
      where: "$priorityColumn=?",
      whereArgs: [priority],
    );
    return response.length;
  }
}
