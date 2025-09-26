import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/authentication/login/login_mobile_widget.dart';
import 'package:occusearch/features/country/country_dialog.dart';
import 'package:occusearch/features/country/model/country_model.dart';

class LoginScreen extends BaseApp {
  const LoginScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _LoginState();
}

class _LoginState extends BaseState {
  final AuthenticationBloc _authBloc = AuthenticationBloc();
  GlobalBloc? _globalBloc;
  late FocusNode _phoneFieldFocusNode;

  @override
  init() {
    _phoneFieldFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await globalBloc?.getDeviceCountryInfo();
        await Future.delayed(const Duration(milliseconds: 500));
        // Fetch list of country if not available
        if (_globalBloc != null &&
            (_globalBloc?.getCountryListValue == null ||
                _globalBloc?.getCountryListValue == [])) {
          // printLog("Country data fetching...");
          await _globalBloc?.getCountryListFromRemoteConfig();
        }
        // To set current country model based on device info
        if (_globalBloc?.getCountryListValue != null &&
            _globalBloc!.getCountryListValue.isNotEmpty) {
          CountryModel? model = _globalBloc?.getCountryListValue.firstWhere(
              (element) =>
                  element.code == _globalBloc?.getDeviceCountryShortcodeValue);
          if (model == null) {
            _authBloc.setSelectedCountryModel =
                _globalBloc?.getCountryListValue[0];
          } else {
            _authBloc.setSelectedCountryModel = model;
          }
        }
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxBlocProvider(
      create: (_) => _authBloc,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        color: AppColorStyle.background(context),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50.0,
                ),
                Image.asset(
                  IconsWEBP.occu3Dlogo,
                  fit: BoxFit.contain,
                  scale: 1,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  StringHelper.loginTitle,
                  style: AppTextStyle.subHeadlineSemiBold(
                      context, AppColorStyle.text(context)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  StringHelper.loginSubtitle,
                  style: AppTextStyle.subTitleRegular(
                      context, AppColorStyle.textDetail(context)),
                ),
                const SizedBox(
                  height: 60.0,
                ),
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
                const SizedBox(
                  height: 120.0,
                ),
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
                          } else if (_authBloc.getMobileNumberValue != "" &&
                              _authBloc.getMobileNumberValue.length < 8) {
                            _phoneFieldFocusNode.requestFocus();
                            Toast.show(context,
                                message: StringHelper.otpMobileInvalid,
                                type: Toast.toastError,
                                gravity: Toast.toastTop,
                                duration: 2);
                          } else {
                            _phoneFieldFocusNode.unfocus();
                            // SEND OTP USING FIREBASE TO USER MOBILE NUMBER
                            _authBloc.sendOTP(RouteName.login, context);
                          }
                        },
                        title: 'Send OTP',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
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
                                        textStyle: AppTextStyle.subTitleMedium(
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
                                        pause: const Duration(milliseconds: 0),
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          color: AppColorStyle.primary(context),
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
                const SizedBox(
                  height: 16.0,
                ),
                Center(
                  child: InkWellWidget(
                    onTap: () {
                      final selected = _authBloc.getSelectedCountryModelValue;
                      GoRoutesPage.go(
                        mode: NavigatorMode.push,
                        moveTo: RouteName.createAccount,
                        param: {
                          'mobile_number': _authBloc.getMobileNumberValue,
                          'email_address': '',
                          'dial_code': selected?.dialCode ?? '',
                          'country_shortcode': selected?.code ?? '',
                          'full_name': _authBloc.fullNameTextEditingController.text,
                        },
                      );
                    },
                    child: Text(
                      "Don't have an account? Sign up",
                      style: AppTextStyle.subTitleMedium(
                        context,
                        AppColorStyle.primary(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: InkWellWidget(
                    onTap: () => GoRoutesPage.go(
                        mode: NavigatorMode.remove,
                        moveTo: RouteName.onboarding),
                    child: Text(
                      "Press to back",
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

  @override
  onResume() {}

  @override
  void dispose() {
    _phoneFieldFocusNode.dispose();
    super.dispose();
  }
}
