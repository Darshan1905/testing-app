class FirebaseTokenModel {
  String? data;
  bool? flag;
  String? message;

  FirebaseTokenModel({this.data, this.flag, this.message});

  FirebaseTokenModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    flag = json['flag'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    data['flag'] = flag;
    data['message'] = message;
    return data;
  }
}