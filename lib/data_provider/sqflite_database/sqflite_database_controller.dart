// ignore_for_file: depend_on_referenced_packages

import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/my_occupation_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_course_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_occupation_table.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfLiteControllerConstants {
  static const _databaseName = "OccuSearch.db";
  static const _databaseVersion = 3;
}

class SqfLiteController {
  static Database? _database;

  //Create Database
  static Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  //Initialize Database
  static initDatabase() async {
    //get the file path and store our database in our file storage system
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, SqfLiteControllerConstants._databaseName);
    printLog("Database path: $path");
    //Create table and define table structure
    return await openDatabase(path,
        version: SqfLiteControllerConstants._databaseVersion,
        onConfigure: onConfigureMethod,
        onCreate: onCreateTableMethod,
        onUpgrade: onUpdateTableMethod,
        onDowngrade: onDatabaseDowngradeDelete);
  }

  static Future onConfigureMethod(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  static Future onCreateTableMethod(Database db, int version) async {
    var batch = db.batch();

    //Create all the database tables here
    await ConfigTable.create(db);
    await MyOccupationTable.create(db);
    await RecentOccupationTable.create(db);
    await RecentCourseTable.create(db);
    await MyBookmarkTable.create(db);
    await batch.commit();
  }

  static createNewTableForV2(Database db) async {
    await RecentOccupationTable.create(db);
  }

  static createNewTableForV3(Database db) async {
    await RecentCourseTable.create(db);
    await MyBookmarkTable.create(db);
  }

  static Future onUpdateTableMethod(
      Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();
    // We update existing table and create the new tables
    printLog("Database current version: $oldVersion & new version: $newVersion");
    if (oldVersion != SqfLiteControllerConstants._databaseVersion) {
      createNewTableForV2(db);
      createNewTableForV3(db);
    }
    await batch.commit();
  }
}
