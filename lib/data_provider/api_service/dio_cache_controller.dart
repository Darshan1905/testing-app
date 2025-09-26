import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:occusearch/resources/string_helper.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:path_provider/path_provider.dart' as pp;

import 'api_constant.dart';
import 'network_controller.dart';

class DioCacheController {
  static DioCacheInterceptor getDioCacheInterceptor(
      {CachePolicy policy = CachePolicy.refreshForceCache}) {
    return DioCacheInterceptor(
      options: CacheOptions(
        store: FileCacheStore(AppPathProvider.path),
        policy: policy,
        hitCacheOnErrorExcept: [],
        maxStale: const Duration(days: 1),
        priority: CachePriority.normal,
        allowPostMethod: true,
      ),
    );
  }

  static Future<void> deleteCache(String api) async {
    try {
      FileCacheStore f = FileCacheStore(AppPathProvider.path);
      final key = CacheOptions.defaultCacheKeyBuilder(
        RequestOptions(path: api),
      );
      printLog("URL $api exist? : ${await f.exists(key)}\n Key: $key");
      if (await f.exists(key) == true) {
        await f.delete(key);
      }
    } catch (e) {
      printLog(e);
    }
  }

  static Future<void> returnRequestHandler(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Duration cacheDuration = const Duration(days: 1);
    final cache = await _getCacheResponse(options);
    bool? isValidTime = await _checkIfValidTime(cache, cacheDuration);
    if (cache != null && isValidTime == true) {
      printLog("All good response is cached");
      return handler.resolve(
          cache.toResponse(options, fromNetwork: false), true);
    }

    bool isNetworkConnected = await NetworkController.isConnected();
    // bool isVpnConnected = false;//await NetworkController.isVpnActive();

    if (!isNetworkConnected) {
      printLog("NetworkConnected is false");
      return handler.resolve(Response(
        statusCode: NetworkAPIConstant.statusCodeNoInternet,
        statusMessage: StringHelper.internetConnection,
        requestOptions: options,
      ));
    }
    /*else if (isVpnConnected) {
      printLog("VPN is connected");
      return handler.resolve(Response(
        statusCode: NetworkAPIConstant.statusCodeVPNConnection,
        statusMessage: NetworkAPIConstant.vpnAlertMessage,
        requestOptions: options,
      ));
    }*/
    else {
      return handler.next(options);
    }
  }

  static avoidingCertificates(Dio dio) {
    //this is for avoiding certificates error cause by dio
    //https://issueexplorer.com/issue/flutterchina/dio/1285
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  static Future<CacheResponse?> _getCacheResponse(
      RequestOptions options) async {
    final key = CacheOptions.defaultCacheKeyBuilder(options);
    final cache = await FileCacheStore(AppPathProvider.path).get(key);
    return cache;
  }

  static Future<bool?> _checkIfValidTime(
      CacheResponse? cache, Duration? cacheDuration) async {
    bool isValidTime = false;

    if (cache != null) {
      isValidTime = DateTime.now().difference(cache.responseDate).inMinutes <
          cacheDuration!.inMinutes;
    }

    return isValidTime;
  }
}

class AppPathProvider {
  static String? _path;

  static String get path {
    if (_path != null) {
      return _path!;
    } else {
      throw Exception('path not initialized');
    }
  }

  static Future<void> initPath() async {
    final dir = await pp.getApplicationDocumentsDirectory();
    _path = dir.path;
  }
}
