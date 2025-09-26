class PromoCodeListModel {
  String? planname;
  int? planid;
  String? promocode;
  String? promodetails;
  String? noofdays;
  String? startdate;
  String? enddate;
  UsesCount? noofuses;

  PromoCodeListModel(
      {this.planname,
      this.planid,
      this.promocode,
      this.promodetails,
      this.noofdays,
      this.startdate,
      this.enddate,
      this.noofuses});

  PromoCodeListModel.fromJson(Map<String, dynamic> json) {
    planname = json['planname'];
    planid = json['planid'];
    promocode = json['promocode'];
    promodetails = json['promodetails'];
    noofdays = json['noofdays'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    noofuses = json['noofuses'] != null ? UsesCount.fromJson(json['noofuses']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['planname'] = planname;
    data['planid'] = planid;
    data['promocode'] = promocode;
    data['promodetails'] = promodetails;
    data['noofdays'] = noofdays;
    data['startdate'] = startdate;
    data['enddate'] = enddate;
    if (noofuses != null) {
      data['noofuses'] = noofuses!.toJson();
    }
    return data;
  }
}

class UsesCount {
  int? android;
  int? iPhone;

  UsesCount({this.android, this.iPhone});

  UsesCount.fromJson(Map<String, dynamic> json) {
    android = json['android'];
    iPhone = json['iPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android'] = android;
    data['iPhone'] = iPhone;
    return data;
  }
}


class PromoCodeListResponse {
  bool? flag;
  String? message;
  List<PromoCodeListModel>? data;

  PromoCodeListResponse({this.flag, this.message, this.data});

  PromoCodeListResponse.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PromoCodeListModel>[];
      json['data'].forEach((v) {
        data!.add(new PromoCodeListModel.fromJson(v));
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

