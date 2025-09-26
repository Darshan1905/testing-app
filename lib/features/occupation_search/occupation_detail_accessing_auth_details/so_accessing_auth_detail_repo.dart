import 'package:occusearch/data_provider/api_service/api_service.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';

class SoAccessingAuthDetailRepo {
  // [ACCESSING AUTHORITY DETAILS]
  // http://stagingapi.searchmyanzsco.com.au/api/v1/get_assessing_details?short_name=CAANZ
  static Future<BaseResponseModel> getAccessingAuthorityDetails(param) async {
    String url =
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.searchOccupation!.getAccessingAuthorityDetailsData}?$param";
    BaseResponseModel apiResponse = await APIProvider.get(url);
    return Future.value(apiResponse);
  }
}
