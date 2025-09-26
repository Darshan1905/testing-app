import '../../../../constants/constants.dart';

class CourseDetailModel {
  bool? flag;
  String? message;
  CourseDetailData? data;

  CourseDetailModel({this.flag, this.message, this.data});

  CourseDetailModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null
        ? CourseDetailData.fromJson(json['data'])
        : null;
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

class CourseDetailData {
  String? id;
  String? courseName;
  String? courseCode;
  String? ascedCode;
  String? universityCode;
  String? description;
  String? programCode;
  String? nationalCode;
  String? dualQualification;
  String? foeBroadField1;
  String? foeNarrowField1;
  String? foeDetailedField1;
  String? foeBroadField2;
  String? foeNarrowField2;
  String? foeDetailedField2;
  String? foundationStudies;
  String? workComponent;
  String? wcHoursWeek;
  String? wcWeeks;
  String? wcTotalHours;
  String? courseLanguage;
  String? areaOfStudy;
  String? durationWeeks;
  String? tutionFee;
  String? nonTutionFee;
  String? totalFee;
  String? expired;
  String? studyMode;
  String? intake;
  String? intakeMonth;
  String? courseOutlineLink;
  String? courseOutcomeLink;
  String? courseLevel;
  String? deliveryMode;
  String? languageRequirement;
  String? admissionRequirement;
  String? academicRequirement;
  String? courseDiscipline;
  String? careerOutcome;
  String? courseOutline;
  String? durationPartTime;
  String? durationPartTimeUnit;
  String? durationPartTimeFee;
  String? durationFullTime;
  String? durationFullTimeUnit;
  String? durationFullTimeFee;
  String? campusCode;
  String? courseCity;
  String? courseState;
  String? skillLevel;
  String? campusId;
  String? campusName;
  List<CampusLocation>? campusLocation;
  String? campusLocationType;
  String? campusAddress1;
  String? campusAddress2;
  String? campusAddress3;
  String? campusAddress4;
  String? campusCity;
  String? campusState;
  String? campusPostcode;
  String? campusMode;
  String? institutionId;
  String? institutionCode;
  String? institutionTradingName;
  String? institutionName;
  String? instituteType;
  String? instituteCapacity;
  String? institutionLogo;
  String? institutionLocation;
  String? institutionAddress1;
  String? institutionAddress2;
  String? institutionAddress3;
  String? institutionAddress4;
  String? instituteCity;
  String? instituteState;
  String? institutePostcode;
  String? instituteCricos;
  String? universityCampusLocation;
  String? instituteWebsite;
  List<UgCode>? ugCode;

  CourseDetailData(
      {this.id,
        this.courseName,
        this.courseCode,
        this.ascedCode,
        this.universityCode,
        this.description,
        this.programCode,
        this.nationalCode,
        this.dualQualification,
        this.foeBroadField1,
        this.foeNarrowField1,
        this.foeDetailedField1,
        this.foeBroadField2,
        this.foeNarrowField2,
        this.foeDetailedField2,
        this.foundationStudies,
        this.workComponent,
        this.wcHoursWeek,
        this.wcWeeks,
        this.wcTotalHours,
        this.courseLanguage,
        this.areaOfStudy,
        this.durationWeeks,
        this.tutionFee,
        this.nonTutionFee,
        this.totalFee,
        this.expired,
        this.studyMode,
        this.intake,
        this.intakeMonth,
        this.courseOutlineLink,
        this.courseOutcomeLink,
        this.courseLevel,
        this.deliveryMode,
        this.languageRequirement,
        this.admissionRequirement,
        this.academicRequirement,
        this.courseDiscipline,
        this.careerOutcome,
        this.courseOutline,
        this.durationPartTime,
        this.durationPartTimeUnit,
        this.durationPartTimeFee,
        this.durationFullTime,
        this.durationFullTimeUnit,
        this.durationFullTimeFee,
        this.campusCode,
        this.courseCity,
        this.courseState,
        this.skillLevel,
        this.campusId,
        this.campusName,
        this.campusLocation,
        this.campusLocationType,
        this.campusAddress1,
        this.campusAddress2,
        this.campusAddress3,
        this.campusAddress4,
        this.campusCity,
        this.campusState,
        this.campusPostcode,
        this.campusMode,
        this.institutionId,
        this.institutionCode,
        this.institutionTradingName,
        this.institutionName,
        this.instituteType,
        this.instituteCapacity,
        this.institutionLogo,
        this.institutionLocation,
        this.institutionAddress1,
        this.institutionAddress2,
        this.institutionAddress3,
        this.institutionAddress4,
        this.instituteCity,
        this.instituteState,
        this.institutePostcode,
        this.instituteCricos,
        this.universityCampusLocation,
        this.instituteWebsite,
        this.ugCode});

  CourseDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseName = json['course_name'];
    courseCode = json['course_code'];
    ascedCode = json['asced_code'];
    universityCode = json['university_code'];
    description = json['description'];
    programCode = json['program_code'];
    nationalCode = json['national_code'];
    dualQualification = json['dual_qualification'];
    foeBroadField1 = json['foe_broad_field1'];
    foeNarrowField1 = json['foe_narrow_field1'];
    foeDetailedField1 = json['foe_detailed_field1'];
    foeBroadField2 = json['foe_broad_field2'];
    foeNarrowField2 = json['foe_narrow_field2'];
    foeDetailedField2 = json['foe_detailed_field2'];
    foundationStudies = json['foundation_studies'];
    workComponent = json['work_component'];
    wcHoursWeek = json['wc_hours_week'];
    wcWeeks = json['wc_weeks'];
    wcTotalHours = json['wc_total_hours'];
    courseLanguage = json['course_language'];
    areaOfStudy = json['area_of_study'];
    durationWeeks = json['duration_weeks'];
    tutionFee = json['tution_fee'];
    nonTutionFee = json['non_tution_fee'];
    totalFee = json['total_fee'];
    expired = json['expired'];
    studyMode = json['study_mode'];
    intake = json['intake'];
    intakeMonth = json['intake_month'];
    courseOutlineLink = json['course_outline_link'];
    courseOutcomeLink = json['course_outcome_link'];
    courseLevel = json['course_level'];
    deliveryMode = json['delivery_mode'];
    languageRequirement = json['language_requirement'];
    admissionRequirement = json['admission_requirement'];
    academicRequirement = json['academic_requirement'];
    courseDiscipline = json['course_discipline'];
    careerOutcome = json['career_outcome'];
    courseOutline = json['course_outline'];
    durationPartTime = json['duration_part_time'];
    durationPartTimeUnit = json['duration_part_time_unit'];
    durationPartTimeFee = json['duration_part_time_fee'];
    durationFullTime = json['duration_full_time'];
    durationFullTimeUnit = json['duration_full_time_unit'];
    durationFullTimeFee = json['duration_full_time_fee'];
    campusCode = json['campus_code'];
    courseCity = json['course_city'];
    courseState = json['course_state'];
    skillLevel = json['skill_level'];
    campusId = json['campus_id'];
    campusName = json['campus_name'];
    if (json['campus_location'] != null) {
      campusLocation = <CampusLocation>[];
      json['campus_location'].forEach((v) {
        campusLocation!.add(CampusLocation.fromJson(v));
      });
    }
    campusLocationType = json['campus_location_type'];
    campusAddress1 = json['campus_address_1'];
    campusAddress2 = json['campus_address_2'];
    campusAddress3 = json['campus_address_3'];
    campusAddress4 = json['campus_address_4'];
    campusCity = json['campus_city'];
    campusState = json['campus_state'];
    campusPostcode = json['campus_postcode'];
    campusMode = json['campus_mode'];
    institutionId = json['institution_id'];
    institutionCode = json['institution_code'];
    institutionTradingName = json['institution_trading_name'];
    institutionName = json['institution_name'];
    instituteType = json['institute_type'];
    instituteCapacity = json['institute_capacity'];
    institutionLogo = json['institution_logo'];
    institutionLocation = json['institution_location'];
    institutionAddress1 = json['institution_address_1'];
    institutionAddress2 = json['institution_address_2'];
    institutionAddress3 = json['institution_address_3'];
    institutionAddress4 = json['institution_address_4'];
    instituteCity = json['institute_city'];
    instituteState = json['institute_state'];
    institutePostcode = json['institute_postcode'];
    instituteCricos = json['institute_cricos'];
    universityCampusLocation = json['university_campus_location'];
    instituteWebsite = json['institute_website'];
    if (json['ug_code'] != null) {
      ugCode = <UgCode>[];
      json['ug_code'].forEach((v) {
        ugCode!.add(UgCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['course_name'] = courseName;
    data['course_code'] = courseCode;
    data['asced_code'] = ascedCode;
    data['university_code'] = universityCode;
    data['description'] = description;
    data['program_code'] = programCode;
    data['national_code'] = nationalCode;
    data['dual_qualification'] = dualQualification;
    data['foe_broad_field1'] = foeBroadField1;
    data['foe_narrow_field1'] = foeNarrowField1;
    data['foe_detailed_field1'] = foeDetailedField1;
    data['foe_broad_field2'] = foeBroadField2;
    data['foe_narrow_field2'] = foeNarrowField2;
    data['foe_detailed_field2'] = foeDetailedField2;
    data['foundation_studies'] = foundationStudies;
    data['work_component'] = workComponent;
    data['wc_hours_week'] = wcHoursWeek;
    data['wc_weeks'] = wcWeeks;
    data['wc_total_hours'] = wcTotalHours;
    data['course_language'] = courseLanguage;
    data['area_of_study'] = areaOfStudy;
    data['duration_weeks'] = durationWeeks;
    data['tution_fee'] = tutionFee;
    data['non_tution_fee'] = nonTutionFee;
    data['total_fee'] = totalFee;
    data['expired'] = expired;
    data['study_mode'] = studyMode;
    data['intake'] = intake;
    data['intake_month'] = intakeMonth;
    data['course_outline_link'] = courseOutlineLink;
    data['course_outcome_link'] = courseOutcomeLink;
    data['course_level'] = courseLevel;
    data['delivery_mode'] = deliveryMode;
    data['language_requirement'] = languageRequirement;
    data['admission_requirement'] = admissionRequirement;
    data['academic_requirement'] = academicRequirement;
    data['course_discipline'] = courseDiscipline;
    data['career_outcome'] = careerOutcome;
    data['course_outline'] = courseOutline;
    data['duration_part_time'] = durationPartTime;
    data['duration_part_time_unit'] = durationPartTimeUnit;
    data['duration_part_time_fee'] = durationPartTimeFee;
    data['duration_full_time'] = durationFullTime;
    data['duration_full_time_unit'] = durationFullTimeUnit;
    data['duration_full_time_fee'] = durationFullTimeFee;
    data['campus_code'] = campusCode;
    data['course_city'] = courseCity;
    data['course_state'] = courseState;
    data['skill_level'] = skillLevel;
    data['campus_id'] = campusId;
    data['campus_name'] = campusName;
    if (campusLocation != null) {
      data['campus_location'] =
          campusLocation!.map((v) => v.toJson()).toList();
    }
    data['campus_location_type'] = campusLocationType;
    data['campus_address_1'] = campusAddress1;
    data['campus_address_2'] = campusAddress2;
    data['campus_address_3'] = campusAddress3;
    data['campus_address_4'] = campusAddress4;
    data['campus_city'] = campusCity;
    data['campus_state'] = campusState;
    data['campus_postcode'] = campusPostcode;
    data['campus_mode'] = campusMode;
    data['institution_id'] = institutionId;
    data['institution_code'] = institutionCode;
    data['institution_trading_name'] = institutionTradingName;
    data['institution_name'] = institutionName;
    data['institute_type'] = instituteType;
    data['institute_capacity'] = instituteCapacity;
    data['institution_logo'] = institutionLogo;
    data['institution_location'] = institutionLocation;
    data['institution_address_1'] = institutionAddress1;
    data['institution_address_2'] = institutionAddress2;
    data['institution_address_3'] = institutionAddress3;
    data['institution_address_4'] = institutionAddress4;
    data['institute_city'] = instituteCity;
    data['institute_state'] = instituteState;
    data['institute_postcode'] = institutePostcode;
    data['institute_cricos'] = instituteCricos;
    data['university_campus_location'] = universityCampusLocation;
    data['institute_website'] = instituteWebsite;
    if (ugCode != null) {
      data['ug_code'] = ugCode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CampusLocation {
  String? name;
  String? city;
  String? state;

  CampusLocation({this.name, this.city, this.state});

  CampusLocation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['city'] = city;
    data['state'] = state;
    return data;
  }
}

class UgCode {
  String? uniqueUgCode;
  String? ugName;
  List<OData>? oData;

  UgCode({this.uniqueUgCode, this.ugName, this.oData});

  UgCode.fromJson(Map<String, dynamic> json) {
    uniqueUgCode = json['unique_ug_code'];
    ugName = json['ug_name'];
    if (json['o_data'] != null) {
      oData = <OData>[];
      json['o_data'].forEach((v) {
        oData!.add(OData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unique_ug_code'] = uniqueUgCode;
    data['ug_name'] = ugName;
    if (oData != null) {
      data['o_data'] = oData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OData {
  String? occupationCode;
  String? occupationName;
  String? ascedCode;
  String? mainOccupationCode;
  int? skillLevel;
  String? ugCode;
  Color? randomColor = Utility.getRandomBGColor();

  OData(
      {this.occupationCode,
      this.occupationName,
      this.ascedCode,
      this.mainOccupationCode,
      this.skillLevel,
      this.ugCode});

  OData.fromJson(Map<String, dynamic> json) {
    occupationCode = json['occupation_code'];
    occupationName = json['occupation_name'];
    ascedCode = json['asced_code'];
    mainOccupationCode = json['main_occupation_code'];
    skillLevel = json['skill_level'];
    ugCode = json['ug_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occupation_code'] = occupationCode;
    data['occupation_name'] = occupationName;
    data['asced_code'] = ascedCode;
    data['main_occupation_code'] = mainOccupationCode;
    data['skill_level'] = skillLevel;
    data['ug_code'] = ugCode;
    return data;
  }
}
