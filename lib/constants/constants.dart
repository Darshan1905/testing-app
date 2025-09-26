export 'package:flutter/material.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:occusearch/app_style/text_style/app_text_style.dart';
export 'package:occusearch/app_style/theme/app_color_style.dart';
export 'package:occusearch/common_widgets/ink_well_widget.dart';
export 'package:occusearch/constants/enum.dart';
export 'package:occusearch/data_provider/api_service/api_service.dart';
export 'package:occusearch/data_provider/api_service/base_response_model.dart';
export 'package:occusearch/data_provider/api_service/dio_commons.dart';
export 'package:occusearch/data_provider/api_service/network_controller.dart';
export 'package:occusearch/data_provider/firebase/event_log/firebase_analytic_event.dart';
export 'package:occusearch/data_provider/firebase/event_log/firebase_event_constants.dart';
export 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';
export 'package:occusearch/features/app/base_app.dart';
export 'package:occusearch/features/app/global_bloc.dart';
export 'package:occusearch/navigation/go_router.dart';
export 'package:occusearch/navigation/route_navigation.dart';
export 'package:occusearch/navigation/routes.dart';
export 'package:occusearch/resources/icons.dart';
export 'package:occusearch/resources/string_helper.dart';
export 'package:occusearch/utility/utils.dart';

class Constants {
  // CDN flag url for country flags
  static String cdnFlagURL = "https://cdn.ptetutorials.com/CountryFlag/";
  static String australiaFlagURL = "${cdnFlagURL}australia.svg";

  // [AUSSIZZ WEBSITE]
  static const aussizzWebsiteUrl = "https://aussizzgroup.com";

  // Terms & Condition URL
  static String termsURL =
      'https://www.aussizzgroup.com/SIteContent/terms-condition-occusearch.html';

  // Privacy & Policy URL
  static String policyURL =
      'https://www.aussizzgroup.com/SIteContent/privacy-policy-occusearch.html';

  // code of conduct
  static String cocURL =
      "https://www.mara.gov.au/tools-for-agents-subsite/Files/code-of-conduct-march-2022.pdf";

  static String occusearchDomainName =
      "https://www.aussizzgroup.com/occusearch";

  // COMMONWEALTH BANK LINK
  static const commonWealthBankUrl =
      "https://www.commbank.com.au/moving-to-australia.html?agentid=74340&ocid=mfs-74340";

  static const getMyPolicyUrl = "https://getmypolicy.online/au/";

  static const occuSearchLogoUrl = // [NOT IN USE]
      "https://firebasestorage.googleapis.com/v0/b/occusearch.appspot.com/o/OccuSearch_logo.png?alt=media&token=70dfb646-0c6e-4bf8-a9ca-b778f1d726ab";

  static const _jobOutLookMain = "https://joboutlook.gov.au/";

  static const jobOutLookDomain =
      "${_jobOutLookMain}occupations/occupation?occupationCode=";

  static const jobOutLookDomainOccupation =
      "${_jobOutLookMain}Occupation?search=alpha&code=";

  //custom question
  static String customQuestion = "assets/json/custom_question.json";

  static const appStoreLink =
      "https://apps.apple.com/app/occusearch-occupation-tracker/id1619089046";

  static const supportLink =
      "https://konze-cs.atlassian.net/servicedesk/customer/portal/3";

  static const playStoreLink =
      "https://play.google.com/store/apps/details?id=com.aussizzgroup.occusearch";

  static const occuSearchAppPlaystoreAppStoreDynamicLink =
      'https://occusearch.page.link/37mR';

  static const vevoCheckReportFilePDFName =
      'occusearch_vevo_visa_detail_check.pdf';
  static const visaFeesAdviceReportFilePDFName =
      'occusearch_visa_fees_estimation_report.pdf';

  static const fundCalculatorSummaryPDFName =
      'occusearch_fund_calculator_summary.pdf';

  static const recentUpdatePDFName = 'occusearch_recent_update.pdf';

  static const commonPadding = 25.0;

  static int statusCodeForNoInternet = 508;
  static int statusCodeForCacheData = 304;
  static int statusCodeForApiData = 200;

  /*For Dynamic link*/
  static const occusearchWebsiteRecentUpdateLink =
      "https://www.aussizzgroup.com/occusearch-update";

  // Visa Fees Official Link
  static const visaFeesOfficialLink =
      "https://immi.homeaffairs.gov.au/visas/visa-pricing-estimator";
}

/*  Facebook Event Keys  */
class EventsKey {
  //------------ SCREEN NAME ------------//
  static const SCREEN_SUBSCRIPTION = "SUBSCRIPTION_PLAN";

  //Sections
  static const SECTION_PURCHASE_PLAN = "Purchase Plan";
  static const SECTION_BASIC_PLAN = "Basic Plan";
  static const SECTION_PREMIUM_PLAN = "Premium Plan";
  static const SECTION_COMPARE_PLAN = "Compare Plan";

  //------------ Add Facebook Events Key Constants------------------------//
  //Event/ACTION
  static const IPHONE_PURCHASE_BASIC_PLAN = "iPhone_Purchase_Basic_Plan";
  static const ANDROID_PURCHASE_BASIC_PLAN = "Android_Purchase_Basic_Plan";
  static const IPHONE_PURCHASE_PREMIUM_PLAN = "iPhone_Purchase_Premium_Plan";
  static const ANDROID_PURCHASE_PREMIUM_PLAN = "Android_Purchase_Premium_Plan";
  static const IPHONE_BASIC_PLAN_BUY_NOW = "iPhone_Basic_Plan_buy_now";
  static const ANDROID_BASIC_PLAN_BUY_NOW = "Android_Basic_Plan_buy_now";
  static const IPHONE_PREMIUM_PLAN_BUY_NOW = "iPhone_Premium_Plan_buy_now";
  static const ANDROID_PREMIUM_PLAN_BUY_NOW = "Android_Premium_Plan_buy_now";
  static const IPHONE_COMPARE_PLAN = "iPhone_Compare_Plan";
  static const ANDROID_COMPARE_PLAN = "Android_Compare_Plan";
}