import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/authentication/otp/otp_parameter_model.dart';
import 'package:occusearch/features/authentication/otp/otp_text_field_widget.dart';
import 'package:occusearch/features/country/model/country_model.dart';
//import 'package:telephony/telephony.dart';

class OTPScreen extends BaseApp {
  const OTPScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _OTPState();
}

class _OTPState extends BaseState {
  final AuthenticationBloc _authBloc = AuthenticationBloc();
  String routeName = RouteName.login;
  String type = "${OTPtype.MOBILE}";
  String emailOTP = "";
  String emailAddress = "";
  String phoneNumber = "";
  bool isDeleteAccount = false;
  String fullName = "";

  final FocusNode _focusHideOtp = FocusNode();

  //for auto detect OTP
  //Telephony telephony = Telephony.instance;

  @override
  init() async {
    Map<String, dynamic>? param = widget.arguments;
    if (param != null) {
      printLog("#OTP# navigation param :: $param");
      if (param[OtpParameterModel.keyMobileNumber] != null &&
          param[OtpParameterModel.keyMobileNumber] != "") {
        _authBloc.onChangeMobile(param[OtpParameterModel.keyMobileNumber]);

        phoneNumber = param[OtpParameterModel.keyMobileNumber];
      }
      if (param[OtpParameterModel.keyFirebaseVerificationID] != null &&
          param[OtpParameterModel.keyFirebaseVerificationID] != "") {
        _authBloc.setFirebaseVerificationID =
            param[OtpParameterModel.keyFirebaseVerificationID];
      }
      if (param[OtpParameterModel.keyCountryModel] != null &&
          param[OtpParameterModel.keyCountryModel] is CountryModel) {
        _authBloc.setSelectedCountryModel =
            param[OtpParameterModel.keyCountryModel] as CountryModel;
      }
      if (param[OtpParameterModel.keyRouteName] != null &&
          param[OtpParameterModel.keyRouteName] != '') {
        routeName = param[OtpParameterModel.keyRouteName];
      }
      if (param[OtpParameterModel.keyType] != null &&
          param[OtpParameterModel.keyType] != '') {
        type = param[OtpParameterModel.keyType];
      }
      if (param[OtpParameterModel.keyEmailAddress] != null &&
          param[OtpParameterModel.keyEmailAddress] != '') {
        emailAddress = param[OtpParameterModel.keyEmailAddress];
      }
      if (param[OtpParameterModel.keyOtp] != null &&
          param[OtpParameterModel.keyOtp] != '') {
        emailOTP = param[OtpParameterModel.keyOtp];
      }
      if (param[OtpParameterModel.keyIsDeleteAccount] != null &&
          param[OtpParameterModel.keyIsDeleteAccount] != '') {
        isDeleteAccount = param[OtpParameterModel.keyIsDeleteAccount];
      }
      if (param[OtpParameterModel.keyFullName] != null &&
          param[OtpParameterModel.keyFullName] != '') {
        fullName = param[OtpParameterModel.keyFullName];
      }
      setState(() {});
    }

    //only we need to listen sms when we are in otp screen opened by phone number not email
    /*if (phoneNumber != null && phoneNumber.isNotEmpty) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          printLog(message.address); // +977981******67, sender number
          printLog(message.body); // Your OTP code is 34567
          printLog(message.date); // 1659690242000, timestamp

          // get the message
          String sms = message.body.toString();

          // verify SMS is sent for OTP with sender number
          if (message.body!.contains('OccuSearch')) {
            // Parse code from the OTP sms
            String otpCode = sms.replaceAll(RegExp(r'[^0-9]'), '');

            // and populate to otb boxes
            _onOtpChange(otpCode);

            Future.delayed(const Duration(milliseconds: 1000), () {
              setState(() {
                // refresh UI
                //to Auto verify when button clicked properly
                verifyOTPButtonClick();
              });
            });
          } else {
            printLog("Normal message.");
          }
        },
        listenInBackground: false,
      );
    }*/
  }

  /*void _onOtpChange(String str) {
    if (str.isNotEmpty) {
      if (str.toString().substring(0, 1) != "") {
        _authBloc.teOtpDigitOne.text = str.toString().substring(0, 1);
      }
      if (str.length > 1 && str.toString().substring(1, 2) != "") {
        _authBloc.teOtpDigitTwo.text = str.toString().substring(1, 2);
      } else {
        _authBloc.teOtpDigitTwo.text = "";
      }
      if (str.length > 2 && str.toString().substring(2, 3) != "") {
        _authBloc.teOtpDigitThree.text = str.toString().substring(2, 3);
      } else {
        _authBloc.teOtpDigitThree.text = "";
      }
      if (str.length > 3 && str.toString().substring(3, 4) != "") {
        _authBloc.teOtpDigitFour.text = str.toString().substring(3, 4);
      } else {
        _authBloc.teOtpDigitFour.text = "";
      }
      if (str.length > 4 && str.toString().substring(4, 5) != "") {
        _authBloc.teOtpDigitFive.text = str.toString().substring(4, 5);
      } else {
        _authBloc.teOtpDigitFive.text = "";
      }
      if (str.length > 5 && str.toString().substring(5, 6) != "") {
        _authBloc.teOtpDigitSix.text = str.toString().substring(5, 6);
      } else {
        _authBloc.teOtpDigitSix.text = "";
      }
    } else {
      _authBloc.teOtpDigitTwo.text = "";
      _authBloc.teOtpDigitThree.text = "";
      _authBloc.teOtpDigitFour.text = "";
      _authBloc.teOtpDigitOne.text = "";
      _authBloc.teOtpDigitFive.text = "";
      _authBloc.teOtpDigitSix.text = "";
    }
  }*/

  @override
  void didChangeDependencies() {
    FocusScope.of(context).requestFocus(_focusHideOtp);
    super.didChangeDependencies();
  }

  @override
  Widget body(BuildContext context) {
    globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxBlocProvider(
      create: (_) => _authBloc,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColorStyle.background(context),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Image.asset(
                    IconsWEBP.occu3Dlogo,
                    fit: BoxFit.contain,
                    scale: 1,
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    StringHelper.otpTitle,
                    style: AppTextStyle.headlineSemiBold(
                        context, AppColorStyle.text(context)),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    isDeleteAccount && emailAddress.isNotEmpty
                        ? StringHelper.otpSubtitle
                        : "${StringHelper.otpSubtitle}your phone number",
                    style: AppTextStyle.subTitleRegular(
                        context, AppColorStyle.textDetail(context)),
                  ),
                  const SizedBox(height: 3.0),
                  emailAddress.isNotEmpty
                      ? Text(
                          emailAddress,
                          style: AppTextStyle.subTitleSemiBold(
                              context, AppColorStyle.primary(context)),
                        )
                      : Row(
                          children: [
                            StreamBuilder(
                              stream: _authBloc.getSelectedCountryModel,
                              builder: (_, snapshot) {
                                return Text(
                                  snapshot.hasData
                                      ? snapshot.data?.dialCode ?? ''
                                      : '   ',
                                  style: AppTextStyle.subTitleSemiBold(
                                      context, AppColorStyle.primary(context)),
                                );
                              },
                            ),
                            const SizedBox(width: 5.0),
                            StreamBuilder(
                              stream: _authBloc.getMobileNumber,
                              builder: (_, snapshot) {
                                return Text(
                                  snapshot.hasData ? snapshot.data ?? '' : "",
                                  style: AppTextStyle.subTitleSemiBold(
                                      context, AppColorStyle.primary(context)),
                                );
                              },
                            ),
                          ],
                        ),
                  const SizedBox(height: 60.0),
                  OTPInputTextFieldWidget(
                      _focusHideOtp, () => verifyOTPButtonClick()),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: _authBloc.getResendOTP,
                        builder: (_, snapshot) {
                          return Row(
                            children: [
                              Text(
                                "Didn't get OTP? ",
                                style: AppTextStyle.subTitleMedium(
                                  context,
                                  AppColorStyle.textDetail(context),
                                ),
                              ),
                              InkWellWidget(
                                onTap: () async {
                                  if (snapshot.hasData &&
                                      snapshot.data == true) {
                                    _authBloc.onResendClick(false);
                                    if (type == "${OTPtype.EMAIL}" &&
                                        isDeleteAccount) {
                                      // DELETE ACCOUNT: RESEND OTP ON EMAIL
                                      String? otp =
                                          await _authBloc.deleteAccount(context,
                                              emailAddress: emailAddress,
                                              phoneNumber: '',
                                              countryCode: '',
                                              routeName: routeName,
                                              isResend: true);
                                      if (otp != null) {
                                        emailOTP = otp;
                                      }
                                    } else if (type == "${OTPtype.MOBILE}" &&
                                        isDeleteAccount) {
                                      // DELETE ACCOUNT: RESEND OTP ON PHONE
                                      _authBloc.sendOTP(routeName, context);
                                    } else {
                                      var result =
                                          _authBloc.sendOTP(routeName, context);
                                      printLog(
                                          "#OTPScreen# Result of OTP screen :: $result");
                                    }
                                  }
                                },
                                child: Text(
                                  "Resend",
                                  style: AppTextStyle.subTitleMedium(
                                    context,
                                    snapshot.hasData
                                        ? snapshot.data == true
                                            ? AppColorStyle.primary(context)
                                            : AppColorStyle.primaryText(context)
                                        : AppColorStyle.primaryText(context),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      StreamBuilder(
                        stream: _authBloc.getResendOTP,
                        builder: (_, snapshot) {
                          if (snapshot.hasData && snapshot.data == false) {
                            return TweenAnimationBuilder(
                              tween: Tween(begin: 120.0, end: 0.0),
                              duration: const Duration(seconds: 120),
                              onEnd: () {
                                _authBloc.onResendClick(true);
                              },
                              builder: (_, value, child) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 00),
                                    child: Text(
                                      setTime((value).toInt()),
                                      //value.toString(),
                                      style: AppTextStyle.detailsMedium(context,
                                          AppColorStyle.primary(context)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 75.0),
                  // --------------------------------------
                  StreamBuilder<bool>(
                    stream: _authBloc.getLoadingSubject,
                    builder: (context, snapshot) {
                      if (snapshot.data == false) {
                        return ButtonWidget(
                          onTap: () {
                            if (isRedundantClick(DateTime.now())) {
                              return;
                            }
                            _focusHideOtp.unfocus();
                            verifyOTPButtonClick();
                          },
                          title: 'Verify OTP',
                          logActionEvent: FBActionEvent.fbActionLoginWithNumber,
                        );
                      } else {
                        return Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColorStyle.backgroundVariant(context),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: SizedBox(
                              height: 50.0,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: StreamBuilder<List<String>?>(
                                  stream: _authBloc.getLoadingMessage,
                                  builder: (context, snapshot) {
                                    List<RotateAnimatedText> messages = [
                                      RotateAnimatedText(
                                        "Please wait...",
                                        textStyle: AppTextStyle.subTitleMedium(
                                          context,
                                          AppColorStyle.primary(context),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ];
                                    if (snapshot.hasData &&
                                        snapshot.data != null &&
                                        snapshot.data!.isNotEmpty) {
                                      messages = List.generate(
                                        snapshot.data!.length,
                                        (index) => RotateAnimatedText(
                                          snapshot.data![index],
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
                                          pause:
                                              const Duration(milliseconds: 0),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.5,
                                            color:
                                                AppColorStyle.primary(context),
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
                  ),
                  // --------------------------------------
                  /*const SizedBox(
                    height: 20.0,
                  ),
                  ButtonWidget(
                    onTap: () {
                      if (isRedundantClick(DateTime.now())) {
                        return;
                      }
                      verifyOTPButtonClick();
                    },
                    title: 'Verify OTP',
                    logActionEvent: FBActionEvent.fbActionLoginWithNumber,
                  ),*/
                  const SizedBox(height: 75.0),
                  Center(
                    child: InkWellWidget(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Press to back",
                        style: AppTextStyle.titleMedium(
                          context,
                          AppColorStyle.textHint(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                ],
              ),
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

  String setTime(int sec) {
    //removed minutes and show only seconds for now
    //int minutes = sec ~/ 60;
    int seconds = (sec % 120);
    String minutesStr =
        //(minutes > 0 ? "${minutes.toString().padLeft(2, "0")}:" : "") +
        seconds.toString().padLeft(2, "0") + (" s");
    return minutesStr;
  }

  @override
  onResume() {}

  @override
  void dispose() {
    _focusHideOtp.dispose();
    super.dispose();
  }

  void verifyOTPButtonClick() {
    try {
      if (type == "${OTPtype.EMAIL}" && isDeleteAccount) {
        // DELETE ACCOUNT: EMAIL ADDRESS OTP
        _authBloc.emailOtpMatchForDeleteAccount(context, emailOTP);
      } else if (type == "${OTPtype.MOBILE}" && isDeleteAccount) {
        // DELETE ACCOUNT: MOBILE OTP
        String dialCode = _authBloc.getSelectedCountryModelValue != null
            ? _authBloc.getSelectedCountryModelValue?.dialCode ?? ''
            : '';
        String shortName = _authBloc.getSelectedCountryModelValue != null
            ? _authBloc.getSelectedCountryModelValue?.code ?? ''
            : '';
        _authBloc.verifyOTP(context, _authBloc.getMobileNumberValue, dialCode,
            shortName, routeName, true, globalBloc, userName: fullName);
      } else {
        // PHONE OTP FOR LOGIN AND ADD PHONE IN MY PROFILE
        String dialCode = _authBloc.getSelectedCountryModelValue != null
            ? _authBloc.getSelectedCountryModelValue?.dialCode ?? ''
            : '';

        String shortName = _authBloc.getSelectedCountryModelValue != null
            ? _authBloc.getSelectedCountryModelValue?.code ?? ''
            : '';

        _authBloc.verifyOTP(context, _authBloc.getMobileNumberValue, dialCode,
            shortName, routeName, false, globalBloc, userName: fullName);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
