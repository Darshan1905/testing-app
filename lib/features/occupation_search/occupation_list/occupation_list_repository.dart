import 'dart:convert';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_bloc.dart';

class OccupationListRepository {
  static insertAllOccupationInDb(String strAllOccupationJson) async {
    ConfigTable? configTable =
        await ConfigTable.read(strField: ConfigFields.configFieldOccupationSyncDate);

    //If user is visiting occupation list page for first time, then values will be inserted.
    // Otherwise existing values for occupation list in database will be updated.
    if (configTable == null) {
      var allOccupationData = ConfigTable(
          fieldName: ConfigFields.configFieldAllOccupation,
          fieldValue: strAllOccupationJson);
      ConfigTable.insertTable(allOccupationData.toJson());

      var occupationSyncData = ConfigTable(
          fieldName: ConfigFields.configFieldOccupationSyncDate,
          fieldValue: Utility.getTodayDate());
      ConfigTable.insertTable(occupationSyncData.toJson());
    } else {
      ConfigTable.update(
          strFieldValue: strAllOccupationJson,
          strFieldName: ConfigFields.configFieldAllOccupation);
      ConfigTable.update(
          strFieldValue: Utility.getTodayDate(),
          strFieldName: ConfigFields.configFieldOccupationSyncDate);
    }
  }

  static Future<List<OccupationRowData>?> getAllOccupationFromDb() async {
    ConfigTable? configTable =
        await ConfigTable.read(strField: ConfigFields.configFieldAllOccupation);
    if (configTable != null && configTable.fieldValue!.isNotEmpty) {
      List<OccupationRowData> occupationList = [];
      occupationList = (jsonDecode(configTable.fieldValue ?? '') as List)
          .map<OccupationRowData>((json) => OccupationRowData.fromJson(json))
          .toList();
      occupationList =
          await OccupationListBloc.setAddedFlagToAllOccupationList(occupationList);
      return occupationList;
    } else {
      return [];
    }
  }
}
