class UnitGroupAndGeneralDetailModel {
  bool? flag;
  String? message;
  Data? data;

  UnitGroupAndGeneralDetailModel({this.flag, this.message, this.data});

  UnitGroupAndGeneralDetailModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<OccupationOtherInfoData>? occupationData;
  List<UgPointScore>? ugPointScore;
  List<CaveatNotes>? caveatNotes;
  List<RelatedOccupation>? relatedOccupation;
  List<EmploymentStatistics>? employmentStatistics;
  List<WeeklyEarning>? weeklyEarning;

  Data(
      {this.occupationData,
        this.ugPointScore,
        this.caveatNotes,
        this.relatedOccupation,
        this.employmentStatistics,
        this.weeklyEarning});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['OccupationData'] != null) {
      occupationData = <OccupationOtherInfoData>[];
      json['OccupationData'].forEach((v) {
        occupationData!.add(OccupationOtherInfoData.fromJson(v));
      });
    }
    if (json['UgPointScore'] != null) {
      ugPointScore = <UgPointScore>[];
      json['UgPointScore'].forEach((v) {
        ugPointScore!.add(UgPointScore.fromJson(v));
      });
    }
    if (json['CaveatNotes'] != null) {
      caveatNotes = <CaveatNotes>[];
      json['CaveatNotes'].forEach((v) {
        caveatNotes!.add(CaveatNotes.fromJson(v));
      });
    }
    if (json['RelatedOccupation'] != null) {
      relatedOccupation = <RelatedOccupation>[];
      json['RelatedOccupation'].forEach((v) {
        relatedOccupation!.add(RelatedOccupation.fromJson(v));
      });
    }
    if (json['EmploymentStatistics'] != null) {
      employmentStatistics = <EmploymentStatistics>[];
      json['EmploymentStatistics'].forEach((v) {
        employmentStatistics!.add(EmploymentStatistics.fromJson(v));
      });
    }
    if (json['weekly_earning'] != null) {
      weeklyEarning = <WeeklyEarning>[];
      json['weekly_earning'].forEach((v) {
        weeklyEarning!.add(WeeklyEarning.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (occupationData != null) {
      data['OccupationData'] =
          occupationData!.map((v) => v.toJson()).toList();
    }
    if (ugPointScore != null) {
      data['UgPointScore'] = ugPointScore!.map((v) => v.toJson()).toList();
    }
    if (caveatNotes != null) {
      data['CaveatNotes'] = caveatNotes!.map((v) => v.toJson()).toList();
    }
    if (relatedOccupation != null) {
      data['RelatedOccupation'] =
          relatedOccupation!.map((v) => v.toJson()).toList();
    }
    if (employmentStatistics != null) {
      data['EmploymentStatistics'] =
          employmentStatistics!.map((v) => v.toJson()).toList();
    }
    if (weeklyEarning != null) {
      data['weekly_earning'] =
          weeklyEarning!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OccupationOtherInfoData {
  String? occupationCode;
  String? mainOccupationCode;
  String? occupationName;
  String? oscaOccupationCode;
  String? oscaOccupationName;
  String? oscaLink;
  String? alternativeTitle;
  String? specialisation;
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

  OccupationOtherInfoData(
      {this.occupationCode,
        this.mainOccupationCode,
        this.occupationName,
        this.oscaOccupationCode,
        this.oscaOccupationName,
        this.oscaLink,
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

  OccupationOtherInfoData.fromJson(Map<String, dynamic> json) {
    occupationCode = json['occupation_code'];
    mainOccupationCode = json['main_occupation_code'];
    occupationName = json['occupation_name'];
    oscaOccupationCode = json['osca_occupation_code'];
    oscaOccupationName = json['osca_occupation_name'];
    oscaLink = json['osca_link'];
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
    data['osca_occupation_code'] = oscaOccupationCode;
    data['osca_occupation_name'] = oscaOccupationName;
    data['osca_link'] = oscaLink;
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

class UgPointScore {
  int? ugPointScore;
  String? effectiveDate;
  int? visaSubclass;

  UgPointScore({this.ugPointScore, this.effectiveDate, this.visaSubclass});

  UgPointScore.fromJson(Map<String, dynamic> json) {
    ugPointScore = json['ug_point_score'];
    effectiveDate = json['effective_date'];
    visaSubclass = json['visa_subclass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ug_point_score'] = ugPointScore;
    data['effective_date'] = effectiveDate;
    data['visa_subclass'] = visaSubclass;
    return data;
  }
}

class CaveatNotes {
  String? notes;

  CaveatNotes({this.notes});

  CaveatNotes.fromJson(Map<String, dynamic> json) {
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notes'] = notes;
    return data;
  }
}

class RelatedOccupation {
  String? occupationCode;
  String? mainOccupationCode;
  String? occupationName;

  RelatedOccupation(
      {this.occupationCode, this.mainOccupationCode, this.occupationName});

  RelatedOccupation.fromJson(Map<String, dynamic> json) {
    occupationCode = json['occupation_code'];
    mainOccupationCode = json['main_occupation_code'];
    occupationName = json['occupation_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occupation_code'] = occupationCode;
    data['main_occupation_code'] = mainOccupationCode;
    data['occupation_name'] = occupationName;
    return data;
  }
}

class EmploymentStatistics {
  String? esId;
  String? ugCode;
  int? year;
  String? workers;

  EmploymentStatistics({this.esId, this.ugCode, this.year, this.workers});

  EmploymentStatistics.fromJson(Map<String, dynamic> json) {
    esId = json['es_id'];
    ugCode = json['ug_code'];
    year = json['year'];
    workers = json['workers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['es_id'] = esId;
    data['ug_code'] = ugCode;
    data['year'] = year;
    data['workers'] = workers;
    return data;
  }
}

class WeeklyEarning {
  String? weId;
  String? occupationCode;
  int? earning;

  WeeklyEarning({this.weId, this.occupationCode, this.earning});

  WeeklyEarning.fromJson(Map<String, dynamic> json) {
    weId = json['we_id'];
    occupationCode = json['occupation_code'];
    earning = json['earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['we_id'] = weId;
    data['occupation_code'] = occupationCode;
    data['earning'] = earning;
    return data;
  }
}
