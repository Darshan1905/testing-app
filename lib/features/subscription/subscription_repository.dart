import 'package:occusearch/constants/constants.dart';

class SubscriptionRepository {
  // [Get Subscription Plan]
  static Future<BaseResponseModel> getOccuSubscriptionPlan(Map<String, int> requestJSON,
      {bool isCaching = false}) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.subscriptionPlan!.getOccuSubscriptionPlan!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return Future.value(response);
  }

  static Future<BaseResponseModel> buySubscriptionPlan(Map<String, Object?> requestJSON) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.subscriptionPlan!.buyOccuSubscriptionPlan!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return Future.value(response);
  }

  static Future<BaseResponseModel> getMyOccuSubscriptionPlan(Map<String, int> requestJSON,
      {bool isCaching = false}) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.subscriptionPlan!.getMyOccuSubscriptionPlan!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return Future.value(response);
  }

  static Future<BaseResponseModel> getMyOccuSubTransHistory(Map<String, int> requestJSON,
      {bool isCaching = false}) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.subscriptionPlan!.getMyOccuSubTranshistory!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return Future.value(response);
  }

  static Future<BaseResponseModel> applyPromoCode(Map<String, Object?> requestJSON,
      {bool isCaching = false}) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.subscriptionPlan!.checkPromoCode!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return Future.value(response);
  }

  static Future<BaseResponseModel> getPromoCodeList(Map<String, Object?> requestJSON,
      {bool isCaching = false}) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.subscriptionPlan!.getPromoCodeList!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return Future.value(response);
  }
}
