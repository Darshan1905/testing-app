class OccupationOtherInfoModel {
  bool? flag;
  String? message;
  List<OtherInfoData>? data;

  OccupationOtherInfoModel({this.flag, this.message, this.data});

  OccupationOtherInfoModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OtherInfoData>[];
      json['data'].forEach((v) {
        data!.add(OtherInfoData.fromJson(v));
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

class OtherInfoData {
  String? occupationCode;
  String? mainOccupationCode;
  String? occupationName;
  String? alternativeTitle;
  // [START]
  // specialisation data
  String? specialisation;
  // [END]
  String? mgCode;
  String? migCode;
  String? smgCode;
  String? ugCode;
  int? skillLevel;
  String? description;
  String? mgName;
  String? migName;
  String? smgName;
  String? ugName;
  String? ugDescription;
  String? ugIndicativeSkillLevel;
  String? ugTaskInclude;
  String? assessingAuthorith;
  String? sourceLink;
  String? updatedDate;
  int? curYear;
  String? invitationNumbers;
  String? ceilingValue;
  String? cYear;
  String? prefix;
  String? updatedDateCeiling;

  OtherInfoData(
      {this.occupationCode,
        this.mainOccupationCode,
        this.occupationName,
        this.alternativeTitle,
        this.specialisation,
        this.mgCode,
        this.migCode,
        this.smgCode,
        this.ugCode,
        this.skillLevel,
        this.description,
        this.mgName,
        this.migName,
        this.smgName,
        this.ugName,
        this.ugDescription,
        this.ugIndicativeSkillLevel,
        this.ugTaskInclude,
        this.assessingAuthorith,
        this.sourceLink,
        this.updatedDate,
        this.curYear,
        this.invitationNumbers,
        this.ceilingValue,
        this.cYear,
        this.prefix,
        this.updatedDateCeiling});

  OtherInfoData.fromJson(Map<String, dynamic> json) {
    occupationCode = json['occupation_code'];
    mainOccupationCode = json['main_occupation_code'];
    occupationName = json['occupation_name'];
    alternativeTitle = json['alternative_title'];
    specialisation = json['specialisation'];
    mgCode = json['mg_code'];
    migCode = json['mig_code'];
    smgCode = json['smg_code'];
    ugCode = json['ug_code'];
    skillLevel = json['skill_level'];
    description = json['description'];
    mgName = json['mg_name'];
    migName = json['mig_name'];
    smgName = json['smg_name'];
    ugName = json['ug_name'];
    ugDescription = json['ug_description'];
    ugIndicativeSkillLevel = json['ug_indicative_skill_level'];
    ugTaskInclude = json['ug_task_include'];
    assessingAuthorith = json['assessing_authorith'];
    sourceLink = json['source_link'];
    updatedDate = json['updated_date'];
    curYear = json['cur_year'];
    invitationNumbers = json['invitation_numbers'];
    ceilingValue = json['ceiling_value'];
    cYear = json['c_year'];
    prefix = json['prefix'];
    updatedDateCeiling = json['updated_date_ceiling'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occupation_code'] = occupationCode;
    data['main_occupation_code'] = mainOccupationCode;
    data['occupation_name'] = occupationName;
    data['alternative_title'] = alternativeTitle;
    data['specialisation'] = specialisation;
    data['mg_code'] = mgCode;
    data['mig_code'] = migCode;
    data['smg_code'] = smgCode;
    data['ug_code'] = ugCode;
    data['skill_level'] = skillLevel;
    data['description'] = description;
    data['mg_name'] = mgName;
    data['mig_name'] = migName;
    data['smg_name'] = smgName;
    data['ug_name'] = ugName;
    data['ug_description'] = ugDescription;
    data['ug_indicative_skill_level'] = ugIndicativeSkillLevel;
    data['ug_task_include'] = ugTaskInclude;
    data['assessing_authorith'] = assessingAuthorith;
    data['source_link'] = sourceLink;
    data['updated_date'] = updatedDate;
    data['cur_year'] = curYear;
    data['invitation_numbers'] = invitationNumbers;
    data['ceiling_value'] = ceilingValue;
    data['c_year'] = cYear;
    data['prefix'] = prefix;
    data['updated_date_ceiling'] = updatedDateCeiling;
    return data;
  }
}