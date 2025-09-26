import 'package:occusearch/constants/constants.dart';

class SoAllVisaTypeRepo {
  // [ALL VISA TYPE]
  static Future<BaseResponseModel> getAllVisaTypeAPICall(param) async {
    String url =
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.searchOccupation!.getAllVisaTypeData}?$param";
    BaseResponseModel apiResponse = await APIProvider.get(url);
    return apiResponse;
  }
}
