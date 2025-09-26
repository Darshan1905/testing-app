import 'dart:convert';
import 'package:occusearch/data_provider/api_service/api_service.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_bloc.dart';

class GlobalRepository {
  // [DEVICE NETWORK INFORMATION]
  static Future<BaseResponseModel> getDeviceCountryInfo() async {
    /*
      URL: http://ip-api.com/json
      {
      "status": "success",
      "country": "India",
      "countryCode": "IN",
      "region": "GJ",
      "regionName": "Gujarat",
      "city": "Ahmedabad",
      "zip": "380001",
      "lat": 23.0276,
      "lon": 72.5871,
      "timezone": "Asia/Kolkata",
      "isp": "Tata Teleservices LTD - Tata Indicom - Cdma Division",
      "org": "Tata Teleservices LTD Cdma",
      "as": "AS45820 Tata Teleservices ISP AS",
      "query": "14.97.112.194"
    }*/
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.authentication!.deviceCountryInfo!;
    BaseResponseModel response = await APIProvider.get(url);
    return response;
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
