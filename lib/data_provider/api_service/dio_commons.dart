import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/api_service/dio_cache_controller.dart';
import 'package:occusearch/data_provider/api_service/dio_interceptor_controller.dart';
import 'package:occusearch/utility/platform_channels.dart';

enum EncryptionType {
  noEncryption,
  defaultEncryption,
  kondeskEncryption,
  anzscoEncryption,
}

enum CacheTypes {
  forceCache,
  refreshForceCache,
  noCache,
  refresh,
  request,
}

class DioClient {
  static Future<Dio> getDioClient({
    String? apiUrl,
    Map<String, dynamic>? headers,
    var params,
    String? method,
    DioOptions? dioOptions,
  }) async {
    Dio dio = Dio();
    dioOptions ??= DioOptions();
    var defaultHeaders = await APIProvider.getHeader([
      ApiHeader.contentTypeJson,
    ]);

    // To encrypt request parameter
    switch (dioOptions.encryptionType) {
      case EncryptionType.kondeskEncryption:
        params = await PlatformChannels.getOccuSearchEncryptedParam(params);
        break;
      case EncryptionType.noEncryption:
        break;
      case EncryptionType.defaultEncryption:
        break;
      case EncryptionType.anzscoEncryption:
        break;
      default:
        break;
    }

    dio.interceptors.add(DioInterceptor(
        headers ?? defaultHeaders, params ?? {}, method ?? "", dioOptions));

    if (dioOptions.cachePolicy != null) {
      dio.interceptors.add(DioCacheController.getDioCacheInterceptor(
          policy: dioOptions.cachePolicy ?? CachePolicy.refreshForceCache));
    }

    DioCacheController.avoidingCertificates(dio);
    return dio;
  }
}

class DioOptions {
  EncryptionType? encryptionType;
  CachePolicy? cachePolicy;
  ResponseType? responseType;

  DioOptions({this.encryptionType, this.cachePolicy, this.responseType});

  DioOptions.ideal() {
    encryptionType = EncryptionType.defaultEncryption;
    setCacheType(CacheTypes.refreshForceCache);
  }

  DioOptions.none() {
    encryptionType = EncryptionType.noEncryption;
    setCacheType(CacheTypes.noCache);
  }

  DioOptions.submit() {
    encryptionType = EncryptionType.defaultEncryption;
    setCacheType(CacheTypes.noCache);
  }

  DioOptions.cacheOnly() {
    encryptionType = EncryptionType.noEncryption;
    setCacheType(CacheTypes.refreshForceCache);
  }

  DioOptions.custom({
    EncryptionType encryptionType = EncryptionType.noEncryption,
    CacheTypes cacheTypes = CacheTypes.refreshForceCache,
  }) {
    encryptionType = encryptionType;
    setCacheType(cacheTypes);
  }

  CachePolicy setCacheType(CacheTypes type) {
    CachePolicy policy = CachePolicy.refreshForceCache;

    switch (type) {
      case CacheTypes.forceCache:
        policy = CachePolicy.forceCache;
        break;
      case CacheTypes.refreshForceCache:
        policy = CachePolicy.refreshForceCache;
        break;
      case CacheTypes.refresh:
        policy = CachePolicy.refresh;
        break;
      case CacheTypes.noCache:
        policy = CachePolicy.noCache;
        break;
      case CacheTypes.request:
        policy = CachePolicy.request;
        break;
    }

    cachePolicy = policy;
    return policy;
  }
}
