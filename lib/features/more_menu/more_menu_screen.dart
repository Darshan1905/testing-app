import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/contact_us/contact_us_bloc.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/more_menu/edit_profile/edit_profile_bloc.dart';
import 'package:occusearch/features/more_menu/more_menu_bloc.dart';
import 'package:occusearch/features/more_menu/widget/more_app_list_widget.dart';
import 'package:occusearch/features/more_menu/widget/more_menu_widget.dart';
import 'package:occusearch/features/my_bookmark/my_bookmark_bloc.dart';

class MoreMenuScreen extends BaseApp {
  final Function(int)? changeTab;

  const MoreMenuScreen({super.key, this.changeTab}) : super.builder();

  @override
  BaseState createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends BaseState {
  final MoreMenuBloc _moreMenuBloc = MoreMenuBloc();
  final EditProfileBloc _editProfileBloc = EditProfileBloc();
  GlobalBloc? _globalBloc;
  final _myBookmarkBloc = MyBookmarkBloc();
  final ContactUsBloc _contactUsBloc = ContactUsBloc();

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);

    return RxMultiBlocProvider(
        providers: [
          RxBlocProvider<MoreMenuBloc>(create: (context) => _moreMenuBloc),
          RxBlocProvider<EditProfileBloc>(
              create: (context) => _editProfileBloc),
        ],
        child: RxBlocProvider(
          create: (_) => _moreMenuBloc,
          child: Container(
            color: AppColorStyle.background(context),
            child: SafeArea(
              child: Container(
                color: AppColorStyle.backgroundVariant(context),
                child: Column(children: [
                  Container(
                    color: AppColorStyle.background(context),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: Constants.commonPadding,
                          right: Constants.commonPadding,
                          top: 20,
                          bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            StringHelper.moreMenu,
                            style: AppTextStyle.subHeadlineSemiBold(
                                context, AppColorStyle.text(context)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: AnimationLimiter(
                        child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 500),
                                childAnimationBuilder: (widget) =>
                                    SlideAnimation(
                                      horizontalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: widget,
                                      ),
                                    ),
                                children: [
                              Container(
                                color: AppColorStyle.background(context),
                                padding: const EdgeInsets.all(
                                    Constants.commonPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    /*top header*/
                                    MoreMenuHeaderWidget(
                                      fullName: fullName,
                                      emailAddress: emailAddress,
                                      phoneNumber: phoneNumber,
                                      onClick: () async {
                                        var result = await context
                                            .push<dynamic>(RouteName.root +
                                                RouteName.editProfile);
                                        if (result != null) {
                                          setUserProfileData();
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    StreamBuilder(
                                        stream: _myBookmarkBloc
                                            .getBookmarkListStream,
                                        builder: (_, snapshot) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: InkWellWidget(
                                                  onTap: () {
                                                    GoRoutesPage.go(
                                                        mode:
                                                            NavigatorMode.push,
                                                        moveTo: RouteName
                                                            .myBookmarkListScreen,
                                                        param: BookmarkType
                                                            .OCCUPATION.name);
                                                  },
                                                  child: SizedBox(
                                                    width: MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                    height: 115,
                                                    child: Stack(
                                                      fit: StackFit.passthrough,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical:
                                                                      15.0),
                                                          decoration: BoxDecoration(
                                                              color: AppColorStyle
                                                                  .purpleText(
                                                                      context),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SvgPicture.asset(
                                                                IconsSVG
                                                                    .occupationIcon,
                                                                height: 35,
                                                                width: 35,
                                                              ),
                                                              const SizedBox(
                                                                  height: 15),
                                                              // OCCUPATION IS-ADDED COUNT
                                                              (snapshot.data !=
                                                                      null)
                                                                  ? Text(
                                                                      _myBookmarkBloc.occupationBookmarkTypeCount.value.toString().length >
                                                                              1
                                                                          ? _myBookmarkBloc
                                                                              .occupationBookmarkTypeCount
                                                                              .value
                                                                              .toString()
                                                                          : "0${_myBookmarkBloc.occupationBookmarkTypeCount.value.toString()}",
                                                                      style: AppTextStyle.titleSemiBold(
                                                                          context,
                                                                          AppColorStyle.text(
                                                                              context)),
                                                                    )
                                                                  : Container(),
                                                              Text(
                                                                StringHelper
                                                                    .occupationSaved,
                                                                style: AppTextStyle.captionRegular(
                                                                    context,
                                                                    AppColorStyle
                                                                        .textHint(
                                                                            context)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: SvgPicture.asset(
                                                              IconsSVG
                                                                  .bgOccupationSaved,
                                                              fit: BoxFit.fill),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Flexible(
                                                child: InkWellWidget(
                                                  onTap: () {
                                                    if (globalBloc?.subscriptionType == AppType.PAID) {
                                                      GoRoutesPage.go(
                                                          mode:
                                                          NavigatorMode.push,
                                                          moveTo: RouteName
                                                              .myBookmarkListScreen,
                                                          param: BookmarkType
                                                              .COURSE.name);
                                                    } else {
                                                      GoRoutesPage.go(
                                                          mode: NavigatorMode.push,
                                                          moveTo: RouteName.subscription);
                                                    }
                                                  },
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                    height: 115,
                                                    child: Stack(
                                                      fit: StackFit.passthrough,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical:
                                                                      15.0),
                                                          decoration: BoxDecoration(
                                                              color: AppColorStyle
                                                                  .tealText(
                                                                      context),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SvgPicture.asset(
                                                                IconsSVG
                                                                    .graduationIcon,
                                                                height: 35,
                                                                width: 35,
                                                              ),
                                                              const SizedBox(
                                                                  height: 15),
                                                              // OCCUPATION IS-ADDED COUNT
                                                              (snapshot.data !=
                                                                      null)
                                                                  ? Text(
                                                                      _myBookmarkBloc.courseBookmarkTypeCount.value.toString().length >
                                                                              1
                                                                          ? _myBookmarkBloc
                                                                              .courseBookmarkTypeCount
                                                                              .value
                                                                              .toString()
                                                                          : "0${_myBookmarkBloc.courseBookmarkTypeCount.value.toString()}",
                                                                      style: AppTextStyle.titleSemiBold(
                                                                          context,
                                                                          AppColorStyle.text(
                                                                              context)),
                                                                    )
                                                                  : Container(),
                                                              Text(
                                                                StringHelper
                                                                    .coursesSaved,
                                                                style: AppTextStyle.captionRegular(
                                                                    context,
                                                                    AppColorStyle
                                                                        .textHint(
                                                                            context)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: SvgPicture.asset(
                                                              IconsSVG
                                                                  .bgCoursesSaved,
                                                              fit: BoxFit.fill),
                                                        ),
                                                        globalBloc?.subscriptionType == AppType.PAID ? Container() : Align(
                                                          alignment: Alignment.topRight,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: SvgPicture.asset(
                                                              IconsSVG.icPremiumFeature,
                                                              height: 20,
                                                              width: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                    const SizedBox(height: 15),
                                    InkWellWidget(
                                      onTap: () {
                                        if (NetworkController
                                            .isInternetConnected) {
                                          GoRoutesPage.go(
                                              mode: NavigatorMode.push,
                                              moveTo: RouteName.subscription);
                                        } else {
                                          Toast.show(context,
                                              message: StringHelper
                                                  .internetConnection,
                                              type: Toast.toastError);
                                        }
                                      },
                                      child: Stack(
                                        fit: StackFit.passthrough,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                color: themeBloc!.currentTheme
                                                    ? AppColorStyle
                                                        .purpleVariant3(context)
                                                    : AppColorStyle.redText(
                                                            context)
                                                        .withOpacity(0.3),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  margin: const EdgeInsets.only(
                                                      right: 5.0),
                                                  child: SvgPicture.asset(
                                                      IconsSVG.icSubscription,
                                                      fit: BoxFit.fill,
                                                      height: 45,
                                                      width: 45),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        StringHelper
                                                            .subscription,
                                                        style: AppTextStyle
                                                            .titleMedium(
                                                                context,
                                                                AppColorStyle
                                                                    .text(
                                                                        context)),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      StreamBuilder<
                                                              UserInfoData>(
                                                          stream: globalBloc
                                                              ?.getUserInfoStream,
                                                          builder: (context,
                                                              snapshot) {
                                                            String
                                                                subscriptionType =
                                                                _moreMenuBloc
                                                                    .getSubscriptionType(
                                                                        snapshot.data?.subName ??
                                                                            "");
                                                            return Text(
                                                              subscriptionType,
                                                              style: AppTextStyle
                                                                  .detailsMedium(
                                                                      context,
                                                                      AppColorStyle
                                                                          .textDetail(
                                                                              context)),
                                                            );
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: SvgPicture.asset(
                                                IconsSVG.bgTopHeaderPink,
                                                fit: BoxFit.fill),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //Dark mode selection
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 20),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: AppColorStyle.background(context),
                                // decoration: BoxDecoration(
                                //   color: AppColorStyle.background(context),
                                //   borderRadius: const BorderRadius.all(
                                //       Radius.circular(10.0)),
                                // ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      IconsSVG.darkModeMenu,
                                      colorFilter: ColorFilter.mode(
                                        AppColorStyle.text(context),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringHelper.darkMode,
                                            style:
                                                AppTextStyle.subTitleSemiBold(
                                                    context,
                                                    AppColorStyle.text(
                                                        context)),
                                          ),
                                          Text(
                                            StringHelper.disable,
                                            style: AppTextStyle.captionRegular(
                                                context,
                                                AppColorStyle.textHint(
                                                    context)),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Transform.scale(
                                      scale: .75,
                                      child: StreamBuilder<bool>(
                                          stream: themeBloc?.themeStream,
                                          builder: (context, switchData) {
                                            if (switchData.hasData &&
                                                switchData.data != null) {
                                              return CupertinoSwitch(
                                                onChanged: toggleSwitch,
                                                value: switchData.data ?? true,
                                                activeColor: AppColorStyle
                                                    .backgroundVariant(context),
                                                trackColor: AppColorStyle
                                                    .surfaceVariant(context),
                                                thumbColor: (!switchData.data!)
                                                    ? AppColorStyle.textDetail(
                                                        context)
                                                    : AppColorStyle.primary(
                                                        context),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              //Section Communicate with us
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 20),
                                margin: const EdgeInsets.only(bottom: 10),
                                color: AppColorStyle.background(context),
                                // decoration: BoxDecoration(
                                //   color: AppColorStyle.background(context),
                                //   borderRadius: const BorderRadius.all(
                                //       Radius.circular(10.0)),
                                // ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        StringHelper.communicateWithUs,
                                        style: AppTextStyle.titleSemiBold(
                                            context,
                                            AppColorStyle.text(context)),
                                      ),
                                      /*const SizedBox(
                                          height: Constants.commonPadding),*/
                                      //support
                                      /*Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            IconsSVG.supportMenu,
                                            color: AppColorStyle.text(context),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  StringHelper.support,
                                                  style: AppTextStyle.titleMedium(
                                                      context,
                                                      AppColorStyle.text(context)),
                                                ),
                                                Text(
                                                  StringHelper.subTitleSupport,
                                                  style:
                                                      AppTextStyle.detailsRegular(
                                                          context,
                                                          AppColorStyle.textHint(
                                                              context)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),*/
                                      //Contact us
                                      InkWellWidget(
                                        onTap: () async {
                                          await _contactUsBloc
                                              .contactUsOnTap(context);
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          decoration: BoxDecoration(
                                            color: AppColorStyle.background(
                                                context),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                IconsSVG.contactUsMenu,
                                                colorFilter: ColorFilter.mode(
                                                  AppColorStyle.text(context),
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        StringHelper.contactUs,
                                                        style: AppTextStyle
                                                            .subTitleMedium(
                                                                context,
                                                                AppColorStyle
                                                                    .text(
                                                                        context)),
                                                      ),
                                                      Text(
                                                        StringHelper
                                                            .subTitleContactUs,
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle
                                                                    .textHint(
                                                                        context)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              //refer a friend
                              InkWellWidget(
                                onTap: () async {
                                  FirebaseAnalyticLog.shared.eventTracking(
                                      screenName: RouteName.moreMenu,
                                      actionEvent:
                                          FBActionEvent.fbActionReferAFriend,
                                      sectionName:
                                          FBSectionEvent.fbSectionReferAFriend,
                                      message: Constants
                                          .occuSearchAppPlaystoreAppStoreDynamicLink);

                                  //Share application
                                  String content =
                                      FirebaseRemoteConfigController
                                          .shared.shareAppContent;
                                  Utility.shareApplication(content.isNotEmpty
                                      ? content
                                      : StringHelper.shareApplication);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                      horizontal: Constants.commonPadding),
                                  color: AppColorStyle.background(context),
                                  // decoration: BoxDecoration(
                                  //   color: AppColorStyle.background(context),
                                  //   borderRadius: const BorderRadius.all(
                                  //       Radius.circular(10.0)),
                                  // ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          StringHelper.helpUs,
                                          style: AppTextStyle.titleSemiBold(
                                              context,
                                              AppColorStyle.text(context)),
                                        ),
                                        const SizedBox(height: 15),
                                        InkWellWidget(
                                          onTap: () async {
                                            FirebaseAnalyticLog.shared
                                                .eventTracking(
                                                    screenName:
                                                        RouteName.moreMenu,
                                                    actionEvent: FBActionEvent
                                                        .fbActionReferAFriend,
                                                    sectionName: FBSectionEvent
                                                        .fbSectionReferAFriend,
                                                    message: Constants
                                                        .occuSearchAppPlaystoreAppStoreDynamicLink);

                                            //Share application
                                            String content =
                                                FirebaseRemoteConfigController
                                                    .shared.shareAppContent;
                                            Utility.shareApplication(
                                                content.isNotEmpty
                                                    ? content
                                                    : StringHelper
                                                        .shareApplication);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                IconsSVG.referFriendMenu,
                                                colorFilter: ColorFilter.mode(
                                                  AppColorStyle.text(context),
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Text(
                                                  StringHelper.referFriend,
                                                  style: AppTextStyle
                                                      .subTitleMedium(
                                                          context,
                                                          AppColorStyle.text(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ),

                              //rate us
                              InkWellWidget(
                                onTap: () {
                                  FirebaseAnalyticLog.shared.eventTracking(
                                      screenName: RouteName.moreMenu,
                                      actionEvent: FBActionEvent.fbActionRateUs,
                                      sectionName:
                                          FBSectionEvent.fbSectionRateUs,
                                      message: (Platform.isIOS)
                                          ? Constants.appStoreLink
                                          : Constants.playStoreLink);

                                  if (Platform.isIOS) {
                                    Utility.launchURL(Constants.appStoreLink);
                                  } else if (Platform.isAndroid) {
                                    Utility.launchURL(Constants.playStoreLink);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 20,
                                      left: Constants.commonPadding,
                                      right: Constants.commonPadding),
                                  color: AppColorStyle.background(context),
                                  // decoration: BoxDecoration(
                                  //   color: AppColorStyle.background(context),
                                  //   borderRadius: const BorderRadius.all(
                                  //       Radius.circular(10.0)),
                                  // ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        IconsSVG.rateUsMenu,
                                        colorFilter: ColorFilter.mode(
                                          AppColorStyle.text(context),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          StringHelper.rateUs,
                                          style: AppTextStyle.subTitleMedium(
                                              context,
                                              AppColorStyle.text(context)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              //Other Apps && About and Legal
                              const MoreAppsWidget(),
                              const SizedBox(height: 10),
                            ])),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }

  void toggleSwitch(bool value) {
    themeBloc?.setTheme(value);
  }

  String fullName = '';
  String phoneNumber = '';
  String emailAddress = '';

  @override
  init() {
    Future.delayed(Duration.zero, () async {
      setUserProfileData();
      // To get more apps list
      await _moreMenuBloc.fetchMoreAppsDataFromRemoteConfig();
    });
  }

  @override
  onResume() {
    _myBookmarkBloc.getAllBookmarkList(type: "");
  }

  setUserProfileData() async {
    await _globalBloc?.setUserInfoData(context);
    // ignore: use_build_context_synchronously
    UserInfoData? info = await _globalBloc?.getUserInfo(context);
    if (info != null && info.leadCode != null && info.leadCode != "") {
      // SET country model based on Login user country code or current device location(if not found)
      if (_globalBloc?.getCountryListValue != null &&
          _globalBloc?.getCountryListValue != []) {
        CountryModel? model;
        if (info.countryCode != null && info.countryCode != "") {
          model = _globalBloc?.getCountryListValue
              .firstWhere((element) => element.code == info.countryCode);
        } else {
          await _globalBloc?.getDeviceCountryInfo();
          model = _globalBloc?.getCountryListValue.firstWhere((element) =>
              element.code == _globalBloc?.getDeviceCountryShortcodeValue);
        }
        setState(() {
          fullName = info.name ?? '';
          emailAddress = info.email ?? '';
          phoneNumber = info.phone != null && info.phone != ''
              ? "${model!.dialCode ?? ''} ${info.phone ?? ''}"
              : '';
        });
      }
    }
  }
}
