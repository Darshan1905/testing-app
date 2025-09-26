class AccessingAuthDetailModel {
  bool? flag;
  String? message;
  List<AccessingAuthModel>? data;

  AccessingAuthDetailModel({this.flag, this.message, this.data});

  AccessingAuthDetailModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AccessingAuthModel>[];
      json['data'].forEach((v) {
        data!.add(AccessingAuthModel.fromJson(v));
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

class AccessingAuthModel {
  String? aaId;
  String? shortName;
  String? fullName;
  String? address;
  String? email;
  String? link;
  String? applicableFees;
  String? feesLink;
  String? processingTime;
  String? modeOfApplication;
  String? guideline;
  String? faqs;
  String? outcomeLattetAlidity;
  String? checkList;
  String? englishTest;
  String? englishTestTable;
  int? iVersion;
  String? effectiveDate;

  AccessingAuthModel(
      {this.aaId,
        this.shortName,
        this.fullName,
        this.address,
        this.email,
        this.link,
        this.applicableFees,
        this.feesLink,
        this.processingTime,
        this.modeOfApplication,
        this.guideline,
        this.faqs,
        this.outcomeLattetAlidity,
        this.checkList,
        this.englishTest,
        this.englishTestTable,
        this.iVersion,
        this.effectiveDate});

  AccessingAuthModel.fromJson(Map<String, dynamic> json) {
    aaId = json['aa_id'];
    shortName = json['short_name'];
    fullName = json['full_name'];
    address = json['address'];
    email = json['email'];
    link = json['link'];
    applicableFees = json['applicable_fees'];
    feesLink = json['fees_link'];
    processingTime = json['processing_time'];
    modeOfApplication = json['mode_of_application'];
    guideline = json['guideline'];
    faqs = json['faqs'];
    outcomeLattetAlidity = json['outcome_lattet_alidity'];
    checkList = json['check_list'];
    englishTest = json['english_test'];
    englishTestTable = json['english_test_table'];
    iVersion = json['_version'];
    effectiveDate = json['effective_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aa_id'] = aaId;
    data['short_name'] = shortName;
    data['full_name'] = fullName;
    data['address'] = address;
    data['email'] = email;
    data['link'] = link;
    data['applicable_fees'] = applicableFees;
    data['fees_link'] = feesLink;
    data['processing_time'] = processingTime;
    data['mode_of_application'] = modeOfApplication;
    data['guideline'] = guideline;
    data['faqs'] = faqs;
    data['outcome_lattet_alidity'] = outcomeLattetAlidity;
    data['check_list'] = checkList;
    data['english_test'] = englishTest;
    data['english_test_table'] = englishTestTable;
    data['_version'] = iVersion;
    data['effective_date'] = effectiveDate;
    return data;
  }
}