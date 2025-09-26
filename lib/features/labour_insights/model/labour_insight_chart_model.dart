class LabourInsightChartModel {
  LabourInsightChartModel({this.year, this.workersEmployment});
  final String? year;
  final double? workersEmployment;
}

class EarningChartModel {
  EarningChartModel({this.name, this.totalEarn});
  final String? name;
  final int? totalEarn;
}

class AgeProfileModel {
  AgeProfileModel({this.ageBracket, this.occupation,this.avg});
  final String? ageBracket;
  final double? occupation;
  final double? avg;
}

class QualificationModel {
  QualificationModel({this.type, this.share,this.avg});
  final String? type;
  final double? share;
  final double? avg;
}