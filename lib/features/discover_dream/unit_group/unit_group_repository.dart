import 'dart:convert';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_model.dart';

class UnitGroupRepository {
  //Unit group data from realtime database to local database
  static insertAllUnitGroupInDb(String strAllUnitGroupJson) async {
    ConfigTable? configTable =
        await ConfigTable.read(strField: ConfigFields.unitGroupSyncDate);

    //If user is visiting occupation list page for first time, then values will be inserted.
    // Otherwise existing values for unit_group group list in database will be updated.
    if (configTable == null) {
      var allUnitGroupData = ConfigTable(
          fieldName: ConfigFields.allUnitGroupData,
          fieldValue: strAllUnitGroupJson);
      ConfigTable.insertTable(allUnitGroupData.toJson());

      var unitGroupSyncData = ConfigTable(
          fieldName: ConfigFields.unitGroupSyncDate,
          fieldValue: Utility.getTodayDate());
      ConfigTable.insertTable(unitGroupSyncData.toJson());
    } else {
      ConfigTable.update(
          strFieldValue: strAllUnitGroupJson,
          strFieldName: ConfigFields.allUnitGroupData);
      ConfigTable.update(
          strFieldValue: Utility.getTodayDate(),
          strFieldName: ConfigFields.unitGroupSyncDate);
    }
  }

  static Future<List<UnitGroupListData>?> getAllUnitGroupFromDb() async {
    ConfigTable? configTable =
        await ConfigTable.read(strField: ConfigFields.allUnitGroupData);
    if (configTable != null && configTable.fieldValue!.isNotEmpty) {
      List<UnitGroupListData> unitGroupList = [];
      unitGroupList = (jsonDecode(configTable.fieldValue ?? '') as List)
          .map<UnitGroupListData>((json) => UnitGroupListData.fromJson(json))
          .toList();

      return unitGroupList;
    } else {
      return [];
    }
  }
}
