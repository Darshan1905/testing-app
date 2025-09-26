import 'package:occusearch/data_provider/api_service/api_service.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';

class SoUnitGroupAndGeneralRepository {

  static Future<BaseResponseModel> getRelatedCoursesData(param) async {
    String url =
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.cricosCourse!.getRelatedCourseByOccupation}?$param";
    BaseResponseModel apiResponse = await APIProvider.get(url);
    return apiResponse;
  }
}
