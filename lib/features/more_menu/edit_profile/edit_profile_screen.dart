// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/text_field_with_stream_widget.dart';
import 'package:occusearch/common_widgets/text_form_field_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/authentication/login/login_mobile_widget.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/country/country_dialog.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/custom_question/custom_question_bloc.dart';
import 'package:occusearch/features/more_menu/edit_profile/edit_profile_bloc.dart';
import 'package:occusearch/features/more_menu/edit_profile/edit_profile_widget.dart';
import 'package:occusearch/features/more_menu/edit_profile/widget/edit_profile_delete_account_widget.dart';

class EditProfileScreen extends BaseApp {
  const EditProfileScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _EditProfileState();
}

class _EditProfileState extends BaseState {
  final EditProfileBloc _editProfileBloc = EditProfileBloc();
  final AuthenticationBloc _authBloc = AuthenticationBloc();

  // final _customQuestionBloc = CustomQuestionBloc();
  GlobalBloc? _globalBloc;

  var isAnyChangeInData = false;

  @override
  init() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await _globalBloc?.setUserInfoData(context);

        UserInfoData? info = await _globalBloc?.getUserInfo(context);
        if (info != null && info.leadCode != null && info.leadCode != "") {
          _editProfileBloc.setUserInfo = info;
          _editProfileBloc.setFullName = info.name ?? '';
          _editProfileBloc.setPhoneNumber = info.phone ?? '';
          if (info.email != null &&
              info.email != "" &&
              info.email!.isNotEmpty &&
              !info.email!.contains("@gmail.com") &&
              !info.email!.contains("@privaterelay.appleid.com")) {
            _editProfileBloc.setEmailAddress = '';
          } else {
            _editProfileBloc.setEmailAddress = info.email ?? '';
          }

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
            if (model == null) {
              _authBloc.setSelectedCountryModel =
                  _globalBloc?.getCountryListValue[0];
            } else {
              _authBloc.setSelectedCountryModel = model;
            }
          }
        }

        //to get custom question data
        CustomQuestionBloc.getCustomQuestionData();
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxMultiBlocProvider(
      providers: [
        RxBlocProvider<EditProfileBloc>(create: (context) => _editProfileBloc),
        RxBlocProvider<AuthenticationBloc>(create: (context) => _authBloc),
      ],
      child: Container(
        color: AppColorStyle.background(context),
        child: WillPopScopeWidget(
          onWillPop: () async {
            if (_editProfileBloc.isLoading) {
              return false;
            }
            if (isAnyChangeInData == true) {
              WidgetHelper.alertDialogWidget(
                context: context,
                title: StringHelper.discardDialogTitle,
                buttonColor: AppColorStyle.primary(context),
                message: StringHelper.discardDialogSubTitle,
                positiveButtonTitle: StringHelper.okay,
                negativeButtonTitle: StringHelper.cancel,
                onPositiveButtonClick: () {
                  context.pop();
                },
              );
              return false;
            } else {
              return true;
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: Constants.commonPadding),
                  child: Row(
                    children: [
                      InkWellWidget(
                        onTap: () {
                          if (_editProfileBloc.isLoading) {
                            return false;
                          }
                          if (isAnyChangeInData == true) {
                            WidgetHelper.alertDialogWidget(
                              context: context,
                              title: StringHelper.discardDialogTitle,
                              buttonColor: AppColorStyle.primary(context),
                              message: StringHelper.discardDialogSubTitle,
                              positiveButtonTitle: StringHelper.okay,
                              negativeButtonTitle: StringHelper.cancel,
                              onPositiveButtonClick: () {
                                context.pop();
                              },
                            );
                          } else {
                            context.pop();
                          }
                        },
                        child: SvgPicture.asset(
                          IconsSVG.arrowBack,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.text(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        StringHelper.editProfile,
                        style: AppTextStyle.subHeadlineSemiBold(
                            context, AppColorStyle.text(context)),
                      ),
                      const Spacer(),
                      // [LOGOUT]
                      InkWellWidget(
                        onTap: () {
                          if (_editProfileBloc.isLoading) {
                            return;
                          }
                          WidgetHelper.alertDialogWidget(
                            context: context,
                            title: StringHelper.menuLogoutTitle,
                            message: StringHelper.menuLogoutMessage,
                            positiveButtonTitle:
                                StringHelper.menuLogoutButtonPos,
                            negativeButtonTitle: StringHelper.cancel,
                            onPositiveButtonClick: () {
                              _editProfileBloc.userLogout(context, _authBloc);
                              globalBloc?.needToShowAdsDialog = true;
                            },
                          );
                        },
                        child: SvgPicture.asset(
                          IconsSVG.signOutIcon,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.red(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: StreamBuilder(
                      stream: _globalBloc?.getUserInfoStream,
                      builder: (_, snapshots) {
                        if (snapshots.hasData) {
                          final UserInfoData? userInfo = snapshots.data;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StreamBuilder<CountryModel>(
                                  stream: _authBloc.getSelectedCountryModel,
                                  builder: (context,
                                      AsyncSnapshot<CountryModel> snapshot) {
                                    final String dialCode = snapshot.hasData
                                        ? "${snapshot.data?.dialCode}"
                                        : '';
                                    return EditProfileHeaderWidget(
                                        name: userInfo?.name ?? '',
                                        email: userInfo?.email ?? '',
                                        mobile: userInfo?.phone ?? '',
                                        dialCode: dialCode);
                                  }),

                              /*StreamWidget(
                                  stream: CustomQuestionBloc.getCustomQuestionsListStream,
                                  onBuild: (_,questionsSnapshot){
                                    if(questionsSnapshot != null){
                                      List<CustomQuestions>? submitQuestionList = questionsSnapshot?.where((element) => element.answer != "").toList();
                                      var param = {
                                        "customQuestionList" : questionsSnapshot,
                                        "isFromEditProfileScreen" : true,
                                      };
                                      return Padding(
                                        padding: const EdgeInsets.only(top:20.0),
                                        child: InkWellWidget(
                                            onTap:() {
                                              if( (submitQuestionList?.length ?? 0) > 0){
                                                CustomQuestionBloc.setFirstAttemptValue = false;
                                                GoRoutesPage.go(mode: NavigatorMode.push, moveTo: RouteName.customQuestionAnswerReview, param: param);
                                              }else{
                                                CustomQuestionBloc.setFirstAttemptValue = true;
                                                GoRoutesPage.go(mode: NavigatorMode.push, moveTo: RouteName.customQuestionOnboarding);
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 5.0, horizontal: 15.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:AppColorStyle.primary(context),
                                                    width: 2,
                                                  ),
                                                // border: AppColorStyle.primarySurface2(context),
                                                borderRadius:
                                                const BorderRadius.all(Radius.circular(20.0)),
                                              ),
                                              child: Text(
                                                StringHelper.setPreferences,
                                                style: AppTextStyle.detailsRegular(
                                                    context, AppColorStyle.primary(context)),
                                              ),
                                            ),
                                        ),
                                      );
                                    }
                                  }
                              ),*/
                              const SizedBox(height: 40.0),
                              Container(
                                height: 10.0,
                                color: AppColorStyle.backgroundVariant(context),
                              ),
                              // Edit My Profile Form
                              Form(
                                // key: _myprofileformkey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                      horizontal: Constants.commonPadding),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        StringHelper.personalDetails,
                                        style: AppTextStyle.subTitleSemiBold(
                                            context,
                                            AppColorStyle.text(context)),
                                      ),
                                      const SizedBox(height: 20.0),
                                      // [FULL NAME]
                                      Text(
                                        StringHelper.profileFullName,
                                        style: AppTextStyle.detailsRegular(
                                            context,
                                            AppColorStyle.textHint(context)),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      TextFormFieldWidget(
                                          initialValue: userInfo?.name ?? '',
                                          stream:
                                              _editProfileBloc.fullNameStream,
                                          maxLength: 30,
                                          keyboardKey: TextInputType.text,
                                          hintText:
                                              StringHelper.profileFullName,
                                          onTextChanged: (String name) {
                                            _editProfileBloc
                                                .onChangeFullName(name);

                                            if (name.isNotEmpty &&
                                                name.trim() !=
                                                    userInfo?.name!) {
                                              _editProfileBloc.isNameChange
                                                  .add(true);
                                            } else {
                                              _editProfileBloc.isNameChange
                                                  .add(false);
                                            }
                                          }),
                                      // [Email Address]
                                      Text(
                                        StringHelper.profileEmailAddress,
                                        style: AppTextStyle.detailsRegular(
                                            context,
                                            AppColorStyle.textHint(context)),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      StreamBuilder(
                                          stream:
                                              _editProfileBloc.isEmailVerified,
                                          builder: (_, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data == true) {
                                              return TextFieldWithStreamWidget(
                                                stream: _editProfileBloc
                                                    .emailStream,
                                                suffixIcon: SvgPicture.asset(
                                                  IconsSVG.checkOutline,
                                                  colorFilter: ColorFilter.mode(
                                                    AppColorStyle.green(
                                                        context),
                                                    BlendMode.srcIn,
                                                  ),
                                                  width: 14.0,
                                                  height: 14.0,
                                                ),
                                                fromOccupationDashboard:
                                                    (snapshot.hasData &&
                                                        snapshot.data == true),
                                              );
                                            } else {
                                              return Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Visibility(
                                                    visible: Platform.isIOS,
                                                    child: InkWellWidget(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        height: 30,
                                                        width: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColorStyle
                                                              .backgroundVariant(
                                                                  context),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                25.0),
                                                          ),
                                                        ),
                                                        child: SvgPicture.asset(
                                                            IconsSVG.appleIcon),
                                                      ),
                                                      onTap: () {
                                                        _editProfileBloc
                                                            .appleSignIn(
                                                                context);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Platform.isIOS
                                                        ? 20.0
                                                        : 0.0,
                                                  ),
                                                  InkWellWidget(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        color: AppColorStyle
                                                            .backgroundVariant(
                                                                context),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(25.0),
                                                        ),
                                                      ),
                                                      child: SvgPicture.asset(
                                                          IconsSVG.googleIcon),
                                                    ),
                                                    onTap: () {
                                                      _editProfileBloc
                                                          .googleSignIn(
                                                              context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            }
                                          }),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      // [Mobile Number]
                                      Text(
                                        StringHelper.profilePhoneNumber,
                                        style: AppTextStyle.detailsRegular(
                                            context,
                                            AppColorStyle.textHint(context)),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      StreamBuilder<bool>(
                                        stream:
                                            _editProfileBloc.isPhoneVerified,
                                        builder:
                                            (context, snapshotPhoneVerified) {
                                          printLog(
                                              "Phone verification has data : ${snapshotPhoneVerified.hasData}");
                                          printLog(
                                              "Phone verification data : ${snapshotPhoneVerified.data}");
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: AppColorStyle
                                                  .backgroundVariant(context),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                InkWellWidget(
                                                  onTap: () {
                                                    if (snapshotPhoneVerified
                                                            .hasData &&
                                                        snapshotPhoneVerified
                                                                .data ==
                                                            false) {
                                                      CountryDialog
                                                          .countryDialog(
                                                        context: context,
                                                        onItemClick:
                                                            (CountryModel
                                                                country) {
                                                          _authBloc
                                                                  .setSelectedCountryModel =
                                                              country;
                                                        },
                                                        countryList: _globalBloc
                                                                ?.getCountryListValue ??
                                                            [],
                                                      );
                                                    }
                                                  },
                                                  child: StreamBuilder<
                                                      CountryModel>(
                                                    stream: _authBloc
                                                        .getSelectedCountryModel,
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                CountryModel>
                                                            snapshot) {
                                                      return Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 14.0,
                                                          ),
                                                          if (snapshot.hasData)
                                                            SvgPicture.network(
                                                              '${Constants.cdnFlagURL}${snapshot.data?.flag}',
                                                              width: 24.0,
                                                              height: 24.0,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              fit: BoxFit.fill,
                                                              placeholderBuilder:
                                                                  (context) =>
                                                                      Icon(
                                                                Icons.flag,
                                                                size: 24.0,
                                                                color: AppColorStyle
                                                                    .surfaceVariant(
                                                                        context),
                                                              ),
                                                            )
                                                          else
                                                            Icon(
                                                              Icons.flag,
                                                              size: 24.0,
                                                              color: AppColorStyle
                                                                  .surfaceVariant(
                                                                      context),
                                                            ),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          Text(
                                                            snapshot.hasData
                                                                ? "${snapshot.data?.dialCode}"
                                                                : '',
                                                            style: AppTextStyle
                                                                .titleSemiBold(
                                                              context,
                                                              (snapshot.hasData &&
                                                                      snapshotPhoneVerified
                                                                              .data ==
                                                                          true)
                                                                  ? AppColorStyle
                                                                      .textHint(
                                                                          context)
                                                                  : AppColorStyle
                                                                      .text(
                                                                          context),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: MobileTextFieldWidget(
                                                    stream: _editProfileBloc
                                                        .mobileStream,
                                                    readOnly: snapshotPhoneVerified
                                                            .hasData &&
                                                        snapshotPhoneVerified
                                                                .data ==
                                                            true &&
                                                        !_authBloc.isLoading,
                                                    initialValue:
                                                        userInfo?.phone ?? '',
                                                    isErrorShow: false,
                                                    keyboardKey:
                                                        TextInputType.number,
                                                    hintText: StringHelper
                                                        .profilePhoneNumber,
                                                    onTextChanged:
                                                        (String number) {
                                                      _editProfileBloc
                                                          .onChangePhone(
                                                              number);
                                                      if (number.isNotEmpty &&
                                                          number.trim() !=
                                                              userInfo?.phone &&
                                                          _editProfileBloc
                                                                  .isPhoneVerified ==
                                                              true) {
                                                        _editProfileBloc
                                                                .isPhoneNumberChangeValue =
                                                            true;
                                                      } else {
                                                        _editProfileBloc
                                                                .isPhoneNumberChangeValue =
                                                            false;
                                                      }
                                                    },
                                                  ),
                                                ),
                                                if (snapshotPhoneVerified
                                                        .hasData &&
                                                    snapshotPhoneVerified
                                                            .data ==
                                                        true)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5.0,
                                                            right: 15.0),
                                                    child: SvgPicture.asset(
                                                      IconsSVG.checkOutline,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        AppColorStyle.green(
                                                            context),
                                                        BlendMode.srcIn,
                                                      ),
                                                      width: 14.0,
                                                      height: 14.0,
                                                    ),
                                                  )
                                                else
                                                  StreamBuilder(
                                                    stream: _authBloc
                                                        .getLoadingSubject,
                                                    builder: (context,
                                                        snapshotLoader) {
                                                      if (snapshotLoader
                                                              .hasData &&
                                                          snapshotLoader.data ==
                                                              false) {
                                                        return StreamBuilder(
                                                          stream:
                                                              _editProfileBloc
                                                                  .mobileStream,
                                                          builder: (_,
                                                              AsyncSnapshot<
                                                                      String>
                                                                  snapshot) {
                                                            return InkWellWidget(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        15.0),
                                                                child: Text(
                                                                  StringHelper
                                                                      .profileGetOTP,
                                                                  style: AppTextStyle
                                                                      .detailsRegular(
                                                                    context,
                                                                    (snapshot.hasData &&
                                                                            snapshot
                                                                                .data!.isNotEmpty &&
                                                                            snapshot.data!.length >
                                                                                6)
                                                                        ? AppColorStyle.primary(
                                                                            context)
                                                                        : AppColorStyle.textHint(
                                                                            context),
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                if (NetworkController
                                                                        .isInternetConnected ==
                                                                    false) {
                                                                  Toast.show(
                                                                      context,
                                                                      message:
                                                                          StringHelper
                                                                              .internetConnection,
                                                                      type: Toast
                                                                          .toastError);
                                                                  return;
                                                                }
                                                                if (snapshot.hasData &&
                                                                    snapshot
                                                                        .data!
                                                                        .isNotEmpty &&
                                                                    snapshot.data!
                                                                            .length >
                                                                        6) {
                                                                  if (snapshotPhoneVerified
                                                                          .hasData &&
                                                                      snapshotPhoneVerified
                                                                              .data ==
                                                                          true) {
                                                                    return;
                                                                  }
                                                                  bool flag = _editProfileBloc
                                                                      .validationForPhoneNumber(
                                                                          context);
                                                                  if (flag) {
                                                                    printLog(
                                                                        "#EditProfileScreen# send OTP on ${_editProfileBloc.getPhoneNumberValue}");
                                                                    _authBloc
                                                                            .setMobileNumber =
                                                                        _editProfileBloc
                                                                            .getPhoneNumberValue;
                                                                    //FocusManager.instance.primaryFocus?.unfocus();
                                                                    // SENDING OTP
                                                                    var result = await _authBloc.sendOTP(
                                                                        RouteName
                                                                            .editProfile,
                                                                        context);
                                                                    // PROCESS RESULT
                                                                    _editProfileBloc
                                                                        .verifyPhoneNumber(
                                                                            result,
                                                                            context);
                                                                  }
                                                                } else {
                                                                  //do nothing because of invalid phone number
                                                                }
                                                              },
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15.0),
                                                          child: SizedBox(
                                                            width: 20.0,
                                                            height: 20.0,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 1.5,
                                                              color: AppColorStyle
                                                                  .primary(
                                                                      context),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // [UPDATE PROFILE]
                              StreamBuilder(
                                stream: _editProfileBloc.isUserDataChanged,
                                builder: (_, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data == true) {
                                    isAnyChangeInData = true;
                                  } else {
                                    isAnyChangeInData = false;
                                  }
                                  if (snapshot.data == true) {
                                    return StreamBuilder<bool>(
                                        stream:
                                            _editProfileBloc.getLoadingSubject,
                                        builder: (context, snapshotLoading) {
                                          if (snapshotLoading.data == false) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Constants
                                                          .commonPadding,
                                                      vertical: 10.0),
                                              child: ButtonWidget(
                                                buttonColor:
                                                    (snapshot.data == true)
                                                        ? AppColorStyle.primary(
                                                            context)
                                                        : AppColorStyle
                                                            .backgroundVariant(
                                                                context),
                                                onTap: () {
                                                  if (snapshot.data == true) {
                                                    CountryModel? model = _authBloc
                                                        .getSelectedCountryModelValue;
                                                    _editProfileBloc
                                                        .submitUserProfile(
                                                            context,
                                                            model,
                                                            _globalBloc!);
                                                  }
                                                },
                                                title: StringHelper
                                                    .profileSaveChanges,
                                                logActionEvent: FBActionEvent
                                                    .fbActionEditProfile,
                                                textColor: (snapshot.data ==
                                                        true)
                                                    ? AppColorStyle.textWhite(
                                                        context)
                                                    : AppColorStyle.textHint(
                                                        context),
                                              ),
                                            );
                                          } else {
                                            List<RotateAnimatedText> messages =
                                                [
                                              RotateAnimatedText(
                                                "Updating your profile...",
                                                textStyle:
                                                    AppTextStyle.subTitleMedium(
                                                  context,
                                                  AppColorStyle.primary(
                                                      context),
                                                ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              RotateAnimatedText(
                                                "Please wait...",
                                                textStyle:
                                                    AppTextStyle.subTitleMedium(
                                                  context,
                                                  AppColorStyle.primary(
                                                      context),
                                                ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Constants
                                                          .commonPadding,
                                                      vertical: 10.0),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: AppColorStyle
                                                          .backgroundVariant(
                                                              context),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: SizedBox(
                                                    height: 50.0,
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          AnimatedTextKit(
                                                            animatedTexts:
                                                                messages,
                                                            repeatForever: true,
                                                            pause:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                          ),
                                                          SizedBox(
                                                            width: 20.0,
                                                            height: 20.0,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 1.5,
                                                              color: AppColorStyle
                                                                  .primary(
                                                                      context),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Constants.commonPadding),
                                child: DeleteAccountWidget(
                                  onDeleteClick: () {
                                    if (userInfo?.phone != null &&
                                        userInfo?.phone != "") {
                                      CountryModel? model = _authBloc
                                          .getSelectedCountryModelValue;
                                      _authBloc.deleteAccount(context,
                                          emailAddress: '',
                                          phoneNumber: _editProfileBloc
                                                  .getPhoneNumberValue ??
                                              userInfo?.phone,
                                          countryCode: model?.dialCode,
                                          routeName: RouteName.editProfile);
                                    } else if (userInfo?.email != null &&
                                        userInfo?.email != "") {
                                      _authBloc.deleteAccount(context,
                                          emailAddress: _editProfileBloc
                                                  .getEmailAddressValue ??
                                              userInfo?.email,
                                          phoneNumber: '',
                                          countryCode: '',
                                          routeName: RouteName.editProfile);
                                    } else {
                                      Toast.show(context,
                                          message: StringHelper
                                              .profileDeleteAccountError,
                                          gravity: Toast.toastTop,
                                          duration: 3);
                                    }
                                  },
                                  editProfileBloc: _editProfileBloc,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  onResume() {}
}
