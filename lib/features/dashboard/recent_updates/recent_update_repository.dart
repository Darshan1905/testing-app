import 'package:occusearch/constants/constants.dart';

class RecentUpdateRepository {
  static Future<BaseResponseModel> getRecentUpdatesDio(String param,
      {bool isCaching = false}) async {
    String url =
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.latestUpdate!.getRecentChangesNew}?$param";
    BaseResponseModel response = await APIProvider.get(url);
    return response;
  }
}
