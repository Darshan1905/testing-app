import 'package:occusearch/data_provider/sqflite_database/sqflite_database_controller.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:sqflite/sqflite.dart';

class MyBookmarkTable {
  int? id;
  String? name;
  String? code; // For OCCUPATION (occuId) & for COURSE (cricos)
  String? subCode; // For OCCUPATION (occuMainId) & for COURSE (ascedCode)
  String? type; // Enum Type (OCCUPATION, COURSE, JOBS)
  ///Currently below two variable are not in use
  String? subList; // For OCCUPATION () & for Course (studyLevel)
  int? skillLevel; //It is from 0-5, in which 0 means nothing

  static String tableName = "MyBookmarkTable";

  MyBookmarkTable(
      {this.id,
      this.name,
      this.code,
      this.subCode,
      this.subList,
      this.type,
      this.skillLevel = 0});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['subCode'] = subCode;
    map['subList'] = subList;
    map['type'] = type;
    map['skillLevel'] = skillLevel;
    return map;
  }

  MyBookmarkTable.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    code = json["code"];
    subCode = json["subCode"];
    subList = json["subList"];
    type = json["type"];
    skillLevel = 0;
    /*skillLevel = json["skillLevel"] == null || '${json["skillLevel"]}'.isEmpty
        ? 0
        : json["skillLevel"] as int;*/
  }

  //Create database table
  static create(Database? db) async {
    String query =
        "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, code TEXT NOT NULL, subCode TEXT NOT NULL, subList TEXT NOT NULL, type TEXT NOT NULL, skillLevel INTEGER NOT NULL)";
    await db?.execute(query);
  }

  //Insert data into table
  static Future<int?> insert({required MyBookmarkTable myBookmarkTable}) async {
    Database? db = await SqfLiteController.database;
    return await db?.insert(tableName, myBookmarkTable.toJson());
  }

  //Insert Occupation list data into table
  static Future<int?> insertAllData(
      {required List<MyBookmarkTable> myBookmarkList}) async {
    Database? db = await SqfLiteController.database;
    Batch? batch = db?.batch();
    for (var val in myBookmarkList) {
      batch?.insert(tableName, val.toJson());
    }
    await batch?.commit();
    return null;
  }

  //Delete particular occupation from table
  static Future<int?> deleteBookmarkById({required String bookmarkID}) async {
    Database? db = await SqfLiteController.database;
    String query = "$tableName WHERE code = '$bookmarkID'";
    return await db?.delete(query);
  }

  // TO GET BOOKMARK DATA BY TYPE [ENUM: OCCUPATION, COURSE AND JOB]
  static Future<List<MyBookmarkTable>?> getBookmarkDataByType(
      {required String bookmarkType}) async {
    Database? db = await SqfLiteController.database;
    List<Map<String, dynamic>>? result = await db
        ?.rawQuery('SELECT * FROM $tableName WHERE type=?', [bookmarkType]);
    if (result == null) {
      return null;
    } else {
      try {
        List<MyBookmarkTable> list = (result)
            .map<MyBookmarkTable>((json) => MyBookmarkTable.fromJson(json))
            .toList();
        return list;
      } catch (e) {
        printLog(e);
      }
    }
    return null;
  }

  //get all table
  static Future<List<MyBookmarkTable>> getAllBookmarkList() async {
    Database? db = await SqfLiteController.database;
    List<Map<String, Object?>> listData = await db?.query(tableName) ?? [];

    List<MyBookmarkTable> list = (listData)
        .map<MyBookmarkTable>((json) => MyBookmarkTable.fromJson(json))
        .toList();
    return list;
  }

  //Check that course exists or not in the table
  static Future<int?> checkBookmarkExists({required String bookmarkID}) async {
    Database? db = await SqfLiteController.database;
    String query =
        ("SELECT COUNT(code) AS CNT FROM $tableName WHERE code = '$bookmarkID'");
    int? count = Sqflite.firstIntValue(await db?.rawQuery(query) ?? []);
    return count;
  }

  //Delete table
  static Future<int?> deleteByType({required String type}) async {
    Database? db = await SqfLiteController.database;
    // return await db?.delete(table)
    return await db?.rawDelete('DELETE FROM $tableName WHERE type = ?', [type]);
  }

  //Delete table
  static Future<int?> deleteTable() async {
    Database? db = await SqfLiteController.database;
    return await db?.delete(tableName);
  }
}
