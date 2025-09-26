import 'package:occusearch/data_provider/api_service/api_service.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/data_provider/api_service/dio_commons.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';

class CustomQuestionRepository {
  // [CUSTOM QUESTIONS]
  static Future<BaseResponseModel> getCustomQuestions(
      Map<String, dynamic> param,
      {bool isCaching = false}) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.authentication!.getCustomQuestion!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        dioOptions:
            DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return response;
  }

  //[SUBMIT QUESTIONS]
  static Future<BaseResponseModel> submitCustomQuestions(
      Map<String, dynamic> param,
      {bool isCaching = false}) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.authentication!.saveCustomQuestionAnswer!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        dioOptions: DioOptions(encryptionType: EncryptionType.noEncryption));
    return response;
  }
}
