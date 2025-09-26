import 'package:occusearch/data_provider/api_service/api_service.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/data_provider/api_service/dio_commons.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';
import 'package:dio/dio.dart';

class VevoCheckRepository {
  // Vevo Check Form API
  static Future<BaseResponseModel> getVevoCheckDetails(params) async {
    String url =
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.vevoCheck!.checkMyVisa!}?$params";
    BaseResponseModel response = await APIProvider.post(url,
        dioOptions: DioOptions(encryptionType: EncryptionType.noEncryption),
        parameters: params);
    return response;
  }

  //PASSPORT API
  static Future<Response> fetchOCRPassport(
      var params, var header) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.vevoCheck!.passportOCRAPI!;
    Response response = await APIProvider.postWithoutBaseResponse(
      url,
      dioOptions: DioOptions(encryptionType: EncryptionType.noEncryption),
      parameters: params,
      headers: header,
    );
    return response;
  }

  //VISA GRANT API
  static Future<Response> fetchOCRVRN(var params, var header) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.vevoCheck!.vrnOCRAPI!;
    Response response = await APIProvider.postWithoutBaseResponse(
      url,
      dioOptions: DioOptions(encryptionType: EncryptionType.noEncryption),
      parameters: params,
      headers: header,
    );
    return response;
  }
}
