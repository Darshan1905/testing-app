import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_bloc.dart';

class FundActionBarWidget extends StatelessWidget {
  final bool fromOtherLivingCost;
  final String actionbarTitle;
  final Function onNextClicked;
  final Function onBackPressed;
  final int max;
  final List<dynamic> questionList;

  const FundActionBarWidget(
      {Key? key,
      required this.fromOtherLivingCost,
      required this.actionbarTitle,
      required this.onNextClicked,
      required this.onBackPressed,
      required this.max,
      required this.questionList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FundCalculatorBloc fundBloc =
        RxBlocProvider.of<FundCalculatorBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: StreamBuilder<int>(
        stream: fundBloc.getCurrentIndex,
        builder: (context, snapshot) {
          int currentIndex = snapshot.data ?? 0;
          final int fundQuestionIndex = !fromOtherLivingCost
              ? currentIndex == 3
                  ? 4
                  : currentIndex == 4
                      ? 5
                      : currentIndex
              : currentIndex;
          final String category =
              questionList[fundQuestionIndex].category ?? "";
          final String note = questionList[fundQuestionIndex].note ?? "";
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Step ${currentIndex + 1} of $max",
                    style: AppTextStyle.subTitleRegular(
                      context,
                      AppColorStyle.textHint(context),
                    ),
                  ),
                  Text(
                    actionbarTitle,
                    style: AppTextStyle.titleRegular(
                        context, AppColorStyle.primary(context)),
                  ),
                  // [OTHER LIVING COST]
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: InkWell(
                      onTap: () {
                        onBackPressed();
                      },
                      child: SvgPicture.asset(
                        IconsSVG.closeIcon,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  /*
                  // [FUND CALCULATOR]
                  InkWellWidget(
                    onTap: () {
                      onNextClicked();
                    },
                    child: Text(
                      currentIndex != 0 && (5 - 1 == currentIndex)
                          ? "  Done  "
                          : currentIndex == 0
                          ? "    "
                          : "  Next  ",
                      style: AppTextStyle.subTitleSemiBold(
                          context, AppColorStyle.text(context)),
                    ),
                  )

                       */
                ],
              ),
              Row(
                children: [
                  Text(
                    category,
                    style: AppTextStyle.headlineBold(
                      context,
                      AppColorStyle.text(context),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Visibility(
                    visible: note.isNotEmpty == true,
                    child: InkWellWidget(
                      onTap: () {
                        WidgetHelper.showAlertDialog(context,
                            contentText: note,
                            isHTml: true,
                            title: StringHelper.howWorks);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: SvgPicture.asset(
                          IconsSVG.fundBulb,
                          width: 20.0,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.teal(context),
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
        },
      ),
    );
  }
}
