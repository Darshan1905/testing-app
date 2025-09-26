/// Common API response Model

enum NetworkRequestStatus { loading, completed, error, internetConnection, none, vpn }

class BaseResponseModel<T> {
  bool? flag;
  NetworkRequestStatus status;
  int? statusCode; // 200-SUCCESS, 404-PAGE NOT FOUND, 500-SERVER ERROR etc.,
  String? message;
  dynamic data;

  BaseResponseModel.loading(this.message)
      : status = NetworkRequestStatus.loading;

  BaseResponseModel.completed(this.data)
      : status = NetworkRequestStatus.completed;

  BaseResponseModel.internetLost(this.message)
      : status = NetworkRequestStatus.internetConnection;

  BaseResponseModel.vpnConnected(this.message)
      : status = NetworkRequestStatus.vpn;

  BaseResponseModel.error(this.message) : status = NetworkRequestStatus.error;

  BaseResponseModel(
      {this.flag,
      this.statusCode,
      this.message,
      this.data,
      this.status = NetworkRequestStatus.none});
}
