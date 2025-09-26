// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/widget_regex.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';
import 'package:occusearch/features/visa_fees/widget/pdf_for_visa_fees.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class VisaFeesFooterWidget extends StatelessWidget {
  const VisaFeesFooterWidget({Key? key, required this.animationController})
      : super(key: key);
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final globalBloc = RxBlocProvider.of<GlobalBloc>(context);
    final FirebaseFirestore fireStoreDB = FirebaseFirestore.instance;
    final visaBloc = RxBlocProvider.of<VisaFeesBloc>(context);
    final TextEditingController emailAddress = TextEditingController();
    final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
    return Container(
      color: AppColorStyle.background(context),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  StreamBuilder<bool>(
                    stream: visaBloc.loadingShare.stream,
                    builder: (_, snapshot) {
                      return snapshot.hasData && snapshot.data == true
                          ? SizedBox(
                              width: 30.0,
                              height: 30.0,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColorStyle.purple(context),
                                  strokeWidth: 1.5,
                                ),
                              ),
                            )
                          : InkWellWidget(
                              child: SvgPicture.asset(
                                IconsSVG.shareIcon,
                                width: 30.0,
                                height: 30.0,
                                colorFilter: ColorFilter.mode(
                                  AppColorStyle.text(context),
                                  BlendMode.srcIn,
                                ),
                              ),
                              onTap: () async {
                                //Share application
                                if (NetworkController.isInternetConnected ==
                                    true) {
                                  visaBloc.loadingShare.sink.add(true);
                                  await Printing.sharePdf(
                                    bytes: await generatePDFForVisaFees(
                                        visaBloc.getVisaFeesPriceTableList),
                                    filename: Constants
                                        .visaFeesAdviceReportFilePDFName,
                                  );
                                  visaBloc.loadingShare.sink.add(false);
                                } else {
                                  Toast.show(context,
                                      message: StringHelper.internetConnection,
                                      type: Toast.toastError,
                                      duration: 2);
                                }
                              });
                    },
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  StreamBuilder<bool>(
                    stream: visaBloc.loadingEmail.stream,
                    builder: (_, snapshot) {
                      return snapshot.hasData && snapshot.data == true
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                width: 30.0,
                                height: 30.0,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColorStyle.purple(context),
                                    strokeWidth: 1.5,
                                  ),
                                ),
                              ),
                            )
                          : InkWellWidget(
                              child: SvgPicture.asset(
                                IconsSVG.emailIcon,
                                colorFilter: ColorFilter.mode(
                                  AppColorStyle.text(context),
                                  BlendMode.srcIn,
                                ),
                                width: 40.0,
                                height: 40.0,
                              ),
                              onTap: () async {
                                //firebase tracking
                                if (NetworkController.isInternetConnected ==
                                    true) {
                                  visaBloc.loadingEmail.sink.add(true);
                                  FirebaseAnalyticLog.shared.eventTracking(
                                      screenName: RouteName.visaFeesDetail,
                                      actionEvent:
                                          FBActionEvent.fbActionSendMail,
                                      sectionName: FBSectionEvent
                                          .fbSectionVisaFeesCalculator);
                                  // Generate the file
                                  final output = await getTemporaryDirectory();
                                  final file = File(
                                      '${output.path}/${StringHelper.visaFeesAdviceReportFilePDFName}');
                                  await file.writeAsBytes(
                                      await generatePDFForVisaFees(
                                          visaBloc.getVisaFeesPriceTableList));
                                  // Convert it to base 64
                                  List<int> binaries = await file.readAsBytes();
                                  var base64File =
                                      const Base64Codec().encode(binaries);
                                  // Check if email is available or not and open dialog if not
                                  UserInfoData? useInfo;
                                  if (visaBloc.userInfo.valueOrNull == null) {
                                    useInfo =
                                        await globalBloc.getUserInfo(context);
                                  }

                                  if (useInfo != null &&
                                      useInfo.leadCode != null &&
                                      useInfo.email != "") {
                                    visaBloc.sendEmailWithTemplate(
                                        context,
                                        StringHelper
                                            .visaFeesAdviceReportFilePDFName,
                                        base64File,
                                        fireStoreDB,
                                        useInfo.email!,
                                        useInfo
                                            .name!); //take from userInfoStream
                                  } else {
                                    emailAddress.text = "";
                                    visaBloc.loadingEmail.sink.add(false);
                                    showEmailPickerSheet(
                                        context,
                                        StringHelper
                                            .visaFeesAdviceReportFilePDFName,
                                        emailFormKey,
                                        base64File,
                                        emailAddress, () {
                                      Navigator.pop(context);
                                      visaBloc.loadingEmail.sink.add(true);
                                      visaBloc.sendEmailWithTemplate(
                                          context,
                                          StringHelper
                                              .visaFeesAdviceReportFilePDFName,
                                          base64File,
                                          fireStoreDB,
                                          emailAddress.text,
                                          useInfo == null
                                              ? " "
                                              : useInfo.name!);
                                    });
                                  }
                                } else {
                                  Toast.show(context,
                                      message: StringHelper.internetConnection,
                                      type: Toast.toastError,
                                      duration: 2);
                                }
                              });
                    },
                  ),
                ],
              ),
              // VisaFeesDetailPaymentWidget(animationController: animationController),
            ],
          ),
          SizedBox(
            height: Platform.isIOS ? 25.0 : 0.0,
          )
        ],
      ),
    );
  }

  showEmailPickerSheet(
      BuildContext context,
      String pointTestScoreFilePDFName,
      GlobalKey<FormState> emailFormKey,
      String base64file,
      TextEditingController emailAddress,
      Function onSend) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          color: AppColorStyle.background(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: emailFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    StringHelper.emailRequired,
                    style: AppTextStyle.subTitleSemiBold(
                        context, AppColorStyle.text(context)),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                      color: AppColorStyle.disableVariant(context),
                      thickness: 0.5),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    StringHelper.enterEmailForPdfTitleForVisaFees,
                    style: AppTextStyle.detailsRegular(
                        context, AppColorStyle.text(context)),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: emailAddress,
                    validator: Regex.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: AppColorStyle.purple(context),
                    autofocus: true,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColorStyle.purple(context)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColorStyle.purple(context)),
                      ),
                      hintText: StringHelper.enterYourEmailAddress,
                      hintStyle: AppTextStyle.detailsRegular(
                          context, AppColorStyle.textDetail(context)),
                    ),
                    style: AppTextStyle.detailsSemiBold(
                        context, AppColorStyle.text(context)),
                    onChanged: (String str) {},
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: ButtonWidget(
                        title: StringHelper.sendEmail,
                        textColor: AppColorStyle.textWhite(context),
                        buttonColor: AppColorStyle.purple(context),
                        arrowIconVisibility: true,
                        onTap: () {
                          if (NetworkController.isInternetConnected) {
                            if (!emailFormKey.currentState!.validate()) {
                              return;
                            } else {
                              onSend();
                            }
                          } else {
                            Toast.show(context,
                                message: StringHelper.internetConnection,
                                type: Toast.toastError);
                          }
                        },
                        logActionEvent: '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
