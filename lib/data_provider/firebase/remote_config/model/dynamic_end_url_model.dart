import 'package:occusearch/utility/extension.dart';

class DynamicEndUrlModel {
  General? general;
  VisaFees? visaFees;
  PointTest? pointTest;
  Dashboard? dashboard;
  Authentication? authentication;
  ProfileOccupation? profileOccupation;
  LatestUpdate? latestUpdate;
  VevoCheck? vevoCheck;
  SearchOccupation? searchOccupation;
  LabourInsights? labourInsights;
  CricosCourse? cricosCourse;
  SubscriptionPlan? subscriptionPlan;
  GetMyPolicy? getMyPolicy;

  DynamicEndUrlModel(
      {this.general,
      this.visaFees,
      this.pointTest,
      this.dashboard,
      this.authentication,
      this.profileOccupation,
      this.latestUpdate,
      this.vevoCheck,
      this.searchOccupation,
      this.labourInsights,
      this.cricosCourse,
      this.subscriptionPlan,
      this.getMyPolicy});

  DynamicEndUrlModel.fromJson(Map<String, dynamic> json) {
    general = json['general'] != null ? General.fromJson(json['general']) : null;
    visaFees = json['visaFees'] != null ? VisaFees.fromJson(json['visaFees']) : null;
    pointTest = json['point_test'] != null ? PointTest.fromJson(json['point_test']) : null;
    dashboard = json['dashboard'] != null ? Dashboard.fromJson(json['dashboard']) : null;
    authentication =
        json['authentication'] != null ? Authentication.fromJson(json['authentication']) : null;
    profileOccupation = json['profile_occupation'] != null
        ? ProfileOccupation.fromJson(json['profile_occupation'])
        : null;
    latestUpdate =
        json['latest_update'] != null ? LatestUpdate.fromJson(json['latest_update']) : null;
    vevoCheck = json['vevo_check'] != null ? VevoCheck.fromJson(json['vevo_check']) : null;
    searchOccupation = json['search_occupation'] != null
        ? SearchOccupation.fromJson(json['search_occupation'])
        : null;
    labourInsights =
        json['labour_insights'] != null ? LabourInsights.fromJson(json['labour_insights']) : null;
    cricosCourse =
        json['cricos_course'] != null ? CricosCourse.fromJson(json['cricos_course']) : null;
    subscriptionPlan = json['subscription_plan'] != null
        ? SubscriptionPlan.fromJson(json['subscription_plan'])
        : null;
    getMyPolicy =
        json['get_my_policy'] != null ? GetMyPolicy.fromJson(json['get_my_policy']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (general != null) {
      data['general'] = general!.toJson();
    }
    if (visaFees != null) {
      data['visaFees'] = visaFees!.toJson();
    }
    if (pointTest != null) {
      data['point_test'] = pointTest!.toJson();
    }
    if (dashboard != null) {
      data['dashboard'] = dashboard!.toJson();
    }
    if (authentication != null) {
      data['authentication'] = authentication!.toJson();
    }
    if (profileOccupation != null) {
      data['profile_occupation'] = profileOccupation!.toJson();
    }
    if (latestUpdate != null) {
      data['latest_update'] = latestUpdate!.toJson();
    }
    if (vevoCheck != null) {
      data['vevo_check'] = vevoCheck!.toJson();
    }
    if (searchOccupation != null) {
      data['search_occupation'] = searchOccupation!.toJson();
    }
    if (labourInsights != null) {
      data['labour_insights'] = labourInsights!.toJson();
    }
    if (cricosCourse != null) {
      data['cricos_course'] = cricosCourse!.toJson();
    }
    if (subscriptionPlan != null) {
      data['subscription_plan'] = subscriptionPlan!.toJson();
    }
    if (getMyPolicy != null) {
      data['get_my_policy'] = getMyPolicy!.toJson();
    }
    return data;
  }
}

class General {
  String? getMyPolicy;
  String? cdnUrl;
  String? chatBotUrl;
  String? gmpServerKey;

  General({this.getMyPolicy, this.cdnUrl, this.chatBotUrl, this.gmpServerKey});

  General.fromJson(Map<String, dynamic> json) {
    getMyPolicy = json['getMyPolicy'];
    cdnUrl = json['cdnUrl'];
    chatBotUrl = json['chatbotUrl'];
    gmpServerKey = json['gmpServerKey'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['getMyPolicy'] = getMyPolicy;
    data['cdnUrl'] = cdnUrl;
    data['chatbotUrl'] = chatBotUrl;
    data['gmpServerKey'] = gmpServerKey;
    return data;
  }
}

class VisaFees {
  String? visaPaymentMethodUrl;
  String? visaQuestionDetailUrl;
  String? visaPriceDetailUrl;

  VisaFees({this.visaPaymentMethodUrl, this.visaQuestionDetailUrl, this.visaPriceDetailUrl});

  VisaFees.fromJson(Map<String, dynamic> json) {
    visaPaymentMethodUrl = json.getFirebaseUrl('visaPaymentMethodUrl');
    visaQuestionDetailUrl = json.getFirebaseUrl('visaQuestionDetailUrl');
    visaPriceDetailUrl = json.getFirebaseUrl('visaPriceDetailUrl');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['visaPaymentMethodUrl'] = visaPaymentMethodUrl;
    data['visaQuestionDetailUrl'] = visaQuestionDetailUrl;
    data['visaPriceDetailUrl'] = visaPriceDetailUrl;
    return data;
  }
}

class PointTest {
  String? pointTestQuestionUrl;
  String? savePointTestUrl;
  String? getPointTestResultUrl;
  String? getPointTestPdfUrl;

  PointTest(
      {this.pointTestQuestionUrl,
      this.savePointTestUrl,
      this.getPointTestResultUrl,
      this.getPointTestPdfUrl});

  PointTest.fromJson(Map<String, dynamic> json) {
    pointTestQuestionUrl = json.getFirebaseUrl('pointTestQuestionUrl');
    savePointTestUrl = json.getFirebaseUrl('savePointTestUrl');
    getPointTestResultUrl = json.getFirebaseUrl('getPointTestResultUrl');
    getPointTestPdfUrl = json.getFirebaseUrl('getPointTestPdfUrl');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pointTestQuestionUrl'] = pointTestQuestionUrl;
    data['savePointTestUrl'] = savePointTestUrl;
    data['getPointTestResultUrl'] = getPointTestResultUrl;
    data['getPointTestPdfUrl'] = getPointTestPdfUrl;
    return data;
  }
}

class Dashboard {
  String? kondeskDeshboardUrl;

  Dashboard({this.kondeskDeshboardUrl});

  Dashboard.fromJson(Map<String, dynamic> json) {
    kondeskDeshboardUrl = json.getFirebaseUrl('kondeskDeshboardUrl');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['kondeskDeshboardUrl'] = kondeskDeshboardUrl;
    return data;
  }
}

class Authentication {
  String? deviceCountryInfo;
  String? firebaseCustomTokenUrl;
  String? getUserInfoUrl;
  String? registerUserUrl;
  String? emailVerify;
  String? userLogoutUrl;
  String? deleteAccountUrl;
  String? updateUserDeviceIDUrl;
  String? updateUserProfile;
  String? updateUserMigrationEmail;
  String? kondeskWebsite;
  String? getCustomQuestion;
  String? saveCustomQuestionAnswer;

  Authentication(
      {this.deviceCountryInfo,
      this.firebaseCustomTokenUrl,
      this.getUserInfoUrl,
      this.registerUserUrl,
      this.emailVerify,
      this.userLogoutUrl,
      this.deleteAccountUrl,
      this.updateUserDeviceIDUrl,
      this.updateUserProfile,
      this.updateUserMigrationEmail,
      this.kondeskWebsite,
      this.getCustomQuestion,
      this.saveCustomQuestionAnswer});

  Authentication.fromJson(Map<String, dynamic> json) {
    deviceCountryInfo = json['deviceCountryInfo'];
    firebaseCustomTokenUrl = json['firebaseCustomTokenUrl'];
    getUserInfoUrl = json.getFirebaseUrl('getUserInfoUrl');
    registerUserUrl = json.getFirebaseUrl('registerUserUrl');
    emailVerify = json.getFirebaseUrl('emailVerify');
    userLogoutUrl = json.getFirebaseUrl('userLogoutUrl');
    deleteAccountUrl = json.getFirebaseUrl('deleteAccountUrl');
    updateUserDeviceIDUrl = json.getFirebaseUrl('updateUserDeviceIDUrl');
    updateUserProfile = json.getFirebaseUrl('updateUserProfile');
    updateUserMigrationEmail = json.getFirebaseUrl('updateUserMigrationEmail');
    kondeskWebsite = json.getFirebaseUrl('kondeskWebsite');
    getCustomQuestion = json.getFirebaseUrl('getCustomQuestion');
    saveCustomQuestionAnswer = json.getFirebaseUrl('saveCustomQuestionAnswer');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['deviceCountryInfo'] = deviceCountryInfo;
    data['firebaseCustomTokenUrl'] = firebaseCustomTokenUrl;
    data['getUserInfoUrl'] = getUserInfoUrl;
    data['registerUserUrl'] = registerUserUrl;
    data['emailVerify'] = emailVerify;
    data['userLogoutUrl'] = userLogoutUrl;
    data['deleteAccountUrl'] = deleteAccountUrl;
    data['updateUserDeviceIDUrl'] = updateUserDeviceIDUrl;
    data['updateUserProfile'] = updateUserProfile;
    data['updateUserMigrationEmail'] = updateUserMigrationEmail;
    data['kondeskWebsite'] = kondeskWebsite;
    data['getCustomQuestion'] = getCustomQuestion;
    data['saveCustomQuestionAnswer'] = saveCustomQuestionAnswer;
    return data;
  }
}

class ProfileOccupation {
  String? deleteOccupationUrl;
  String? addOccupationUrl;
  String? getOccupationsByUser;

  ProfileOccupation({this.deleteOccupationUrl, this.addOccupationUrl, this.getOccupationsByUser});

  ProfileOccupation.fromJson(Map<String, dynamic> json) {
    deleteOccupationUrl = json.getFirebaseUrl('deleteOccupationUrl');
    addOccupationUrl = json.getFirebaseUrl('addOccupationUrl');
    getOccupationsByUser = json.getFirebaseUrl('getOccupationsByUser');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['deleteOccupationUrl'] = deleteOccupationUrl;
    data['addOccupationUrl'] = addOccupationUrl;
    data['getOccupationsByUser'] = getOccupationsByUser;
    return data;
  }
}

class LatestUpdate {
  String? getRecentChangesNew;

  LatestUpdate({this.getRecentChangesNew});

  LatestUpdate.fromJson(Map<String, dynamic> json) {
    getRecentChangesNew = json.getFirebaseUrl('getRecentChangesNew');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['getRecentChangesNew'] = getRecentChangesNew;
    return data;
  }
}

class VevoCheck {
  String? checkMyVisa;
  String? vrnOCRAPI;
  String? passportOCRAPI;

  VevoCheck({this.checkMyVisa, this.vrnOCRAPI, this.passportOCRAPI});

  VevoCheck.fromJson(Map<String, dynamic> json) {
    checkMyVisa = json.getFirebaseUrl('checkMyVisa');
    vrnOCRAPI = json.getFirebaseUrl('vrnOCRAPI');
    passportOCRAPI = json.getFirebaseUrl('passportOCRAPI');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['checkMyVisa'] = checkMyVisa;
    data['vrnOCRAPI'] = vrnOCRAPI;
    data['passportOCRAPI'] = passportOCRAPI;
    return data;
  }
}

class SearchOccupation {
  String? getGeneralAndUnitGroupDetailData;
  String? getAllVisaTypeData;
  String? getStateEligibilityData;
  String? getStateEligibilityVisaListData;
  String? getAccessingAuthorityDetailsData;
  String? getInvitationCutOffDetail;
  String? getEOIStatisticsCountData;
  String? getStateEligibilityDetail;

  SearchOccupation(
      {this.getGeneralAndUnitGroupDetailData,
      this.getAllVisaTypeData,
      this.getStateEligibilityData,
      this.getStateEligibilityVisaListData,
      this.getAccessingAuthorityDetailsData,
      this.getInvitationCutOffDetail,
      this.getEOIStatisticsCountData,
      this.getStateEligibilityDetail});

  SearchOccupation.fromJson(Map<String, dynamic> json) {
    getGeneralAndUnitGroupDetailData = json.getFirebaseUrl('getGeneralAndUnitGroupDetailData');
    getAllVisaTypeData = json.getFirebaseUrl('getAllVisaTypeData');
    getStateEligibilityData = json.getFirebaseUrl('getStateEligibilityData');
    getStateEligibilityVisaListData = json.getFirebaseUrl('getStateEligibilityVisaListData');
    getAccessingAuthorityDetailsData = json.getFirebaseUrl('getAccessingAuthorityDetailsData');
    getInvitationCutOffDetail = json.getFirebaseUrl('getInvitationCutOffDetail');
    getEOIStatisticsCountData = json.getFirebaseUrl('getEOIStatisticsCountData');
    getStateEligibilityDetail = json.getFirebaseUrl('getStateEligibilityDetail');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['getGeneralAndUnitGroupDetailData'] = getGeneralAndUnitGroupDetailData;
    data['getAllVisaTypeData'] = getAllVisaTypeData;
    data['getStateEligibilityData'] = getStateEligibilityData;
    data['getStateEligibilityVisaListData'] = getStateEligibilityVisaListData;
    data['getAccessingAuthorityDetailsData'] = getAccessingAuthorityDetailsData;
    data['getInvitationCutOffDetail'] = getInvitationCutOffDetail;
    data['getEOIStatisticsCountData'] = getEOIStatisticsCountData;
    data['getStateEligibilityDetail'] = getStateEligibilityDetail;
    return data;
  }
}

class LabourInsights {
  String? getMarketPlaceAustraliaData;
  String? labourInsightOccupation;
  String? labourInsightUnitGroup;

  LabourInsights(
      {this.getMarketPlaceAustraliaData,
      this.labourInsightOccupation,
      this.labourInsightUnitGroup});

  LabourInsights.fromJson(Map<String, dynamic> json) {
    getMarketPlaceAustraliaData = json.getFirebaseUrl('getMarketPlaceAustraliaData');
    labourInsightOccupation = json.getFirebaseUrl('labourInsightOccupation');
    labourInsightUnitGroup = json.getFirebaseUrl('labourInsightUnitGroup');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['getMarketPlaceAustraliaData'] = getMarketPlaceAustraliaData;
    data['labourInsightOccupation'] = labourInsightOccupation;
    data['labourInsightUnitGroup'] = labourInsightUnitGroup;
    return data;
  }
}

class CricosCourse {
  String? getCourseData;
  String? getFilterMaster;
  String? addCourse;
  String? deleteCourse;
  String? myCourse;
  String? getCourseList;
  String? getRelatedCourseByOccupation;
  String? getTopUniversitiesList;

  CricosCourse(
      {this.getCourseData,
      this.getFilterMaster,
      this.addCourse,
      this.deleteCourse,
      this.myCourse,
      this.getCourseList,
      this.getRelatedCourseByOccupation,
      this.getTopUniversitiesList});

  CricosCourse.fromJson(Map<String, dynamic> json) {
    getCourseData = json.getFirebaseUrl('getCourseData');
    getFilterMaster = json.getFirebaseUrl('getFilterMaster');
    addCourse = json.getFirebaseUrl('addCourse');
    deleteCourse = json.getFirebaseUrl('deleteCourse');
    myCourse = json.getFirebaseUrl('myCourse');
    getCourseList = json.getFirebaseUrl('getCourseList');
    getRelatedCourseByOccupation = json.getFirebaseUrl('getRelatedCourseByOccupation');
    getTopUniversitiesList = json.getFirebaseUrl('getTopUniversitiesList');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['getCourseData'] = getCourseData;
    data['getFilterMaster'] = getFilterMaster;
    data['addCourse'] = addCourse;
    data['deleteCourse'] = deleteCourse;
    data['myCourse'] = myCourse;
    data['getCourseList'] = getCourseList;
    data['getRelatedCourseByOccupation'] = getRelatedCourseByOccupation;
    data['getTopUniversitiesList'] = getTopUniversitiesList;
    return data;
  }
}

class SubscriptionPlan {
  String? getOccuSubscriptionPlan;
  String? getMyOccuSubscriptionPlan;
  String? buyOccuSubscriptionPlan;
  String? getMyOccuSubTranshistory;
  String? checkPromoCode;
  String? getPromoCodeList;

  SubscriptionPlan(
      {this.getOccuSubscriptionPlan,
      this.getMyOccuSubscriptionPlan,
      this.buyOccuSubscriptionPlan,
      this.getMyOccuSubTranshistory,
      this.checkPromoCode,
      this.getPromoCodeList});

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    getOccuSubscriptionPlan = json.getFirebaseUrl('getOccuSubscriptionPlan');
    getMyOccuSubscriptionPlan = json.getFirebaseUrl('getMyOccuSubscriptionPlan');
    buyOccuSubscriptionPlan = json.getFirebaseUrl('buyOccuSubscriptionPlan');
    getMyOccuSubTranshistory = json.getFirebaseUrl('getMyOccuSubTranshistory');
    checkPromoCode = json.getFirebaseUrl('checkPromoCode');
    getPromoCodeList = json.getFirebaseUrl('getPromoCodeList');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['getOccuSubscriptionPlan'] = getOccuSubscriptionPlan;
    data['getMyOccuSubscriptionPlan'] = getMyOccuSubscriptionPlan;
    data['buyOccuSubscriptionPlan'] = buyOccuSubscriptionPlan;
    data['getMyOccuSubTranshistory'] = getMyOccuSubTranshistory;
    data['checkPromoCode'] = checkPromoCode;
    data['getPromoCodeList'] = getPromoCodeList;
    return data;
  }
}

class GetMyPolicy {
  String? getOSHCDetails;
  String? getOVHCDetails;
  String? buyOVHCQuote;
  String? buyOSHCQuote;
  String? buyOSHCPolicy;

  GetMyPolicy(
      {this.getOSHCDetails,
      this.getOVHCDetails,
      this.buyOVHCQuote,
      this.buyOSHCQuote,
      this.buyOSHCPolicy});

  GetMyPolicy.fromJson(Map<String, dynamic> json) {
    getOSHCDetails = json.getFirebaseUrl('getOSHCQuote');
    getOVHCDetails = json.getFirebaseUrl('getOVHCQuote');
    buyOVHCQuote = json.getFirebaseUrl('buyOVHCQuote');
    buyOSHCQuote = json.getFirebaseUrl('buyOSHCQuote');
    buyOSHCPolicy = json.getFirebaseUrl('buyOSHCPolicy');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['getOSHCQuote'] = getOSHCDetails;
    data['getOVHCQuote'] = getOVHCDetails;
    data['buyOVHCQuote'] = buyOVHCQuote;
    data['buyOSHCQuote'] = buyOSHCQuote;
    data['buyOSHCPolicy'] = buyOSHCPolicy;
    return data;
  }
}
