class UnitGroupModel {
  UnitGroupModel({
    this.flag,
    this.error,
    this.message,
    this.data,
  });

  UnitGroupModel.fromJson(dynamic json) {
    flag = json['flag'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(UnitGroupListData.fromJson(v));
      });
    }
  }

  bool? flag;
  dynamic error;
  String? message;
  List<UnitGroupListData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['flag'] = flag;
    map['error'] = error;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UnitGroupListData {
  String? name;
  String? ugCode;
  int? skillLevel;
  int? categoryType;
  List<OccupationData>? occupation;

  UnitGroupListData(
      {this.name,
        this.ugCode,
        this.skillLevel,
        this.categoryType,
        this.occupation});

  UnitGroupListData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ugCode = json['ug_code'];
    skillLevel = json['skill_level'];
    categoryType = json['category_type'];
    if (json['occupation'] != null) {
      occupation = <OccupationData>[];
      json['occupation'].forEach((v) {
        occupation!.add(OccupationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['ug_code'] = ugCode;
    data['skill_level'] = skillLevel;
    data['category_type'] = categoryType;
    if (occupation != null) {
      data['occupation'] = occupation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OccupationData {
  String? occupationCode;
  String? ugCode;
  String? occupationName;
  int? skillLevel;

  OccupationData(
      {this.occupationCode, this.ugCode, this.occupationName, this.skillLevel});

  OccupationData.fromJson(Map<String, dynamic> json) {
    occupationCode = json['occupation_code'];
    ugCode = json['ug_code'];
    occupationName = json['occupation_name'];
    skillLevel = json['skill_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occupation_code'] = occupationCode;
    data['ug_code'] = ugCode;
    data['occupation_name'] = occupationName;
    data['skill_level'] = skillLevel;
    return data;
  }
}
