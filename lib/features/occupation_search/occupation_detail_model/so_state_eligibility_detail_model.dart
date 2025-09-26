class StateEligibilityDetailModel {
  bool? flag;
  String? message;
  SEDData? data;
  String region = "";

  StateEligibilityDetailModel({this.flag, this.message, this.data});

  StateEligibilityDetailModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null ? SEDData.fromJson(json['data']) : null;
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

class SEDData {
  List<StaterequirementG>? staterequirementG;
  List<StaterequirementSpe>? staterequirementSpe;
  List<EligibilityReq>? eligibilityReq;
  List<Region>? region;
  List<Occupation>? occupation;
  List<EngReq>? engReq; // In use
  List<EngReqENS>? engReqEns; // In use
  List<Visa489>? visa489;
  List<VisaDama>? visaDama;
  List<EmpShare>? empShare;
  List<Eoistatecount>? eoistatecount;

  // General Details
  List<SoStateEligibilityGeneralMode>? generalDetailList;

  // Special Requirements
  List<SoStateEligibilityGeneralMode>? specialRequirementList;

  SEDData({
    this.staterequirementG,
    this.staterequirementSpe,
    this.eligibilityReq,
    this.region,
    this.occupation,
    this.engReq,
    this.engReqEns,
    this.visa489,
    this.visaDama,
    this.empShare,
  });

  SEDData.fromJson(Map<String, dynamic> json) {
    if (json['staterequirementG'] != null) {
      staterequirementG = <StaterequirementG>[];
      json['staterequirementG'].forEach((v) {
        staterequirementG!.add(StaterequirementG.fromJson(v));
      });
    }
    if (json['staterequirementSpe'] != null) {
      staterequirementSpe = <StaterequirementSpe>[];
      json['staterequirementSpe'].forEach((v) {
        staterequirementSpe!.add(StaterequirementSpe.fromJson(v));
      });
    }
    if (json['EligibilityReq'] != null) {
      eligibilityReq = <EligibilityReq>[];
      json['EligibilityReq'].forEach((v) {
        eligibilityReq!.add(EligibilityReq.fromJson(v));
      });
    }
    if (json['region'] != null) {
      region = <Region>[];
      json['region'].forEach((v) {
        region!.add(Region.fromJson(v));
      });
    }
    if (json['occupation'] != null) {
      occupation = <Occupation>[];
      json['occupation'].forEach((v) {
        occupation!.add(Occupation.fromJson(v));
      });
    }
    if (json['EngReq'] != null) {
      engReq = <EngReq>[];
      json['EngReq'].forEach((v) {
        engReq!.add(EngReq.fromJson(v));
      });
    }
    if (json['EngReq_ENS'] != null) {
      engReqEns = <EngReqENS>[];
      json['EngReq_ENS'].forEach((v) {
        engReqEns!.add(EngReqENS.fromJson(v));
      });
    }
    if (json['visa_489'] != null) {
      visa489 = <Visa489>[];
      json['visa_489'].forEach((v) {
        visa489!.add(Visa489.fromJson(v));
      });
    }
    if (json['visa_dama'] != null) {
      visaDama = <VisaDama>[];
      json['visa_dama'].forEach((v) {
        visaDama!.add(VisaDama.fromJson(v));
      });
    }
    if (json['EmpShare'] != null) {
      empShare = <EmpShare>[];
      json['EmpShare'].forEach((v) {
        empShare!.add(EmpShare.fromJson(v));
      });
    }
    if (json['eoistatecount'] != null) {
      eoistatecount = <Eoistatecount>[];
      json['eoistatecount'].forEach((v) {
        eoistatecount!.add(Eoistatecount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (staterequirementG != null) {
      data['staterequirementG'] =
          staterequirementG!.map((v) => v.toJson()).toList();
    }
    if (staterequirementSpe != null) {
      data['staterequirementSpe'] =
          staterequirementSpe!.map((v) => v.toJson()).toList();
    }
    if (eligibilityReq != null) {
      data['EligibilityReq'] = eligibilityReq!.map((v) => v.toJson()).toList();
    }
    if (region != null) {
      data['region'] = region!.map((v) => v.toJson()).toList();
    }
    if (occupation != null) {
      data['occupation'] = occupation!.map((v) => v.toJson()).toList();
    }
    if (engReq != null) {
      data['EngReq'] = engReq!.map((v) => v.toJson()).toList();
    }
    if (engReqEns != null) {
      data['EngReq_ENS'] = engReqEns!.map((v) => v.toJson()).toList();
    }
    if (visa489 != null) {
      data['visa_489'] = visa489!.map((v) => v.toJson()).toList();
    }
    if (visaDama != null) {
      data['visa_dama'] = visaDama!.map((v) => v.toJson()).toList();
    }
    if (empShare != null) {
      data['EmpShare'] = empShare!.map((v) => v.toJson()).toList();
    }
    if (eoistatecount != null) {
      data['eoistatecount'] = eoistatecount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaterequirementG {
  String? condition;
  String? cvalue;

  StaterequirementG({this.condition, this.cvalue});

  StaterequirementG.fromJson(Map<String, dynamic> json) {
    condition = json['condition'];
    cvalue = json['cvalue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['condition'] = condition;
    data['cvalue'] = cvalue;
    return data;
  }
}

class StaterequirementSpe {
  String? cvalue;
  String? condition;
  String? region;

  StaterequirementSpe({this.cvalue, this.condition, this.region});

  StaterequirementSpe.fromJson(Map<String, dynamic> json) {
    cvalue = json['cvalue'];
    condition = json['condition'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cvalue'] = cvalue;
    data['condition'] = condition;
    data['region'] = region;
    return data;
  }
}

class EligibilityReq {
  String? eligibilityRequirementId;
  String? state;
  String? region;
  String? occupationCode;
  String? visaType;
  String? conditionType;
  String? experiance;
  String? englishRequirement;
  String? englishRequirementENS;
  int? englishComment;
  int? ageConcession;
  int? tSMITConcession;
  int? prPathway;
  int? workExperienceConcession;
  int? nVersion;
  String? effectiveDate;
  String? updatedDate;
  String? updatedBy;
  int? isOpen;
  String? createdBy;
  String? createdDate;
  String? occupationalReqComment;
  bool? isSendUpdateEmail;

  EligibilityReq(
      {this.eligibilityRequirementId,
      this.state,
      this.region,
      this.occupationCode,
      this.visaType,
      this.conditionType,
      this.experiance,
      this.englishRequirement,
      this.englishRequirementENS,
      this.englishComment,
      this.ageConcession,
      this.tSMITConcession,
      this.prPathway,
      this.workExperienceConcession,
      this.nVersion,
      this.effectiveDate,
      this.updatedDate,
      this.updatedBy,
      this.isOpen,
      this.createdBy,
      this.createdDate,
      this.occupationalReqComment,
      this.isSendUpdateEmail});

  EligibilityReq.fromJson(Map<String, dynamic> json) {
    eligibilityRequirementId = json['eligibility_requirement_id'];
    state = json['state'];
    region = json['region'];
    occupationCode = json['occupation_code'];
    visaType = json['visa_type'];
    conditionType = json['condition_type'];
    experiance = json['experiance'];
    englishRequirement = json['english_requirement'];
    englishRequirementENS = json['english_requirement_ENS'];
    englishComment = json['english_comment'];
    ageConcession = json['age_concession'];
    tSMITConcession = json['TSMIT_concession'];
    prPathway = json['pr_pathway'];
    workExperienceConcession = json['Work_Experience_Concession'];
    nVersion = json['_version'];
    effectiveDate = json['effective_date'];
    updatedDate = json['updated_date'];
    updatedBy = json['updated_by'];
    isOpen = json['is_open'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    occupationalReqComment = json['occupational_req_comment'];
    isSendUpdateEmail = json['IsSendUpdateEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eligibility_requirement_id'] = eligibilityRequirementId;
    data['state'] = state;
    data['region'] = region;
    data['occupation_code'] = occupationCode;
    data['visa_type'] = visaType;
    data['condition_type'] = conditionType;
    data['experiance'] = experiance;
    data['english_requirement'] = englishRequirement;
    data['english_requirement_ENS'] = englishRequirementENS;
    data['english_comment'] = englishComment;
    data['age_concession'] = ageConcession;
    data['TSMIT_concession'] = tSMITConcession;
    data['pr_pathway'] = prPathway;
    data['Work_Experience_Concession'] = workExperienceConcession;
    data['_version'] = nVersion;
    data['effective_date'] = effectiveDate;
    data['updated_date'] = updatedDate;
    data['updated_by'] = updatedBy;
    data['is_open'] = isOpen;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['occupational_req_comment'] = occupationalReqComment;
    data['IsSendUpdateEmail'] = isSendUpdateEmail;
    return data;
  }
}

class Region {
  String? state;
  String? applicationMode;
  String? fees;
  String? processingTime;
  String? region;
  int? orangeTick;
  String? link;
  String? feesLink;
  String? linkExperienceDAMA;
  String? linkEnglishDAMA;

  Region(
      {this.state,
      this.applicationMode,
      this.fees,
      this.processingTime,
      this.region,
      this.orangeTick,
      this.link,
      this.feesLink,
      this.linkExperienceDAMA,
      this.linkEnglishDAMA});

  Region.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    applicationMode = json['application_mode'];
    fees = json['fees'];
    processingTime = json['processing_time'];
    region = json['region'];
    orangeTick = json['orange_tick'];
    link = json['link'];
    feesLink = json['fees_link'];
    linkExperienceDAMA = json['link_experience_DAMA'];
    linkEnglishDAMA = json['link_english_DAMA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['application_mode'] = applicationMode;
    data['fees'] = fees;
    data['processing_time'] = processingTime;
    data['region'] = region;
    data['orange_tick'] = orangeTick;
    data['link'] = link;
    data['fees_link'] = feesLink;
    data['link_experience_DAMA'] = linkExperienceDAMA;
    data['link_english_DAMA'] = linkEnglishDAMA;
    return data;
  }
}

class Occupation {
  String? occupationName;

  Occupation({this.occupationName});

  Occupation.fromJson(Map<String, dynamic> json) {
    occupationName = json['occupation_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occupation_name'] = occupationName;
    return data;
  }
}

class EngReq {
  String? englishRequirementId;
  String? erCategoryId;
  String? examType;
  String? listening;
  String? reading;
  String? writing;
  String? speaking;
  String? overall;
  String? overall2;
  String? createdDate;
  String? updatedDate;
  String? createdBy;
  String? updatedBy;
  String? isSendUpdateEmail;

  EngReq(
      {this.englishRequirementId,
      this.erCategoryId,
      this.examType,
      this.listening,
      this.reading,
      this.writing,
      this.speaking,
      this.overall,
      this.overall2,
      this.createdDate,
      this.updatedDate,
      this.createdBy,
      this.updatedBy,
      this.isSendUpdateEmail});

  EngReq.fromJson(Map<String, dynamic> json) {
    englishRequirementId = json['english_requirement_id'];
    erCategoryId = json['er_category_id'];
    examType = json['exam_type'];
    listening = json['listening'];
    reading = json['reading'];
    writing = json['writing'];
    speaking = json['speaking'];
    overall = json['overall'];
    overall2 = json['overall2'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    isSendUpdateEmail = json['IsSendUpdateEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['english_requirement_id'] = englishRequirementId;
    data['er_category_id'] = erCategoryId;
    data['exam_type'] = examType;
    data['listening'] = listening;
    data['reading'] = reading;
    data['writing'] = writing;
    data['speaking'] = speaking;
    data['overall'] = overall;
    data['overall2'] = overall2;
    data['created_date'] = createdDate;
    data['updated_date'] = updatedDate;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['IsSendUpdateEmail'] = isSendUpdateEmail;
    return data;
  }
}

class EngReqENS {
  String? englishRequirementId;
  String? erCategoryId;
  String? examType;
  String? listening;
  String? reading;
  String? writing;
  String? speaking;
  String? overall;
  String? overall2;
  String? createdDate;
  String? updatedDate;
  String? createdBy;
  String? updatedBy;
  String? isSendUpdateEmail;

  EngReqENS(
      {this.englishRequirementId,
      this.erCategoryId,
      this.examType,
      this.listening,
      this.reading,
      this.writing,
      this.speaking,
      this.overall,
      this.overall2,
      this.createdDate,
      this.updatedDate,
      this.createdBy,
      this.updatedBy,
      this.isSendUpdateEmail});

  EngReqENS.fromJson(Map<String, dynamic> json) {
    englishRequirementId = json['english_requirement_id'];
    erCategoryId = json['er_category_id'];
    examType = json['exam_type'];
    listening = json['listening'];
    reading = json['reading'];
    writing = json['writing'];
    speaking = json['speaking'];
    overall = json['overall'];
    overall2 = json['overall2'];
    createdDate = json['created_date'] ?? "";
    updatedDate = json['updated_date'] ?? "";
    createdBy = json['created_by'] ?? "";
    updatedBy = json['updated_by'] ?? "";
    isSendUpdateEmail = json['IsSendUpdateEmail'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['english_requirement_id'] = englishRequirementId;
    data['er_category_id'] = erCategoryId;
    data['exam_type'] = examType;
    data['listening'] = listening;
    data['reading'] = reading;
    data['writing'] = writing;
    data['speaking'] = speaking;
    data['overall'] = overall;
    data['overall2'] = overall2;
    data['created_date'] = createdDate;
    data['updated_date'] = updatedDate;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['IsSendUpdateEmail'] = isSendUpdateEmail;
    return data;
  }
}

class Visa489 {
  String? link489;

  Visa489({this.link489});

  Visa489.fromJson(Map<String, dynamic> json) {
    link489 = json['link_489'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link_489'] = link489;
    return data;
  }
}

class VisaDama {
  String? linkDAMA;

  VisaDama({this.linkDAMA});

  VisaDama.fromJson(Map<String, dynamic> json) {
    linkDAMA = json['link_DAMA'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link_DAMA'] = linkDAMA;
    return data;
  }
}

class EmpShare {
  double? acrm;
  double? alljobs;
  String? occupationName;

  EmpShare({this.acrm, this.alljobs, this.occupationName});

  EmpShare.fromJson(Map<String, dynamic> json) {
    acrm = double.parse('${json['acrm']}');
    alljobs = double.parse('${json['alljobs']}');
    occupationName = json['occupation_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['acrm'] = acrm;
    data['alljobs'] = alljobs;
    data['occupation_name'] = occupationName;
    return data;
  }
}

class Eoistatecount {
  String? eOIStateId;
  String? eOIState;
  String? visaType;
  String? occupationCode;
  String? eOIStatus;
  String? prefix;
  String? eOICount;
  String? effectiveMonth;
  String? createdDate;
  String? updatedDate;
  String? createdBy;
  String? updatedBy;

  Eoistatecount(
      {this.eOIStateId,
      this.eOIState,
      this.visaType,
      this.occupationCode,
      this.eOIStatus,
      this.prefix,
      this.eOICount,
      this.effectiveMonth,
      this.createdDate,
      this.updatedDate,
      this.createdBy,
      this.updatedBy});

  Eoistatecount.fromJson(Map<String, dynamic> json) {
    eOIStateId = json['EOI_state_id'] ?? "";
    eOIState = json['EOI_state'] ?? "";
    visaType = json['visa_type'] ?? "";
    occupationCode = json['occupation_code'] ?? "";
    eOIStatus = json['EOI_status'] ?? "";
    prefix = json['prefix'] ?? "";
    eOICount = json['EOI_count'] ?? "";
    effectiveMonth = json['effective_month'] ?? "";
    createdDate = json['created_date'] ?? "";
    updatedDate = json['updated_date'] ?? "";
    createdBy = json['created_by'] ?? "";
    updatedBy = json['updated_by'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EOI_state_id'] = eOIStateId;
    data['EOI_state'] = eOIState;
    data['visa_type'] = visaType;
    data['occupation_code'] = occupationCode;
    data['EOI_status'] = eOIStatus;
    data['prefix'] = prefix;
    data['EOI_count'] = eOICount;
    data['effective_month'] = effectiveMonth;
    data['created_date'] = createdDate;
    data['updated_date'] = updatedDate;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    return data;
  }
}

class SoStateEligibilityGeneralMode {
  String label = "";
  String value = "";

  SoStateEligibilityGeneralMode({required this.label, required this.value});
}
