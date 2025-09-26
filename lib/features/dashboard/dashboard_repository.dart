import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';

class DashboardRepository {
  static Future<BaseResponseModel> getAppVersion(String apiURL) async {
    BaseResponseModel apiResponse = await APIProvider.get(apiURL);

    return Future.value(apiResponse);
  }

  // [RECENT UPDATE]
  static Future<BaseResponseModel> getRecentUpdatesDio(String param,
      {bool isCaching = false}) async {
    String url =
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.latestUpdate!.getRecentChangesNew}?$param";
    BaseResponseModel response = await APIProvider.get(url);
    return response;
  }

  // [Dashboard Api]
  static Future<BaseResponseModel> getDashboardData(
      Map<String, int> requestJSON,
      {bool isCaching = false}) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.dashboard!.kondeskDeshboardUrl!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions:
            DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return Future.value(response);
  }

  static Future<List<OccupationRowData>> getMyOccupationModelFromDb(
      List<MyBookmarkTable> arrMyOccupationsDb) async {
    List<OccupationRowData> arrMyOccupationModel = [];
    for (var occupation in arrMyOccupationsDb) {
      OccupationRowData occuModel = OccupationRowData(
          name: occupation.name,
          id: occupation.code,
          mainId: occupation.subCode,
          isAdded: true);
      arrMyOccupationModel.add(occuModel);
    }
    return arrMyOccupationModel;
  }
}
