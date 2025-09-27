import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:occusearch/common_widgets/text_field_widget.dart';
import 'package:occusearch/common_widgets/webview_dialog.dart';
import 'package:occusearch/features/country/country_dialog.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/authentication/login/login_mobile_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateAccountScreen extends BaseApp {
  const CreateAccountScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _CreateAccountState();
}

class _CreateAccountState extends BaseState {
  final AuthenticationBloc _authBloc = AuthenticationBloc();
  GlobalBloc? _globalBloc;

  String? mobileNumber;
  String? emailAddress;
  String? dialCode;
  String? countryShortcode;
  late FocusNode _nameFieldFocusNode;
  late FocusNode _emailFieldFocusNode;
  late FocusNode _phoneFieldFocusNode;

  String? mode;

  @override
  init() {
    _nameFieldFocusNode = FocusNode();
    _emailFieldFocusNode = FocusNode();
    _phoneFieldFocusNode = FocusNode();

    Map<String, dynamic>? param = widget.arguments;
    if (param != null) {
      printLog("#CREATEACCOUNT# navigation param :: $param");
      if (param['mobile_number'] != null && param['mobile_number'] != "") {
        mobileNumber = param['mobile_number'];
        _authBloc.onChangeMobile(param['mobile_number']);
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
      if (param['mode'] != null && param['mode'] != "") {
        mode = param['mode'];
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await globalBloc?.getDeviceCountryInfo();
      await Future.delayed(const Duration(milliseconds: 500));
      if (_globalBloc != null &&
          (_globalBloc?.getCountryListValue == null ||
              _globalBloc?.getCountryListValue == [])) {
        await _globalBloc?.getCountryListFromRemoteConfig();
      }
      if (_globalBloc?.getCountryListValue != null &&
          _globalBloc!.getCountryListValue.isNotEmpty) {
        CountryModel? model = _globalBloc?.getCountryListValue.firstWhere(
            (element) => element.code == _globalBloc?.getDeviceCountryShortcodeValue,
            orElse: () => _globalBloc!.getCountryListValue.first);
        _authBloc.setSelectedCountryModel = model;
      }
    });
  }

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppColorStyle.background(context),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return RxBlocProvider(
      create: (_) => _authBloc,
      child: Scaffold(
        backgroundColor: AppColorStyle.background(context),
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              // Blue background to merge top
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    color: AppColorStyle.primary(context),
                  ),
                ),
              ),
              // Background Icons (same as login screen)
              Positioned(
                top: 40,
                left: 100,
                child: Image.asset('assets/icons/png/icon2.png',
                    height: 60, width: 60),
              ),
              Positioned(
                top: 40,
                right: 130,
                child: Image.asset('assets/icons/png/icon3.png',
                    height: 50, width: 50),
              ),
              Positioned(
                top: 90,
                left: 20,
                child: Image.asset('assets/icons/png/icon1.png',
                    height: 80, width: 80),
              ),
              Positioned(
                top: 90,
                right: 20,
                child: Image.asset('assets/icons/png/icon4.png',
                    height: 50, width: 50),
              ),
              // The main content column
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 90),
                    Text(
                      'Welcome Mate !!!',
                      style: AppTextStyle.headlineBold(context, Colors.white),
                    ),
                    const SizedBox(height: 90),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 30.0),
                          decoration: BoxDecoration(
                            color: AppColorStyle.background(context),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Let\'s get you started',
                                  style: AppTextStyle.subHeadlineBold(
                                      context, AppColorStyle.text(context)),
                                ),
                                const SizedBox(height: 30.0),
                                // Social Media Buttons
                                if (mode != 'phone_verified') ...[
                                  ButtonWidget(
                                    onTap: () async {
                                      if (_authBloc.isLoading) return;
                                      if (NetworkController.isInternetConnected == false) {
                                        Toast.show(context,
                                            message: StringHelper.internetConnection,
                                            type: Toast.toastError,
                                            gravity: Toast.toastTop,
                                            duration: 3);
                                        return;
                                      }
                                      _authBloc.googleSignIn(context, RouteName.createAccount, _globalBloc);
                                    },
                                    title: 'Create with Google',
                                    buttonColor: AppColorStyle.backgroundVariant(context),
                                    textColor: AppColorStyle.text(context),
                                    icon: Image.asset('assets/images/png/google_logo.png', height: 24, width: 24),
                                    border: Border.all(color: const Color(0x8000315A), width: 1.0),
                                    logActionEvent: FBActionEvent.fbActionContinueWithGoogle,
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      if (Platform.isIOS) Expanded(
                                        child: ButtonWidget(
                                          onTap: () {
                                            if (_authBloc.isLoading) return;
                                            if (NetworkController.isInternetConnected == false) {
                                              Toast.show(context,
                                                  message: StringHelper.internetConnection,
                                                  type: Toast.toastError,
                                                  gravity: Toast.toastTop,
                                                  duration: 3);
                                              return;
                                            }
                                            _authBloc.appleSignIn(context, RouteName.createAccount, _globalBloc);
                                          },
                                          title: 'Apple',
                                          buttonColor: AppColorStyle.backgroundVariant(context),
                                          textColor: AppColorStyle.text(context),
                                          icon: Image.asset('assets/images/png/apple_logo.png', height: 24, width: 24),
                                          border: Border.all(color: const Color(0x8000315A), width: 1.0),
                                          logActionEvent: FBActionEvent.fbActionSignIn,
                                        ),
                                      ),
                                      if (Platform.isIOS) const SizedBox(width: 10.0),
                                      Expanded(
                                        child: ButtonWidget(
                                          onTap: () {
                                            Toast.show(context,
                                                message: 'LinkedIn not implemented',
                                                duration: 2);
                                          },
                                          title: 'LinkedIn',
                                          buttonColor: AppColorStyle.backgroundVariant(context),
                                          textColor: AppColorStyle.text(context),
                                          icon: Image.asset('assets/images/png/linkedin_logo.png', height: 24, width: 24),
                                          border: Border.all(color: const Color(0x8000315A), width: 1.0),
                                          logActionEvent: FBActionEvent.fbActionContinueWithGoogle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40.0),
                                  Center(
                                    child: Text(
                                      'Or Enter Details',
                                      style: AppTextStyle.subTitleRegular(context, AppColorStyle.textHint(context)),
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                ],

                                // Full Name Field
                                TextFieldWithoutStreamWidget(
                                  controller: _authBloc.fullNameTextEditingController,
                                  isErrorShow: false,
                                  focusNode: _nameFieldFocusNode,
                                  keyboardKey: TextInputType.text,
                                  onTextChanged: _authBloc.onChangeFullname,
                                  hintText: 'Full name',
                                  maxLength: 30,
                                ),
                                const SizedBox(height: 20.0),
                                // Phone Number Field with Country Code
                                if (mode != 'phone_verified')
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColorStyle.backgroundVariant(context),
                                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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
                                            builder: (context, AsyncSnapshot<CountryModel> snapshot) {
                                              return Row(
                                                children: [
                                                  const SizedBox(width: 14.0),
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
                                                            color: AppColorStyle.surfaceVariant(context),
                                                          ),
                                                        )
                                                      : Icon(
                                                          Icons.flag,
                                                          size: 24.0,
                                                          color: AppColorStyle.surfaceVariant(context),
                                                        ),
                                                  const SizedBox(width: 10.0),
                                                  Text(
                                                    snapshot.hasData ? "${snapshot.data?.dialCode}" : '',
                                                    style: AppTextStyle.titleSemiBold(context, AppColorStyle.text(context)),
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
                                // Create Account Button
                                StreamBuilder<bool>(
                                  stream: _authBloc.getLoadingSubject,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == false) {
                                      return ButtonWidget(
                                        onTap: () {
                                          if (_authBloc.getMobileNumberValue == "") {
                                            _phoneFieldFocusNode.requestFocus();
                                            Toast.show(context,
                                                message: StringHelper.otpMobileValidation,
                                                type: Toast.toastError,
                                                gravity: Toast.toastTop,
                                                duration: 2);
                                          } else if (_authBloc.getMobileNumberValue.isNotEmpty && _authBloc.getMobileNumberValue.length < 8) {
                                            _phoneFieldFocusNode.requestFocus();
                                            Toast.show(context,
                                                message: StringHelper.otpMobileInvalid,
                                                type: Toast.toastError,
                                                gravity: Toast.toastTop,
                                                duration: 2);
                                          } else {
                                            _phoneFieldFocusNode.unfocus();
                                            _authBloc.sendOTP(RouteName.createAccount, context);
                                          }
                                        },
                                        title: 'Create Account',
                                        logActionEvent: FBActionEvent.fbActionCreateAccount,
                                        buttonColor: AppColorStyle.primary(context),
                                        textColor: AppColorStyle.textWhite(context),
                                      );
                                    } else {
                                      return Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColorStyle.backgroundVariant(context),
                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                          ),
                                          child: SizedBox(
                                            height: 50.0,
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: StreamBuilder<List<String>?>(
                                                stream: _authBloc.getLoadingMessage,
                                                builder: (context, snapshot) {
                                                  List<RotateAnimatedText> messages = [
                                                    RotateAnimatedText("Please wait...", textStyle: AppTextStyle.subTitleMedium(context, AppColorStyle.primary(context))),
                                                  ];
                                                  if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                                    messages = List.generate(
                                                      snapshot.data!.length,
                                                      (index) => RotateAnimatedText(snapshot.data![index], textStyle: AppTextStyle.subTitleMedium(context, AppColorStyle.primary(context))),
                                                    );
                                                  }
                                                  return Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      AnimatedTextKit(animatedTexts: messages, repeatForever: true, pause: const Duration(milliseconds: 0)),
                                                      SizedBox(
                                                        width: 20.0,
                                                        height: 20.0,
                                                        child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColorStyle.primary(context)),
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
                                ),
                                const SizedBox(height: 20.0),
                                // Terms and Conditions text
                                Align(
                                  alignment: Alignment.center,
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'By clicking this button, you agree with our ',
                                      style: AppTextStyle.subTitleRegular(context, AppColorStyle.textHint(context)),
                                      children: [
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: AppTextStyle.subTitleRegular(context, AppColorStyle.primary(context)),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              WebviewDialog.webview(context: context, url: Constants.termsURL);
                                            },
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Align(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {
                                      context.goNamed(RouteName.login);
                                    },
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'Already have an account? ',
                                        style: AppTextStyle.subTitleRegular(context, AppColorStyle.textHint(context)),
                                        children: [
                                          TextSpan(
                                            text: 'Login now!',
                                            style: AppTextStyle.subTitleRegular(context, AppColorStyle.primary(context)),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                GoRoutesPage.go(mode: NavigatorMode.push, moveTo: RouteName.login);
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Back Button
              Positioned(
                top: 50,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
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
      return true;
    }
    loginClickTime = currentTime;
    return false;
  }

  @override
  onResume() {}

  @override
  void dispose() {
    _nameFieldFocusNode.dispose();
    _emailFieldFocusNode.dispose();
    _phoneFieldFocusNode.dispose();
    super.dispose();
  }
}