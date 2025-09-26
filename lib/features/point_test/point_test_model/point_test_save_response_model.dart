// ignore_for_file: overridden_fields

import 'package:occusearch/data_provider/api_service/base_response_model.dart';

class PointTestSaveResponseModel extends BaseResponseModel {
  @override
  bool? flag;
  @override
  String? message;
  String? pointTestSaveResponseData;

  PointTestSaveResponseModel(
      {this.flag, this.message, this.pointTestSaveResponseData});

  PointTestSaveResponseModel.fromJson(Map<String, dynamic> json) {
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
