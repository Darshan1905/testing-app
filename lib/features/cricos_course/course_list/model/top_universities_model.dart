class TopUniversitiesModel {
  bool? flag;
  String? message;
  Data? data;

  TopUniversitiesModel({this.flag, this.message, this.data});

  TopUniversitiesModel.fromJson(Map<String, dynamic> json) {
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
  List<TopInstitute>? topInstitute;

  Data({this.topInstitute});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['top_institute'] != null) {
      topInstitute = <TopInstitute>[];
      json['top_institute'].forEach((v) {
        topInstitute!.add(TopInstitute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (topInstitute != null) {
      data['top_institute'] =
          topInstitute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TopInstitute {
  String? institutionCode;
  String? institutionName;
  String? rank;
  String? instituteCity;
  String? instituteWebsite;
  String? institutionLogo;

  TopInstitute(
      {this.institutionCode,
      this.institutionName,
      this.rank,
      this.instituteCity,
      this.instituteWebsite,
      this.institutionLogo});

  TopInstitute.fromJson(Map<String, dynamic> json) {
    institutionCode = json['institution_code'];
    institutionName = json['institution_name'];
    rank = json['rank'];
    instituteCity = json['institute_city'];
    instituteWebsite = json['institute_website'];
    institutionLogo = json['institution_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['institution_code'] = institutionCode;
    data['institution_name'] = institutionName;
    data['rank'] = rank;
    data['institute_city'] = instituteCity;
    data['institute_website'] = instituteWebsite;
    data['institution_logo'] = institutionLogo;
    return data;
  }
}
