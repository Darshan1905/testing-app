// ignore_for_file: library_prefixes

import 'dart:io';
import 'package:dio/dio.dart' as DioNetwork;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/dio_cache_controller.dart';
import 'package:occusearch/utility/platform_channels.dart';
import 'CommonResponseModel.dart';
import 'api_constant.dart';

class APIProvider {
  static getHeader(List<ApiHeader> headers) async {
    Map<String, String> data = {};

    for (var value in headers) {
      switch (value) {
        case ApiHeader.deviceType:
          data[NetworkAPIConstant.reqResKeys.deviceType] =
              Platform.isAndroid ? "1" : "2";
          break;
        // Comment the if-else condition and isNotDebug variable and only keep the code of jwtToken
        case ApiHeader.authorizationKondesk:
          // TODO:[TEMPER-DETECTION] :: the debug app make [isNotDebug] value = true default
          bool isNotDebug = await PlatformChannels.checkGuardDebugger(); // true; //
          if (isNotDebug) {
            try {
              if (FirebaseRemoteConfigController.shared.dynamicEndUrl != null &&
                  FirebaseRemoteConfigController.shared.dynamicEndUrl?.authentication !=
                      null &&
                  FirebaseRemoteConfigController
                          .shared.dynamicEndUrl?.authentication !=
                      null &&
                  FirebaseRemoteConfigController.shared.dynamicEndUrl
                          ?.authentication?.kondeskWebsite !=
                      null) {
                final jwtToken = await PlatformChannels.getJWTBearerToken(
                    "divakar.aussizz@gmail.com",
                    // TODO need to add dynamic email
                    FirebaseRemoteConfigController
                        .shared.dynamicEndUrl!.authentication!.kondeskWebsite!);
                printLog(
                    "JWT Token domainX: ${FirebaseRemoteConfigController.shared.dynamicEndUrl!.authentication!.kondeskWebsite!}");
                //print('jwt token = $jwtToken');
                data[NetworkAPIConstant.reqResKeys.authorization] =
                    "bearer $jwtToken";
              } else {
                final jwtToken = await PlatformChannels.getJWTBearerToken(
                    "divakar.aussizz@gmail.com",
                    // TODO need to add dynamic email
                    PlatformChannelConstants.kondeskDomainName);
                printLog(
                    "JWT Token domainZ: ${PlatformChannelConstants.kondeskDomainName}");
                //print('jwt token = $jwtToken');
                data[NetworkAPIConstant.reqResKeys.authorization] =
                    "bearer $jwtToken";
              }
            } catch (e) {
              printLog(e);
              final jwtToken = await PlatformChannels.getJWTBearerToken(
                  "divakar.aussizz@gmail.com", // TODO need to add dynamic email
                  PlatformChannelConstants.kondeskDomainName);
              printLog(
                  "JWT Token domainZ: ${PlatformChannelConstants.kondeskDomainName}");
              //print('jwt token = $jwtToken');
              data[NetworkAPIConstant.reqResKeys.authorization] =
                  "bearer $jwtToken";
            }
          } else {
            FirebaseCrashlytics.instance.crash();
          }
          break;
        case ApiHeader.authorizationAnzsco:
          // TODO: Handle this case.
          break;
        case ApiHeader.contentTypeJson:
          data[NetworkAPIConstant.reqResKeys.contentType] = "application/json";
          break;
        case ApiHeader.contentTypeFormData:
          data[NetworkAPIConstant.reqResKeys.contentType] =
              "multipart/form-data";
          break;
        case ApiHeader.contentTypeUrl:
          data[NetworkAPIConstant.reqResKeys.contentType] =
              "application/x-www-form-urlencoded";
          break;
        case ApiHeader.browser:
          // TODO: Handle this case.
          break;
      }
    }
    return data;
  }

  static Future<BaseResponseModel<T>> get<T>(
    String url, {
    Map<String, dynamic>? headers,
    DioOptions? dioOptions,
  }) async {
    DioNetwork.Dio dio = await DioClient.getDioClient(
        headers: headers, method: "GET", dioOptions: dioOptions);
    try {
      DioNetwork.Response response = await dio.get(url);
      printLog(
          "Is Response from caching(${response.statusCode}) : ${response.statusCode == NetworkAPIConstant.statusCodeCaching}");
      if (response.statusCode == NetworkAPIConstant.statusCodeSuccess ||
          response.statusCode == NetworkAPIConstant.statusCodeCaching) {
        try {
          if (dioOptions?.cachePolicy != null) {
            CommonResponseModel model =
                CommonResponseModel.fromJson(response.data);
            // TODO delete cache if API response come with failed status pending...
            if (model.flag != null &&
                model.flag == true &&
                model.data != null) {
            } else {
              await DioCacheController.deleteCache(url);
            }
          }
        } catch (e) {
          printLog(e);
        }
        return BaseResponseModel(
            statusCode: response.statusCode,
            flag: true,
            message: response.statusMessage ?? "",
            data: response.data);
      } else {
        // TODO delete cache if API response come with failed status pending...
        return BaseResponseModel(
            statusCode: response.statusCode,
            flag: false,
            message: response.statusMessage ?? "",
            data: response.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      return BaseResponseModel(
          statusCode: NetworkAPIConstant.statusCodeServerError,
          flag: false,
          message: e.toString(),
          data: null);
    }
  }

  static Future<BaseResponseModel<T>> post<T>(
    String url, {
    Map<String, dynamic>? headers,
    var parameters,
    DioOptions? dioOptions,
  }) async {
    DioNetwork.Dio dio = await DioClient.getDioClient(
        headers: headers,
        params: parameters ?? {},
        method: "POST",
        dioOptions: dioOptions);

    try {
      DioNetwork.Response response = await dio.post(url);
      if (response.statusCode == NetworkAPIConstant.statusCodeSuccess) {
        return BaseResponseModel(
            statusCode: response.statusCode,
            flag: true,
            message: response.statusMessage ?? "",
            data: response.data);
      } else {
        return BaseResponseModel(
            statusCode: response.statusCode,
            flag: false,
            message: response.statusMessage ?? "",
            data: response.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      return BaseResponseModel(
          statusCode: NetworkAPIConstant.statusCodeServerError,
          flag: false,
          message: e.toString(),
          data: null);
    }
  }

  static Future<DioNetwork.Response> postWithoutBaseResponse<T>(
    String url, {
    Map<String, dynamic>? headers,
    var parameters,
    DioOptions? dioOptions,
  }) async {
    DioNetwork.Dio dio = await DioClient.getDioClient(
        headers: headers,
        params: parameters ?? {},
        method: "POST",
        dioOptions: dioOptions);

    try {
      DioNetwork.Response response = await dio.post(url);
      if (response.statusCode == NetworkAPIConstant.statusCodeSuccess) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      return DioNetwork.Response(
          requestOptions: DioNetwork.RequestOptions(path: ''),
          data: null,
          statusCode: 500,
          statusMessage: e.toString());
    }
  }

  static Future<BaseResponseModel<T>> postMultipart<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) async {
    DioNetwork.Dio dio = DioNetwork.Dio();

    try {
      var params = DioNetwork.FormData.fromMap(body ?? {});
      DioNetwork.Response response = await dio.post(url,
          data: params,
          options: DioNetwork.Options(
              method: "POST",
              responseType: DioNetwork.ResponseType.json,
              headers: headers));

      if (response.statusCode == NetworkAPIConstant.statusCodeSuccess) {
        return BaseResponseModel(
            statusCode: response.statusCode,
            flag: true,
            message: response.statusMessage ?? "",
            data: response.data);
      } else {
        return BaseResponseModel(
            statusCode: response.statusCode,
            flag: false,
            message: response.statusMessage ?? "",
            data: response.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      return BaseResponseModel(
          statusCode: NetworkAPIConstant.statusCodeServerError,
          flag: false,
          message: e.toString(),
          data: null);
    }
  }
}
