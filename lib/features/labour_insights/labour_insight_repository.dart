import 'package:occusearch/data_provider/api_service/api_service.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';
import 'package:occusearch/utility/utils.dart';

class LabourInsightRepository {
  //[Api call when user click on any Unit group call this api in course detail screen]
  static Future<BaseResponseModel> getLabourInsightDetailData(String param,
      {bool isOccupationData = false}) async {
    String url = isOccupationData
        ? "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.labourInsights!.labourInsightOccupation!}?occ_code=$param"
        : "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.labourInsights!.labourInsightUnitGroup!}?ug_code=$param";
    printLog("Labour insight by Unitgroup API : $url");
    BaseResponseModel apiResponse = await APIProvider.get(url);
    return apiResponse;
  }
}
