/// applicationList : [{"android_url":"com.aussizzgroup.ccltutorials","appDiscription":"CCL Tutorials is a one-stop solution for aspirants with a comprehensive, flexible and test-taker oriented approach to NAATI CCL Test preparation.","appId":0,"appTitle":"CCL Tutorials","buttonText":"open","createdDate":"2018-08-09T18:46:03","images":"https://user.ptetutorials.com/images/iPhoneImages/CCL_Logo.png","iPhone_URL":"https://ccl.app.link/s6xz8GybOO","isActive":1},{"android_url":"com.aussizzgroup.ielts","appDiscription":"One-stop IELTS preparation with a flexible, extensive & student-first approach.","appId":0,"appTitle":"IELTS Tutorials","buttonText":"open","createdDate":"2019-01-04T00:00:00","images":"https://user.ptetutorials.com/images/iPhoneImages/IELTS_LOGO.png","iPhone_URL":"https://ielts.app.link/TkB8zQFm3T","isActive":1},{"android_url":"com.ieltstutorials.writing","appDiscription":"IELTS Writing is no longer a barrier to your desired score. With Self practice material, 90+ solved samples and latest videos available on IELTS Writing app score high in IELTS Exam. Download now.","appId":0,"appTitle":"IELTS Tutorials - Writing","buttonText":"open","createdDate":"2019-08-03T15:38:15","images":"https://user.ptetutorials.com/images/iPhoneImages/WritngAppLogo.png","iPhone_URL":"https://ieltswritingtutorials.page.link/lgn","isActive":1},{"android_url":"com.ieltstutorials.speaking","appDiscription":"IELTS Tutorials – Speaking is a free and self-preparation mobile app for both IELTS Speaking Academic and IELTS Speaking General Training. Download now.","appId":0,"appTitle":"IELTS Tutorials – Speaking","buttonText":"open","createdDate":"2019-08-03T15:38:15","images":"https://play-lh.googleusercontent.com/rBvjNdwE1vhJbHPJ0Lyk4PpivxasUJnxMZgQu0ubJ_eDlE39fguJdF-aGXfTTquzfoUj=s180-rw","iPhone_URL":"https://ieltsspeakingtutorials.page.link/lgn","isActive":1}]

class MoreAppModel {
  List<ApplicationList>? _applicationList;

  List<ApplicationList>? get applicationList => _applicationList;

  MoreAppModel({List<ApplicationList>? applicationList}) {
    _applicationList = applicationList;
  }

  MoreAppModel.fromJson(dynamic json) {
    if (json['applicationList'] != null) {
      _applicationList = [];
      json['applicationList'].forEach((v) {
        _applicationList!.add(ApplicationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_applicationList != null) {
      map['applicationList'] =
          _applicationList!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// android_url : "com.aussizzgroup.ccltutorials"
/// appDiscription : "CCL Tutorials is a one-stop solution for aspirants with a comprehensive, flexible and test-taker oriented approach to NAATI CCL Test preparation."
/// appId : 0
/// appTitle : "CCL Tutorials"
/// buttonText : "open"
/// createdDate : "2018-08-09T18:46:03"
/// images : "https://user.ptetutorials.com/images/iPhoneImages/CCL_Logo.png"
/// iPhone_URL : "https://ccl.app.link/s6xz8GybOO"
/// isActive : 1

class ApplicationList {
  String? _androidUrl;
  String? _appDiscription;
  int? _appId;
  String? _appTitle;
  String? _buttonText;
  String? _createdDate;
  String? _images;
  String? _iPhoneURL;
  int? _isActive;
  String? _facebook;
  String? _instagram;
  String? _twitter;
  String? _telegram;
  String? _linkedin;
  String? _youtube;

  String? get androidUrl => _androidUrl;

  String? get appDiscription => _appDiscription;

  int? get appId => _appId;

  String? get appTitle => _appTitle;

  String? get buttonText => _buttonText;

  String? get createdDate => _createdDate;

  String? get images => _images;

  String? get iPhoneURL => _iPhoneURL;

  int? get isActive => _isActive;

  String? get getFacebookURL => _facebook;

  String? get getInstagramURL => _instagram;

  String? get getTwitterURL => _twitter;

  String? get getTelegramURL => _telegram;

  String? get getLinkedinURL => _linkedin;

  String? get getYoutubeURL => _youtube;

  ApplicationList({
    String? androidUrl,
    String? appDiscription,
    int? appId,
    String? appTitle,
    String? buttonText,
    String? createdDate,
    String? images,
    String? iPhoneURL,
    int? isActive,
    String? facebook,
    String? twitter,
    String? telegram,
    String? linkedin,
    String? youtube,
    String? instagram,
  }) {
    _androidUrl = androidUrl;
    _appDiscription = appDiscription;
    _appId = appId;
    _appTitle = appTitle;
    _buttonText = buttonText;
    _createdDate = createdDate;
    _images = images;
    _iPhoneURL = iPhoneURL;
    _isActive = isActive;
    _facebook = facebook;
    _instagram = instagram;
    _twitter = twitter;
    _telegram = telegram;
    _linkedin = linkedin;
    _youtube = youtube;
  }

  ApplicationList.fromJson(dynamic json) {
    _androidUrl = json['android_url'];
    _appDiscription = json['appDiscription'];
    _appId = json['appId'];
    _appTitle = json['appTitle'];
    _buttonText = json['buttonText'];
    _createdDate = json['createdDate'];
    _images = json['images'];
    _iPhoneURL = json['iPhone_URL'];
    _isActive = json['isActive'];
    _facebook = json['facebook'];
    _instagram = json['instagram'];
    _twitter = json['twitter'];
    _telegram = json['telegram'];
    _linkedin = json['linkedin'];
    _youtube = json['youtube'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['android_url'] = _androidUrl;
    map['appDiscription'] = _appDiscription;
    map['appId'] = _appId;
    map['appTitle'] = _appTitle;
    map['buttonText'] = _buttonText;
    map['createdDate'] = _createdDate;
    map['images'] = _images;
    map['iPhone_URL'] = _iPhoneURL;
    map['isActive'] = _isActive;
    map['facebook'] = _facebook;
    map['instagram'] = _instagram;
    map['twitter'] = _twitter;
    map['telegram'] = _telegram;
    map['linkedin'] = _linkedin;
    map['youtube'] = _youtube;
    return map;
  }
}
