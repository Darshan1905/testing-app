import 'package:occusearch/data_provider/sqflite_database/sqflite_database_controller.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:sqflite/sqflite.dart';

class RecentOccupationTable {
  int? id;
  String? occuName;
  String? occuID;
  String? occuMainID;
  int? mostVisited;
  int? timestamp;
  int? skillLevel;

  static String tableName = "RecentOccupationTable";

  RecentOccupationTable(
      {this.id,
      this.occuName,
      this.occuID,
      this.occuMainID,
      this.mostVisited,
      this.timestamp,
      this.skillLevel});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['occuName'] = occuName;
    map['occuID'] = occuID;
    map['occuMainID'] = occuMainID;
    map['mostVisited'] = mostVisited;
    map['timestamp'] = timestamp;
    map['skillLevel'] = skillLevel;
    return map;
  }

  RecentOccupationTable.fromJson(dynamic json) {
    id = json["id"];
    occuName = json["occuName"];
    occuID = json["occuID"];
    occuMainID = json["occuMainID"];
    mostVisited = json["mostVisited"];
    timestamp = json["timestamp"];
    skillLevel = json["skillLevel"] ?? 0;
  }

  //Create database table
  static create(Database? db) async {
    String query =
        "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, occuName TEXT NOT NULL, occuID TEXT NOT NULL, occuMainID TEXT NOT NULL, mostVisited INTEGER NOT NULL, timestamp INTEGER NOT NULL,skillLevel INTEGER NOT NULL)";
    await db?.execute(query);
  }

  //Get table from database
  static Future<RecentOccupationTable?> read() async {
    Database? db = await SqfLiteController.database;
    String query = "SELECT * FROM $tableName";
    await db?.rawQuery(query);
    return null;
  }

  //Insert data into table
  static Future<int?> insert(
      {required RecentOccupationTable recentOccupationTable}) async {
    Database? db = await SqfLiteController.database;
    return await db?.insert(tableName, recentOccupationTable.toJson());
  }

  //get data from table
  static Future<List<RecentOccupationTable>> getAllList() async {
    Database? db = await SqfLiteController.database;
    List<Map<String, Object?>> listData = await db?.query(tableName) ?? [];
    List<RecentOccupationTable> list = (listData)
        .map<RecentOccupationTable>(
            (json) => RecentOccupationTable.fromJson(json))
        .toList();
    return list;
  }

  //get data from table
  static Future<List<RecentOccupationTable>?>
      getLastRecordOfOccupation() async {
    Database? db = await SqfLiteController.database;
    String query = "SELECT * FROM $tableName ORDER BY id DESC LIMIT 1";
    List<Map<String, Object?>>? data = await db?.rawQuery(query);
    if (data == null) {
      return null;
    }
    List<RecentOccupationTable> list = (data)
        .map<RecentOccupationTable>(
            (json) => RecentOccupationTable.fromJson(json))
        .toList();
    return list;
  }

  //update data from table
  static Future<int?> updateMostVisitedCount(
      {required int mostVisited,
      required String strOccID,
      required int? timestamp}) async {
    Database? db = await SqfLiteController.database;
    return await db?.update(
        tableName, {'mostVisited': mostVisited, 'timestamp': timestamp},
        where: 'occuID = ?', whereArgs: [strOccID]);
  }

  //Delete particular occupation from table
  static Future<int?> deleteOccupation({required String strOccID}) async {
    Database? db = await SqfLiteController.database;
    String query = "$tableName WHERE occuID = $strOccID";
    return await db?.delete(query);
  }

  //Check that Recent-occupation exists or not in the table
  static Future<bool?> checkOccupationExists({required String strOccID}) async {
    Database? db = await SqfLiteController.database;
    String query =
        ("SELECT COUNT(occuID) AS CNT FROM $tableName WHERE occuID = $strOccID");

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
    // printLog("Occupation Exists:: ${(count == 1) ? true : false}");
    // return count;
  }

  //Check that Recent-occupation exists or not in the table
  static Future<RecentOccupationTable?> returnExistsData(
      {required String strOccID}) async {
    Database? db = await SqfLiteController.database;
    List<Map<String, Object?>> listData = await db
            ?.query(tableName, where: 'occuID = ?', whereArgs: [strOccID]) ??
        [];
    try {
      List<RecentOccupationTable> list = (listData)
          .map<RecentOccupationTable>(
              (json) => RecentOccupationTable.fromJson(json))
          .toList();
      return list.first;
    } catch (e) {
      printLog("exception $e");
      return null;
    }
  }

  //COLUMN ADD
  static Future<bool> columnExistInTable() async {
    String columnName = 'skillLevel'; // INSERT COLUMN NAME

    Database? db = await SqfLiteController.database;
    var data = await db?.rawQuery('PRAGMA table_info($tableName);');

    bool exists = false;
    for (int i = 0; i < data!.length; i++) {
      if (data[i].containsValue(columnName)) {
        exists = true;
      }
    }
    if (exists) {
      return true;
    } else {
      //Add new column
      alterTable(tableName, columnName);
      return false;
    }
  }

  //ALTER TABLE
  static Future<dynamic> alterTable(String tableName, String columnName) async {
    Database? dbClient = await SqfLiteController.database;
    var count = await dbClient?.execute("ALTER TABLE $tableName ADD "
        "COLUMN $columnName TEXT;");
    return count;
  }

  //Delete table
  static Future<int?> deleteTable() async {
    Database? db = await SqfLiteController.database;
    return await db?.delete(tableName);
  }
}
