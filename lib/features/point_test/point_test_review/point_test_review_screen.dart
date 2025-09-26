// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/widget_regex.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/point_test/point_test_review/point_test_review_bloc.dart';
import 'package:occusearch/features/point_test/point_test_review/widget/point_test_review_widget.dart';
import 'package:occusearch/features/point_test/widget/pdf_for_point_score.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PointTestReviewScreen extends BaseApp {
  const PointTestReviewScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _PointTestReviewScreenState();
}

class _PointTestReviewScreenState extends BaseState {
  static TextEditingController emailAddress = TextEditingController();
  static final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final PointTestReviewBloc _pointTestReviewBloc = PointTestReviewBloc();
  GlobalBloc? _globalBloc;

  var args;
  FirebaseFirestore? fireStoreDB;
  UserInfoData? info;

  //var isEnableOtherClicks = true;

  @override
  init() async {
    args = widget.arguments;
    fireStoreDB = FirebaseFirestore.instance;
    await _globalBloc?.setUserInfoData(context);
    info = await _globalBloc?.getUserInfo(context);

    Future.delayed(Duration.zero, () async {
      //question list api call when user come for first time, db does not have question data
      await _pointTestReviewBloc.getPointTestQuestionList(
          context, info!.userId);
    });
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxBlocProvider(
      create: (_) => _pointTestReviewBloc,
      child: WillPopScopeWidget(
        onWillPop: () async {
          GoRoutesPage.go(mode: NavigatorMode.remove, moveTo: RouteName.home);
          return false;
        },
        child: Container(
          color: AppColorStyle.cyan(context),
          height: double.infinity,
          width: double.infinity,
          child: SafeArea(
            bottom: false,
            child: Container(
              color: AppColorStyle.background(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //title section
                  Container(
                    color: AppColorStyle.cyan(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.commonPadding, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            StringHelper.pointsScore,
                            style: AppTextStyle.subHeadlineBold(
                              context,
                              AppColorStyle.textWhite(context),
                            ),
                          ),
                          InkWellWidget(
                            onTap: () {
                              GoRoutesPage.go(
                                mode: NavigatorMode.push,
                                moveTo: RouteName.home,
                              );
                              // Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              IconsSVG.closeIcon,
                              width: 14,
                              colorFilter: ColorFilter.mode(
                                AppColorStyle.textWhite(context),
                                BlendMode.srcIn,
                              ),
                              height: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Question List Data
                  PointTestReviewWidget(
                      args: args, pointTestReviewBloc: _pointTestReviewBloc),
                  //FOOTER Widget
                  Container(
                    decoration: BoxDecoration(
                        color: AppColorStyle.background(context),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 15,
                        left: 15,
                        right: Constants.commonPadding),
                    child: footerWidget(context: context),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget footerWidget({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //share button
        StreamBuilder<bool>(
          stream: _pointTestReviewBloc.loadingShare.stream,
          builder: (_, snapshot) {
            return snapshot.hasData && snapshot.data == true
                ? Container(
                    padding: const EdgeInsets.all(5.0),
                    height: 40,
                    width: 40,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColorStyle.cyan(context),
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                : InkWellWidget(
                    onTap: () async {
                      _pointTestReviewBloc.loadingShare.sink.add(true);
                      //firebase tracking
                      FirebaseAnalyticLog.shared.eventTracking(
                          screenName: RouteName.pointTestReviewScreen,
                          actionEvent: FBActionEvent.fbActionShare,
                          sectionName: FBSectionEvent.fbSectionPointScore);

                      try {
                        if (_pointTestReviewBloc
                            .pointTestResultJSONStringData.isNotEmpty) {
                          FirebaseAnalyticLog.shared.eventTracking(
                              screenName: RouteName.pointTestReviewScreen,
                              actionEvent: FBActionEvent.fbActionShare,
                              message: StringHelper.share);
                          await Printing.sharePdf(
                            bytes: await generatePdf(_pointTestReviewBloc
                                .pointTestResultJSONStringData),
                            filename: StringHelper.pointTestScoreFilePDFName,
                          );
                          _pointTestReviewBloc.loadingShare.sink.add(false);
                        } else {
                          Toast.show(context,
                              message: StringHelper.pointTestPdfDataNotFound);
                          _pointTestReviewBloc.loadingShare.sink.add(false);
                        }
                      } catch (e) {
                        _pointTestReviewBloc.loadingShare.sink.add(false);
                        printLog(e);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      height: 40,
                      width: 40,
                      child: SvgPicture.asset(
                        IconsSVG.shareIcon,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  );
          },
        ),
        const SizedBox(width: 10),
        //email button
        StreamBuilder<bool>(
          stream: _pointTestReviewBloc.loadingEmail.stream,
          builder: (_, snapshot) {
            return snapshot.hasData && snapshot.data == true
                ? Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 50,
                    width: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColorStyle.cyan(context),
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                : InkWellWidget(
                    onTap: () async {
                      if (NetworkController.isInternetConnected == false) {
                        Toast.show(context,
                            message: StringHelper.internetConnection,
                            type: Toast.toastError);
                        return;
                      }
                      //firebase tracking
                      _pointTestReviewBloc.loadingEmail.sink.add(true);
                      FirebaseAnalyticLog.shared.eventTracking(
                          screenName: RouteName.pointTestReviewScreen,
                          actionEvent: FBActionEvent.fbActionSendMail,
                          sectionName: FBSectionEvent.fbSectionPointScore);

                      bool flag = await _pointTestReviewBloc.getPointTestResult(
                          isFromShare: true, userId: info!.userId!);
                      if (flag) {
                        // Generate the file
                        final output = await getTemporaryDirectory();
                        final file = File(
                            '${output.path}/${StringHelper.pointTestScoreFilePDFName}');
                        await file.writeAsBytes(await generatePdf(
                            _pointTestReviewBloc
                                .pointTestResultJSONStringData));
                        // Convert it to base 64
                        List<int> binaries = await file.readAsBytes();
                        var base64File = const Base64Codec().encode(binaries);
                        // Check if email is available or not and open dialog if not
                        if (info!.email!.isNotEmpty) {
                          _pointTestReviewBloc.sendEmailWithTemplate(
                              context,
                              StringHelper.pointTestScoreFilePDFName,
                              base64File,
                              fireStoreDB!,
                              info!.email!,
                              info!.name!); //take from userinfostream
                        } else {
                          emailAddress.text = "";
                          _pointTestReviewBloc.loadingEmail.sink.add(false);
                          showEmailPickerSheet(
                              context,
                              StringHelper.pointTestScoreFilePDFName,
                              base64File);
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      height: 50,
                      width: 50,
                      child: SvgPicture.asset(
                        IconsSVG.emailIcon,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  );
          },
        ),

        const SizedBox(width: 15),
        //retake button
        Expanded(
          child: ButtonWidget(
              title: StringHelper.retake,
              onTap: () {
                if (_pointTestReviewBloc.loadingEmail.value == true ||
                    _pointTestReviewBloc.loadingShare.value == true) {
                  Toast.show(context,
                      message: StringHelper.processRunningMessage,
                      type: Toast.toastError);
                } else {
                  FirebaseAnalyticLog.shared.eventTracking(
                      screenName: RouteName.pointTestReviewScreen,
                      actionEvent: FBActionEvent.fbActionRetakePointTest,
                      sectionName: FBSectionEvent.fbSectionPointTestReview);
                  var param = {
                    "mode": PointTestMode.NEW_TEST,
                    "question_ID": 0,
                    "from_where": args
                  };
                  GoRoutesPage.go(
                      mode: NavigatorMode.replace,
                      moveTo: RouteName.pointTestQuestionScreen,
                      param: param);
                }
              },
              buttonColor: AppColorStyle.cyan(context),
              logActionEvent: FBActionEvent.fbActionSendMail),
        )
      ],
    );
  }

  // ***************** Email Picker Widget ******************
  showEmailPickerSheet(BuildContext context, String pointTestScoreFilePDFName,
      String base64file) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            color: AppColorStyle.background(context),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _emailFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      StringHelper.emailRequired,
                      style: AppTextStyle.subHeadlineSemiBold(
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
                      StringHelper.enterEmailForPdfTitleForPointScore,
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
                      cursorColor: AppColorStyle.cyan(context),
                      autofocus: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColorStyle.cyan(context))),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColorStyle.cyan(context)),
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
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: ButtonWidget(
                        title: StringHelper.sendEmail,
                        buttonColor: AppColorStyle.cyan(context),
                        textColor: AppColorStyle.textWhite(context),
                        arrowIconVisibility: true,
                        onTap: () {
                          if (NetworkController.isInternetConnected) {
                            if (!_emailFormKey.currentState!.validate()) {
                              return;
                            } else {
                              Navigator.pop(context);
                              _pointTestReviewBloc.loadingEmail.sink.add(true);
                              _pointTestReviewBloc.sendEmailWithTemplate(
                                  context,
                                  StringHelper.pointTestScoreFilePDFName,
                                  base64file,
                                  fireStoreDB!,
                                  emailAddress.text,
                                  info!.name!);
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
                  ],
                ),
              ),
            ),
          );
        });
  }
}
