

import 'package:occusearch/data_provider/api_service/base_response_model.dart';

class OtherInfoModel extends BaseResponseModel {
  List<OtherInfoRow>? otherInfoRowList;

  OtherInfoModel({this.otherInfoRowList});

  OtherInfoModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OtherInfoRow>[];
      json['data'].forEach((v) {
        data!.add(OtherInfoRow.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class OtherInfoRow {
  String? title;
  String? subtitle;
  String? link;
  bool isLink = false;

  OtherInfoRow({this.title, this.subtitle, this.link});

  OtherInfoRow.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['link'] = link;
    return data;
  }
}
