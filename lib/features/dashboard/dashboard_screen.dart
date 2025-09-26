import 'dart:convert';
import 'dart:io';

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:occusearch/common_widgets/ads_dialog.dart';
import 'package:occusearch/common_widgets/subscription_details_dialog.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_course_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_occupation_table.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';
import 'package:occusearch/features/cricos_course/course_list/widgets/top_universities_widget.dart';
import 'package:occusearch/features/custom_question/custom_question_bloc.dart';
import 'package:occusearch/features/dashboard/dashboard_bloc.dart';
import 'package:occusearch/features/dashboard/widget/all_recent_search_list_widget.dart';
import 'package:occusearch/features/dashboard/widget/because_you_searched_widget.dart';
import 'package:occusearch/features/dashboard/widget/dashboard_bookmark_occupation_widget.dart';
import 'package:occusearch/features/dashboard/widget/dashboard_contact_us_widget.dart';
import 'package:occusearch/features/dashboard/widget/dashboard_footer_brand.dart';
import 'package:occusearch/features/dashboard/widget/dashboard_header_widget.dart';
import 'package:occusearch/features/dashboard/widget/dashboard_menu_section_widget.dart';
import 'package:occusearch/features/dashboard/widget/dashboard_other_product_widget.dart';
import 'package:occusearch/features/dashboard/widget/dashboard_recent_update_widget.dart';
import 'package:occusearch/features/dashboard/widget/most_visited_occupation_widget.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_bloc.dart';
import 'package:occusearch/features/my_bookmark/my_bookmark_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_bloc.dart';
import 'package:occusearch/features/subscription/subscription_bloc.dart';
import 'package:occusearch/utility/rating/dynamic_rating_bloc.dart';
import 'package:occusearch/utility/rating/dynamic_rating_dialog.dart';

class DashboardScreen extends BaseApp {
  final Function(int)? changeTab;

  const DashboardScreen({super.key, this.changeTab}) : super.builder();

  @override
  BaseState createState() => _DashboardState();
}

class _DashboardState extends BaseState {
  final _dashboardBloc = DashboardBloc();
  OccupationListBloc occupationBloc = OccupationListBloc();
  CoursesBloc coursesBloc = CoursesBloc();
  MyBookmarkBloc myBookmarkBloc = MyBookmarkBloc();
  UnitGroupBloc occupationUnitGroupBloc = UnitGroupBloc();

  // RECENT OCCUPATION
  List<RecentOccupationTable> recentListOccupation = [];

  // RECENT COURSE
  List<RecentCourseTable> courseRecentList = [];

  @override
  init() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await globalBloc?.setUserInfoData(context);

        if (await SharedPreferenceController.getIsSubscriptionDialogShown() ==
                false &&
            globalBloc?.isShowDialogSubscription == true) {
          UserInfoData? userInfoData =
              await SharedPreferenceController.getUserData();
          if (!context.mounted) return;
          //Buy free plan if not already bought
          if ((userInfoData.subName == null && userInfoData.subscriptionId == null) || ((userInfoData.subName == "") && userInfoData.subscriptionId == null)) {
            showSubscriptionDialog();
            SharedPreferenceController.setIsSubscriptionDialogShown(true);
            globalBloc!.isShowDialogSubscription = true;
          }
        }

        // Show Ads banner dialog if visible true & user come from splash screen
        if (await SharedPreferenceController.getAdsBannerClickStatus() ==
                false &&
            globalBloc?.needToShowAdsDialog == true) {
          // ignore: use_build_context_synchronously
          showAdsBannerDialog(context);
        }
        globalBloc?.needToShowAdsDialog = false;

        await globalBloc?.getDeviceCountryInfo();
        printLog(
            "Device country ${globalBloc?.getDeviceCountryShortcodeValue}");
        printLog("Country length ${globalBloc?.getCountryListValue.length}");

        if ((globalBloc!.recentUpdateList).isEmpty) {
          _dashboardBloc.getRecentUpdateDataList(context, false, globalBloc);
        } else {
          _dashboardBloc.setRecentUpdateList = globalBloc!.recentUpdateList;
        }

        _dashboardBloc.fetchOtherProductFromRemoteConfig(
            globalBloc?.getDeviceCountryShortcodeValue);
        Future.delayed(Duration.zero, () async {
          if (!globalBloc!.checkUserIsFromSplash &&
              true ==
                  await SharedPreferenceController.getAdsBannerClickStatus()) {
            // return true if need to show rating dialog
            final ratingResult =
                await DynamicRatingCalculation.showRatingDialog();
            if (ratingResult) {
              Future.delayed(const Duration(milliseconds: 1000), () async {
                DynamicRatingDialog.showRatingAppDialog(context: context);
              });
            }
          }
        });

        // SET Dynamic rating data from Firebase remote config
        globalBloc?.checkUserIsFromSplash =
            await DynamicRatingCalculation.setFirebaseRemoteConfigRatingJSON(
                isCameFromSplash: globalBloc!.checkUserIsFromSplash);

        //FOR GET CUSTOM QUESTION
        // await CustomQuestionBloc.getCustomQuestionData();

        // If country data not available/load, try again to fetch data from firebase config
        if (globalBloc != null && globalBloc!.getCountryListValue.isEmpty) {
          globalBloc?.getCountryListFromRemoteConfig();
        }
      },
    );

    Future.delayed(const Duration(seconds: 10), () async {
      if (!mounted) return;
      if (Platform.isAndroid) {
        _dashboardBloc.checkForUpdate(context);
      } else {
        _dashboardBloc.checkAppUpdate(
            context,
            FirebaseRemoteConfigController.shared.severity,
            FirebaseRemoteConfigController.shared.iosVersion,
            FirebaseRemoteConfigController.shared.description);
      }
    });

    UserInfoData? userInfoData = await SharedPreferenceController.getUserData();
    if (!context.mounted) return;
    //Buy free plan if not already bought
    if ((userInfoData.subName == null && userInfoData.subscriptionId == null) || ((userInfoData.subName == "") && userInfoData.subscriptionId == null)) {
      await SubscriptionBloc().buyFreeSubscription(context);
      userInfoData = await SharedPreferenceController.getUserData();
      globalBloc?.userInfoStream.sink.add(userInfoData);
    }

    if (userInfoData.subName != null && userInfoData.subName!.isNotEmpty) {
      if (userInfoData.subRemainingDays != null &&
          userInfoData.subRemainingDays! <= 0) {
        globalBloc?.subscriptionType = AppType.EXPIRED;
      } else {
        switch (userInfoData.subName) {
          case StringHelper.freePlan:
            globalBloc?.subscriptionType = AppType.FREE_TRIAL;
            break;
          case StringHelper.miniPlan:
          case StringHelper.premiumPlan:
            globalBloc?.subscriptionType = AppType.PAID;
            break;
          default:
            globalBloc?.subscriptionType = AppType.FREE_TRIAL;
            break;
        }
      }
    }

    //Top Universities List API
    coursesBloc.getTopUniversitiesInAustraliaList();
    await _dashboardBloc.getDashboardContactBranchFromFirebaseRealtimeDB();
  }

  @override
  onResume() async {
    //RECENT SEARCH OCCUPATION
    await occupationBloc.getOccupationsRecentList();

    //RECENT SEARCH COURSE
    await coursesBloc.getCourseRecentList();

    _dashboardBloc.getRecentSearchMergedData(
        coursesBloc, occupationBloc, globalBloc!);

    //Because you searched
    await _dashboardBloc.getOccupationListFromUnitGroup();

    await occupationBloc.getOccupationsList();

    UserInfoData? userInfoData = await globalBloc?.getUserInfo(context);
    _dashboardBloc.getDashboardData(context, userInfoData!.userId!);

    //get most visited occupation list
    globalBloc!.getOccupationVisitedCountData();

    // showSubscriptionDialog();
  }

  @override
  Widget body(BuildContext context) {
    globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxMultiBlocProvider(
      providers: [
        RxBlocProvider<DashboardBloc>(create: (context) => _dashboardBloc),
        RxBlocProvider<OccupationListBloc>(create: (context) => occupationBloc),
        RxBlocProvider<CoursesBloc>(create: (context) => coursesBloc),
        RxBlocProvider<UnitGroupBloc>(
            create: (context) => occupationUnitGroupBloc),
      ],
      child: Container(
        color: AppColorStyle.background(context),
        child: RefreshIndicator(
          color: AppColorStyle.primary(context),
          onRefresh: () async {
            _dashboardBloc.getRecentUpdateDataList(context, false, globalBloc);
            UserInfoData? userInfoData = await globalBloc?.getUserInfo(context);
            _dashboardBloc.getDashboardData(context, userInfoData!.userId!);
          },
          child: SafeArea(
            bottom: false,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: StreamBuilder<UserInfoData>(
                      stream: globalBloc?.getUserInfoStream,
                      builder: (_, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          UserInfoData data = snapshot.data!;
                          return DashboardHeaderWidget(
                              userData: data, globalBloc: globalBloc);
                        } else {
                          return const SizedBox(height: 50.0);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: AnimationLimiter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 800),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: widget,
                                    ),
                                  ),
                              children: [
                                // RECENT UPDATES SECTION
                                //For subscription type FREE, show recent update widget
                                DashboardRecentUpdateWidget(
                                    globalBloc: globalBloc),

                                // MENU SECTION
                                DashboardMenuSectionWidget(),

                                //BOOKMARK OCCUPATION LIST
                                DashboardBookmarkOccupationWidget(
                                    globalBloc: globalBloc),

                                //CUSTOM QUESTION DASHBOARD WIDGET
                                /*StreamWidget(
                                  stream: CustomQuestionBloc.getCustomQuestionsListStream,
                                  onBuild: (_, questionListSnapshot) {
                                    if (questionListSnapshot != null) {
                                      List<CustomQuestions>? customQuestionsList =
                                          questionListSnapshot;
                                      List<CustomQuestions>? pendingQuestionList =
                                          customQuestionsList
                                              ?.where((element) =>
                                                  element.answer == "" && element.primary == true)
                                              .toList();
                                      return pendingQuestionList?.isNotEmpty == true
                                          ? DashboardCustomQuestionWidget(
                                              customQuestionsList: customQuestionsList)
                                          : Container(
                                              height: 15.0,
                                              color: AppColorStyle.backgroundVariant(context));
                                    }
                                  },
                                ),*/

                                // BECAUSE YOU SEARCHED SECTION
                                BecauseYouSearchedWidget(
                                    globalBloc: globalBloc),
                                const SizedBox(
                                  height: 10.0,
                                ),

                                // ALL RECENT SEARCH LIST
                                AllRecentSearchListWidget(
                                    isFromDashboard: true,
                                    globalBloc: globalBloc),

                                // MOST VISITED OCCUPATION ON OCCUSEARCH
                                const MostVisitedOccupationWidget(
                                    isFromOccupationTab: false),

                                // TOP UNIVERSITIES
                                const TopUniversitiesWidget(),

                                // OTHER PRODUCT SECTION
                                DashboardOtherProductWidget(
                                    themeBloc?.currentTheme ?? false),

                                //CONTACT US CARD AND SOCIAL MEDIA LINKS
                                DashboardContactUsWidget(
                                    dashboardBloc: _dashboardBloc),

                                const DashboardFooterBrandWidget(),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    CustomQuestionBloc.setDashboardIndexValue = 0;
    //_dashboardBloc.bookmarkByTypeListStream.close();
    // _dashboardBloc.contactBranchStream.close();
  }

  showAdsBannerDialog(BuildContext context) async {
    try {
      var adsJSON =
          await FirebaseRemoteConfigController.shared.Data(key: "ads_banner");
      var jsonData = json.decode(adsJSON);
      if (jsonData["visible"] == true && jsonData["ads_image_url"] != "") {
        AdsDialog.showAdsDialog(
            context: context,
            bannerURL: jsonData["ads_image_url"],
            redirectURL: jsonData["direct_to"]);
      }
    } catch (e) {
      printLog(e);
    }
  }

  void showSubscriptionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const SubscriptionDetailsDialog();
      },
    );
  }
}
