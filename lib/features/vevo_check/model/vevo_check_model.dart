import 'dart:convert';
import 'package:occusearch/utility/extension.dart';

class CheckMyVisaModel {
  bool? flag;
  String? message;
  VevoVisaDetailModel? data;
  int? count;
  String? filePath;

  CheckMyVisaModel(
      {this.flag, this.message, this.data, this.count, this.filePath});

  CheckMyVisaModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];

    if (json['data'] != null && json['data'] != "") {
      var temp = (json['data']).toString().removeSquareBracketFromString();
      data = VevoVisaDetailModel.fromJson(jsonDecode(temp));
    } else {
      data = null;
    }

    count = json['count'];
    filePath = json['filePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    data['count'] = count;
    data['filePath'] = filePath;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class VevoVisaDetailModel {
  String? familyName;
  String? givenName;
  String? visaDescription;
  String? documentNumber;
  String? visaClassSubclass;
  String? educationSector;
  String? visaApplicant;
  String? visaGrantDate;
  String? visaExpiryDate;
  String? location;
  String? visaStatus;
  String? visaGrantNumber;
  String? entriesAllowed;
  String? mustNotArriveAfter;
  String? periodOfStay;
  String? visaType;
  String? visaConditions;
  String? workEntitlements;
  String? workplaceRights;
  String? studyEntitlements;

  VevoVisaDetailModel(
      {this.familyName,
        this.givenName,
        this.visaDescription,
        this.documentNumber,
        this.visaClassSubclass,
        this.educationSector,
        this.visaApplicant,
        this.visaGrantDate,
        this.visaExpiryDate,
        this.location,
        this.visaStatus,
        this.visaGrantNumber,
        this.entriesAllowed,
        this.mustNotArriveAfter,
        this.periodOfStay,
        this.visaType,
        this.visaConditions,
        this.workEntitlements,
        this.workplaceRights,
        this.studyEntitlements});

  VevoVisaDetailModel.fromJson(Map<String, dynamic> json) {
    familyName = json['Family_name'];
    givenName = json['Given_name'];
    visaDescription = json['Visa_description'];
    documentNumber = json['Document_number'];
    visaClassSubclass = json['Visa_class_subclass'];
    educationSector = json['Education_Sector'];
    visaApplicant = json['Visa_applicant'];
    visaGrantDate = json['Visa_grant_date'];
    visaExpiryDate = json['Visa_expiry_date'];
    location = json['Location'];
    visaStatus = json['Visa_status'];
    visaGrantNumber = json['Visa_grant_number'];
    entriesAllowed = json['Entries_allowed'];
    mustNotArriveAfter = json['Must_not_arrive_after'];
    periodOfStay = json['Period_of_stay'];
    visaType = json['Visa_type'];
    visaConditions = json['Visa_conditions'];
    workEntitlements = json['Work_entitlements'];
    workplaceRights = json['Workplace_rights'];
    studyEntitlements = json['Study_entitlements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Family_name'] = familyName;
    data['Given_name'] = givenName;
    data['Visa_description'] = visaDescription;
    data['Document_number'] = documentNumber;
    data['Visa_class_subclass'] = visaClassSubclass;
    data['Education_Sector'] = educationSector;
    data['Visa_applicant'] = visaApplicant;
    data['Visa_grant_date'] = visaGrantDate;
    data['Visa_expiry_date'] = visaExpiryDate;
    data['Location'] = location;
    data['Visa_status'] = visaStatus;
    data['Visa_grant_number'] = visaGrantNumber;
    data['Entries_allowed'] = entriesAllowed;
    data['Must_not_arrive_after'] = mustNotArriveAfter;
    data['Period_of_stay'] = periodOfStay;
    data['Visa_type'] = visaType;
    data['Visa_conditions'] = visaConditions;
    data['Work_entitlements'] = workEntitlements;
    data['Workplace_rights'] = workplaceRights;
    data['Study_entitlements'] = studyEntitlements;
    return data;
  }
}
