// ** Firebase Analytics Column **
const String firebaseAnalyticsCurrentScreenName = "CURRENT_SCREEN_NAME";
const String firebaseAnalyticsPreviousScreenName = "PREVIOUS_SCREEN_NAME";
const String firebaseAnalyticsNextScreenName = "NEXT_SCREEN_NAME";
const String firebaseAnalyticsSectionName = "SECTION_NAME";
const String firebaseAnalyticsSubSectionName = "SUB_SECTION_NAME";
const String firebaseAnalyticsTitle = "TITLE";
const String firebaseAnalyticsMessage = "MESSAGE";
const String firebaseAnalyticsUserId = "USER_ID";
const String firebaseAnalyticsUsername = "USER_NAME";
const String firebaseAnalyticsUserEmail = "USER_EMAIL";
const String firebaseAnalyticsUserMobile = "USER_MOBILE";
const String firebaseAnalyticsFbToken = "FIREBASE_TOKEN";
const String firebaseAnalyticsFbUserId = "FIREBASE_USER_ID";
const String firebaseAnalyticsOther = "OTHER_INFO";
const String firebaseAnalyticsNavigationTo = "NAVIGATION_STATUS";
const String firebaseAnalyticsSpentTime = "SPENT_TIME";
const String firebaseAnalyticsAction = "ACTION";
// APIs
const String firebaseAnalyticsApiName = "API_NAME";
const String firebaseAnalyticsApiHeader = "API_HEADER";
const String firebaseAnalyticsApiRequestJson = "API_REQUEST_JSON";
const String firebaseAnalyticsApiRequestEncryptedJson = "API_REQUEST_ENCRYPTED_JSON";
const String firebaseAnalyticsApiRequestType = "API_REQUEST_TYPE";
const String firebaseAnalyticsApiResponseJson = "API_RESPONSE_JSON";
const String firebaseAnalyticsApiResponseCode = "API_RESPONSE_CODE";
const String firebaseAnalyticsApiResponseMessage = "API_RESPONSE_MESSAGE";
const String firebaseAnalyticsApiRequestTypePost = "POST";
const String firebaseAnalyticsApiRequestTypeGet = "GET";
// Payment
const String firebaseAnalyticsCartId = "CART_ID";
const String firebaseAnalyticsProductId = "PRODUCT_ID";
const String firebaseAnalyticsProductName = "PRODUCT_NAME";
const String firebaseAnalyticsTransactionId = "TRANSACTION_ID";
const String firebaseAnalyticsPaymentTokenId = "PAYMENT_TOKEN_ID";
const String firebaseAnalyticsProductPrice = "PRODUCT_PRICE";
const String firebaseAnalyticsCurrency = "CURRENCY";
const String firebaseAnalyticsDeviceType = "DEVICE_TYPE";
const String firebaseAnalyticsPriceId = "PRICE_ID";
const String firebaseAnalyticsPaymentFlag = "PAYMENT_FLAG";
const String firebaseAnalyticsPaymentGateway = "PAYMENT_GATEWAY";
const String firebaseAnalyticsIsPurchaseProduct = "IS_PURCHASE_PRODUCT";
// Notification & Dynamic link
const String firebaseAnalyticsIsNotification =
    "IS_NOTIFICATION"; // [TRUE] Notification, [FALSE] Dynamic link
const String firebaseAnalyticsType = "type";
const String firebaseAnalyticsUrl = "URL";
// Firebase Event Name
const String firebaseAnalyticsEventLog = "EVENT_LOG";
const String firebaseAnalyticsEventTracking = "EVENT_TRACKING";
const String firebaseAnalyticsNavigationTracking = "NAVIGATION_TRACKING";
const String firebaseAnalyticsScreenTimeTracking = "SCREEN_TIME_TRACKING";
const String firebaseAnalyticsApiTracking = "API_TRACKING";
const String firebaseAnalyticsPaymentTracking = "PAYMENT_TRACKING";
const String firebaseAnalyticsNotifyDynamicTracking = "NOTIFICATION_DYNAMIC_LINK_TRACKING";

class FBActionEvent {
  // Navigation Action
  static String fbActionPush = "PUSH";
  static String fbActionPop = "POP";
  static String fbActionPause = "BACKGROUND";
  static String fbActionResume = "FOREGROUND";
  static String fbActionRemove = "REMOVE";
  static String fbActionReplace = "REPLACE";

  // Action Event name
  static String fbWhatsappWelcomeMsg = "WHATSAPP_WELCOME_MSG";
  static String fbActionDownload = "DOWNLOAD";
  static String fbActionClick = "CLICK";
  static String fbActionSave = "SAVE";
  static String fbActionDynamicLink = "DYNAMIC_LINK";
  static String fbActionFollow = "FOLLOW";
  static String fbActionEmail = "EMAIL";
  static String fbActionCall = "CALL";
  static String fbActionReferral = "REFERRAL";
  static String fbActionWatch = "WATCH";
  static String fbActionJoin = "JOIN";
  static String fbActionDelete = "DELETE";
  static String fbActionBook = "BOOK";
  static String fbActionAdsBanner = "AD_BANNER";
  static String fbActionOfferBanner = "OFFER_BANNER";
  static String fbActionTermsCondition = "TERMS_AND_CONDITION";

  // Ecommerce
  static String fbActionBuy = "BUY";
  static String fbActionWishlist = "WISHLIST";
  static String fbActionCheckout = "CHECKOUT";
  static String fbActionPayment = "PAYMENT";
  static String fbActionItemRemove = "ITEM_REMOVE";
  static String fbActionCoupon = "COUPON";

  //Dashboard Screen Action Event
  static String fbActionNotification = "NOTIFICATION_ACTION";
  static String fbActionWelcomeBack = "WELCOME_BACK";
  static String fbActionLetsGo = "LETS_GO_ACTION";
  static String fbActionCalculateNow = "CALCULATE_NOW_ACTION";
  static String fbActionAddNow = "ADD_NOW_ACTION";
  static String fbActionViewAll = "VIEW_ALL_ACTION";
  static String fbActionRecentUpdatesList = "RECENT_UPDATES_LIST_ACTION";
  static String fbActionAddOccupation = "ADD_OCCUPATION_ACTION";
  static String fbActionTakeTheTest = "TAKE_THE_TEST_ACTION";
  static String fbActionRetakePointTest = "RETAKE_POINT_TEST_ACTION";
  static String fbActionReferAFriend = "REFER_A_FRIEND_ACTION";

  //MORE MENU ACTION EVENT
  static String fbActionEditProfile = "EDIT_PROFILE_ACTION";
  static String fbActionRateUs = "RATE_US_ACTION";
  static String fbAds = "ADS_BANNER_CLICK";
  static String fbActionMoreApp = "MORE_APP_ACTION";
  static String fbActionVevoCheck = "VEVO_CHECK_ACTION";
  static String fbActionContactUs = "CONTACT_US_ACTION";
  static String fbActionPrivacyPolicy = "PRIVACY_POLICY_ACTION";
  static String fbActionTermsAndCondition = "TERMS_AND_CONDITION_ACTION";
  static String fbCodeOfConduct = "CODE_OF_CONDUCT_ACTION";
  static String fbFundCalculator = "FUND_CALCULATOR";
  static String fbActionDeleteAccount = "DELETE_ACCOUNT_ACTION";
  static String fbActionLogout = "LOGOUT_ACTION";

  //MY PROFILE ACTION EVENT
  static String fbActionPersonalDetailsTab = "PERSONAL_DETAILS_TAB_ACTION";
  static String fbActionPointTestTab = "POINT_TEST_TAB_ACTION";
  static String fbActionEdit = "EDIT_ACTION";
  static String fbActionVerifyEmail = "VERIFY_EMAIL_ACTION";
  static String fbActionVerifyNumber = "VERIFY_NUMBER_ACTION";
  static String fbActionChangeCountryCode = "CHANGE_COUNTRY_CODE_ACTION";
  static String fbActionDob = "DOB_ACTION";
  static String fbActionViewScoreDetails = "VIEW_SCORE_DETAILS_ACTION";
  static String fbActionSharePdf = "SHARE_PDF_ACTION";
  static String fbActionDownloadPdf = "DOWNLOAD_PDF_ACTION";
  static String fbActionViewMailPdf = "MAIL_PDF_ACTION";

  //CONTACT US SCREEN ACTION EVENT
  static String fbActionCountryNameDropdown =
      "COUNTRY_NAME_DROPDOWN_ACTION";
  static String fbActionSocialMediaWidget = "SOCIAL_MEDIA_WIDGET_ACTION";
  static String fbActionWhatsapp = "WHATSAPP_ACTION";
  static String fbActionFacebook = "FACEBOOK_ACTION";
  static String fbActionTwitter = "TWITTER_ACTION";
  static String fbActionInstagram = "INSTAGRAM_ACTION";
  static String fbActionTelegram = "TELEGRAM_ACTION";
  static String fbActionLinkedin = "LINKEDIN_ACTION";

  //OCCUPATION DETAIL SCREENS ACTION EVENT
  static String fbActionRemoveOccupation = "REMOVE_OCCUPATION_ACTION";
  static String fbActionChartView = "CHART_VIEW_ACTION";
  static String fbActionTableView = "TABLE_VIEW_ACTION";
  static String fbActionMonth = "MONTH_ACTION";
  static String fbActionYear = "YEAR_ACTION";
  static String fbActionCaveat = "CAVEAT_GENERAL_SUB_SECTION";
  static String fbActionSpecialisation = "SPECIALISATION_ACTION";
  static String fbActionAssessingAuthority = "ASSESSING_AUTHORITY_ACTION";
  static String fbActionRelatedOccupation = "RELATED_OCCUPATION_ACTION";
  static String fbActionInvitationCutOff = "INVITATION_CUT_OFF_ACTION";
  static String fbActionEmploymentStatistics =
      "EMPLOYMENT_STATISTICS_ACTION";

  //POINT TEST SCREEN ACTION EVENT
  static String fbActionPrevious = "PREVIOUS_ACTION";
  static String fbActionNext = "NEXT_ACTION";
  static String fbActionSubmit = "SUBMIT_ACTION";
  static String fbActionDashboard = "DASHBOARD_ACTION";
  static String fbActionRetake = "RETAKE_ACTION";
  static String fbActionSendMail = "SEND_MAIL_ACTION";
  static String fbActionShare = "SHARE_ACTION";
  static String fbActionPointCalculator = "POINT_CALCULATOR_ACTION";
  static String fbActionMyOccupation = "MY_OCCUPATION_ACTION";

  //Registration Screens Action Event
  static String fbActionSignIn = "SIGN_IN_ACTION";
  static String fbActionContinueWithGoogle = "CONTINUE_WITH_GOOGLE_ACTION";
  static String fbActionSendOtp = "SEND_OTP_ACTION";
  static String fbActionLoginWithEmail = "LOGIN_WITH_EMAIL_ACTION";
  static String fbActionLoginWithNumber = "LOGIN_WITH_NUMBER_ACTION";
  static String fbActionVerify = "VERIFY_ACTION";
  static String fbActionUseDiffNumber = "USE_DIFF_NUMBER_ACTION";
  static String fbActionGetStarted = "GET_STARTED_ACTION";
  static String fbActionLetsStart = "LETS_START_ACTION";
  static String fbActionCustomQuestionContinue = "CUSTOM_QUESTIONS_CONTINUE_ACTION";
  static String fbActionCreateAccount = "CREATE_ACCOUNT_ACTION";
  static String fbActionUserLimitAlert = "USER_LIMIT_ALERT_ACTION";
  static String fbActionUserDashboardCustomQuestionCard = "USER_DASHBOARD_CUSTOM_QUESTION_CARD";


  //Visa Fees Action Event
  static String fbActionAddSecondaryApplicant =
      "ADD_SECONDARY_APPLICANT_ACTION";
  static String fbActionVevoCheckPassport = "VEVO_CHECK_PASSPORT_ACTION";

  //CUSTOM QUESTIONS
  static String fbCustomQuestionSubmit =
      "CUSTOM_QUESTION_SUBMIT_SECTION";
}

//Section name
class FBSectionEvent {
  //Dashboard
  static String fbSectionAdsBanner = "ADS_BANNER_SECTION";
  static String fbSectionRateReview = "RATE_REVIEW_SECTION";
  static String fbSectionPointTest = "POINT_TEST_SECTION";
  static String fbSectionNotificationScreen = "NOTIFICATION_SCREEN_SECTION";
  static String fbSectionVisaFeesCalculator =
      "VISA_FEES_CALCULATOR_SCREEN_SECTION";
  static String fbSectionSearchOccupation =
      "SEARCH_OCCUPATION_SCREEN_SECTION";
  static String fbSectionSearchCourse =
      "SEARCH_COURSE_SCREEN_SECTION";
  static String fbSectionRecentUpdates = "RECENT_UPDATES_SCREEN_SECTION";
  static String fbSectionAddOccupation = "ADD_OCCUPATION_SCREEN_SECTION";
  static String fbSectionReferAFriend = "REFER_A_FRIEND_SECTION";
  static String fbSectionMoreApps = "MORE_APPS_SECTION";
  static String fbSectionAboutAussizz = "ABOUT_AUSSIZZ_GROUP_SECTION";

  //LATEST UPDATE
  static String fbSectionLatestUpdate = "LATEST_UPDATE_SECTION";

  //MORE APP
  static String fbSectionMoreApp = "MORE_APP_SECTION";

  //MORE MENU
  static String fbSectionEditProfile = "EDIT_PROFILE_SECTION";
  static String fbSectionRateUs = "RATE_US_SECTION";
  static String fbSectionContactUs = "CONTACT_US_SECTION";
  static String fbSectionPrivacyPolicy = "PRIVACY_POLICY_SECTION";
  static String fbSectionTermsAndCondition = "TERMS_AND_CONDITION_SECTION";
  static String fbSectionLogout = "LOGOUT_SECTION";
  static String fbSectionDeleteAccount = "DELETE_ACCOUNT_SECTION";
  static String fbSectionAussizzWebsite = "AUSSIZZ_WEBSITE_SECTION";

  //MY PROFILE
  static String fbSectionPersonalDetailsTab =
      "PERSONAL_DETAILS_TAB_SECTION";
  static String fbSectionPointTestTab = "POINT_TEST_TAB_SECTION";
  static String fbSectionDeleteAccountRequest = "DELETE_ACCOUNT_REQUEST";

  //SEARCH OCCUPATION DETAILS SCREEN
  static String fbSectionSearchOccupationDetail =
      "SEARCH_OCCUPATION_DETAIL_SECTION";
  static String fbSectionAllVisaType = "ALL_VISA_TYPE_SECTION";
  static String fbSectionStateEligibility = "STATE_ELIGIBILITY_SECTION";
  static String fbSectionEoiStatistics = "EOI_STATISTICS_SECTION";
  static String fbSectionUnitGroup = "UNIT_GROUP_SECTION";
  static String fbSectionGeneral = "GENERAL_SECTION";

  //POINT TEST REVIEW SCREEN
  static String fbSectionPointTestReview = "POINT_TEST_REVIEW_SECTION";
  static String fbSectionDashboard = "DASHBOARD_SECTION";
  static String fbSectionActionBar = "ACTION_BAR_SECTION";
  static String fbSectionPointScore = "POINT_SCORE_SECTION";
  static String fbSectionPointDetailsEdit = "POINT_DETAILS_EDIT_SECTION";
  static String fbSectionPointDetailsList = "POINT_DETAILS_LIST_SECTION";

  //REGISTRATION SCREENS
  static String fbSectionLogin = "LOGIN_SECTION";
  static String fbSectionOtp = "OTP_SECTION";
  static String fbSectionCreateAccount = "CREATE_ACCOUNT_SECTION";
  static String fbSectionWelcome = "WELCOME_SECTION";
  static String fbSectionUserLimitLogout = "USER_LIMIT_LOGOUT_SECTION";

  //Visa Fees Estimator
  static String fbSectionCurrencyEstimationSelection =
      "CURRENCY_ESTIMATION_SELECTION_SECTION";
  static String fbSectionSecondaryApplicant = "SECONDARY_APPLICANT_SECTION";
  static String fbSectionPaymentMode = "PAYMENT_MODE_SECTION";

}

//Sub Section name
class FBSubSectionEvent {
  //Dashboard
  static String fbSubSectionDashboardBannerPointTest =
      "DASHBOARD_BANNER_POINT_TEST";
  static String fbSubSectionDashboardBannerVisaFeesCalculator =
      "DASHBOARD_BANNER_VISA_FEES_CALCULATOR";
  static String fbSubSectionDashboardBannerSearchOccupation =
      "DASHBOARD_BANNER_SEARCH_OCCUPATION";
  static String fbSubSectionDashboardMoreAppSectionFacebook =
      "DASHBOARD_MORE_APP_SECTION_FACEBOOK";
  static String fbSubSectionDashboardMoreAppSectionInstagram =
      "DASHBOARD_MORE_APP_SECTION_INSTAGRAM";
  static String fbSubSectionDashboardMoreAppSectionYoutube =
      "DASHBOARD_MORE_APP_SECTION_YOUTUBE";
  static String fbSubSectionDashboardMoreAppSectionTwitter =
      "DASHBOARD_MORE_APP_SECTION_TWITTER";
  static String fbSubSectionDashboardMoreAppSectionTelegram =
      "DASHBOARD_MORE_APP_SECTION_TELEGRAM";
  static String fbSubSectionDashboardMoreAppSectionLinkedin =
      "DASHBOARD_MORE_APP_SECTION_LINKEDIN";

  static String fbSubSectionDashboardAboutAussizzSectionFacebook =
      "DASHBOARD_ABOUT_AUSSIZZ_SECTION_FACEBOOK";
  static String fbSubSectionDashboardAboutAussizzSectionInstagram =
      "DASHBOARD_ABOUT_AUSSIZZ_SECTION_INSTAGRAM";
  static String fbSubSectionDashboardAboutAussizzSectionYoutube =
      "DASHBOARD_ABOUT_AUSSIZZ_SECTION_YOUTUBE";
  static String fbSubSectionDashboardAboutAussizzSectionTwitter =
      "DASHBOARD_ABOUT_AUSSIZZ_SECTION_TWITTER";
  static String fbSubSectionDashboardAboutAussizzSectionTelegram =
      "DASHBOARD_ABOUT_AUSSIZZ_SECTION_TELEGRAM";
  static String fbSubSectionDashboardAboutAussizzSectionLinkedin =
      "DASHBOARD_ABOUT_AUSSIZZ_SECTION_LINKEDIN";

  //SEARCH OCCUPATION DETAIL
  static String fbSubSectionCaveat = "CAVEAT_GENERAL_SUB_SECTION";
  static String fbSubSectionSpecialisation =
      "SPECIALISATION_GENERAL_SUB_SECTION";
  static String fbSubSectionAssessingAuthority =
      "ASSESSING_AUTHORITY_GENERAL_SUB_SECTION";
  static String fbSubSectionRelatedOccupation =
      "RELATED_OCCUPATION_SUB_SECTION";
  static String fbSubSectionInvitationCutOff =
      "INVITATION_CUT_OFF_GENERAL_SUB_SECTION";
  static String fbSubSectionEmploymentStatistics =
      "EMPLOYMENT_STATISTICS_GENERAL_SUB_SECTION";

  //Contact Us
  static String fbSubSectionContactUsCountryname =
      "CONTACT_US_COUNTRYNAME_SUB_SECTION";
  static String fbSubSectionContactUsCitynameList =
      "CONTACT_US_CITYNAME_LIST_SUB_SECTION";
  static String fbSubSectionContactUsGooglemap =
      "CONTACT_US_GOOGLEMAP_SUB_SECTION";
}
