import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';

class SearchOccupationRepo {
  // [OTHER DETAILS]
  static Future<BaseResponseModel> getUnitGroupAndGeneralDetailInformation(
      param) async {
    String url =
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.searchOccupation!.getGeneralAndUnitGroupDetailData}?$param";
    BaseResponseModel apiResponse = await APIProvider.get(url);
    return apiResponse;
  }

  // [DELETE OCCUPATION]
  static Future<BaseResponseModel> deleteOccupation(requestJSON) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.profileOccupation!.deleteOccupationUrl!;
    BaseResponseModel apiResponse = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions:
            DioOptions(encryptionType: EncryptionType.kondeskEncryption));

    return Future.value(apiResponse);
  }

  // [ADD OCCUPATION]
  static Future<BaseResponseModel> addOccupation(requestJSON) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.profileOccupation!.addOccupationUrl!;
    BaseResponseModel apiResponse = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions:
            DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return apiResponse;
  }

  static Future<void> deleteOccupationFromDB(String occupationId) async {
    //Delete from My Bookmark Table
    MyBookmarkTable.deleteBookmarkById(bookmarkID: occupationId);
  }
}
