enum ApiHeader {
  deviceType,
  browser,
  authorizationKondesk,
  authorizationAnzsco,
  contentTypeJson,
  contentTypeFormData,
  contentTypeUrl
}

class NetworkAPIConstant {
  //class instances
  static RequestResponseKeys reqResKeys = RequestResponseKeys();

  //status code
  static const statusCodeSuccess = 200;
  static const statusCodeCaching = 304;
  static const statusCodeServerError = 500;
  static const statusCodeNoInternet = 901;
  static const statusCodeBlankUrl = 902;
  static const statusCodeVPNConnection = 903;

  //string constants
  static const noInternetConnection = "No Internet Connection";
  static const somethingWentWrong = "Something went wrong";
  static const vpnAlertMessage = "Please disconnect VPN to continue.";
}

class RequestResponseKeys {
  //header
  final String contentType = "Content-Type";
  final String deviceType = "device_type";
  final String authorization = "Authorization";
  final String browser = "browser_detail";

  String get id => "id";

  String get userid => "userid";

  String get userId => "userId";

  String get deviceid => "deviceid";

  String get deviceId => "deviceId";

  String get companyId => "companyid";

  String get branchId => "branchid";

  String get leadId => "leadid";

  String get tokenId => "tokenid";

  String get countryCode => "countrycode";

  String get sessionId => "sessionid";

  String get fcmToken => "fcmToken";

  //header

  String get devicetype => "devicetype";

  //verifyUser
  String get phoneNo => "phone";

  String get phone => "Phone";

  String get mobile => "mobilenumber";

  String get name => "name";

  String get email => "email";

  String get contact => "contact";

  String get fcmtoken => "fcmtoken";

  String get session => "session";

  String get emailAddress => "emailaddress";

  String get verifyUseremail => "Email";

  String get langID => "languageId";

  String get cCode => "ccode";

  String get profilePicture => "profile_picture_picker";

  String get dateOfBirth => "dateOfBirth";

  //Course
  String get ascedCode => "asced_code";
  String get cricosCode => "cricoscode";
}

class RequestParameterKey {
  static const String session = "session";
  static const String contact = "contact";
  static const String email = "email";
  static const String fcmToken = "fcmtoken";
  static const String deviceId = "deviceid";
  static const String phone = "phone";

  static const String userid = "userid";
  static const String name = "name";
  static const String leadId = "leadid";
  static const String companyId = "companyid";
  static const String branchId = "branchid";
  static const String oldEmailAddress = "oldemailaddress";
  static const String newEmailAddress = "newemailaddress";
  static const String dateOfBirth = "dateOfBirth";
  static const String countrycode = "countrycode";

  static const String companyIdf = "companyidf";
  static const String branchIdf = "branchidf";

  static const String secretKey = "secretkey";
  static const String sKey = "skey";
  static const String purchasePolicy = "purchasepolicy";
  static const String leadFirstName = "leadfirstname";
  static const String leadLastName = "leadlastname";
  static const String countryCode = "countrycode";
  static const String phoneNo = "phoneno";
  static const String leadSource = "leadsource";
  static const String insuranceProviderId = "insuranceproviderid";
  static const String insuranceType = "insurancetype";
  static const String insuranceStartDate = "insurancestartdate";
  static const String insuranceEndDate = "insuranceenddate";
  static const String isLiveInAustralia = "isliveinaustralia";
  static const String insuranceAmount = "insuranceamount";
  static const String insuranceAudAmount = "insuranceaudamount";
  static const String isActive = "isactive";
  static const String leadFrom = "leadfrom";
  static const String leadType = "leadtype";
  static const String createdBy = "createdby";
  static const String isEmailQuote = "isemailquote";
  static const String isPhoneQuote = "isphonequote";
  static const String isMailNotSendKonDesk = "ismailnotsendkondesk";

  // Occupation
  static const String occupationId = "occupationid";

  //Vevo Check
  static const String dateofbirth = "dateofbirth";
  static const String visaGrantNumber = "VisaGrantNumber";
  static const String transactionRefType = "refType";
  static const String passportNumber = "PassportNumber";
  static const String countryIDF = "Countryidf";

  // [secureDeviceId] don't change this, use to get unique device id for iOS platform
  static const String secureDeviceId = "secureDeviceIdKey";

  //for courseSearch
  static const String searchByName = "search_by_name";
  static const String universityId = "university_id";
  static const String studyArea = "study_area";
  static const String areaOfStudy = "area_of_study";
  static const String deliveryMode = "delivery_mode";
  static const String studyLevel = "study_level";
  static const String feeRange = "fee_range";
  static const String duration = "duration";
  static const String courseType = "course_type";
  static const String ascedCode = "asced_code";
  static const String cricos = "cricos";
  static const String intake = "intake";

  //for Subscriptions
  static const String subscriptionId = "subscriptionId";
  static const String currency = "currency";
  static const String price = "price";
  static const String planName = "planname";
  static const String subClass = "subclass";
  static const String orderId = "orderId";
  static const String productID = "productID";
  static const String purchaseToken = "purchaseToken";
  static const String isAutoRenewing = "isAutoRenewing";
  static const String quantity = "quantity";
  static const String source = "source";
  static const String transactionDate = "transactionDate";
  static const String status = "status";
  static const String startDate = "startdate";
  static const String type = "type";
  static const String endDate = "enddate";
  static const String promoCode = "promoCode";

  // for getMyPolicy
  static const String serverKey = "skey";
  static const String coverValue = "covervalue";
  static const String visaType = "visatype";
  static const String providerId = "providerid";
  static const String filterDate = "filterdate";
  static const String filterEndDate = "filterenddate";
  static const String providerName = "providerName";
  static const String providerUrl = "providerurl";
  static const String providerLogo = "providerlogo";
  static const String coverType = "covertype";
  static const String fullMobileNumber = "fullMobileNumber";
  static const String fullName = "fullname";
  static const String emailAddress = "emailaddress";

}
