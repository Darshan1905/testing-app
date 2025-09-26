import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:occusearch/constants/constants.dart';

class DiscoverDreamRepository {

  //[Employment Insights for market place data]
  static Future<BaseResponseModel> getMarketPlaceAustraliaData() async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.labourInsights!.getMarketPlaceAustraliaData!;
    BaseResponseModel apiResponse = await APIProvider.get(url,
        dioOptions: DioOptions(cachePolicy: CachePolicy.refreshForceCache));
    return apiResponse;
  }
}