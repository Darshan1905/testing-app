class OtherServicesModel {
  List<OtherServiceData>? data;

  OtherServicesModel({this.data});

  OtherServicesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OtherServiceData>[];
      json['data'].forEach((v) {
        data!.add(OtherServiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OtherServiceData {
  String? tag;
  String? title;
  String? description;
  String? notes;
  String? countryAllow;
  String? logo;
  Action? action;
  Theme? theme;

  OtherServiceData(
      {this.tag,
        this.title,
        this.description,
        this.notes,
        this.countryAllow,
        this.logo,
        this.action,
        this.theme});

  OtherServiceData.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    title = json['title'];
    description = json['description'];
    notes = json['notes'];
    countryAllow = json['countryAllow'];
    logo = json['logo'];
    action =
    json['action'] != null ? Action.fromJson(json['action']) : null;
    theme = json['theme'] != null ? Theme.fromJson(json['theme']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag'] = tag;
    data['title'] = title;
    data['description'] = description;
    data['notes'] = notes;
    data['countryAllow'] = countryAllow;
    data['logo'] = logo;
    if (action != null) {
      data['action'] = action!.toJson();
    }
    if (theme != null) {
      data['theme'] = theme!.toJson();
    }
    return data;
  }
}

class Action {
  String? title;
  Link? link;

  Action({this.title, this.link});

  Action.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    link = json['link'] != null ? Link.fromJson(json['link']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (link != null) {
      data['link'] = link!.toJson();
    }
    return data;
  }
}

class Link {
  String? android;
  String? ios;

  Link({this.android, this.ios});

  Link.fromJson(Map<String, dynamic> json) {
    android = json['android'];
    ios = json['ios'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android'] = android;
    data['ios'] = ios;
    return data;
  }
}

class Theme {
  Light? light;
  Light? dark;

  Theme({this.light, this.dark});

  Theme.fromJson(Map<String, dynamic> json) {
    light = json['light'] != null ? Light.fromJson(json['light']) : null;
    dark = json['dark'] != null ? Light.fromJson(json['dark']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (light != null) {
      data['light'] = light!.toJson();
    }
    if (dark != null) {
      data['dark'] = dark!.toJson();
    }
    return data;
  }
}

class Light {
  String? primary;
  String? secondary;

  Light({this.primary, this.secondary});

  Light.fromJson(Map<String, dynamic> json) {
    primary = json['primary'];
    secondary = json['secondary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primary'] = primary;
    data['secondary'] = secondary;
    return data;
  }
}
