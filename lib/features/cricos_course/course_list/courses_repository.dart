import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:occusearch/constants/constants.dart';

class CoursesRepository {
  //[COURSES FILTER API]
  static Future<BaseResponseModel> getCoursesListByFilter() async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.cricosCourse!.getFilterMaster!;
    BaseResponseModel apiResponse = await APIProvider.get(url, //);
        dioOptions: DioOptions(cachePolicy: CachePolicy.refreshForceCache));
    return apiResponse;
  }

  //[Api call when user came to search course screen]
  static Future<BaseResponseModel> getCoursesList(String requestParam) async {
    String url =
        '${FirebaseRemoteConfigController.shared.dynamicEndUrl!.cricosCourse!.getCourseList!}?$requestParam';
    BaseResponseModel apiResponse = await APIProvider.get(url);
    return apiResponse;
  }

  //[Api call when user click on any course call this api in course detail screen]
  static Future<BaseResponseModel> getCoursesDetailData(requestParam) async {
    //Course detail staging api call
    String url =
        '${FirebaseRemoteConfigController.shared.dynamicEndUrl!.cricosCourse!.getCourseData!}?cricos_course=$requestParam';
    BaseResponseModel apiResponse = await APIProvider.get(url);
    return apiResponse;
  }

  //[TOP UNIVERSITIES IN AUSTRALIA API]
  static Future<BaseResponseModel> getTopUniversitiesData() async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.cricosCourse!.getTopUniversitiesList!;
    BaseResponseModel apiResponse = await APIProvider.get(url,
        dioOptions: DioOptions(cachePolicy: CachePolicy.refreshForceCache));
    return apiResponse;
  }

  //[Add Course API]
  static Future<BaseResponseModel> addCourseData(requestParam) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.cricosCourse!.addCourse!;

    BaseResponseModel apiResponse = await APIProvider.post(url,
        parameters: requestParam,
        dioOptions:
            DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return apiResponse;
  }

  //[Delete Course API]
  static Future<BaseResponseModel> deleteCourseData(
      Map<String, dynamic> requestParam) async {
    String url = FirebaseRemoteConfigController
        .shared.dynamicEndUrl!.cricosCourse!.deleteCourse!;

    BaseResponseModel apiResponse = await APIProvider.post(url,
        parameters: requestParam,
        dioOptions:
            DioOptions(encryptionType: EncryptionType.kondeskEncryption));
    return apiResponse;
  }
}
