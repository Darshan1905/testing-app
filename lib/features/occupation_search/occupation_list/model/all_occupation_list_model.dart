import 'package:occusearch/data_provider/api_service/base_response_model.dart';

class AllOccupationModel extends BaseResponseModel {
  List<OccupationRowData>? occupationData;

  AllOccupationModel.fromJson(dynamic json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OccupationRowData>[];
      json['data'].forEach((v) {
        data!.add(OccupationRowData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['flag'] = flag;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OccupationRowData {
  String? id;
  String? mainId;
  String? name;
  bool? isAdded; // occupation added or not
  String? skillLevel; // occupation skillLevel Value
  int? visitCount; //user's occupation visit count

  OccupationRowData({this.id, this.mainId, this.name,this.isAdded,this.skillLevel, this.visitCount});

  OccupationRowData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainId = json['mainId'];
    name = json['name'];
    isAdded = json['isAdded'] ?? false;
    skillLevel = json['skillLevel'] ?? "0";
    visitCount = json['visit_count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mainId'] = mainId;
    data['name'] = name;
    data['isAdded'] = isAdded;
    data['skillLevel'] = skillLevel;
    data['visit_count'] = visitCount;
    return data;
  }
}
