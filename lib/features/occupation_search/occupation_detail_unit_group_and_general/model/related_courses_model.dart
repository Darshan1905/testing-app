class RelatedCoursesModel {
  RelatedCoursesModel({
    this.flag,
    this.message,
    this.data,
  });

  RelatedCoursesModel.fromJson(dynamic json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? flag;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['flag'] = flag;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    this.courseList,
  });

  Data.fromJson(dynamic json) {
    if (json['course_list'] != null) {
      courseList = [];
      json['course_list'].forEach((v) {
        courseList?.add(RelatedCoursesList.fromJson(v));
      });
    }
  }

  List<RelatedCoursesList>? courseList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (courseList != null) {
      map['course_list'] = courseList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RelatedCoursesList {
  RelatedCoursesList({
    this.courseCode,
    this.courseName,
    this.instituteName,
    this.ascedCode,
  });

  RelatedCoursesList.fromJson(dynamic json) {
    courseCode = json['course_code'];
    courseName = json['course_name'];
    instituteName = json['institute_name'];
    ascedCode = json['asced_code'];
  }

  String? courseCode;
  String? courseName;
  String? instituteName;
  String? ascedCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['course_code'] = courseCode;
    map['course_name'] = courseName;
    map['institute_name'] = instituteName;
    map['asced_code'] = ascedCode;
    return map;
  }
}
