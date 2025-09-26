class RateUsDialogModel {
  List<DynamicRating>? dynamicRating;

  RateUsDialogModel({this.dynamicRating});

  RateUsDialogModel.fromJson(Map<String, dynamic> json) {
    if (json['dynamic_rating'] != null) {
      dynamicRating = <DynamicRating>[];
      json['dynamic_rating'].forEach((v) {
        dynamicRating!.add(DynamicRating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dynamicRating != null) {
      data['dynamic_rating'] = dynamicRating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DynamicRating {
  String? module;
  int? matchCount;
  int? incrementBy;
  int localMatchCount = 0; // manage locally (match_count + increment_by)
  int localCount = 0; // user interaction or user event count

  DynamicRating(this.localCount, this.localMatchCount,
      {this.module, this.matchCount, this.incrementBy});

  DynamicRating.fromJson(Map<String, dynamic> json) {
    module = json['module'];
    matchCount = json['match_count'];
    incrementBy = json['increment_by'];
    localCount = json['localCount'] ?? 0;
    // localMatchCount = json['localMatchCount'] ?? 0;
    localMatchCount = (json['localMatchCount'] == 0)
        ? json['match_count']
        : json['localMatchCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module'] = module;
    data['match_count'] = matchCount;
    data['increment_by'] = incrementBy;
    data['localCount'] = localCount;
    data['localMatchCount'] = localMatchCount;
    return data;
  }
}
