// ignore_for_file: overridden_fields

import 'package:occusearch/data_provider/api_service/base_response_model.dart';

class PointScoreModel extends BaseResponseModel {
  @override
  bool? flag;
  @override
  String? message;
  InvitationCutoffScoreModel? invitationCutoffScoreData;

  PointScoreModel({this.flag, this.message, this.invitationCutoffScoreData});

  PointScoreModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null ? InvitationCutoffScoreModel.fromJson(json['data']) : null;
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

class InvitationCutoffScoreModel {
  List<Ugpointscore>? ugpointscore;
  List<Visascore189>? visascore189;
  List<Visascore491>? visascore491;

  InvitationCutoffScoreModel({this.ugpointscore, this.visascore189, this.visascore491});

  InvitationCutoffScoreModel.fromJson(Map<String, dynamic> json) {
    if (json['ugpointscore'] != null) {
      ugpointscore = <Ugpointscore>[];
      json['ugpointscore'].forEach((v) {
        ugpointscore!.add(Ugpointscore.fromJson(v));
      });
    }
    if (json['visascore189'] != null) {
      visascore189 = <Visascore189>[];
      json['visascore189'].forEach((v) {
        visascore189!.add(Visascore189.fromJson(v));
      });
    }
    if (json['visascore491'] != null) {
      visascore491 = <Visascore491>[];
      json['visascore491'].forEach((v) {
        visascore491!.add(Visascore491.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ugpointscore != null) {
      data['ugpointscore'] = ugpointscore!.map((v) => v.toJson()).toList();
    }
    if (visascore189 != null) {
      data['visascore189'] = visascore189!.map((v) => v.toJson()).toList();
    }
    if (visascore491 != null) {
      data['visascore491'] = visascore491!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ugpointscore {
  int? ugPointScore;
  String? effectiveDate;
  int? visaSubclass;

  Ugpointscore({this.ugPointScore, this.effectiveDate, this.visaSubclass});

  Ugpointscore.fromJson(Map<String, dynamic> json) {
    ugPointScore = json['ug_point_score'];
    effectiveDate = json['effective_date'];
    visaSubclass = json['visa_subclass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ug_point_score'] = ugPointScore;
    data['effective_date'] = effectiveDate;
    data['visa_subclass'] = visaSubclass;
    return data;
  }
}

class Visascore189 {
  String? effectiveDate;
  int? visaPointScore;
  String? visaSubclass;

  Visascore189({this.effectiveDate, this.visaPointScore, this.visaSubclass});

  Visascore189.fromJson(Map<String, dynamic> json) {
    effectiveDate = json['effective_date'];
    visaPointScore = json['visa_point_score'];
    visaSubclass = json['visa_subclass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['effective_date'] = effectiveDate;
    data['visa_point_score'] = visaPointScore;
    data['visa_subclass'] = visaSubclass;
    return data;
  }
}

class Visascore491 {
  String? effectiveDate;
  int? visaPointScore;
  String? visaSubclass;

  Visascore491({this.effectiveDate, this.visaPointScore, this.visaSubclass});

  Visascore491.fromJson(Map<String, dynamic> json) {
    effectiveDate = json['effective_date'];
    visaPointScore = json['visa_point_score'];
    visaSubclass = json['visa_subclass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['effective_date'] = effectiveDate;
    data['visa_point_score'] = visaPointScore;
    data['visa_subclass'] = visaSubclass;
    return data;
  }
}
