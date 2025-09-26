class EOIStatisticsModel {
  bool? flag;
  String? message;
  Data? data;

  EOIStatisticsModel({this.flag, this.message, this.data});

  EOIStatisticsModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<EOIData>? eOIData;

  Data({this.eOIData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['EOI_data'] != null) {
      eOIData = <EOIData>[];
      json['EOI_data'].forEach((v) {
        eOIData!.add(EOIData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (eOIData != null) {
      data['EOI_data'] = eOIData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EOIData {
  String? vType;
  List<EOIStatisticsDetailData>? eoiCountData;

  EOIData({this.vType, this.eoiCountData});

  EOIData.fromJson(Map<String, dynamic> json) {
    vType = json['VType'];
    if (json['data'] != null) {
      eoiCountData = <EOIStatisticsDetailData>[];
      json['data'].forEach((v) {
        eoiCountData!.add(EOIStatisticsDetailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VType'] = vType;
    if (eoiCountData != null) {
      data['data'] = eoiCountData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EOIStatisticsDetailData {
  String? visaType;
  String? point;
  String? prefix;
  String? eOICount;
  String? eOIStatus;
  String? eOIMonth;
  String? eOIYear;
  String? vType;
  String? color;
  String? visaTitle;

  EOIStatisticsDetailData(
      {this.visaType,
        this.point,
        this.prefix,
        this.eOICount,
        this.eOIStatus,
        this.eOIMonth,
        this.eOIYear,
        this.vType,
        this.color,
        this.visaTitle});

  EOIStatisticsDetailData.fromJson(Map<String, dynamic> json) {
    visaType = json['visa_type'];
    point = json['point'];
    prefix = json['prefix'];
    eOICount = json['EOI_count'];
    eOIStatus = json['EOI_status'];
    eOIMonth = json['EOI_month'];
    eOIYear = json['EOI_year'];
    vType = json['VType'];
    color = json['color'];
    visaTitle = json['visa_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visa_type'] = visaType;
    data['point'] = point;
    data['prefix'] = prefix;
    data['EOI_count'] = eOICount;
    data['EOI_status'] = eOIStatus;
    data['EOI_month'] = eOIMonth;
    data['EOI_year'] = eOIYear;
    data['VType'] = vType;
    data['color'] = color;
    data['visa_title'] = visaTitle;
    return data;
  }
}
