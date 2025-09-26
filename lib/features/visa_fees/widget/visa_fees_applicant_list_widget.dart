import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/visa_fees/model/question_model.dart';
import 'package:occusearch/features/visa_fees/model/visa_subclass_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_add_applicant.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_shimmer.dart';

class VisaFeesApplicantWidget extends StatelessWidget {
  const VisaFeesApplicantWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VisaFeesBloc visaFeesBloc = RxBlocProvider.of<VisaFeesBloc>(context);
    final PageController applicantController = PageController(
      initialPage: 0,
      keepPage: false,
      viewportFraction: 0.80,
    );
    return Container(
      color: AppColorStyle.purple(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      StringHelper.visaFeesTitle,
                      style: AppTextStyle.subHeadlineSemiBold(
                        context,
                        AppColorStyle.textWhite(context),
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    InkWellWidget(
                      child: SvgPicture.asset(
                        IconsSVG.linkIcon,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.textWhite(context),
                          BlendMode.srcIn,
                        ),
                      ),
                      onTap: () {
                        Utility.launchURL(Constants.visaFeesOfficialLink);
                      },
                    ),
                  ],
                ),
                InkWellWidget(
                  child: SvgPicture.asset(
                    IconsSVG.closeIcon,
                    colorFilter: ColorFilter.mode(
                      AppColorStyle.textWhite(context),
                      BlendMode.srcIn,
                    ),
                  ),
                  onTap: () {
                    WidgetHelper.alertDialogWidget(
                      context: context,
                      title: StringHelper.visaFees,
                      buttonColor: AppColorStyle.purple(context),
                      message: StringHelper.fundConfirmDialogMessage,
                      positiveButtonTitle: StringHelper.yesQuit,
                      negativeButtonTitle: StringHelper.cancel,
                      onPositiveButtonClick: () {
                        GoRoutesPage.go(
                            mode: NavigatorMode.remove, moveTo: RouteName.home);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          StreamBuilder<SubclassData?>(
            stream: visaFeesBloc.getSelectedSubClass,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                SubclassData? data = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    data?.name ?? '',
                    style: AppTextStyle.detailsRegular(
                      context,
                      AppColorStyle.textWhite(context).withOpacity(0.65),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          // [APPLICANT LIST]
          StreamBuilder<List<VisaQuestionApplicantModel>>(
            stream: visaFeesBloc.getApplicantListStream,
            builder: (_, snapshot) {
              if ((visaFeesBloc.getPrimaryApplicantQuesValue == null ||
                      (visaFeesBloc.getPrimaryApplicantQuesValue != null &&
                          visaFeesBloc
                              .getPrimaryApplicantQuesValue!.isEmpty)) &&
                  (visaFeesBloc.getSecondaryApplicantQuesValue == null ||
                      (visaFeesBloc.getSecondaryApplicantQuesValue != null &&
                          visaFeesBloc
                              .getSecondaryApplicantQuesValue!.isEmpty))) {
                return const ApplicantNotRequiredWidget();
              } else {
                if (snapshot.hasData && snapshot.data != null) {
                  final List<VisaQuestionApplicantModel> applicantModelList =
                      snapshot.data as List<VisaQuestionApplicantModel>;
                  int secondaryApplicantRequired = 1;
                  if (visaFeesBloc.getSecondaryApplicantQuesValue == null ||
                      (visaFeesBloc.getSecondaryApplicantQuesValue != null &&
                          visaFeesBloc
                              .getSecondaryApplicantQuesValue!.isEmpty)) {
                    secondaryApplicantRequired = 0;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      height: 120,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: applicantController,
                        physics: const ClampingScrollPhysics(),
                        pageSnapping: true,
                        padEnds: false,
                        itemCount: applicantModelList.length +
                            secondaryApplicantRequired,
                        onPageChanged: (value) {
                          Future.delayed(Duration.zero, () async {
                            visaFeesBloc.applicantControllerCount.sink
                                .add(value);
                          });
                        },
                        itemBuilder: (context, index) {
                          if (index != applicantModelList.length ||
                              secondaryApplicantRequired == 0) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 10.0 : 0.0),
                              child: ApplicantRowWidget(
                                visaModel: applicantModelList[index],
                                controller: applicantController,
                                subClassList:
                                    visaFeesBloc.getVisaQuestionSubclassList,
                                onSubmit: (VisaQuestionApplicantModel model) {
                                  visaFeesBloc.addUpdateApplicant(model, index);
                                  visaFeesBloc.applicantControllerCount.sink
                                      .add(applicantModelList.length);
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) {
                                      if (applicantController.hasClients) {
                                        applicantController.animateToPage(
                                            visaFeesBloc
                                                    .applicantControllerCount
                                                    .valueOrNull ??
                                                0,
                                            curve: Curves.linearToEaseOut,
                                            duration: const Duration(
                                                milliseconds: 1000));
                                      }
                                    },
                                  );
                                },
                                onDelete: () {
                                  visaFeesBloc.deleteApplicant(index);
                                },
                              ),
                            );
                          } else {
                            // [TO ADD NEW APPLICANT]
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 10.0 : 0.0),
                              child: EmptyApplicantWidget(
                                onAdd: () {
                                  VisaFeesAddApplicant.showApplicantFormInSheet(
                                    context,
                                    questionModel: visaFeesBloc
                                        .secondaryApplicantQuestionModel(),
                                    subClassList: visaFeesBloc
                                        .getVisaQuestionSubclassList,
                                    onSubmit:
                                        (VisaQuestionApplicantModel model) {
                                      visaFeesBloc.addUpdateApplicant(
                                          model, -1);
                                      visaFeesBloc.applicantControllerCount.sink
                                          .add(applicantModelList.length);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                        (_) {
                                          if (applicantController.hasClients) {
                                            applicantController.animateToPage(
                                              visaFeesBloc
                                                      .applicantControllerCount
                                                      .valueOrNull ??
                                                  0,
                                              curve: Curves.linearToEaseOut,
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  return const VisaFeesApplicantShimmer();
                }
              }
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}

class ApplicantRowWidget extends StatelessWidget {
  const ApplicantRowWidget(
      {Key? key,
      required this.visaModel,
      required this.controller,
      required this.subClassList,
      required this.onSubmit,
      required this.onDelete})
      : super(key: key);

  final Function onSubmit;
  final Function onDelete;
  final List<SubclassData> subClassList;
  final PageController controller;
  final VisaQuestionApplicantModel visaModel;

  @override
  Widget build(BuildContext context) {
    QuestionModel? isWithinAustralia;
    if (visaModel.questionList != null) {
      for (var element in visaModel.questionList!) {
        if (element.questionId == "3") {
          isWithinAustralia = element;
          break;
        }
      }
    }
    return Container(
      key: UniqueKey(),
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWellWidget(
        onTap: () {
          // Edit Applicant
          VisaQuestionApplicantModel model = VisaQuestionApplicantModel()
              .copyWith(visaModel.getTitle, visaModel.count,
                  visaModel.isPrimaryApplicant, visaModel.getQuestionList);

          VisaFeesAddApplicant.showApplicantFormInSheet(
            context,
            questionModel: model,
            subClassList: subClassList,
            onSubmit: (VisaQuestionApplicantModel model) {
              /*for (var element in model.getQuestionList) {
                  element.setOptionStream = element.selectedOption;
                  if (element.selectedSubclass != null) {
                    element.setSubclassStream = element.selectedSubclass!;
                  }
                  printLog("Type ${element.type}");
                  printLog("Ans1 ${element.selectedOption}");
                  printLog("Ans2 ${element.selectedSubclass}");
                }*/
              onSubmit(model);
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 20.0, horizontal: 15.0),
              margin: const EdgeInsets.only(top: 10.0, right: 10.0),
              decoration: BoxDecoration(
                color: AppColorStyle.purpleVariant1(context),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: AppColorStyle.purple(context),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                    child: SvgPicture.asset(IconsSVG.visaApplicantUser),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          visaModel.getTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.subTitleSemiBold(
                            context,
                            AppColorStyle.textWhite(context)
                                .withOpacity(0.80),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          isWithinAustralia != null
                              ? isWithinAustralia.selectedOption == true
                                  ? StringHelper.visaWithinAustralia
                                  : " - "
                              : " - ",
                          maxLines: 1,
                          style: AppTextStyle.detailsRegular(
                            context,
                            AppColorStyle.textWhite(context)
                                .withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyApplicantWidget extends StatelessWidget {
  const EmptyApplicantWidget({Key? key, required this.onAdd}) : super(key: key);

  final Function onAdd;

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onTap: () => onAdd(),
      child: Container(
        key: UniqueKey(),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              margin: const EdgeInsets.only(top: 10.0, right: 10.0),
              decoration: BoxDecoration(
                color: AppColorStyle.purpleVariant1(context),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: AppColorStyle.purple(context),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                    child: SvgPicture.asset(IconsSVG.visaApplicantAdd),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Include",
                          style: AppTextStyle.detailsRegular(
                            context,
                            AppColorStyle.textWhite(context).withOpacity(0.75),
                          ),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          'Secondary Applicant',
                          style: AppTextStyle.subTitleSemiBold(
                            context,
                            AppColorStyle.textWhite(context).withOpacity(0.80),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApplicantNotRequiredWidget extends StatelessWidget {
  const ApplicantNotRequiredWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        margin: const EdgeInsets.only(top: 10.0, right: 10.0),
        decoration: BoxDecoration(
          color: AppColorStyle.redVariant1(context).withOpacity(0.50),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: AppColorStyle.redVariant1(context),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              width: 50.0,
              height: 50.0,
              child: SvgPicture.asset(IconsSVG.visaApplicantUser),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    StringHelper.visaApplicantNotReq,
                    style: AppTextStyle.subTitleSemiBold(
                      context,
                      AppColorStyle.textWhite(context).withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    StringHelper.visaApplicantNotReq1,
                    style: AppTextStyle.detailsRegular(
                      context,
                      AppColorStyle.textWhite(context).withOpacity(0.80),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
