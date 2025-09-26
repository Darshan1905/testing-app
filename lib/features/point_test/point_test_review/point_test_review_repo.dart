import 'package:occusearch/constants/constants.dart';

class PointTestReviewRepository {
  static Future<BaseResponseModel> getPointTestResult(requestJSON) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.pointTest!.getPointTestResultUrl!;
    BaseResponseModel response = await APIProvider.post(url,
        parameters: requestJSON,
        dioOptions:
            DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return Future.value(response);
  }
}