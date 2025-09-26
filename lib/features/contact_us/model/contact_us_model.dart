
class ContactUsModel {

  Occusearch? occuSearch;

  ContactUsModel({this.occuSearch});

  ContactUsModel.fromJson(Map<String, dynamic> json) {
    occuSearch = json['occusearch'] != null
        ? Occusearch.fromJson(json['occusearch'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (occuSearch != null) {
      data['occusearch'] = occuSearch!.toJson();
    }
    return data;
  }

}

class Occusearch {

  List<AussizzBranches>? aussizzBranches;

  Occusearch({this.aussizzBranches});

  Occusearch.fromJson(Map<String, dynamic> json) {
    if (json['aussizzBranches'] != null) {
      aussizzBranches = <AussizzBranches>[];
      json['aussizzBranches'].forEach((v) {
        aussizzBranches!.add(AussizzBranches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (aussizzBranches != null) {
      data['aussizzBranches'] =
          aussizzBranches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AussizzBranches {
  String? address2;
  String? addressline1;
  String? addressline2;
  String? cityname;
  String? companycontact;
  int? companyid;
  String? companylogo;
  String? companyname;
  String? companyphone;
  String? companystrip;
  String? companywhatsappno;
  String? countryname;
  String? emailaddress;
  String? latitude;
  String? longitude;
  String? marn;
  List<SocialLinks>? socialLinks;
  String? sociallink;
  String? statename;
  String? weburl;
  String? zipcode;

  AussizzBranches(
      {this.address2,
        this.addressline1,
        this.addressline2,
        this.cityname,
        this.companycontact,
        this.companyid,
        this.companylogo,
        this.companyname,
        this.companyphone,
        this.companystrip,
        this.companywhatsappno,
        this.countryname,
        this.emailaddress,
        this.latitude,
        this.longitude,
        this.marn,
        this.socialLinks,
        this.sociallink,
        this.statename,
        this.weburl,
        this.zipcode});

  AussizzBranches.fromJson(Map<String, dynamic> json) {
    address2 = json['address2'];
    addressline1 = json['addressline1'];
    addressline2 = json['addressline2'];
    cityname = json['cityname'];
    companycontact = json['companycontact'];
    companyid = json['companyid'];
    companylogo = json['companylogo'];
    companyname = json['companyname'];
    companyphone = json['companyphone'];
    companystrip = json['companystrip'];
    companywhatsappno = json['companywhatsappno'];
    countryname = json['countryname'];
    emailaddress = json['emailaddress'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    marn = json['marn'];
    if (json['social_links'] != null) {
      socialLinks = <SocialLinks>[];
      json['social_links'].forEach((v) {
        socialLinks!.add(SocialLinks.fromJson(v));
      });
    }
    sociallink = json['sociallink'];
    statename = json['statename'];
    weburl = json['weburl'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address2'] = address2;
    data['addressline1'] = addressline1;
    data['addressline2'] = addressline2;
    data['cityname'] = cityname;
    data['companycontact'] = companycontact;
    data['companyid'] = companyid;
    data['companylogo'] = companylogo;
    data['companyname'] = companyname;
    data['companyphone'] = companyphone;
    data['companystrip'] = companystrip;
    data['companywhatsappno'] = companywhatsappno;
    data['countryname'] = countryname;
    data['emailaddress'] = emailaddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['marn'] = marn;
    if (socialLinks != null) {
      data['social_links'] = socialLinks!.map((v) => v.toJson()).toList();
    }
    data['sociallink'] = sociallink;
    data['statename'] = statename;
    data['weburl'] = weburl;
    data['zipcode'] = zipcode;
    return data;
  }
}

class SocialLinks {
  String? icon;
  String? link;
  String? type;

  SocialLinks({this.icon, this.link, this.type});

  SocialLinks.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    link = json['link'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['link'] = link;
    data['type'] = type;
    return data;
  }
}
