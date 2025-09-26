class OVHCDataModel {
  bool? flag;
  String? message;
  List<DataModel>? data;

  OVHCDataModel({this.flag, this.message, this.data});

  OVHCDataModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataModel>[];
      json['data'].forEach((v) {
        data!.add(DataModel.fromJson(v));
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

class DataModel {
  int? id;
  String? name;
  String? description;
  int? typeofagent;
  String? providerurl;
  int? providerid;
  int? isworking;
  int? covertypeid;
  int? planid;
  String? planname;
  dynamic price;
  String? broserurl;
  String? tagline;
  String? offer;
  String? offertext;
  String? logourl;
  int? compareid;
  String? covertypename;
  int? covertypenumber;

  DataModel(
      {this.id,
      this.name,
      this.description,
      this.typeofagent,
      this.providerurl,
      this.providerid,
      this.isworking,
      this.covertypeid,
      this.planid,
      this.planname,
      this.price,
      this.broserurl,
      this.tagline,
      this.offer,
      this.offertext,
      this.logourl,
      this.compareid,
      this.covertypename,
      this.covertypenumber});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    typeofagent = json['typeofagent'];
    providerurl = json['providerurl'];
    providerid = json['providerid'];
    isworking = json['isworking'];
    covertypeid = json['covertypeid'];
    planid = json['planid'];
    planname = json['planname'];
    price = json['price'];
    broserurl = json['broserurl'];
    tagline = json['tagline'];
    offer = json['offer'];
    offertext = json['offertext'];
    logourl = json['logourl'];
    compareid = json['compareid'];
    covertypename = json['covertypename'];
    covertypenumber = json['covertypenumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['typeofagent'] = typeofagent;
    data['providerurl'] = providerurl;
    data['providerid'] = providerid;
    data['isworking'] = isworking;
    data['covertypeid'] = covertypeid;
    data['planid'] = planid;
    data['planname'] = planname;
    data['price'] = price;
    data['broserurl'] = broserurl;
    data['tagline'] = tagline;
    data['offer'] = offer;
    data['offertext'] = offertext;
    data['logourl'] = logourl;
    data['compareid'] = compareid;
    data['covertypename'] = covertypename;
    data['covertypenumber'] = covertypenumber;
    return data;
  }
}
