class SeVisaTypeModel {
  bool? flag;
  String? message;
  List<VisaTypeData>? data;

  SeVisaTypeModel({this.flag, this.message, this.data});

  SeVisaTypeModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VisaTypeData>[];
      json['data'].forEach((v) {
        data!.add(VisaTypeData.fromJson(v));
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

class VisaTypeData {
  int? visaType;
  String? visaTypeTitle;
  bool? isTabSelected = false;

  VisaTypeData({this.visaType, this.visaTypeTitle});

  VisaTypeData.fromJson(Map<String, dynamic> json) {
    visaType = int.parse(json['visa_type'] ?? "0");
    visaTypeTitle = json['visa_type_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visa_type'] = visaType;
    data['visa_type_title'] = visaTypeTitle;
    return data;
  }
}
