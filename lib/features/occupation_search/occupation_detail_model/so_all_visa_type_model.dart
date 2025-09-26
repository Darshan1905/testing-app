class AllVisaTypeModel {
  bool? flag;
  String? message;
  List<VisaTypeRow>? data;

  AllVisaTypeModel({this.flag, this.message, this.data});

  AllVisaTypeModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VisaTypeRow>[];
      json['data'].forEach((v) {
        data!.add(VisaTypeRow.fromJson(v));
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

class VisaTypeRow {
  int? rNo;
  String? eligibilityList;
  int? isEligible;
  String? visaType;
  String? legislativeInstrument;
  String? liLink;
  String? link;
  int? showOrder;
  String? shortName;
  String? visaStream;

  VisaTypeRow(
      {this.rNo,
        this.eligibilityList,
        this.isEligible,
        this.visaType,
        this.legislativeInstrument,
        this.liLink,
        this.link,
        this.showOrder,
        this.shortName,
        this.visaStream});

  VisaTypeRow.fromJson(Map<String, dynamic> json) {
    rNo = json['RNo'];
    eligibilityList = json['eligibility_list'];
    isEligible = json['is_eligible'];
    visaType = json['visa_type'];
    legislativeInstrument = json['legislative_instrument'];
    liLink = json['li_link'];
    link = json['link'];
    showOrder = json['show_order'];
    shortName = json['short_name'];
    visaStream = json['visa_stream'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RNo'] = rNo;
    data['eligibility_list'] = eligibilityList;
    data['is_eligible'] = isEligible;
    data['visa_type'] = visaType;
    data['legislative_instrument'] = legislativeInstrument;
    data['li_link'] = liLink;
    data['link'] = link;
    data['show_order'] = showOrder;
    data['short_name'] = shortName;
    data['visa_stream'] = visaStream;
    return data;
  }
}