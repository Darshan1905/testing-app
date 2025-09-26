import 'package:occusearch/features/cricos_course/course_detail/model/add_course_data_model.dart';

class AddCourseJsonRequestModel {
  int? leadid;
  int? companyid;
  int? branchid;
  List<AddCourseData>? courses;

  AddCourseJsonRequestModel({this.leadid,this.companyid,this.branchid, this.courses});

  AddCourseJsonRequestModel.fromJson(Map<String, dynamic> json) {
    leadid = json['leadid'];
    companyid = json['companyid'];
    branchid = json['branchid'];
    if (json['courses'] != null) {
      courses = <AddCourseData>[];
      json['courses'].forEach((v) {
        courses!.add(AddCourseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leadid'] = leadid;
    data['companyid'] = companyid;
    data['branchid'] = branchid;
    if (courses != null) {
      data['courses'] = courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}