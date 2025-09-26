class OccupationData {
  String? id;
  String? mainId;
  String? name;
  bool isAdded = false;

  OccupationData({this.id, this.mainId, this.name});

  OccupationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainId = json['mainId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mainId'] = mainId;
    data['name'] = name;
    return data;
  }
}
