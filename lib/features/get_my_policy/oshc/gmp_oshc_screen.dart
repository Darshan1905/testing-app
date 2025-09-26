import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/text_field_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/get_my_policy/gmp_bloc.dart';
import 'package:occusearch/features/get_my_policy/widget/cover_type_widget.dart';

class GmpOSHCScreen extends BaseApp {
  const GmpOSHCScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => GmpOSHCScreenState();
}

class GmpOSHCScreenState extends BaseState {
  GetMyPolicyBloc gmpBloc = GetMyPolicyBloc();

  @override
  init() async {
    gmpBloc.initData();
  }

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider<GetMyPolicyBloc>(
      create: (context) => GetMyPolicyBloc(),
      child: Container(
        color: AppColorStyle.background(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(StringHelper.oshcPolicy,
                            style: AppTextStyle.headlineBold(
                                context, AppColorStyle.text(context))),
                      ],
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
                const SizedBox(height: 15),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 100 / 3),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, _) => LinearProgressIndicator(
                    minHeight: 2.0,
                    value: 3,
                    backgroundColor: AppColorStyle.backgroundVariant(context),
                    color: AppColorStyle.green(context).withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(StringHelper.ovhcCoverType,
                              style: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                        const SizedBox(height: 15),
                        CoverTypeWidget(gmpBloc: gmpBloc, type: "OSHC"),
                        const SizedBox(height: 10),
                        //Start date
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(StringHelper.oshcStartDate,
                              style: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                        const SizedBox(height: 15),
                        Stack(
                          children: [
                            TextFieldWithoutStreamWidget(
                              onTextChanged: gmpBloc.onChangeOshcStartingDate,
                              controller: gmpBloc.startDateEditingController,
                              hintStyle: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.textHint(context)),
                              hintText: StringHelper.hintDateFormat,
                              keyboardKey: TextInputType.datetime,
                              readOnly: true,
                              onTap: () {
                                gmpBloc.selectDate(context,
                                    ohscStartDate: true,
                                    initDate: gmpBloc
                                        .startDateEditingController.text);
                              },
                            ),
                            InkWellWidget(
                              onTap: () {
                                gmpBloc.selectDate(context,
                                    ohscStartDate: true,
                                    initDate: gmpBloc
                                        .startDateEditingController.text);
                              },
                              child: Container(
                                height: 50.0,
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SvgPicture.asset(
                                    IconsSVG.icCalendar,
                                    colorFilter: ColorFilter.mode(
                                      AppColorStyle.text(context),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        InkWellWidget(
                          onTap: () {
                            WidgetHelper.showAlertDialog(context,
                                contentText:
                                    "Select the date you will arrive in Australia, if you are unsure choose a date upto 28 days before your course start date\n\n"
                                    "If you are switching from another OSHC provider the day after your OSHC expires. In order to keep your visa valid, you must be covered for OSHC continuously",
                                isHTml: false,
                                title: "Start Date:");
                          },
                          child: Text.rich(
                            TextSpan(
                                text: "Help to choose start Date",
                                style: AppTextStyle.captionRegular(
                                    context, AppColorStyle.text(context)),
                                children: [
                                  WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: SvgPicture.asset(
                                          IconsSVG.icQuestionInfo,
                                        ),
                                      ))
                                ]),
                          ),
                        ),
                        const SizedBox(height: 15),
                        //End Date
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(StringHelper.oshcEndDate,
                              style: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                        const SizedBox(height: 15),
                        Stack(
                          children: [
                            TextFieldWithoutStreamWidget(
                              onTextChanged: gmpBloc.onChangeOshcEndDate,
                              controller: gmpBloc.endDateEditingController,
                              hintStyle: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.textHint(context)),
                              hintText: StringHelper.hintDateFormat,
                              keyboardKey: TextInputType.datetime,
                              readOnly: true,
                              onTap: () {
                                gmpBloc.selectDate(context,
                                    ohscEndDate: true,
                                    initDate:
                                        gmpBloc.endDateEditingController.text);
                              },
                            ),
                            InkWellWidget(
                              onTap: () {
                                gmpBloc.selectDate(context,
                                    ohscEndDate: true,
                                    initDate:
                                        gmpBloc.endDateEditingController.text);
                              },
                              child: Container(
                                height: 50.0,
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SvgPicture.asset(
                                    IconsSVG.icCalendar,
                                    colorFilter: ColorFilter.mode(
                                      AppColorStyle.text(context),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        InkWellWidget(
                          onTap: () {
                            WidgetHelper.showAlertDialog(context,
                                contentText: "<html lang='en'>"
                                    "<head>"
                                    "<meta charset='UTF-8'>"
                                    "<meta name='viewport' content='width=device-width, initial-scale=1.0'>"
                                    "<title>End Date Information</title>"
                                    "<style>"
                                    "body {"
                                    "font-family: Arial, sans-serif;"
                                    "}"
                                    ".container {"
                                    "width: 300px;"
                                    "margin: 0 auto;"
                                    "border: 1px solid #ccc;"
                                    "padding: 10px;"
                                    "background-color: #f8f8f8;"
                                    "}"
                                    "h2 {"
                                    "text-align: center;"
                                    "}"
                                    "table {"
                                    "width: 100%;"
                                    "border-collapse: collapse;"
                                    "margin-top: 10px;"
                                    "}"
                                    "th, td {"
                                    "border: 1px solid #ccc;"
                                    "padding: 8px;"
                                    "text-align: center;"
                                    "}"
                                    "th {"
                                    "background-color: #f2f2f2;"
                                    "}"
                                    "    .note {"
                                    "font-size: 14px;"
                                    "margin-top: 10px;"
                                    "}"
                                    "</style>"
                                    "</head>"
                                    "<body>"
                                    "<div class='container>'"
                                    "<h2>End Date:</h2>"
                                    "<p class='note'>"
                                    "Our cover end date should align with your expected end date of your student visa. Refer to the table below."
                                    "</p>"
                                    "<table>"
                                    "<thead>"
                                    "<tr>"
                                    "<th>Course Duration</th>"
                                    "<th>Add to your course end date</th>"
                                    "</tr>"
                                    "</thead>"
                                    "<tbody>"
                                    "<tr>"
                                    "<td>10 months or less</td>"
                                    "<td>1 Month</td>"
                                    "</tr>"
                                    "<tr>"
                                    "<td>Over 10 months ending January to October</td>"
                                    "<td>2 Months</td>"
                                    "</tr>"
                                    "<tr>"
                                    "<td>Over 10 months ending November to December</td>"
                                    "<td>Select 15th March next year</td>"
                                    "</tr>"
                                    "</tbody>"
                                    "</table>"
                                    "</div>"
                                    "</body>"
                                    "</html>",
                                isHTml: true,
                                title: " End date:");
                          },
                          child: Text.rich(
                            TextSpan(
                                text: "Help to choose End Date",
                                style: AppTextStyle.captionRegular(
                                    context, AppColorStyle.text(context)),
                                children: [
                                  WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: SvgPicture.asset(
                                          IconsSVG.icQuestionInfo,
                                        ),
                                      ))
                                ]),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SvgPicture.asset(
                          IconsSVG.oSHCProviders,
                        ),
                        const SizedBox(height: 40),

                        StreamBuilder<bool>(
                            stream: gmpBloc.getLoadingSubject,
                            builder: (context, snapshot) {
                              if (snapshot.data == false) {
                                return InkWellWidget(
                                  onTap: () {
                                    if (NetworkController.isInternetConnected) {
                                      if (gmpBloc.selectedCoverTypeStream
                                                  .valueOrNull !=
                                              null &&
                                          gmpBloc.selectedCoverTypeStream.value
                                                  .id !=
                                              null &&
                                          gmpBloc
                                              .selectedCoverTypeStream.value.id
                                              .toString()
                                              .isNotEmpty) {
                                        gmpBloc.getOHSCDetails(
                                            context, gmpBloc);
                                      } else {
                                        Toast.show(context,
                                            message: "Please select cover type",
                                            type: Toast.toastError,
                                            duration: 2);
                                      }
                                    } else {
                                      Toast.show(context,
                                          message:
                                              StringHelper.internetConnection,
                                          type: Toast.toastError,
                                          duration: 2);
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 45.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: AppColorStyle.green(context)),
                                    child: Text(StringHelper.getAQuote,
                                        style: AppTextStyle.detailsRegular(
                                            context,
                                            AppColorStyle.textWhite(context))),
                                  ),
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
                                      height: 45.0,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: StreamBuilder<List<String>?>(
                                          stream: gmpBloc.getLoadingMessage,
                                          builder: (context, snapshot) {
                                            List<RotateAnimatedText> messages =
                                                [
                                              RotateAnimatedText(
                                                "Please wait...",
                                                textStyle:
                                                    AppTextStyle.subTitleMedium(
                                                  context,
                                                  AppColorStyle.primary(
                                                      context),
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
                                                  textStyle: AppTextStyle
                                                      .subTitleMedium(
                                                    context,
                                                    AppColorStyle.primary(
                                                        context),
                                                  ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                ),
                                              );
                                            }
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                    color:
                                                        AppColorStyle.primary(
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
                            }),

                        const SizedBox(height: 20),
                        Center(
                          child: Text.rich(
                            TextSpan(
                                text: "${StringHelper.duration} : ",
                                style: AppTextStyle.detailsSemiBold(
                                    context, AppColorStyle.text(context)),
                                children: [
                                  WidgetSpan(
                                      alignment: PlaceholderAlignment.top,
                                      child: StreamBuilder(
                                          stream: gmpBloc
                                              .durationBetweenDates.stream,
                                          builder: (_, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data != "") {
                                              return Text(snapshot.data!,
                                                  style: AppTextStyle
                                                      .captionRegular(
                                                          context,
                                                          AppColorStyle.text(
                                                              context)));
                                            } else {
                                              return Text(
                                                  "1 Year 0 Month 0 Day",
                                                  style: AppTextStyle
                                                      .captionRegular(
                                                          context,
                                                          AppColorStyle.text(
                                                              context)));
                                            }
                                          }))
                                ]),
                          ),
                        )
                      ],
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
}
