// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/point_test/point_test_model/point_test_ques_model.dart';
import 'package:occusearch/features/point_test/point_test_review/point_test_review_bloc.dart';
import 'package:occusearch/features/point_test/point_test_review/point_test_review_page_shimmer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeaderSectionWidget extends StatelessWidget {
  const HeaderSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pointTestReviewBloc = RxBlocProvider.of<PointTestReviewBloc>(context);
    return StreamBuilder(
      stream: pointTestReviewBloc.userPointsScore,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Stack(
            children: [
              // OUTER RADIAL GAUGE
              SizedBox(
                width: double.infinity,
                height: 220,
                child: SfRadialGauge(
                  backgroundColor: AppColorStyle.cyan(context),
                  enableLoadingAnimation: true,
                  animationDuration: 1200,
                  axes: <RadialAxis>[
                    RadialAxis(
                      startAngle: 180,
                      endAngle: 360,
                      radiusFactor: 1,
                      interval: 10,
                      canScaleToFit: true,
                      showTicks: false,
                      showLastLabel: false,
                      showAxisLine: true,
                      showLabels: false,
                      axisLineStyle: AxisLineStyle(
                        thicknessUnit: GaugeSizeUnit.factor,
                        thickness: 0.15,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      minimum: 0,
                      maximum: 100,
                      pointers: <GaugePointer>[
                        RangePointer(
                            value: pointTestReviewBloc.progressBarValue,
                            width: 0.15,
                            sizeUnit: GaugeSizeUnit.factor,
                            animationDuration: 1200,
                            animationType: AnimationType.linear,
                            gradient: SweepGradient(
                              colors: Utility.getPointTestDialerGradientColor(
                                      context,
                                      pointTestReviewBloc.userPointsScore.value)
                                  .$1,
                              stops: Utility.getPointTestDialerGradientColor(
                                      context,
                                      pointTestReviewBloc.userPointsScore.value)
                                  .$2,
                            ),
                            enableAnimation: true),
                        MarkerPointer(
                          value: pointTestReviewBloc.progressBarValue,
                          markerType: MarkerType.circle,
                          enableAnimation: true,
                          borderWidth: 3,
                          animationDuration: 1200,
                          animationType: AnimationType.linear,
                          elevation: 6,
                          color: Utility.getPointTestDialerColor(context,
                              pointTestReviewBloc.userPointsScore.value),
                          borderColor: AppColorStyle.textWhite(context),
                          markerHeight: 26,
                          markerWidth: 26,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          angle: 90,
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "${pointTestReviewBloc.userPointsScore.value.toInt()}",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.subHeadlineBold(
                                  context,
                                  AppColorStyle.textWhite(context),
                                ),
                              ),
                              Text(
                                Utility.getPointGrade(context,
                                    pointTestReviewBloc.userPointsScore.value),
                                textAlign: TextAlign.center,
                                style: AppTextStyle.subTitleRegular(
                                  context,
                                  AppColorStyle.textWhite(context),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // INNER RADIAL GAUGE
              Positioned.fill(
                bottom: 12.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 165,
                    child: SfRadialGauge(
                      enableLoadingAnimation: true,
                      animationDuration: 1200,
                      axes: <RadialAxis>[
                        RadialAxis(
                          startAngle: 180,
                          endAngle: 360,
                          radiusFactor: 1,
                          axisLabelStyle: const GaugeTextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          interval: 20,
                          labelOffset: -16.0,
                          canScaleToFit: true,
                          showTicks: false,
                          showLastLabel: false,
                          showAxisLine: true,
                          showLabels: true,
                          axisLineStyle: AxisLineStyle(
                            thicknessUnit: GaugeSizeUnit.factor,
                            thickness: 0.35,
                            color: Colors.black.withOpacity(0.1),
                          ),
                          minimum: 0,
                          maximum: 161,
                          pointers: const <GaugePointer>[],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const PointTestCardShimmer();
        }
      },
    );
  }
}

// ignore: must_be_immutable
class PointTestReviewWidget extends StatelessWidget {
  var args;
  PointTestReviewBloc pointTestReviewBloc;

  PointTestReviewWidget(
      {Key? key, required this.args, required this.pointTestReviewBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pointTestReviewBloc = RxBlocProvider.of<PointTestReviewBloc>(context);
    return StreamBuilder(
      stream: pointTestReviewBloc.ptAllQuesList,
      builder: (_, snapshot) {
        List<Questionlist>? questionList =
            (snapshot.hasData && snapshot.data != null) ? snapshot.data : [];
        if (questionList!.isNotEmpty) {
          return Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderSectionWidget(),
                  Divider(
                    color: AppColorStyle.background(context),
                    thickness: 30,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: Constants.commonPadding),
                    child: Text(StringHelper.pointsDetails,
                        style: AppTextStyle.titleBold(
                          context,
                          AppColorStyle.text(context),
                        )),
                  ),
                  StreamBuilder<int>(
                      stream: pointTestReviewBloc.getMinPointValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final int? minPoint = snapshot.data;
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: Constants.commonPadding),
                            child: Text("Minimum $minPoint points is required",
                                style: AppTextStyle.captionItalic(
                                    context, ThemeConstant.textHint
                                    // AppColorStyle.textHint(context),
                                    )),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                  const SizedBox(height: 20.0),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: questionList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Questionlist questionRow = questionList[index];

                      String answer = ""; // if user give answer of any
                      String question =
                          questionRow.qname ?? ""; // if user skip any question
                      String pointScore = "00";
                      if (questionRow.option != null) {
                        for (var element in questionRow.option!) {
                          if (element.isSelected) {
                            pointScore = element.ovalue ?? "00";
                            answer = element.oname ?? "";
                          }
                        }
                      }
                      return Column(
                        children: [
                          InkWellWidget(
                            onTap: () {
                              if (pointTestReviewBloc.loadingEmail.value ==
                                      true ||
                                  pointTestReviewBloc.loadingShare.value ==
                                      true) {
                                Toast.show(context,
                                    message: StringHelper.processRunningMessage,
                                    type: Toast.toastError);
                              } else {
                                //firebase tracking
                                FirebaseAnalyticLog.shared.eventTracking(
                                    screenName: RouteName.pointTestReviewScreen,
                                    actionEvent: questionRow.qtype.toString(),
                                    sectionName: FBSectionEvent
                                        .fbSectionPointDetailsList);

                                var param = {
                                  "mode": PointTestMode.EDIT_QTEST,
                                  "question_ID": questionRow.id,
                                  "from_where": args
                                };

                                GoRoutesPage.go(
                                    mode: NavigatorMode.replace,
                                    moveTo: RouteName.pointTestQuestionScreen,
                                    param: param);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Constants.commonPadding,
                                  vertical: 12.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Container(
                                          width: 45.0,
                                          height: 45.0,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5.0)),
                                              color: (questionList[index]
                                                          .isAttendQuestion ==
                                                      true)
                                                  ? AppColorStyle.cyanVariant2(
                                                      context)
                                                  : AppColorStyle.redText(
                                                      context)),
                                          child: Text(
                                            (questionList[index]
                                                        .isAttendQuestion ==
                                                    true)
                                                ? pointScore
                                                    .toString()
                                                    .padLeft(2, '0')
                                                : "--",
                                            style: AppTextStyle.subTitleBold(
                                              context,
                                              questionList[index]
                                                      .isAttendQuestion
                                                  ? AppColorStyle.cyan(context)
                                                  : AppColorStyle.red(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              questionList[index].qtype ?? "",
                                              style: AppTextStyle.detailsMedium(
                                                context,
                                                AppColorStyle.text(context),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              (questionList[index]
                                                          .isAttendQuestion ==
                                                      true)
                                                  ? answer
                                                  : question,
                                              style:
                                                  AppTextStyle.captionRegular(
                                                context,
                                                AppColorStyle.textCaption(
                                                    context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            child: Visibility(
                              visible: questionList.length - 1 != index,
                              child: Divider(
                                  color: AppColorStyle.borderColors(context),
                                  thickness: 0.5),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const PointTestReviewListShimmer();
        }
      },
    );
  }
}
