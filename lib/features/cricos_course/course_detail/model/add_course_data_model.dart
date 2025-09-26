class AddCourseData {
  String? ascedCode;
  String? cricos;
  String? courseName;

  AddCourseData({this.ascedCode, this.cricos, this.courseName});

  AddCourseData.fromJson(Map<String, dynamic> json) {
    ascedCode = json['ascedcode'];
    cricos = json['cricoscode'];
    courseName = json['coursename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ascedcode'] = ascedCode;
    data['cricoscode'] = cricos;
    data['coursename'] = courseName;
    return data;
  }
}
