import 'package:occusearch/data_provider/api_service/base_response_model.dart';

class InvitationCutOffModel extends BaseResponseModel {
  List<InvitationCutOffRow>? invitationCutoffRowList;

  InvitationCutOffModel({this.invitationCutoffRowList});

  InvitationCutOffModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InvitationCutOffRow>[];
      json['data'].forEach((v) {
        data!.add(InvitationCutOffRow.fromJson(v));
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

class InvitationCutOffRow {
  String? months;
  String? effectiveDate;
  int? pointScore;

  InvitationCutOffRow({this.months,this.effectiveDate,this.pointScore});

  InvitationCutOffRow.fromJson(Map<String, dynamic> json) {
    months = json['months'];
    effectiveDate = json['effective_date'];
    pointScore = json['pointscore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['months'] = months;
    data['effective_date'] = effectiveDate;
    data['pointscore'] = pointScore;
    return data;
  }
}
