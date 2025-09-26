import 'package:occusearch/data_provider/api_service/api_service.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';

class SoInvitationCutOffDetailRepo {
  // [INVITATION CUT OFF DETAILS]
  static Future<BaseResponseModel> getInvitationCutOffDetails(param) async {
    BaseResponseModel apiResponse = await APIProvider.get(
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.searchOccupation!.getInvitationCutOffDetail}?$param");
    return apiResponse;
  }
}
