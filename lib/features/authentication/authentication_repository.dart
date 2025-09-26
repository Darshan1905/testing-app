import 'package:occusearch/constants/constants.dart';

class AuthenticationRepository {
  // [GET USER DETAILS]
  static Future<BaseResponseModel> getUserProfileData(Map<String, dynamic> param) async {
    String url =
        FirebaseRemoteConfigController.shared.dynamicEndUrl!.authentication!.getUserInfoUrl!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return response;
  }

  // [UPDATE USER DEVICE]
  static Future<BaseResponseModel> updateUserDeviceID(Map<String, dynamic> param) async {
    String url =
        FirebaseRemoteConfigController.shared.dynamicEndUrl!.authentication!.updateUserDeviceIDUrl!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return response;
  }

  // [CREATE NEW ACCOUNT]
  static Future<BaseResponseModel> createAccountAPI(Map<String, dynamic> param) async {
    String url =
        FirebaseRemoteConfigController.shared.dynamicEndUrl!.authentication!.registerUserUrl!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return response;
  }

  // [GET FIREBASE AUTH TOKEN]
  static Future<BaseResponseModel> getFirebaseAuthToken(Map<String, dynamic> param) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.authentication!.firebaseCustomTokenUrl!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param, dioOptions: DioOptions(encryptionType: EncryptionType.noEncryption));
    return response;
  }

  // [LOGOUT]
  static Future<BaseResponseModel> userLogout(Map<String, dynamic> param) async {
    String url =
        FirebaseRemoteConfigController.shared.dynamicEndUrl!.authentication!.userLogoutUrl!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return response;
  }

  // [OTP SEND ON MAIL]
  static Future<BaseResponseModel> sendOTPEmail(Map<String, dynamic> param) async {
    String url = FirebaseRemoteConfigController.shared.dynamicEndUrl!.authentication!.emailVerify!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return response;
  }

  // [DELETE ACCOUNT]
  static Future<BaseResponseModel> deleteAccount(Map<String, dynamic> param) async {
    String url =
        FirebaseRemoteConfigController.shared.dynamicEndUrl!.authentication!.deleteAccountUrl!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return response;
  }

  // [DEVICE NETWORK INFORMATION]
  static Future<BaseResponseModel> getDeviceCountryInfo() async {
    /*
      URL: http://ip-api.com/json
      {
      "status": "success",
      "country": "India",
      "countryCode": "IN",
      "region": "GJ",
      "regionName": "Gujarat",
      "city": "Ahmedabad",
      "zip": "380001",
      "lat": 23.0276,
      "lon": 72.5871,
      "timezone": "Asia/Kolkata",
      "isp": "Tata Teleservices LTD - Tata Indicom - Cdma Division",
      "org": "Tata Teleservices LTD Cdma",
      "as": "AS45820 Tata Teleservices ISP AS",
      "query": "14.97.112.194"
    }*/
    String url =
        FirebaseRemoteConfigController.shared.dynamicEndUrl!.authentication!.deviceCountryInfo!;
    BaseResponseModel response = await APIProvider.get(url);
    return response;
  }

  static updateUserProfile(Map<String, dynamic> param) async {
    String url =
        FirebaseRemoteConfigController.shared.dynamicEndUrl!.authentication!.updateUserProfile!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return response;
  }

  static updateGmailAddress(Map<String, dynamic> param) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.authentication!.updateUserMigrationEmail!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        dioOptions: DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return response;
  }

  static sendWhatsAppWelcomeMessage(
      String url, Map<String, dynamic> header, Map<String, dynamic> param) async {
    BaseResponseModel response = await APIProvider.post(url,
        parameters: param,
        headers: header,
        dioOptions: DioOptions(encryptionType: EncryptionType.noEncryption));
    return response;
  }
}
