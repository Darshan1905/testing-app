import '../../../../constants/constants.dart';

class EmploymentInsightsForAustralia {
  bool? flag;
  String? message;
  MarketPlaceData? data;

  EmploymentInsightsForAustralia({this.flag, this.message, this.data});

  EmploymentInsightsForAustralia.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null ? MarketPlaceData.fromJson(json['data']) : null;
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

class MarketPlaceData {
  String? region;
  String? workingAgePopulation;
  String? employed;
  String? employmentRate;
  String? participationRate;
  String? unemploymentRate;
  String? youthUnemploymentRate;
  List<ProjectedEmpGrowthByIndustry>? projectedEmpGrowthByIndustry;
  List<LargestEmployingOccupations>? largestEmployingOccupations;

  MarketPlaceData(
      {this.region,
      this.workingAgePopulation,
      this.employed,
      this.employmentRate,
      this.participationRate,
      this.unemploymentRate,
      this.youthUnemploymentRate,
      this.projectedEmpGrowthByIndustry,
      this.largestEmployingOccupations});

  MarketPlaceData.fromJson(Map<String, dynamic> json) {
    region = json['region'];
    workingAgePopulation = json['working_age_population'];
    employed = json['employed'];
    employmentRate = json['employment_rate'];
    participationRate = json['participation_rate'];
    unemploymentRate = json['unemployment_rate'];
    youthUnemploymentRate = json['youth_unemployment_rate'];
    if (json['projected_emp_growth_by_industry'] != null) {
      projectedEmpGrowthByIndustry = <ProjectedEmpGrowthByIndustry>[];
      json['projected_emp_growth_by_industry'].forEach((v) {
        projectedEmpGrowthByIndustry!
            .add(ProjectedEmpGrowthByIndustry.fromJson(v));
      });
    }
    if (json['largest_employing_occupations'] != null) {
      largestEmployingOccupations = <LargestEmployingOccupations>[];
      json['largest_employing_occupations'].forEach((v) {
        largestEmployingOccupations!
            .add(LargestEmployingOccupations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['region'] = region;
    data['working_age_population'] = workingAgePopulation;
    data['employed'] = employed;
    data['employment_rate'] = employmentRate;
    data['participation_rate'] = participationRate;
    data['unemployment_rate'] = unemploymentRate;
    data['youth_unemployment_rate'] = youthUnemploymentRate;
    if (projectedEmpGrowthByIndustry != null) {
      data['projected_emp_growth_by_industry'] =
          projectedEmpGrowthByIndustry!.map((v) => v.toJson()).toList();
    }
    if (largestEmployingOccupations != null) {
      data['largest_employing_occupations'] =
          largestEmployingOccupations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProjectedEmpGrowthByIndustry {
  String? label;
  String? month;
  String? year;
  String? value;
  String? growthPercentage;
  Color? randomColor = Utility.getRandomBGColor();

  ProjectedEmpGrowthByIndustry(
      {this.label, this.month, this.year, this.value, this.growthPercentage});

  ProjectedEmpGrowthByIndustry.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    month = json['month'];
    year = json['year'];
    value = json['value'];
    growthPercentage = json['growth_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['month'] = month;
    data['year'] = year;
    data['value'] = value;
    data['growth_percentage'] = growthPercentage;
    return data;
  }
}

class LargestEmployingOccupations {
  String? region;
  String? occupationName;
  String? employed;
  Color? randomColor = Utility.getRandomBGColor();

  LargestEmployingOccupations(
      {this.region, this.occupationName, this.employed});

  LargestEmployingOccupations.fromJson(Map<String, dynamic> json) {
    region = json['region'];
    occupationName = json['occupation_name'];
    employed = json['employed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['region'] = region;
    data['occupation_name'] = occupationName;
    data['employed'] = employed;
    return data;
  }
}
