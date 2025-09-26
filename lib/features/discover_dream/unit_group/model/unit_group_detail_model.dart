import 'package:occusearch/constants/constants.dart';

class UnitGroupDetailDataModel {
  bool? flag;
  String? message;
  UnitGroupDetailData? data;

  UnitGroupDetailDataModel({this.flag, this.message, this.data});

  UnitGroupDetailDataModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null
        ? UnitGroupDetailData.fromJson(json['data'])
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

class UnitGroupDetailData {
  String? code;
  String? name;
  int? skillLevel;
  String? snapshotEmployed;
  String? snapshotFutureGrowth;
  String? snapshotWeeklyEarnings;
  String? snapshotFulltimeShare;
  String? snapshotFemaleShare;
  String? snapshotAverageAge;
  String? summary;
  String? tasks;
  String? outlookProjectedChange;
  String? employeePathwaysSourse;
  String? workersProfileSource;
  String? numberOfWorkersSource;
  String? regionsSource;
  String? earningsHoursSources;
  String? fullTimeEarnOccupation;
  int? fullTimeEarnJobAvg;
  String? profileAgeInYear;
  int? profileAllJobsAvg;
  String? profileFemaleShare;
  String? profileFemaleJobsAvg;
  String? outlookFrom;
  String? outlookFromYear;
  String? outlookTo;
  String? outlookYear;

  // START - Characteristic
  String? jobType;
  String? unemploymentRate;
  String? pathWay;
  String? interests;
  String? physicalDamand;
  String? indrusties;
  String? regionsDescription;
  String? workersProfileDescription;

  // END - Characteristic
  List<Occupations>? occupations;
  List<NumberOfWorker>? numberOfWorker;
  List<Industries>? industries;
  List<MainIndustries>? mainIndustries;
  List<RegionsEmployment>? regionsEmployment;
  List<AgeProfile>? ageProfile;
  List<HighestLevelEducation>? highestLevelEducation;

  UnitGroupDetailData(
      {this.code,
      this.name,
      this.skillLevel,
      this.snapshotEmployed,
      this.snapshotFutureGrowth,
      this.snapshotWeeklyEarnings,
      this.snapshotFulltimeShare,
      this.snapshotFemaleShare,
      this.snapshotAverageAge,
      this.summary,
      this.tasks,
      this.outlookProjectedChange,
      this.employeePathwaysSourse,
      this.workersProfileSource,
      this.numberOfWorkersSource,
      this.regionsSource,
      this.earningsHoursSources,
      this.fullTimeEarnOccupation,
      this.fullTimeEarnJobAvg,
      this.profileAgeInYear,
      this.profileAllJobsAvg,
      this.profileFemaleShare,
      this.profileFemaleJobsAvg,
      this.outlookFrom,
      this.outlookFromYear,
      this.outlookTo,
      this.outlookYear,
      this.jobType,
      this.unemploymentRate,
      this.pathWay,
      this.interests,
      this.physicalDamand,
      this.indrusties,
      this.regionsDescription,
      this.workersProfileDescription,
      this.occupations,
      this.numberOfWorker,
      this.industries,
      this.mainIndustries,
      this.regionsEmployment,
      this.ageProfile,
      this.highestLevelEducation});

  UnitGroupDetailData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    skillLevel = json['skill_level'];
    snapshotEmployed = json['snapshot_employed'];
    snapshotFutureGrowth = json['snapshot_future_growth'];
    snapshotWeeklyEarnings = json['snapshot_weekly_earnings'];
    snapshotFulltimeShare = json['snapshot_fulltime_share'];
    snapshotFemaleShare = json['snapshot_female_share'];
    snapshotAverageAge = json['snapshot_average_age'];
    summary = json['summary'];
    tasks = json['tasks'];
    outlookProjectedChange = json['outlook_projected_change'];
    employeePathwaysSourse = json['employee_pathways_sourse'];
    workersProfileSource = json['workers_profile_source'];
    numberOfWorkersSource = json['number_of_workers_source'];
    regionsSource = json['regions_source'];
    earningsHoursSources = json['earnings_hours_sources'];
    fullTimeEarnOccupation = json['full_time_earn_occupation'];
    fullTimeEarnJobAvg = json['full_time_earn_job_avg'];
    profileAgeInYear = json['profile_age_in_year'];
    profileAllJobsAvg = json['profile_all_jobs_avg'];
    profileFemaleShare = json['profile_female_share'];
    profileFemaleJobsAvg = json['profile_female_jobs_avg'];
    outlookFrom = json['outlook_from'] ?? "0";
    outlookFromYear = json['outlook_from_year'];
    outlookTo = json['outlook_to'] ?? "0";
    outlookYear = json['outlook_year'];

    jobType = json['job_type'];
    unemploymentRate = json['unemployment_rate'];
    pathWay = json['path_way'];
    interests = json['interests'];
    physicalDamand = json['physical_damand'];
    indrusties = json['sub_industries'];
    regionsDescription = json['regions_description'];
    workersProfileDescription = json['workers_profile_description'];

    if (json['occupations'] != null) {
      occupations = <Occupations>[];
      json['occupations'].forEach((v) {
        occupations!.add(Occupations.fromJson(v));
      });
    }
    if (json['number_of_worker'] != null) {
      numberOfWorker = <NumberOfWorker>[];
      json['number_of_worker'].forEach((v) {
        numberOfWorker!.add(NumberOfWorker.fromJson(v));
      });
    }
    if (json['industries'] != null) {
      industries = <Industries>[];
      json['industries'].forEach((v) {
        industries!.add(Industries.fromJson(v));
      });
    }
    if (json['main_industries'] != null) {
      mainIndustries = <MainIndustries>[];
      json['main_industries'].forEach((v) {
        mainIndustries!.add(MainIndustries.fromJson(v));
      });
    }
    if (json['regions_employment'] != null) {
      regionsEmployment = <RegionsEmployment>[];
      json['regions_employment'].forEach((v) {
        regionsEmployment!.add(RegionsEmployment.fromJson(v));
      });
    }
    if (json['age_profile'] != null) {
      ageProfile = <AgeProfile>[];
      json['age_profile'].forEach((v) {
        ageProfile!.add(AgeProfile.fromJson(v));
      });
    }
    if (json['highest_level_education'] != null) {
      highestLevelEducation = <HighestLevelEducation>[];
      json['highest_level_education'].forEach((v) {
        highestLevelEducation!.add(HighestLevelEducation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['skill_level'] = skillLevel;
    data['snapshot_employed'] = snapshotEmployed;
    data['snapshot_future_growth'] = snapshotFutureGrowth;
    data['snapshot_weekly_earnings'] = snapshotWeeklyEarnings;
    data['snapshot_fulltime_share'] = snapshotFulltimeShare;
    data['snapshot_female_share'] = snapshotFemaleShare;
    data['snapshot_average_age'] = snapshotAverageAge;
    data['summary'] = summary;
    data['tasks'] = tasks;
    data['outlook_projected_change'] = outlookProjectedChange;
    data['employee_pathways_sourse'] = employeePathwaysSourse;
    data['number_of_workers_source'] = workersProfileSource;
    data['workers_profile_source'] = numberOfWorkersSource;
    data['regions_source'] = regionsSource;
    data['earnings_hours_sources'] = earningsHoursSources;
    data['full_time_earn_occupation'] = fullTimeEarnOccupation;
    data['full_time_earn_job_avg'] = fullTimeEarnJobAvg;
    data['profile_age_in_year'] = profileAgeInYear;
    data['profile_all_jobs_avg'] = profileAllJobsAvg;
    data['profile_female_share'] = profileFemaleShare;
    data['profile_female_jobs_avg'] = profileFemaleJobsAvg;
    data['outlook_from'] = outlookFrom;
    data['outlook_from_year'] = outlookFromYear;
    data['outlook_to'] = outlookTo;
    data['outlook_year'] = outlookYear;
    if (occupations != null) {
      data['occupations'] = occupations!.map((v) => v.toJson()).toList();
    }
    if (numberOfWorker != null) {
      data['number_of_worker'] =
          numberOfWorker!.map((v) => v.toJson()).toList();
    }
    if (industries != null) {
      data['industries'] = industries!.map((v) => v.toJson()).toList();
    }
    if (mainIndustries != null) {
      data['main_industries'] = mainIndustries!.map((v) => v.toJson()).toList();
    }
    if (regionsEmployment != null) {
      data['regions_employment'] =
          regionsEmployment!.map((v) => v.toJson()).toList();
    }
    if (ageProfile != null) {
      data['age_profile'] = ageProfile!.map((v) => v.toJson()).toList();
    }
    if (highestLevelEducation != null) {
      data['highest_level_education'] =
          highestLevelEducation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Occupations {
  String? occupation;
  String? name;
  Color? randomColor = Utility.getRandomBGColor();

  Occupations({this.occupation, this.name});

  Occupations.fromJson(Map<String, dynamic> json) {
    occupation = json['occupation'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occupation'] = occupation;
    data['name'] = name;
    return data;
  }
}

class NumberOfWorker {
  String? year;
  int? employment;

  NumberOfWorker({this.year, this.employment});

  NumberOfWorker.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    employment = json['employment'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['employment'] = employment;
    return data;
  }
}

class Industries {
  String? industryName;
  Color? randomColor = Utility.getRandomBGColor();

  Industries({this.industryName});

  Industries.fromJson(Map<String, dynamic> json) {
    industryName = json['industry_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['industry_name'] = industryName;
    return data;
  }
}

class MainIndustries {
  String? industryName;
  String? industryValue;
  Color? randomColor = Utility.getRandomBGColor();

  MainIndustries({this.industryName, this.industryValue});

  MainIndustries.fromJson(Map<String, dynamic> json) {
    industryName = json['industry_name'];
    industryValue = json['industry_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['industry_name'] = industryName;
    data['industry_value'] = industryValue;
    return data;
  }
}

class RegionsEmployment {
  String? state;
  String? worker;
  String? jobAverage;

  RegionsEmployment({this.state, this.worker, this.jobAverage});

  RegionsEmployment.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    worker = json['worker'];
    jobAverage = json['job_average'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['worker'] = worker;
    data['job_average'] = jobAverage;
    return data;
  }
}

class AgeProfile {
  String? ageBracket;
  double? occupationJob;
  num? allJobAvg;

  AgeProfile({this.ageBracket, this.occupationJob, this.allJobAvg});

  AgeProfile.fromJson(Map<String, dynamic> json) {
    ageBracket = json['age_bracket'];
    occupationJob = double.parse("${json['occupation_job'] ?? '0'}");
    allJobAvg = double.parse("${json['all_job_avg'] ?? '0'}");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['age_bracket'] = ageBracket;
    data['occupation_job'] = occupationJob;
    data['all_job_avg'] = allJobAvg;
    return data;
  }
}

class HighestLevelEducation {
  String? qualificationType;
  double? occupationShare;
  double? allJobAvg;

  HighestLevelEducation(
      {this.qualificationType, this.occupationShare, this.allJobAvg});

  HighestLevelEducation.fromJson(Map<String, dynamic> json) {
    qualificationType = json['qualification_type'];
    allJobAvg = json['all_job_avg'];
    occupationShare = double.parse("${json['occupation_share'] ?? '0'}");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qualification_type'] = qualificationType;
    data['occupation_share'] = occupationShare;
    data['all_job_avg'] = allJobAvg;
    return data;
  }
}
