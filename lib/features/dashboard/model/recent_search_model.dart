class RecentSearchModel {
  List<RecentSearchData>? data;

  RecentSearchModel({this.data});

  RecentSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RecentSearchData>[];
      json['data'].forEach((v) {
        data!.add(RecentSearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentSearchData {
  String? name;
  String? code;
  String? mainId;
  int? skillLevel;
  String? type;
  int? timestamp;

  RecentSearchData(
      {this.name,
      this.code,
      this.mainId,
      this.skillLevel,
      this.type,
      this.timestamp});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['code'] = code;
    map['mainId'] = mainId;
    map['skillLevel'] = skillLevel;
    map['type'] = type;
    map['timestamp'] = timestamp;
    return map;
  }

  RecentSearchData.fromJson(dynamic json) {
    name = json["name"];
    code = json["code"];
    mainId = json["mainId"];
    skillLevel = json["skillLevel"];
    type = json["type"];
    skillLevel = json["skillLevel"];
    timestamp = json["timestamp"];
  }
}
