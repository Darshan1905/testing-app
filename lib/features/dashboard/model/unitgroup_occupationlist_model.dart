class UnitGroupOccupationListModel {
  String? occupationCode;
  String? occupationName;
  bool? isLoading;
  List<OccupationDataList>? occupationDataList;

  UnitGroupOccupationListModel.loading(this.isLoading);

  UnitGroupOccupationListModel(
      {this.occupationCode, this.occupationName, this.occupationDataList});

  UnitGroupOccupationListModel.fromJson(Map<String, dynamic> json) {
    occupationCode = json['occupationCode'];
    occupationName = json['occupationName'];
    if (json['occupationDataList'] != null) {
      occupationDataList = <OccupationDataList>[];
      json['occupationDataList'].forEach((v) {
        occupationDataList!.add(OccupationDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occupationCode'] = occupationCode;
    data['occupationName'] = occupationName;
    if (occupationDataList != null) {
      data['occupationDataList'] =
          occupationDataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OccupationDataList {
  String? occCode;
  String? occName;
  String? ugCode;
  int? skillLevel;

  OccupationDataList(
      {this.occCode, this.occName, this.ugCode, this.skillLevel});

  OccupationDataList.fromJson(Map<String, dynamic> json) {
    occCode = json['occCode'];
    occName = json['occName'];
    ugCode = json['ugCode'];
    skillLevel = json['skillLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occCode'] = occCode;
    data['occName'] = occName;
    data['ugCode'] = ugCode;
    data['skillLevel'] = skillLevel;
    return data;
  }
}
