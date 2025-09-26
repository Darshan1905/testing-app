class CourseListModel {
  bool? flag;
  String? message;
  CourseListDataTemp? data;

  CourseListModel({this.flag, this.message, this.data});

  CourseListModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data =
        json['data'] != null ? CourseListDataTemp.fromJson(json['data']) : null;
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

class CourseListDataTemp {
  List<PageDetail>? pageDetail;
  List<CourseList>? courseList;

  CourseListDataTemp({this.pageDetail, this.courseList});

  CourseListDataTemp.fromJson(Map<String, dynamic> json) {
    if (json['page_detail'] != null) {
      pageDetail = <PageDetail>[];
      json['page_detail'].forEach((v) {
        pageDetail!.add(PageDetail.fromJson(v));
      });
    }
    if (json['course_list'] != null) {
      courseList = <CourseList>[];
      json['course_list'].forEach((v) {
        courseList!.add(CourseList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pageDetail != null) {
      data['page_detail'] = pageDetail!.map((v) => v.toJson()).toList();
    }
    if (courseList != null) {
      data['course_list'] = courseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PageDetail {
  int? totalPage;
  int? pageNo;

  PageDetail({this.totalPage, this.pageNo});

  PageDetail.fromJson(Map<String, dynamic> json) {
    totalPage = json['TotalPage'];
    pageNo = json['PageNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalPage'] = totalPage;
    data['PageNo'] = pageNo;
    return data;
  }
}

class CourseList {
  String? courseCode;
  String? ascedCode;
  String? courseName;
  String? courseLevel;
  String? institutionName;
  bool? isAdded = false; // User added course or not.

  CourseList(
      {this.courseCode,
      this.ascedCode,
      this.courseName,
      this.courseLevel,
      this.institutionName});

  CourseList.fromJson(Map<String, dynamic> json) {
    courseCode = json['course_code'];
    ascedCode = json['asced_code'];
    courseName = json['course_name'];
    courseLevel = json['course_level'];
    institutionName = json['institution_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['course_code'] = courseCode;
    data['asced_code'] = ascedCode;
    data['course_name'] = courseName;
    data['course_level'] = courseLevel;
    data['institution_name'] = institutionName;
    return data;
  }
}
