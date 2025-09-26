import 'package:occusearch/data_provider/sqflite_database/sqflite_database_controller.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:sqflite/sqflite.dart';

class MyOccupationTable {
  int? id;
  String? occuName;
  String? occuID;
  String? occuMainID;

  static String tableName = "MyOccupationTable";

  MyOccupationTable({this.id, this.occuName, this.occuID, this.occuMainID});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['occuName'] = occuName;
    map['occuID'] = occuID;
    map['occuMainID'] = occuMainID;
    return map;
  }

  MyOccupationTable.fromJson(dynamic json) {
    id = json["id"];
    occuName = json["occuName"];
    occuID = json["occuID"];
    occuMainID = json["occuMainID"];
  }

  //Create database table
  static create(Database? db) async {
    // Database? db = await SqfLiteController.shared.database;
    String query =
        "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, occuName TEXT NOT NULL, occuID TEXT NOT NULL, occuMainID TEXT NOT NULL)";
    await db?.execute(query);
  }

  //Get table from database
  static Future<MyOccupationTable?> read() async {
    Database? db = await SqfLiteController.database;
    String query = "SELECT * FROM $tableName";
    await db?.rawQuery(query);
    return null;
  }

  //Insert data into table
  static Future<int?> insert(
      {required MyOccupationTable myOccupationTable}) async {
    Database? db = await SqfLiteController.database;
    return await db?.insert(tableName, myOccupationTable.toJson());
  }

  //Insert Occupation list data into table
  static Future<int?> insertAllData(
      {required List<MyOccupationTable> myOccupationList}) async {
    Database? db = await SqfLiteController.database;
    Batch? batch = db?.batch();
    for (var val in myOccupationList) {
      batch?.insert(tableName, val.toJson());
    }
    await batch?.commit();
    return null;
  }

  //get data from table
  static Future<List<MyOccupationTable>> getAllList() async {
    Database? db = await SqfLiteController.database;
    List<Map<String, Object?>> listData = await db?.query(tableName) ?? [];
    List<MyOccupationTable> list = (listData)
        .map<MyOccupationTable>((json) => MyOccupationTable.fromJson(json))
        .toList();
    return list;
  }

  //Delete particular occupation from table
  static Future<int?> deleteOccupation({required String strOccID}) async {
    Database? db = await SqfLiteController.database;
    String query = "$tableName WHERE occuID = $strOccID";
    return await db?.delete(query);
  }

  //Check that occupation exists or not in the table
  static Future<int?> checkOccupationExists({required String strOccID}) async {
    Database? db = await SqfLiteController.database;
    String query =
        ("SELECT COUNT(occuID) AS CNT FROM $tableName WHERE occuID = $strOccID");
    int? count = Sqflite.firstIntValue(await db?.rawQuery(query) ?? []);
    printLog("Occupation Exists:: ${(count == 1) ? true : false}");
    return count;
  }

  //Delete table
  static Future<int?> deleteTable() async {
    Database? db = await SqfLiteController.database;
    return await db?.delete(tableName);
  }
}
