import 'package:occusearch/data_provider/api_service/api_service.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';

class SoStateEligibilityRepo {

  // [VISA LIST]
 static Future<BaseResponseModel> getStateEligibilityVisaListAPICall() async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!
        .searchOccupation!.getStateEligibilityVisaListData!;
    BaseResponseModel apiResponse = await APIProvider.get(url);
    return apiResponse;
  }

  // [STATE ELIGIBILITY]
  static Future<BaseResponseModel> getStateEligibilityStateWiseAPICall(param) async {
    String url =
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.searchOccupation!.getStateEligibilityData}?$param";
    BaseResponseModel apiResponse =  await APIProvider.get(url);
    return apiResponse;
  }

 static Future<BaseResponseModel> getStateEligibilityDetail(param) async {
   String url =
       "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.searchOccupation!.getStateEligibilityDetail}?$param";
   BaseResponseModel apiResponse = await APIProvider.get(url);
   return Future.value(apiResponse);
 }
}
