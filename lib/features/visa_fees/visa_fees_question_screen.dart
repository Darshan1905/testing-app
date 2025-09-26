// ignore_for_file: use_build_context_synchronously

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/visa_fees/model/question_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_question_widget.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_shimmer.dart';

class VisaFeesQuestionScreen extends BaseApp {
  const VisaFeesQuestionScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _VisaPrimaryApplicantScreenState();
}

class _VisaPrimaryApplicantScreenState extends BaseState {
  final VisaFeesBloc _visaBloc = VisaFeesBloc();

  static PageController applicantController = PageController(
    initialPage: 0,
  );

  int currentIndex = 0;

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider(
      create: (_) => _visaBloc,
      child: Container(
        color: AppColorStyle.background(context),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(Constants.commonPadding),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<bool>(
                  stream: _visaBloc.isLoadingQuestionAPI,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data == false) {
                      return StreamBuilder<List<VisaQuestionApplicantModel>>(
                        stream: _visaBloc.getApplicantListStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data
                                  is List<VisaQuestionApplicantModel> &&
                              (snapshot.data
                                      as List<VisaQuestionApplicantModel>)
                                  .isNotEmpty) {
                            final List<VisaQuestionApplicantModel>
                                applicantModelList = snapshot.data
                                    as List<VisaQuestionApplicantModel>;
                            final int applicantLength =
                                applicantModelList.length;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                          applicantModelList.length >
                                                  currentIndex
                                              ? applicantModelList[currentIndex]
                                                  .title
                                              : '',
                                          style: AppTextStyle.subHeadlineBold(
                                              context,
                                              AppColorStyle.text(context))),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
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
                                        ))
                                  ],
                                ),
                                Expanded(
                                  child: PageView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: applicantLength,
                                    controller: applicantController,
                                    onPageChanged: (index) {
                                      setState(() {
                                        currentIndex = index;
                                      });
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final List<QuestionModel>
                                          questionModelList =
                                          applicantModelList[index]
                                              .getQuestionList;
                                      return SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // VISA FEES QUESTION
                                            if (questionModelList.isNotEmpty)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // *****************  Question No. 1 [RADIO BUTTON] *****************
                                                  questionModelList
                                                              .isNotEmpty &&
                                                          questionModelList[0]
                                                                  .type ==
                                                              "radio"
                                                      ? VisaRadioButtonWidget(
                                                          questionModel:
                                                              questionModelList[
                                                                  0],
                                                        )
                                                      : Container(),
                                                  // *****************  Question No. 2 [RADIO BUTTON] *****************
                                                  questionModelList
                                                              .isNotEmpty &&
                                                          questionModelList
                                                                  .length >
                                                              1 &&
                                                          questionModelList[1]
                                                                  .type ==
                                                              "radio"
                                                      ? StreamBuilder<bool>(
                                                          stream: questionModelList[
                                                                  0]
                                                              .selectedOptionStream,
                                                          builder:
                                                              (_, snapshot) {
                                                            return questionModelList
                                                                        .isNotEmpty &&
                                                                    questionModelList
                                                                            .length >
                                                                        1 &&
                                                                    questionModelList[1]
                                                                            .type ==
                                                                        "radio"
                                                                ? VisaRadioButtonWidget(
                                                                    questionModel:
                                                                        questionModelList[
                                                                            1],
                                                                  )
                                                                : Container();
                                                          },
                                                        )
                                                      : const SizedBox(),
                                                  // *****************  Question No. 3 [DROPDOWN] *****************
                                                  questionModelList.isNotEmpty
                                                      ? StreamBuilder<bool>(
                                                          stream: questionModelList[
                                                                  questionModelList
                                                                              .length ==
                                                                          3
                                                                      ? 1
                                                                      : 0]
                                                              .selectedOptionStream,
                                                          builder:
                                                              (_, snapshot) {
                                                            if ((questionModelList
                                                                        .isNotEmpty &&
                                                                    (questionModelList.length == 2 &&
                                                                        questionModelList[1].type!.toLowerCase() ==
                                                                            "dropdown"
                                                                                .toLowerCase() &&
                                                                        questionModelList[0].getSelectedOption ==
                                                                            true)) ||
                                                                (questionModelList
                                                                            .length ==
                                                                        3 &&
                                                                    questionModelList[2]
                                                                            .type!
                                                                            .toLowerCase() ==
                                                                        "dropdown"
                                                                            .toLowerCase() &&
                                                                    questionModelList[1]
                                                                            .getSelectedOption ==
                                                                        true)) {
                                                              return VisaDropdownWidget(
                                                                questionModel: questionModelList.length ==
                                                                            2 &&
                                                                        questionModelList[1].type!.toLowerCase() ==
                                                                            "dropdown"
                                                                    ? questionModelList[
                                                                        1]
                                                                    : questionModelList.length ==
                                                                                3 &&
                                                                            questionModelList[2].type!.toLowerCase() ==
                                                                                "dropdown"
                                                                        ? questionModelList[
                                                                            2]
                                                                        : questionModelList[
                                                                            0],
                                                                subclassList:
                                                                    _visaBloc
                                                                        .getVisaQuestionSubclassList,
                                                              );
                                                            } else {
                                                              return const SizedBox();
                                                            }
                                                          },
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // NEXT-PREVIOUS BUTTON
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if ((applicantLength - 1 == currentIndex &&
                                            applicantLength > 1) ||
                                        (applicantLength == 1 &&
                                            !applicantModelList[0]
                                                .isPrimaryApplicant))
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        child: InkWellWidget(
                                          onTap: () {
                                            _visaBloc.count = 1;
                                            _visaBloc.deleteApplicant(
                                                applicantLength - 1);
                                            GoRoutesPage.go(
                                                mode: NavigatorMode.replace,
                                                moveTo:
                                                    RouteName.visaFeesDetail,
                                                param: _visaBloc);
                                          },
                                          child: Text("Skip",
                                              style:
                                                  AppTextStyle.subTitleMedium(
                                                      context,
                                                      AppColorStyle.textDetail(
                                                          context))),
                                        ),
                                      ),
                                    if (currentIndex != 0)
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 750),
                                        curve: Curves.fastOutSlowIn,
                                        child: InkWellWidget(
                                          onTap: () {
                                            applicantController.previousPage(
                                                duration: const Duration(
                                                    microseconds: 500),
                                                curve: Curves.fastOutSlowIn);
                                          },
                                          child: Container(
                                            width: 40.0,
                                            height: 36.0,
                                            decoration: BoxDecoration(
                                                color: AppColorStyle.purpleText(context),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                IconsSVG.leftIcon,
                                                colorFilter: ColorFilter.mode(
                                                  AppColorStyle.purple(
                                                      context),
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    InkWellWidget(
                                      onTap: () {
                                        if (applicantLength - 1 >
                                            currentIndex) {
                                          applicantController.nextPage(
                                              duration: const Duration(
                                                  microseconds: 500),
                                              curve: Curves.fastOutSlowIn);
                                        } else {
                                          _visaBloc.count = 2;
                                          GoRoutesPage.go(
                                              mode: NavigatorMode.replace,
                                              moveTo: RouteName.visaFeesDetail,
                                              param: _visaBloc);
                                        }
                                      },
                                      child: Container(
                                        width: 40.0,
                                        height: 36.0,
                                        decoration: BoxDecoration(
                                            color: AppColorStyle.purpleText(context),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            IconsSVG.rightIcon,
                                            colorFilter: ColorFilter.mode(
                                              AppColorStyle.purple(context),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return const VisaFeesQuestionShimmer();
                          }
                        },
                      );
                    } else {
                      return const VisaFeesQuestionShimmer();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  init() async {
    dynamic param = widget.arguments;
    if (param != null) {
      printLog("#VisaFeesQuestionScreen# navigation param :: $param");
      _visaBloc.setSelectedSubClassData = param;
    }
    await _visaBloc.getVisaSubclassData(context);
    await _visaBloc.getVisaQuestionDetailAPI(context, 1, _visaBloc);
    await _visaBloc.getVisaQuestionDetailAPI(context, 2, _visaBloc);
  }

  @override
  onResume() {}
}
