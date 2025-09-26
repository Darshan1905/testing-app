import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/text_field_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/webview_dialog.dart';
import 'package:occusearch/common_widgets/google_apple_singin_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/authentication/login/login_mobile_widget.dart';
import 'package:occusearch/features/country/country_dialog.dart';
import 'package:occusearch/features/country/model/country_model.dart';

class CreateAccountScreen extends BaseApp {
  const CreateAccountScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _CreateAccountState();
}

class _CreateAccountState extends BaseState {
  final AuthenticationBloc _authBloc = AuthenticationBloc();

  String? mobileNumber;
  String? emailAddress;
  String? dialCode;
  String? countryShortcode;
  late FocusNode _nameFieldFocusNode;
  late FocusNode _phoneFieldFocusNode;
  GlobalBloc? _globalBloc;

  @override
  init() {
    _nameFieldFocusNode = FocusNode();
    _phoneFieldFocusNode = FocusNode();
    Map<String, dynamic>? param = widget.arguments;
    if (param != null) {
      printLog("#CREATEACCOUNT# navigation param :: $param");
      if (param['mobile_number'] != null && param['mobile_number'] != "") {
        mobileNumber = param['mobile_number'];
      }
      if (param['email_address'] != null && param['email_address'] != "") {
        emailAddress = param['email_address'];
      }
      if (param['dial_code'] != null && param['dial_code'] != "") {
        dialCode = param['dial_code'];
      }
      if (param['country_shortcode'] != null &&
          param['country_shortcode'] != "") {
        countryShortcode = param['country_shortcode'];
      }
      if (param['full_name'] != null && param['full_name'] != "") {
        _authBloc.fullNameTextEditingController.text = param['full_name'];
      }
    }

    // Post-frame: preselect country based on device like LoginScreen
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await globalBloc?.getDeviceCountryInfo();
      await Future.delayed(const Duration(milliseconds: 500));
      if (globalBloc != null &&
          (globalBloc?.getCountryListValue == null ||
              globalBloc?.getCountryListValue == [])) {
        await globalBloc?.getCountryListFromRemoteConfig();
      }
      if (globalBloc?.getCountryListValue != null &&
          globalBloc!.getCountryListValue.isNotEmpty) {
        CountryModel? model = globalBloc?.getCountryListValue.firstWhere(
            (element) => element.code == globalBloc?.getDeviceCountryShortcodeValue,
            orElse: () => globalBloc!.getCountryListValue.first);
        _authBloc.setSelectedCountryModel = model;
      }
    });
  }

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxBlocProvider(
      create: (_) => _authBloc,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
          color: AppColorStyle.background(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  IconsWEBP.occu3Dlogo,
                  fit: BoxFit.contain,
                  scale: 1,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  StringHelper.createAccountTitle,
                  style: AppTextStyle.subHeadlineSemiBold(
                      context, AppColorStyle.text(context)),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  StringHelper.createAccountSubTitle,
                  style: AppTextStyle.subTitleRegular(
                      context, AppColorStyle.textDetail(context)),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                // Country + Mobile input
                Container(
                  decoration: BoxDecoration(
                    color: AppColorStyle.backgroundVariant(context),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      InkWellWidget(
                        onTap: () => CountryDialog.countryDialog(
                          context: context,
                          onItemClick: (CountryModel country) {
                            _authBloc.setSelectedCountryModel = country;
                          },
                          countryList: _globalBloc?.getCountryListValue ?? [],
                        ),
                        child: StreamBuilder<CountryModel>(
                          stream: _authBloc.getSelectedCountryModel,
                          builder:
                              (context, AsyncSnapshot<CountryModel> snapshot) {
                            return Row(
                              children: [
                                const SizedBox(
                                  width: 14.0,
                                ),
                                snapshot.hasData
                                    ? SvgPicture.network(
                                        '${Constants.cdnFlagURL}${snapshot.data?.flag}',
                                        width: 24.0,
                                        height: 24.0,
                                        alignment: Alignment.center,
                                        fit: BoxFit.fill,
                                        placeholderBuilder: (context) => Icon(
                                          Icons.flag,
                                          size: 24.0,
                                          color: AppColorStyle.surfaceVariant(
                                              context),
                                        ),
                                      )
                                    : Icon(
                                        Icons.flag,
                                        size: 24.0,
                                        color: AppColorStyle.surfaceVariant(
                                            context),
                                      ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  snapshot.hasData
                                      ? "${snapshot.data?.dialCode}"
                                      : '',
                                  style: AppTextStyle.titleSemiBold(
                                    context,
                                    AppColorStyle.text(context),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: MobileTextFieldWidget(
                          isErrorShow: false,
                          readOnly: false,
                          focusNode: _phoneFieldFocusNode,
                          stream: _authBloc.getMobileNumber,
                          keyboardKey: TextInputType.number,
                          onTextChanged: _authBloc.onChangeMobile,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                // Social sign-in buttons
                GoogleAppleSignInWidget(
                  onTap: () async {
                    if (_authBloc.fullNameTextEditingController.text.trim().isEmpty) {
                      Toast.show(context,
                          message: StringHelper.createAccountFullNameValidation,
                          gravity: Toast.toastTop,
                          type: Toast.toastError);
                      return;
                    }
                    await _authBloc.googleSignIn(context, RouteName.createAccount, _globalBloc);
                  },
                  isGoogle: true,
                ),
                const SizedBox(height: 12.0),
                GoogleAppleSignInWidget(
                  onTap: () async {
                    if (_authBloc.fullNameTextEditingController.text.trim().isEmpty) {
                      Toast.show(context,
                          message: StringHelper.createAccountFullNameValidation,
                          gravity: Toast.toastTop,
                          type: Toast.toastError);
                      return;
                    }
                    await _authBloc.appleSignIn(context, RouteName.createAccount, _globalBloc);
                  },
                  isGoogle: false,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextFieldWithoutStreamWidget(
                  controller: _authBloc.fullNameTextEditingController,
                  isErrorShow: false,
                  focusNode: _nameFieldFocusNode,
                  keyboardKey: TextInputType.text,
                  onTextChanged: _authBloc.onChangeFullname,
                  hintText: 'Full name',
                  maxLength: 30,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<bool>(
                      stream: _authBloc.getConditionAgree,
                      builder: (_, snapshot) {
                        if (snapshot.hasData && snapshot.data == true) {
                          return InkWellWidget(
                            onTap: () =>
                                _authBloc.onClickConditionCheckbox(false),
                            child: SvgPicture.asset(
                              IconsSVG.check,
                              width: 24,
                              height: 24,
                            ),
                          );
                        } else {
                          return InkWellWidget(
                            onTap: () =>
                                _authBloc.onClickConditionCheckbox(true),
                            child: SvgPicture.asset(
                              IconsSVG.uncheck,
                              width: 24,
                              height: 24,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: StringHelper.createAccountTerms1,
                              style: AppTextStyle.subTitleMedium(
                                context,
                                AppColorStyle.textDetail(context),
                              ),
                            ),
                            WidgetSpan(
                              child: InkWellWidget(
                                onTap: () {
                                  WebviewDialog.webview(
                                      context: context,
                                      url: Constants.termsURL);
                                },
                                child: Text(
                                  StringHelper.createAccountTerms2,
                                  style: AppTextStyle.subTitleMedium(
                                    context,
                                    AppColorStyle.primary(context),
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: StringHelper.createAccountTerms3,
                              style: AppTextStyle.subTitleMedium(
                                context,
                                AppColorStyle.textDetail(context),
                              ),
                            ),
                            WidgetSpan(
                              child: InkWellWidget(
                                onTap: () {
                                  WebviewDialog.webview(
                                      context: context,
                                      url: Constants.policyURL);
                                },
                                child: Text(
                                  StringHelper.createAccountTerms4,
                                  style: AppTextStyle.subTitleMedium(
                                    context,
                                    AppColorStyle.primary(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40.0,
                ),
                StreamBuilder<bool>(
                  stream: _authBloc.getConditionAgree,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return StreamBuilder<bool>(
                        stream: _authBloc.getLoadingSubject,
                        builder: (context, snapshotLoading) {
                          if (snapshotLoading.data == false) {
                            return ButtonWidget(
                              onTap: () {
                                if (!snapshot.hasData || snapshot.data != true) {
                                  Toast.show(context,
                                      message: StringHelper
                                          .createAccountTermsCondition,
                                      duration: 3,
                                      type: Toast.toastError);
                                  return;
                                }
                                if (_authBloc.fullNameTextEditingController.text.trim().isEmpty) {
                                  Toast.show(context,
                                      message: StringHelper.createAccountFullNameValidation,
                                      gravity: Toast.toastTop,
                                      type: Toast.toastError);
                                  return;
                                }
                                if (_authBloc.getMobileNumberValue.isEmpty || _authBloc.getMobileNumberValue.length < 8) {
                                  _phoneFieldFocusNode.requestFocus();
                                  Toast.show(context,
                                      message: _authBloc.getMobileNumberValue.isEmpty
                                          ? StringHelper.otpMobileValidation
                                          : StringHelper.otpMobileInvalid,
                                      type: Toast.toastError,
                                      gravity: Toast.toastTop,
                                      duration: 2);
                                  return;
                                }
                                if (isRedundantClick(DateTime.now())) {
                                  return;
                                }
                                _nameFieldFocusNode.unfocus();
                                _phoneFieldFocusNode.unfocus();
                                // Send OTP for create-account route; OTP verify will auto-create if user not found
                                _authBloc.sendOTP(RouteName.createAccount, context);
                              },
                              title: 'Send OTP',
                              logActionEvent:
                                  FBActionEvent.fbActionCreateAccount,
                              buttonColor:
                                  snapshot.hasData && snapshot.data == true
                                      ? AppColorStyle.primary(context)
                                      : AppColorStyle.textCaption(context),
                              textColor: AppColorStyle.textWhite(context),
                            );
                          } else {
                            return Material(
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColorStyle.backgroundVariant(
                                        context),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: SizedBox(
                                  height: 50.0,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: StreamBuilder<List<String>?>(
                                      stream: _authBloc.getLoadingMessage,
                                      builder: (context, snapshotMessage) {
                                        List<RotateAnimatedText> messages = [
                                          RotateAnimatedText(
                                            "Please wait...",
                                            textStyle:
                                                AppTextStyle.subTitleMedium(
                                              context,
                                              AppColorStyle.primary(context),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ];
                                        if (snapshotMessage.hasData &&
                                            snapshotMessage.data != null &&
                                            snapshotMessage.data!.isNotEmpty) {
                                          messages = List.generate(
                                            snapshotMessage.data!.length,
                                            (index) => RotateAnimatedText(
                                              snapshotMessage.data![index],
                                              textStyle:
                                                  AppTextStyle.subTitleMedium(
                                                context,
                                                AppColorStyle.primary(context),
                                              ),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          );
                                        }
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AnimatedTextKit(
                                              animatedTexts: messages,
                                              repeatForever: true,
                                              pause: const Duration(
                                                  milliseconds: 0),
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.5,
                                                color: AppColorStyle.primary(
                                                    context),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                    );
                  },
                ),
                const SizedBox(height: 40.0),
                Center(
                  child: InkWellWidget(
                    onTap: () => GoRoutesPage.go(
                        mode: NavigatorMode.remove,
                        moveTo: RouteName.login),
                    child: Text(
                      "Already have an account? Log in",
                      style: AppTextStyle.subTitleMedium(
                        context,
                        AppColorStyle.textHint(context),
                      ),
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

  DateTime? loginClickTime;

  // TO PREVENT MULTIPLE CLICK EVENT
  bool isRedundantClick(DateTime currentTime) {
    if (loginClickTime == null) {
      loginClickTime = currentTime;
      return false;
    }
    if (currentTime.difference(loginClickTime!).inSeconds < 1) {
      //set this difference time in seconds
      return true;
    }

    loginClickTime = currentTime;
    return false;
  }

  @override
  onResume() {}
}
