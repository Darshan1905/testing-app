import 'package:occusearch/data_provider/sqflite_database/sqflite_database_controller.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:sqflite/sqflite.dart';

class ConfigTable {
  int? id;
  String? fieldName;
  String? fieldValue;

  static String tableName = "ConfigTable";

  ConfigTable({this.id, this.fieldName, this.fieldValue});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['fieldName'] = fieldName;
    map['fieldValue'] = fieldValue;
    return map;
  }

  ConfigTable.fromJson(dynamic json) {
    id = json["id"];
    fieldName = json["fieldName"];
    fieldValue = json["fieldValue"];
  }

  //Create database table
  static create(Database? db) async {
    // Database? db = await SqfLiteController.shared.database;
    String query =
        "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, fieldName TEXT NOT NULL, fieldValue TEXT NOT NULL)";
    await db?.execute(query);
  }

  //Get table from database
  static Future<ConfigTable?> read({required String strField}) async {
    Database? db = await SqfLiteController.database;
    String query =
        "SELECT * FROM $tableName WHERE fieldName = '$strField' ORDER BY id DESC LIMIT 1";
    var data = await db?.rawQuery(query);
    if ((data?.length ?? 0) > 0) {
      return data
          ?.map<ConfigTable>((json) => ConfigTable.fromJson(json))
          .toList()
          .first;
    } else {
      printLog("config table data not found");
      return null;
    }
  }

  //Insert data into table
  static Future<int?> insertTable(Map<String, dynamic> configData) async {
    Database? db = await SqfLiteController.database;
    return await db?.insert(tableName, configData);
  }

  //Update table
  static Future<int?> update(
      {required String strFieldValue, required String strFieldName}) async {
    Database? db = await SqfLiteController.database;
    // String query = "update $tableName set fieldValue = '$strFieldValue' where fieldName = '$strFieldName'";
    // return await db?.rawUpdate(query);
    return await db?.update(tableName, {'fieldValue': strFieldValue},
        where: 'fieldName = ?', whereArgs: [strFieldName]);
  }

  //Delete particular data from table
  static Future<int?> deleteConfigData({required String strField}) async {
    Database? db = await SqfLiteController.database;
    return await db?.delete(
      tableName,
      where: 'fieldName = ?',
      whereArgs: [strField],
    );
  }

  //Delete table
  static Future<int?> deleteTable() async {
    Database? db = await SqfLiteController.database;
    // String query = "delete from $tableName";
    // return await db?.rawDelete(query);
    return await db?.delete(tableName);
  }
}
