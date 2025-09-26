class DynamicBaseUrlModel {
  List<UrlList>? stagingUrlList;
  List<UrlList>? liveUrlList;

  DynamicBaseUrlModel({this.stagingUrlList, this.liveUrlList});

  DynamicBaseUrlModel.fromJson(dynamic json) {
    if (json['staging'] != null) {
      stagingUrlList = [];
      json['staging'].forEach((String key, dynamic val) {
        stagingUrlList?.add(UrlList(urlKey: key, urlValue: val));
      });
    }
    if (json['live'] != null) {
      liveUrlList = [];
      json['live'].forEach((String key, dynamic val) {
        liveUrlList?.add(UrlList(urlKey: key, urlValue: val));
      });
    }
  }
}

class UrlList {
  String? urlKey;
  String? urlValue;

  UrlList({this.urlKey, this.urlValue});
}
