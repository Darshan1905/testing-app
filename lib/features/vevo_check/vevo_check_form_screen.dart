// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/vevo_check/model/passport_model.dart';
import 'package:occusearch/features/vevo_check/model/visa_grant_model.dart';
import 'package:occusearch/features/vevo_check/vevo_check_bloc.dart';
import 'package:occusearch/features/vevo_check/widgets/vevo_check_form_widget.dart';
import 'package:intl/intl.dart';

class VevoCheckFormScreen extends BaseApp {
  const VevoCheckFormScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _VevoCheckFormScreenState();
}

class _VevoCheckFormScreenState extends BaseState {
  final VevoCheckBloc _vevoCheckBloc = VevoCheckBloc();
  final AuthenticationBloc _authBloc = AuthenticationBloc();
  GlobalBloc? _globalBloc;

  final GlobalKey<FormState> _vevoFormKey = GlobalKey<FormState>();
  late String pattern;
  late RegExp regExp;

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColorStyle.background(context),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: SvgPicture.asset(
            IconsSVG.arrowBack,
            colorFilter: ColorFilter.mode(
              AppColorStyle.text(context),
              BlendMode.srcIn,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              StringHelper.vevoCheck,
              style: AppTextStyle.subHeadlineSemiBold(
                  context, AppColorStyle.text(context)),
            ),
          ],
        ),
      ),
      body: RxMultiBlocProvider(
        providers: [
          RxBlocProvider<VevoCheckBloc>(create: (context) => _vevoCheckBloc),
          RxBlocProvider<AuthenticationBloc>(create: (context) => _authBloc),
        ],
        child: RxBlocProvider(
          create: (_) => _vevoCheckBloc,
          child: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColorStyle.backgroundVariant(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                StringHelper.checkYourVisaStatus,
                                style: AppTextStyle.titleSemiBold(
                                    context, AppColorStyle.text(context)),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                StringHelper.visaDetails,
                                style: AppTextStyle.detailsRegular(
                                    context, AppColorStyle.textDetail(context)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const VevoTabBarWidget(),
                            const SizedBox(height: 20),
                            VevoFormWidget(
                              vevoFormKey: _vevoFormKey,
                            ),
                            const SizedBox(height: 24),
                            ButtonWidget(
                              title: StringHelper.check,
                              logActionEvent: FBActionEvent.fbActionVevoCheck,
                              buttonColor: AppColorStyle.red(context),
                              textColor: AppColorStyle.background(context),
                              onTap: () {
                                if (_vevoCheckBloc.isSelectedRefType.value &&
                                    _vevoCheckBloc
                                        .vgnEditingController.text.isEmpty) {
                                  Toast.show(context,
                                      message: "Enter your number",
                                      type: Toast.toastError,
                                      gravity: Toast.toastTop,
                                      duration: 2);
                                  return false;
                                } else if (_vevoCheckBloc
                                        .isSelectedRefType.value &&
                                    _vevoCheckBloc
                                        .vgnEditingController.text.isNotEmpty &&
                                    _vevoCheckBloc.vgnEditingController.text
                                            .trim()
                                            .length !=
                                        13) {
                                  Toast.show(context,
                                      message: "Enter valid number",
                                      type: Toast.toastError,
                                      gravity: Toast.toastTop,
                                      duration: 2);
                                  return false;
                                } else if (!_vevoCheckBloc
                                        .isSelectedRefType.value &&
                                    _vevoCheckBloc
                                        .trnEditingController.text.isEmpty) {
                                  Toast.show(context,
                                      message: "Enter your number",
                                      type: Toast.toastError,
                                      gravity: Toast.toastTop,
                                      duration: 2);
                                  return false;
                                } else if (_vevoCheckBloc
                                    .dobEditingController.text.isEmpty) {
                                  Toast.show(context,
                                      message: "Select date of birth",
                                      type: Toast.toastError,
                                      gravity: Toast.toastTop,
                                      duration: 2);
                                  return false;
                                } else if (_vevoCheckBloc
                                    .passportEditingController.text.isEmpty) {
                                  Toast.show(context,
                                      message: "Enter Passport Number",
                                      type: Toast.toastError,
                                      gravity: Toast.toastTop,
                                      duration: 2);
                                } else if (!regExp.hasMatch(_vevoCheckBloc
                                    .passportEditingController.text
                                    .trim())) {
                                  Toast.show(context,
                                      message: "Enter valid Passport Number",
                                      type: Toast.toastError,
                                      gravity: Toast.toastTop,
                                      duration: 2);
                                } else if (_vevoCheckBloc
                                    .countryEditingController.text.isEmpty) {
                                  Toast.show(context,
                                      message: "Select country",
                                      type: Toast.toastError,
                                      gravity: Toast.toastTop,
                                      duration: 2);
                                } else {
                                  _vevoCheckBloc.submitVisaDetails(context,
                                      strTransactionType: _vevoCheckBloc
                                          .selectedReference.value,
                                      strPassportNumber: _vevoCheckBloc
                                          .passportEditingController.text,
                                      strDOB: _vevoCheckBloc
                                          .dobEditingController.text,
                                      strVisaGrantNumber: (_vevoCheckBloc
                                              .isSelectedRefType.value)
                                          ? _vevoCheckBloc
                                              .vgnEditingController.text
                                          : _vevoCheckBloc
                                              .trnEditingController.text);
                                }
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
    );
  }

  @override
  init() {
    pattern = r'^(?!^0+$)[a-zA-Z0-9]{3,20}$';
    regExp = RegExp(pattern);
    /*_vevoCheckBloc.dobEditingController.text = "02-03-1994";
    _vevoCheckBloc.passportEditingController.text = "M1661462";
    _vevoCheckBloc.vgnEditingController.text = "0059526698620";*/

    Future.delayed(Duration.zero, () async {
      dynamic args = widget.arguments;
      if (args != null) {
        if (args.runtimeType == VisaGrantModel) {
          _vevoCheckBloc.passportEditingController.text =
              (args as VisaGrantModel).passportNumber ?? "";
          _vevoCheckBloc.vgnEditingController.text = args.visaGrantNumber ?? "";
          _vevoCheckBloc.trnEditingController.text =
              args.transactionReferenceNumber ?? "";
          _vevoCheckBloc.setCountryModelList = _globalBloc?.getCountryListValue;
          _vevoCheckBloc.setSelectedCountry(args.passportCountry ?? "",
              _vevoCheckBloc.countryEditingController);

          try {
            var inputFormat = DateFormat('dd MMMM yyyy');
            var inputDate = inputFormat.parse(args.dateOfBirth ?? "");

            var outputFormat = DateFormat('dd-MM-yyyy');
            var outputDate = outputFormat.format(inputDate);

            _vevoCheckBloc.dobEditingController.text = outputDate;
          } catch (e) {
            printLog("Error: $e");
          }

          if (args.runtimeType == VisaGrantModel &&
              (args.passportNumber == null || args.passportNumber == "") &&
              (args.visaGrantNumber == null || args.visaGrantNumber == "") &&
              (args.transactionReferenceNumber == null ||
                  args.transactionReferenceNumber == "") &&
              (args.passportCountry == null || args.passportCountry == "") &&
              (args.dateOfBirth == null || args.dateOfBirth == "")) {
            showVerificationDialog(context,
                "No details were detected from the document. Please enter all the details manually.");
          } else {
            showVerificationDialog(context,
                "Please ensure that every detail on the form is correct before submitting.");
          }
        } else {
          updateVevoForm(args);
        }
      } else {
        _vevoCheckBloc.setSelectedCountry(
            "", _vevoCheckBloc.countryEditingController);
      }
      _vevoCheckBloc.isSelectedRefType.value = true;
    });
  }

  updateVevoForm(args) {
    if (args != null && args["docType"] == StringHelper.passport) {
      PassportModel passportModel = args["model"];
      _vevoCheckBloc.passportEditingController.text =
          passportModel.documentNumber.toString().trim();

      /*Check Date model and correct the year accordingly of passport eg: 07 -2007, 95 -1995 */

      if (passportModel.birthDate.toString() != "Could not read") {
        var parts = passportModel.birthDate.toString().split('/');
        var prefix = parts[2].trim();

        if (prefix[0] == "0") {
          passportModel.birthDate =
              passportModel.birthDate!.replaceAll(prefix, "20$prefix");
        } else {
          passportModel.birthDate =
              passportModel.birthDate!.replaceAll(prefix, "19$prefix");
        }

        _vevoCheckBloc.dobEditingController.text =
            passportModel.birthDate.toString().trim().replaceAll("/", "-");
      }

      _vevoCheckBloc.setSelectedCountry(passportModel.country.toString(),
          _vevoCheckBloc.countryEditingController);
    } else if (args != null && args["docType"] == StringHelper.vrnDOC) {
      dynamic visaGrantModel = args["model"];

      if (visaGrantModel["passport_number"].isNotEmpty) {
        _vevoCheckBloc.passportEditingController.text =
            visaGrantModel["passport_number"];
      }

      if (visaGrantModel["visa_grant_number"].isNotEmpty) {
        _vevoCheckBloc.vgnEditingController.text =
            visaGrantModel["visa_grant_number"];
      } else if (visaGrantModel["transaction_reference_number"].isNotEmpty) {
        _vevoCheckBloc.setIsSelectedRefType = false;
      }

      if (visaGrantModel["transaction_reference_number"].isNotEmpty) {
        _vevoCheckBloc.trnEditingController.text =
            visaGrantModel["transaction_reference_number"];
      }

      if (visaGrantModel["date_of_birth"].isNotEmpty) {
        // Check if pdf or image as format are changing based on image type
        if (args["type"] == "pdf") {
          var inputFormat = DateFormat('dd MMMM yyyy');
          var inputDate = inputFormat.parse(visaGrantModel["date_of_birth"]);

          var outputFormat = DateFormat('dd-MM-yyyy');
          var outputDate = outputFormat.format(inputDate);

          _vevoCheckBloc.dobEditingController.text = outputDate;
        } else {
          if (visaGrantModel["date_of_birth"].toString() != "Could not read") {
            _vevoCheckBloc.dobEditingController.text =
                visaGrantModel["date_of_birth"]
                    .toString()
                    .trim()
                    .replaceAll("/", "-");
          }
        }
      }

      //set country model list from global bloc
      _vevoCheckBloc.setCountryModelList = _globalBloc?.getCountryListValue;
      _vevoCheckBloc.setSelectedCountry(visaGrantModel["passport_country"],
          _vevoCheckBloc.countryEditingController);
    }
  }

  @override
  onResume() {}

  showVerificationDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5.0,
              ),
              Text(message,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.detailsRegular(
                      context, AppColorStyle.textDetail(context))),
              const SizedBox(
                height: 20.0,
              ),
              Divider(
                height: 0.5,
                color: AppColorStyle.textCaption(context),
              ),
              InkWellWidget(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 30.0, right: 30.0),
                  child: Text(
                    'Close',
                    style: AppTextStyle.detailsMedium(
                      context,
                      AppColorStyle.red(context),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          backgroundColor: AppColorStyle.background(context),
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        );
      },
    );
  }
}
