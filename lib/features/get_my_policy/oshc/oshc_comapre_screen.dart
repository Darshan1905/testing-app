import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/get_my_policy/gmp_bloc.dart';
import 'package:occusearch/features/get_my_policy/model/oshc_provider_data_model.dart';
import 'package:occusearch/features/get_my_policy/widget/add_phone_number_bottom_sheet.dart';
import 'package:occusearch/features/get_my_policy/widget/email_picker_bottom_sheet.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OSHCCompareScreen extends BaseApp {
  const OSHCCompareScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => OSHCCompareScreenState();
}

class OSHCCompareScreenState extends BaseState {
  GetMyPolicyBloc? getMyPolicyBloc;
  final AuthenticationBloc authBloc = AuthenticationBloc();
  UserInfoData? info;

  OSHCProviderDataModel model = OSHCProviderDataModel();
  List<OSHCProviderDataModelList> list = [];
  late ScrollController _scrollController1;
  late ScrollController _scrollController2;
  static final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  @override
  init() async {
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();

    // Add listener to the first scroll controller
    _scrollController1.addListener(() {
      if (_scrollController1.offset != _scrollController2.offset) {
        _scrollController2.jumpTo(_scrollController1.offset);
      }
    });

    // Add listener to the second scroll controller
    _scrollController2.addListener(() {
      if (_scrollController2.offset != _scrollController1.offset) {
        _scrollController1.jumpTo(_scrollController2.offset);
      }
    });

    dynamic argumentValue = widget.arguments;
    if (widget.arguments != null) {
      model = argumentValue['model'];
      getMyPolicyBloc = argumentValue['gmpBloc'];
      list = model.outData!;
    }
    info = await globalBloc?.getUserInfo(context);

    WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
        await globalBloc?.getDeviceCountryInfo();
        await Future.delayed(const Duration(milliseconds: 500));
        // Fetch list of country if not available
        if (globalBloc != null &&
            (globalBloc?.getCountryListValue == null ||
                globalBloc?.getCountryListValue == [])) {
          // printLog("Country data fetching...");
          await globalBloc?.getCountryListFromRemoteConfig();
        }
        // To set current country model based on device info
        if (globalBloc?.getCountryListValue != null &&
            globalBloc!.getCountryListValue.isNotEmpty) {
          CountryModel? model = globalBloc?.getCountryListValue.firstWhere(
                  (element) =>
              element.code == globalBloc?.getDeviceCountryShortcodeValue);
          if (model == null) {
            authBloc.setSelectedCountryModel =
            globalBloc?.getCountryListValue[0];
          } else {
            authBloc.setSelectedCountryModel = model;
          }
        }
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColorStyle.background(context),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.commonPadding, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringHelper.oshcPolicy,
                    style: AppTextStyle.titleSemiBold(
                        context, AppColorStyle.text(context)),
                  ),
                  InkWellWidget(
                    onTap: () {
                      context.pop();
                    },
                    child: SvgPicture.asset(
                      IconsSVG.closeIcon,
                      colorFilter: ColorFilter.mode(
                        AppColorStyle.text(context),
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Container(
                height: 10, color: AppColorStyle.backgroundVariant1(context)),
            SizedBox(
              height: 120,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController1,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 125,
                      color: AppColorStyle.background(context),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Image.network(list[index].logo ?? '',
                                      height: 35, width: 60),
                                  Text(list[index].price ?? '',
                                      style: AppTextStyle.detailsSemiBold(
                                          context,
                                          AppColorStyle.text(context))),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      StreamBuilder<Map<int, bool>>(
                                          stream:
                                              getMyPolicyBloc?.loadingStream,
                                          builder: (context, snapshot) {
                                            final loadingMap =
                                                snapshot.data ?? {};
                                            final isLoading =
                                                loadingMap[index] ?? false;
                                            if (isLoading == false) {
                                              return InkWellWidget(
                                                onTap: () {
                                                  if (NetworkController
                                                      .isInternetConnected) {
                                                    if (info!.email != null &&
                                                        info!.email!
                                                            .isNotEmpty &&
                                                        info!.phone != null &&
                                                        info!.phone!
                                                            .isNotEmpty) {
                                                      getMyPolicyBloc
                                                          ?.buyOSHCGmpQuote(
                                                              context,
                                                              list[index],
                                                              globalBloc,
                                                              index);
                                                    } else if (info!.email ==
                                                            null ||
                                                        info!.email!.isEmpty) {
                                                      showEmailPickerSheet(
                                                          context,
                                                          list[index],
                                                          globalBloc,
                                                          index,
                                                          getMyPolicyBloc,
                                                          false);
                                                    } else if (info!.phone ==
                                                            null ||
                                                        info!.phone!.isEmpty) {
                                                      showPhoneNumberBottomSheet(
                                                          context,
                                                          list[index],
                                                          globalBloc,
                                                          index,
                                                          getMyPolicyBloc,
                                                          authBloc,
                                                          phoneFormKey,
                                                          false);
                                                    }
                                                  } else {
                                                    Toast.show(context,
                                                        message: StringHelper
                                                            .internetConnection,
                                                        type: Toast.toastError);
                                                  }

                                                  // getMyPolicyBloc?.buyOSHCGmpQuote(context, list[index], globalBloc, index);
                                                  // Utility.launchURL(data.providerurl ?? "");
                                                },
                                                child: Container(
                                                  height: 25,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColorStyle.primary(
                                                            context),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 2),
                                                    child: Text(
                                                      StringHelper.buyNow,
                                                      style: AppTextStyle
                                                          .captionLight(
                                                              context,
                                                              AppColorStyle
                                                                  .textWhite(
                                                                      context)),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: SizedBox(
                                                  width: 15.0,
                                                  height: 15.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                    color:
                                                        AppColorStyle.primary(
                                                            context),
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          child: SvgPicture.asset(
                                            IconsSVG.downloadIcon,
                                            height: 20,
                                            width: 20,
                                          ),
                                          onTap: () {
                                            Utility.launchURL(
                                                list[index].pdfFilePath!);
                                          })
                                    ],
                                  ),
                                  const SizedBox(height: 10)
                                ],
                              ),
                            ),
                            Container(
                              width: 3,
                              color: AppColorStyle.backgroundVariant1(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Container(
                height: 10, color: AppColorStyle.backgroundVariant1(context)),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController2,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: list.length * 132.0,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /////Student Health Cover//////
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: Constants.commonPadding),
                            child: Text(
                              "Student Health Cover",
                              style: AppTextStyle.subTitleRegular(
                                  context, AppColorStyle.primary(context)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        AppColorStyle.primaryVariant(context),
                                    width: 1)),
                            child: Column(children: [
                              /*Approved Insurer for Visa*/
                              Container(
                                color: AppColorStyle.primaryVariant(context),
                                height: 30,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: Constants.commonPadding),
                                child: Text(
                                  "Approved Insurer for Visa",
                                  style: AppTextStyle.detailsMedium(context,
                                      AppColorStyle.textDetail(context)),
                                ),
                              ),
                              SizedBox(
                                height: 85,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 120,
                                      color: AppColorStyle.background(context),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  list[index].approvedInsurerForVisaFlag ==
                                                          true
                                                      ? SvgPicture.asset(
                                                          IconsSVG.icCheckGreen,
                                                          width: 20,
                                                          height: 20)
                                                      : SvgPicture.asset(
                                                          IconsSVG.redCrossIcon,
                                                          width: 20,
                                                          height: 20),
                                                  Text(
                                                    list[index]
                                                        .approvedInsurerForVisa!,
                                                    style: AppTextStyle
                                                        .captionRegular(
                                                            context,
                                                            AppColorStyle.text(
                                                                context)),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            color: AppColorStyle.primaryVariant(
                                                context),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              /*Online Membership account*/
                              Container(
                                color: AppColorStyle.primaryVariant(context),
                                height: 30,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: Constants.commonPadding),
                                child: Text(
                                  "Policy Certificate",
                                  style: AppTextStyle.detailsMedium(context,
                                      AppColorStyle.textDetail(context)),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Text(
                                                  list[index]
                                                      .policyCertificate!,
                                                  style: AppTextStyle
                                                      .captionRegular(
                                                          context,
                                                          AppColorStyle.text(
                                                              context)),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ]),
                          ),

                          //// Support Services//////
                          Container(
                            height: 50,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: Constants.commonPadding),
                            child: Text(
                              "Support Services",
                              style: AppTextStyle.subTitleMedium(
                                  context, AppColorStyle.primary(context)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        AppColorStyle.primaryVariant(context),
                                    width: 1)),
                            child: Column(
                              children: [
                                /*Mobile App*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Mobile App",
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          onTap: () {
                                            WidgetHelper.showAlertDialog(
                                              context,
                                              isHTml: false,
                                              title: "",
                                              contentText:
                                                  "This feature helps you manage your OSHC policy. You can launch a claim, find a direct billing doctor or a partner hospital and make changes to the policy through the app.",
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconsSVG.icQuestionInfo,
                                              width: 14,
                                              height: 14)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 120,
                                          color:
                                              AppColorStyle.background(context),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      InkWellWidget(
                                                        onTap: () {
                                                          Utility.launchURL(list[
                                                                  index]
                                                              .mobileAppSupportApple!);
                                                        },
                                                        child: SvgPicture.asset(
                                                            IconsSVG.appleIcon,
                                                            width: 20,
                                                            height: 20),
                                                      ),
                                                      const SizedBox(
                                                          height: 15.0),
                                                      InkWellWidget(
                                                        onTap: () {
                                                          Utility.launchURL(list[
                                                                  index]
                                                              .mobileAppSupportAndroid!);
                                                        },
                                                        child: SvgPicture.asset(
                                                            IconsSVG
                                                                .androidIcon,
                                                            width: 20,
                                                            height: 20),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 1,
                                                color: AppColorStyle
                                                    .primaryVariant(context),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                ),

                                /*Online Membership account*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Online Membership account",
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          onTap: () {
                                            WidgetHelper.showAlertDialog(
                                              context,
                                              isHTml: false,
                                              title: "",
                                              contentText:
                                                  "This online service helps you manage your policy. You can launch a claim, apply for refunds and make changes to the policy through the app through the portal.",
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconsSVG.icQuestionInfo,
                                              width: 14,
                                              height: 14)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: 120,
                                          color:
                                              AppColorStyle.background(context),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 0.0),
                                                  child: list[index]
                                                              .onlineMembershipAccount ==
                                                          true
                                                      ? SvgPicture.asset(
                                                          IconsSVG.icCheckGreen,
                                                          width: 20,
                                                          height: 20)
                                                      : SvgPicture.asset(
                                                          IconsSVG.redCrossIcon,
                                                          width: 20,
                                                          height: 20),
                                                ),
                                              ),
                                              Container(
                                                width: 1,
                                                color: AppColorStyle
                                                    .primaryVariant(context),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),

                                /*Home Doctor services*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Home Doctor services",
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          onTap: () {
                                            WidgetHelper.showAlertDialog(
                                              context,
                                              isHTml: false,
                                              title: "",
                                              contentText:
                                                  "This service can be used by students when they need a GP outside of normal business hours. Students can request a direct billing doctor to come and visit them by calling.",
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconsSVG.icQuestionInfo,
                                              width: 14,
                                              height: 14)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              width: 120,
                                              color: AppColorStyle.background(
                                                  context),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 0.0),
                                                      child: list[index]
                                                                  .homeDoctorServices ==
                                                              true
                                                          ? SvgPicture.asset(
                                                              IconsSVG
                                                                  .icCheckGreen,
                                                              width: 20.0,
                                                              height: 20.0)
                                                          : SvgPicture.asset(
                                                              IconsSVG
                                                                  .redCrossIcon,
                                                              width: 20.0,
                                                              height: 20.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    color: AppColorStyle
                                                        .primaryVariant(
                                                            context),
                                                  ),
                                                ],
                                              ));
                                        })),

                                /*24*7 Supports*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        "24*7 Supports",
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          onTap: () {
                                            WidgetHelper.showAlertDialog(
                                              context,
                                              isHTml: false,
                                              title: "",
                                              contentText:
                                                  "24* 7 support with Interpretor services in a wide variety of languages",
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconsSVG.icQuestionInfo,
                                              width: 14,
                                              height: 14)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 70,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 15.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset(
                                                        IconsSVG.callIcon,
                                                        width: 10,
                                                        height: 10),
                                                    const SizedBox(width: 5.0),
                                                    Expanded(
                                                      child: InkWellWidget(
                                                        onTap: () {
                                                          launchUrlString(
                                                              "tel://${list[index].support247}");
                                                        },
                                                        child: Text(
                                                          list[index]
                                                              .support247!,
                                                          style: AppTextStyle
                                                              .captionRegular(
                                                                  context,
                                                                  AppColorStyle
                                                                      .text(
                                                                          context)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /*On campus support*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        "On campus support",
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          onTap: () {
                                            WidgetHelper.showAlertDialog(
                                              context,
                                              isHTml: false,
                                              title: "",
                                              contentText:
                                                  "Available only at selected education providers",
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconsSVG.icQuestionInfo,
                                              width: 14,
                                              height: 14)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 120,
                                          color:
                                              AppColorStyle.background(context),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: list[index]
                                                            .onCampusSupport ==
                                                        true
                                                    ? SvgPicture.asset(
                                                        IconsSVG.icCheckGreen,
                                                        width: 20,
                                                        height: 20)
                                                    : SvgPicture.asset(
                                                        IconsSVG.redCrossIcon,
                                                        width: 20,
                                                        height: 20),
                                              ),
                                              Container(
                                                width: 1,
                                                color: AppColorStyle
                                                    .primaryVariant(context),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                ),

                                /*Virtual doctor services*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Virtual doctor services",
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          onTap: () {
                                            WidgetHelper.showAlertDialog(
                                              context,
                                              isHTml: false,
                                              title: "",
                                              contentText:
                                                  "With this service, you can see a Doctor without leaving home. Students can consult Doctors over the phone and video calls, and also avail medical prescriptions and specialist referrals.",
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconsSVG.icQuestionInfo,
                                              width: 14,
                                              height: 14)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 135,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 120,
                                          color:
                                              AppColorStyle.background(context),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 15.0),
                                                  child: Column(
                                                    children: [
                                                      list[index].doctorOnDemand ==
                                                              true
                                                          ? SvgPicture.asset(
                                                              IconsSVG
                                                                  .icCheckGreen,
                                                              width: 20.0,
                                                              height: 20.0)
                                                          : SvgPicture.asset(
                                                              IconsSVG
                                                                  .redCrossIcon,
                                                              width: 20.0,
                                                              height: 20.0),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Text(
                                                        list[index]
                                                            .doctorOnDemandTooltipText!,
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle
                                                                    .text(
                                                                        context)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 1,
                                                color: AppColorStyle
                                                    .primaryVariant(context),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                ),

                                /*Safety & Security app*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Safety & Security app",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: list[index].sonder == true
                                                  ? SvgPicture.asset(
                                                      IconsSVG.icCheckGreen,
                                                      width: 20,
                                                      height: 20)
                                                  : SvgPicture.asset(
                                                      IconsSVG.redCrossIcon,
                                                      width: 20,
                                                      height: 20),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /*Members exclusive discounts*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Members exclusive discounts",
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          onTap: () {
                                            WidgetHelper.showAlertDialog(
                                              context,
                                              isHTml: false,
                                              title: "",
                                              contentText:
                                                  "As a student, keep your mind and body active with some great discounts on health and fitness, entertainment, and experience with exclusive membership offers.",
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconsSVG.icQuestionInfo,
                                              width: 14,
                                              height: 14)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 120,
                                          color:
                                              AppColorStyle.background(context),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: list[index]
                                                              .membersExclusiveDiscountsFlag ==
                                                          true
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            SvgPicture.asset(
                                                                IconsSVG
                                                                    .icCheckGreen,
                                                                width: 20,
                                                                height: 20),
                                                            const SizedBox(
                                                                width: 5),
                                                            list[index].membersExclusiveDiscountsTooltip ==
                                                                    true
                                                                ? InkWellWidget(
                                                                    onTap: () {
                                                                      WidgetHelper.showAlertDialog(
                                                                          context,
                                                                          isHTml:
                                                                              false,
                                                                          title:
                                                                              "",
                                                                          contentText:
                                                                              list[index].membersExclusiveDiscounts!);
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                        IconsSVG
                                                                            .icQuestionInfo,
                                                                        width:
                                                                            14,
                                                                        height:
                                                                            14),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        )
                                                      : SvgPicture.asset(
                                                          IconsSVG.redCrossIcon,
                                                          width: 20,
                                                          height: 20)),
                                              Container(
                                                width: 1,
                                                color: AppColorStyle
                                                    .primaryVariant(context),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                ),

                                /*Multilingual OSHC Customer Service team*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Multilingual OSHC Customer Service team",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 120,
                                          color:
                                              AppColorStyle.background(context),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: list[index]
                                                              .multilingualOSHCCustomerServiceTeam ==
                                                          true
                                                      ? SvgPicture.asset(
                                                          IconsSVG.icCheckGreen,
                                                          width: 20,
                                                          height: 20)
                                                      : SvgPicture.asset(
                                                          IconsSVG.redCrossIcon,
                                                          width: 20,
                                                          height: 20)),
                                              Container(
                                                width: 1,
                                                color: AppColorStyle
                                                    .primaryVariant(context),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //// Out of Hospital Medical Services //////
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: Constants.commonPadding),
                            child: Text(
                              "Out of Hospital Medical Services",
                              style: AppTextStyle.subTitleMedium(
                                  context, AppColorStyle.primary(context)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        AppColorStyle.primaryVariant(context),
                                    width: 1)),
                            child: Column(
                              children: [
                                /*Doctor Visits*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Doctor Visits",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 85,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 10.0),
                                                child: Text(
                                                  list[index].doctorVisits!,
                                                  style: AppTextStyle
                                                      .captionRegular(
                                                          context,
                                                          AppColorStyle.text(
                                                              context)),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /*Pathology (blood tests etc)*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Pathology (blood tests etc)",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            width: 120,
                                            color: AppColorStyle.background(
                                                context),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0,
                                                        horizontal: Constants
                                                            .commonPadding),
                                                    child: Text(
                                                      list[index].pathology!,
                                                      style: AppTextStyle
                                                          .captionRegular(
                                                              context,
                                                              AppColorStyle
                                                                  .text(
                                                                      context)),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 1,
                                                  color: AppColorStyle
                                                      .primaryVariant(context),
                                                ),
                                              ],
                                            ));
                                      }),
                                ),

                                /*Radiology (e.g. x-ray, scans)*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Radiology (e.g. x-ray, scans)",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            width: 120,
                                            color: AppColorStyle.background(
                                                context),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0,
                                                        horizontal: Constants
                                                            .commonPadding),
                                                    child: Text(
                                                      list[index].radiology!,
                                                      style: AppTextStyle
                                                          .captionRegular(
                                                              context,
                                                              AppColorStyle
                                                                  .text(
                                                                      context)),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 1,
                                                  color: AppColorStyle
                                                      .primaryVariant(context),
                                                ),
                                              ],
                                            ));
                                      }),
                                ),

                                /*Specialist consultations*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Specialist consultations",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              width: 120,
                                              color: AppColorStyle.background(
                                                  context),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10.0,
                                                          horizontal: Constants
                                                              .commonPadding),
                                                      child: Text(
                                                        list[index]
                                                            .specialistConsultations!,
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle
                                                                    .text(
                                                                        context)),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    color: AppColorStyle
                                                        .primaryVariant(
                                                            context),
                                                  ),
                                                ],
                                              ));
                                        })),
                              ],
                            ),
                          ),

                          /////In-Hospital Medical Services //////
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: Constants.commonPadding),
                            child: Text(
                              "In-Hospital Medical Services",
                              style: AppTextStyle.subTitleMedium(
                                  context, AppColorStyle.primary(context)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        AppColorStyle.primaryVariant(context),
                                    width: 1)),
                            child: Column(
                              children: [
                                /*Public Hospital*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Public Hospital",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 120,
                                          color:
                                              AppColorStyle.background(context),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 15.0),
                                                  child: Column(
                                                    children: [
                                                      list[index].publicHospitalFlag ==
                                                              true
                                                          ? SvgPicture.asset(
                                                              IconsSVG
                                                                  .icCheckGreen,
                                                              width: 20,
                                                              height: 20)
                                                          : SvgPicture.asset(
                                                              IconsSVG
                                                                  .redCrossIcon,
                                                              width: 20,
                                                              height: 20),
                                                      const SizedBox(
                                                          height: 3.0),
                                                      Expanded(
                                                        child: Text(
                                                          list[index]
                                                              .publicHospital!,
                                                          style: AppTextStyle
                                                              .captionRegular(
                                                                  context,
                                                                  AppColorStyle
                                                                      .text(
                                                                          context)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 1,
                                                color: AppColorStyle
                                                    .primaryVariant(context),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                ),

                                /*Private Hospital*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Private Hospital",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 15.0),
                                                child: Column(
                                                  children: [
                                                    list[index].privateHospitalFlag ==
                                                            true
                                                        ? SvgPicture.asset(
                                                            IconsSVG
                                                                .icCheckGreen,
                                                            width: 20,
                                                            height: 20)
                                                        : SvgPicture.asset(
                                                            IconsSVG
                                                                .redCrossIcon,
                                                            width: 20,
                                                            height: 20),
                                                    const SizedBox(height: 3.0),
                                                    Expanded(
                                                      child: Text(
                                                        list[index]
                                                            .privateHospital!,
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle
                                                                    .text(
                                                                        context)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /*Private Room*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Private Room",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 70,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 15.0),
                                                child: Column(
                                                  children: [
                                                    list[index].privateRoomFlag ==
                                                            true
                                                        ? SvgPicture.asset(
                                                            IconsSVG
                                                                .icCheckGreen,
                                                            width: 20,
                                                            height: 20)
                                                        : SvgPicture.asset(
                                                            IconsSVG
                                                                .redCrossIcon,
                                                            width: 20,
                                                            height: 20),
                                                    const SizedBox(height: 3.0),
                                                    Text(
                                                      list[index].privateRoom!,
                                                      style: AppTextStyle
                                                          .captionRegular(
                                                              context,
                                                              AppColorStyle
                                                                  .text(
                                                                      context)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /////Accident and Emergency Department Facility Fees /////
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: Constants.commonPadding),
                            child: Text(
                              "Accident and Emergency Department Facility Fees",
                              style: AppTextStyle.subTitleMedium(
                                  context, AppColorStyle.primary(context)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        AppColorStyle.primaryVariant(context),
                                    width: 1)),
                            child: Column(
                              children: [
                                /*Public Hospital*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Public Hospital",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 15.0),
                                                child: Column(
                                                  children: [
                                                    list[index].publicHospitalAccidentAndEmergencyFlag ==
                                                            true
                                                        ? SvgPicture.asset(
                                                            IconsSVG
                                                                .icCheckGreen,
                                                            width: 20,
                                                            height: 20)
                                                        : SvgPicture.asset(
                                                            IconsSVG
                                                                .redCrossIcon,
                                                            width: 20,
                                                            height: 20),
                                                    const SizedBox(height: 3.0),
                                                    Expanded(
                                                      child: Text(
                                                        list[index]
                                                            .publicHospitalAccidentAndEmergency!,
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle
                                                                    .text(
                                                                        context)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /*Contracted Private hospitals*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Contracted Private hospitals",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 210,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 15.0),
                                                child: Column(
                                                  children: [
                                                    list[index].contractedPrivateHospitalsAccidentAndEmergencyFlag ==
                                                            true
                                                        ? SvgPicture.asset(
                                                            IconsSVG
                                                                .icCheckGreen,
                                                            width: 20,
                                                            height: 20)
                                                        : SvgPicture.asset(
                                                            IconsSVG
                                                                .redCrossIcon,
                                                            width: 20,
                                                            height: 20),
                                                    const SizedBox(height: 3.0),
                                                    Expanded(
                                                      child: Text(
                                                        list[index]
                                                            .contractedPrivateHospitalsAccidentAndEmergency!,
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle
                                                                    .text(
                                                                        context)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /*Non-contract Private hospitals*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Non-contract Private hospitals",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 410,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 15.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          list[index].nonContractPrivateHospitalsAccidentAndEmergencyFlag ==
                                                                  true
                                                              ? SvgPicture.asset(
                                                                  IconsSVG
                                                                      .icCheckGreen,
                                                                  width: 20,
                                                                  height: 20)
                                                              : SvgPicture.asset(
                                                                  IconsSVG
                                                                      .redCrossIcon,
                                                                  width: 20,
                                                                  height: 20),
                                                          const SizedBox(
                                                              width: 5),
                                                          list[index].nonContractPrivateHospitalsAccidentAndEmergencyTooltip ==
                                                                  true
                                                              ? InkWellWidget(
                                                                  onTap: () {
                                                                    WidgetHelper.showAlertDialog(
                                                                        context,
                                                                        isHTml:
                                                                            false,
                                                                        title:
                                                                            "",
                                                                        contentText:
                                                                            list[index].nonContractPrivateHospitalsAccidentAndEmergencyTooltipText!);
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                      IconsSVG
                                                                          .icQuestionInfo,
                                                                      width: 14,
                                                                      height:
                                                                          14))
                                                              : Container()
                                                        ]),
                                                    const SizedBox(height: 3.0),
                                                    Expanded(
                                                      child: Text(
                                                        list[index]
                                                            .nonContractPrivateHospitalsAccidentAndEmergency!,
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle
                                                                    .text(
                                                                        context)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /////Other Coverage/////
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: Constants.commonPadding),
                            child: Text(
                              "Other Coverage",
                              style: AppTextStyle.subTitleMedium(
                                  context, AppColorStyle.primary(context)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        AppColorStyle.primaryVariant(context),
                                    width: 1)),
                            child: Column(
                              children: [
                                /*Ambulance services*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Ambulance services",
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          onTap: () {
                                            WidgetHelper.showAlertDialog(
                                              context,
                                              isHTml: false,
                                              title: "",
                                              contentText:
                                                  "100% of the cost where immediate professional attention is required and your medical condition is such that you couldn't be transported any other way",
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconsSVG.icQuestionInfo,
                                              width: 14,
                                              height: 14)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: list[index]
                                                          .ambulanceServices ==
                                                      true
                                                  ? SvgPicture.asset(
                                                      IconsSVG.icCheckGreen,
                                                      width: 20,
                                                      height: 20)
                                                  : SvgPicture.asset(
                                                      IconsSVG.redCrossIcon,
                                                      width: 20,
                                                      height: 20),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /*Surgically implanted prostheses and other items included on the Federal Government's prostheses List*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Surgically implanted prostheses and other items included on the Federal Government's prostheses List",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 15.0),
                                              child: Column(
                                                children: [
                                                  list[index].surgicallyImplantedProsthesesFlag ==
                                                          true
                                                      ? SvgPicture.asset(
                                                          IconsSVG.icCheckGreen,
                                                          width: 20,
                                                          height: 20)
                                                      : SvgPicture.asset(
                                                          IconsSVG.redCrossIcon,
                                                          width: 20,
                                                          height: 20),
                                                  const SizedBox(height: 5.0),
                                                  Expanded(
                                                    child: Text(
                                                      list[index]
                                                          .surgicallyImplantedProstheses!,
                                                      style: AppTextStyle
                                                          .captionRegular(
                                                              context,
                                                              AppColorStyle
                                                                  .text(
                                                                      context)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /*MRI's*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        "MRI's",
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          onTap: () {
                                            WidgetHelper.showAlertDialog(
                                              context,
                                              isHTml: true,
                                              title: "",
                                              contentText:
                                                  "Your OSHC will pay equivalent to the MBS benefit towards MRI scans where the following three (3) criteria are met: <br/>- A registered specialist medical practitioner refers you to undergo an MRI;<br/>- The MRI is billed with an eligible Medicare Benefits Schedule (MBS) item number; and<br/> - The MRI is performed on a Medicare Eligible MRI Unit by a Medicare Eligible Provider;<br/> subject to waiting periods.",
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconsSVG.icQuestionInfo,
                                              width: 14,
                                              height: 14)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: list[index].mri == true
                                                  ? SvgPicture.asset(
                                                      IconsSVG.icCheckGreen,
                                                      width: 20,
                                                      height: 20)
                                                  : SvgPicture.asset(
                                                      IconsSVG.redCrossIcon,
                                                      width: 20,
                                                      height: 20),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /*Prescription medicines*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Prescription medicines",
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWellWidget(
                                          onTap: () {
                                            WidgetHelper.showAlertDialog(
                                              context,
                                              isHTml: true,
                                              title: "",
                                              contentText:
                                                  "For Prescription Medicines prescribed by your doctor. Excludes: medications, drugs or other treatments not prescribed by a doctor or not listed on the Pharmaceutical Benefits Scheme (PBS). Pharmacy expenses coverage always comes with a co-payment. This is the fixed amount that students pay for a covered medicine.",
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconsSVG.icQuestionInfo,
                                              width: 14,
                                              height: 14)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 350,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 15.0),
                                                  child: HtmlWidget(
                                                    list[index]
                                                        .prescriptionMedicines!,
                                                    textStyle: AppTextStyle
                                                        .captionRegular(
                                                      context,
                                                      AppColorStyle.text(
                                                          context),
                                                    ),
                                                    renderMode:
                                                        RenderMode.column,
                                                  )
                                                  /*Text(
                                                  list[index]
                                                      .prescriptionMedicines!,
                                                  style: AppTextStyle
                                                      .captionRegular(
                                                          context,
                                                          AppColorStyle.text(
                                                              context)),
                                                ),*/
                                                  ),
                                            ),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /////Waiting Periods/////
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: Constants.commonPadding),
                            child: Text(
                              "Waiting Periods",
                              style: AppTextStyle.subTitleMedium(
                                  context, AppColorStyle.primary(context)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        AppColorStyle.primaryVariant(context),
                                    width: 1)),
                            child: Column(
                              children: [
                                /*Psychiatric Conditions*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Psychiatric Conditions",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 120,
                                          color:
                                              AppColorStyle.background(context),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15.0,
                                                          vertical: 15.0),
                                                      child: Text(
                                                          list[index]
                                                              .psychiatricConditions!,
                                                          style: AppTextStyle
                                                              .captionRegular(
                                                                  context,
                                                                  AppColorStyle
                                                                      .text(
                                                                          context))))),
                                              Container(
                                                width: 1,
                                                color: AppColorStyle
                                                    .primaryVariant(context),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                ),

                                /*Pregnancy and birth related services*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Pregnancy and birth related services",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 15.0),
                                                    child: Text(
                                                        list[index]
                                                            .pregnancyAndBirthRelatedServices!,
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle.text(
                                                                    context))))),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                /*Other pre-existing conditions*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Other pre-existing conditions",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 120,
                                        color:
                                            AppColorStyle.background(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 15.0),
                                                    child: Text(
                                                        list[index]
                                                            .otherPreExisitingConditions!,
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle.text(
                                                                    context))))),
                                            Container(
                                              width: 1,
                                              color:
                                                  AppColorStyle.primaryVariant(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /////Refund Policy /////
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: Constants.commonPadding),
                            child: Text(
                              "Refund Policy",
                              style: AppTextStyle.subTitleMedium(
                                  context, AppColorStyle.primary(context)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        AppColorStyle.primaryVariant(context),
                                    width: 1)),
                            child: Column(
                              children: [
                                /*Refund policy*/
                                Container(
                                  color: AppColorStyle.primaryVariant(context),
                                  height: 30,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: Constants.commonPadding),
                                  child: Text(
                                    "Refund policy",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                ),
                                SizedBox(
                                  height: 130,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 120,
                                          color:
                                              AppColorStyle.background(context),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15.0,
                                                          vertical: 15.0),
                                                      child: Text(
                                                          list[index]
                                                              .refundPolicy!,
                                                          style: AppTextStyle
                                                              .captionRegular(
                                                                  context,
                                                                  AppColorStyle
                                                                      .text(
                                                                          context))))),
                                              Container(
                                                width: 1,
                                                color: AppColorStyle
                                                    .primaryVariant(context),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  onResume() {}
}
