import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';

class UserModel {
  bool? flag;
  String? message;
  String? outdata;
  String? outdata1;
  List<DashboardDetails>? data;
  String? bytedata;

  UserModel(
      {this.flag,
      this.message,
      this.outdata,
      this.outdata1,
      this.data,
      this.bytedata});

  UserModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    outdata = json['outdata'];
    outdata1 = json['outdata1'];
    if (json['data'] != null) {
      data = <DashboardDetails>[];
      json['data'].forEach((v) {
        data!.add(DashboardDetails.fromJson(v));
      });
    }
    bytedata = json['bytedata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    data['outdata'] = outdata;
    data['outdata1'] = outdata1;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['bytedata'] = bytedata;
    return data;
  }
}

class DashboardDetails {
  int? companyid;
  String? companyname;
  String? companylogo;
  String? weburl;
  String? emailaddress;
  String? sociallink;
  String? companyphone;
  String? companywhatsappno;
  String? companycontact;
  String? addressline1;
  String? addressline2;
  String? cityname;
  String? statename;
  String? countryname;
  String? zipcode;
  String? pointscore;
  String? minimumreqpoint;
  String? totalpoint;
  String? updateddate;
  List<OccupationRowData>? occupations;
  List<CoursesRowData>? courses;

  DashboardDetails(
      {this.companyid,
      this.companyname,
      this.companylogo,
      this.weburl,
      this.emailaddress,
      this.sociallink,
      this.companyphone,
      this.companywhatsappno,
      this.companycontact,
      this.addressline1,
      this.addressline2,
      this.cityname,
      this.statename,
      this.countryname,
      this.zipcode,
      this.pointscore,
      this.minimumreqpoint,
      this.totalpoint,
      this.updateddate,
      this.occupations,
      this.courses});

  DashboardDetails.fromJson(Map<String, dynamic> json) {
    companyid = json['companyid'];
    companyname = json['companyname'];
    companylogo = json['companylogo'];
    weburl = json['weburl'];
    emailaddress = json['emailaddress'];
    sociallink = json['sociallink'];
    companyphone = json['companyphone'];
    companywhatsappno = json['companywhatsappno'];
    companycontact = json['companycontact'];
    addressline1 = json['addressline1'];
    addressline2 = json['addressline2'];
    cityname = json['cityname'];
    statename = json['statename'];
    countryname = json['countryname'];
    zipcode = json['zipcode'];
    pointscore = json['pointscore'];
    minimumreqpoint = json['minimumreqpoint'];
    totalpoint = json['totalpoint'];
    updateddate = json['updateddate'];
    if (json['occupations'] != null) {
      occupations = <OccupationRowData>[];
      json['occupations'].forEach((v) {
        occupations!.add(OccupationRowData.fromJson(v));
      });
    }
    if (json['courses'] != null) {
      courses = <CoursesRowData>[];
      json['courses'].forEach((v) {
        courses!.add(CoursesRowData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyid'] = companyid;
    data['companyname'] = companyname;
    data['companylogo'] = companylogo;
    data['weburl'] = weburl;
    data['emailaddress'] = emailaddress;
    data['sociallink'] = sociallink;
    data['companyphone'] = companyphone;
    data['companywhatsappno'] = companywhatsappno;
    data['companycontact'] = companycontact;
    data['addressline1'] = addressline1;
    data['addressline2'] = addressline2;
    data['cityname'] = cityname;
    data['statename'] = statename;
    data['countryname'] = countryname;
    data['zipcode'] = zipcode;
    data['pointscore'] = pointscore;
    data['minimumreqpoint'] = minimumreqpoint;
    data['totalpoint'] = totalpoint;
    data['updateddate'] = updateddate;
    if (occupations != null) {
      data['occupations'] = occupations!.map((v) => v.toJson()).toList();
    }
    if (courses != null) {
      data['courses'] = courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoursesRowData {
  String? ascedCode;
  String? cricosCode;
  String? courseName;

  CoursesRowData({this.ascedCode, this.cricosCode, this.courseName});

  CoursesRowData.fromJson(Map<String, dynamic> json) {
    ascedCode = json['asced_code'];
    cricosCode = json['cricos_code'];
    courseName = json['course_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asced_code'] = ascedCode;
    data['cricos_code'] = cricosCode;
    data['course_name'] = courseName;
    return data;
  }
}
