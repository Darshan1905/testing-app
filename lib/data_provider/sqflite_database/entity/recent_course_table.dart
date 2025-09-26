import 'package:occusearch/data_provider/sqflite_database/sqflite_database_controller.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:sqflite/sqflite.dart';

class RecentCourseTable {
  int? id;
  String? courseName;
  String? ascedCode;
  String? cricos;
  String? courseLevel;
  int? skillLevel;
  String? fullTimeFee;
  String? partTimeFee;
  String? courseDurationWeeks;
  int? timestamp;

  static String tableName = "RecentCourseTable";

  RecentCourseTable(
      {this.id,
      this.courseName,
      this.ascedCode,
      this.cricos,
      this.courseLevel,
      this.skillLevel = 0,
      this.fullTimeFee,
      this.partTimeFee,
      this.courseDurationWeeks,
      this.timestamp});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['courseName'] = courseName;
    map['ascedCode'] = ascedCode;
    map['cricos'] = cricos;
    map['courseLevel'] = courseLevel;
    map['skillLevel'] = skillLevel;
    map['fullTimeFee'] = fullTimeFee;
    map['partTimeFee'] = partTimeFee;
    map['courseDurationWeeks'] = courseDurationWeeks;
    map['timestamp'] = timestamp;
    return map;
  }

  RecentCourseTable.fromJson(dynamic json) {
    id = json["id"];
    courseName = json["courseName"];
    ascedCode = json["ascedCode"];
    cricos = json["cricos"];
    courseLevel = json["courseLevel"];
    skillLevel = json["skillLevel"];
    fullTimeFee = json["fullTimeFee"];
    partTimeFee = json["partTimeFee"];
    courseDurationWeeks = json["courseDurationWeeks"];
    timestamp = json["timestamp"];
  }

  //Create database table
  static create(Database? db) async {
    String query =
        "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, courseName TEXT NOT NULL, ascedCode TEXT NOT NULL, cricos TEXT NOT NULL,courseLevel TEXT NOT NULL, skillLevel INTEGER NOT NULL,fullTimeFee TEXT NOT NULL,partTimeFee TEXT NOT NULL,courseDurationWeeks TEXT NOT NULL,timestamp INTEGER NOT NULL)";
    await db?.execute(query);
  }

  //Get table from database
  static Future<RecentCourseTable?> read() async {
    Database? db = await SqfLiteController.database;
    String query = "SELECT * FROM $tableName";
    await db?.rawQuery(query);
    return null;
  }

  //Insert data into table
  static Future<int?> insert(
      {required RecentCourseTable recentCourseTable}) async {
    Database? db = await SqfLiteController.database;
    return await db?.insert(tableName, recentCourseTable.toJson());
  }

  //get data from table
  static Future<List<RecentCourseTable>> getAllList() async {
    Database? db = await SqfLiteController.database;
    List<Map<String, Object?>> listData = await db?.query(tableName) ?? [];
    List<RecentCourseTable> list = (listData)
        .map<RecentCourseTable>(
            (json) => RecentCourseTable.fromJson(json))
        .toList();
    return list;
  }

  //update data from table
  static Future<int?> updateRecentCourseTimeStamp(
      {required String strCricos,
      required int? timestamp}) async {
    Database? db = await SqfLiteController.database;
    return await db?.update(
        tableName, {'timestamp': timestamp},
        where: 'cricos = ?', whereArgs: [strCricos]);
  }

  //Delete particular occupation from table
  static Future<int?> deleteOccupation({required String strCricos}) async {
    Database? db = await SqfLiteController.database;
    String query = "$tableName WHERE cricos = $strCricos";
    return await db?.delete(query);
  }

  //Check that Recent-occupation exists or not in the table
  static Future<bool?> checkOccupationExists({required String strCricos}) async {
    Database? db = await SqfLiteController.database;
    String query =
        ("SELECT COUNT(cricos) AS CNT FROM $tableName WHERE cricos = '$strCricos'");

    try {
      int? count = Sqflite.firstIntValue(await db?.rawQuery(query) ?? []);
      if (count == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printLog("exception:::::::::: $e");
      return null;
    }
  }

  //Check that Recent-occupation exists or not in the table
  static Future<RecentCourseTable?> returnExistsData(
      {required String strCricos}) async {
    Database? db = await SqfLiteController.database;
    List<Map<String, Object?>> listData = await db
            ?.query(tableName, where: 'cricos = ?', whereArgs: [strCricos]) ??
        [];
    try {
      List<RecentCourseTable> list = (listData)
          .map<RecentCourseTable>(
              (json) => RecentCourseTable.fromJson(json))
          .toList();
      return list.first;
    } catch (e) {
      printLog("exception $e");
      return null;
    }
  }

  //Delete table data
  static Future<int?> deleteTable() async {
    Database? db = await SqfLiteController.database;
    return await db?.delete(tableName);
  }

}
