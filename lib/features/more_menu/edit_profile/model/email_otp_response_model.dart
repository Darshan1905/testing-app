class EmailOTPResponse {
  bool? flag;
  String? message;
  String? data;

  EmailOTPResponse({this.flag, this.message, this.data});

  EmailOTPResponse.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}
