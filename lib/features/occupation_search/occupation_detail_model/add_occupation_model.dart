

import 'occupations_model.dart';

/// userid : 12
/// occupations : [{"id":"111111","mainId":"111111","name":"CHIEF EXECUTIVE OR MANAGING DIRECTOR"},{"id":"111211","mainId":"111211","name":"CORPORATE GENERAL MANAGER"}]
class AddOccupationJsonRequestModel {
  int? userid;
  List<OccupationData>? occupations;

  AddOccupationJsonRequestModel({this.userid, this.occupations});

  AddOccupationJsonRequestModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    if (json['occupations'] != null) {
      occupations = <OccupationData>[];
      json['occupations'].forEach((v) {
        occupations!.add(OccupationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    if (occupations != null) {
      data['occupations'] = occupations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}