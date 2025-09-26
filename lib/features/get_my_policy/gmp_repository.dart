import 'package:occusearch/constants/constants.dart';

class GetMyPolicyRepository {
  static Future<BaseResponseModel> getOSHCDetails(
      {bool isCaching = false,
      required Map<String, String> requestJSON}) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.getMyPolicy!.getOSHCDetails!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions: DioOptions(encryptionType: EncryptionType.noEncryption));
    return Future.value(response);
  }

  static Future<BaseResponseModel> getOVHCDetails(
      {bool isCaching = false,
      required Map<String, String> requestJSON}) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.getMyPolicy!.getOVHCDetails!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions: DioOptions(encryptionType: EncryptionType.noEncryption));
    return Future.value(response);
  }

  static Future<BaseResponseModel> buyOVHCQuote(
      {bool isCaching = false,
        required Map<String, dynamic> requestJSON}) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.getMyPolicy!.buyOVHCQuote!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions: DioOptions(encryptionType: EncryptionType.noEncryption));
    return Future.value(response);
  }

  static Future<BaseResponseModel> buyOSHCQuote(
      {bool isCaching = false,
        required Map<String, dynamic> requestJSON}) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.getMyPolicy!.buyOSHCPolicy!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions: DioOptions(encryptionType: EncryptionType.noEncryption));
    return Future.value(response);
  }
}
