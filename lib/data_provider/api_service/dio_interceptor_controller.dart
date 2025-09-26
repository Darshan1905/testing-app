import 'package:dio/dio.dart';
import 'package:occusearch/utility/utils.dart';
import 'dio_cache_controller.dart';
import 'dio_commons.dart';

class DioInterceptor extends Interceptor {
  Map<String, dynamic> headers = {};
  Map<String, dynamic> queryParams = {};
  String method = '';
  DioOptions dioOptions = DioOptions();

  DioInterceptor(
    this.headers,
    this.queryParams,
    this.method,
    this.dioOptions,
  );

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers = headers;
    options.method = method;
    options.responseType = dioOptions.responseType ?? ResponseType.json;
    options.data = queryParams;

    printLog("queryParams $queryParams");

    await DioCacheController.returnRequestHandler(options, handler);
  }

  /// You can also perform some actions in the response or onError.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    printLog('onResponse ==>> ${response.requestOptions.path}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    printLog('onError ==>> ${err.response?.statusCode}');
    if (err.response != null) {
      return handler.resolve(err.response!);
    } else {
      return super.onError(err, handler);
    }
  }
}
