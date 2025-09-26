import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_bloc.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';

class OtherLivingFooterWidget extends StatelessWidget {
  const OtherLivingFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FundCalculatorBloc fundBloc =
    RxBlocProvider.of<FundCalculatorBloc>(context);
    return StreamBuilder<List<OtherLivingQuestion>>(
      stream: fundBloc.currentOtherLivingQuestion,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          List<OtherLivingQuestion> questionList =
          snapshot.data as List<OtherLivingQuestion>;
          String category = "";
          double amountTotal = fundBloc.totalOtherLivingAmount();
          double answerTotal = 0.00;
          if (questionList.isNotEmpty) {
            for (OtherLivingQuestion question in questionList) {
              // SET category
              if (category.isEmpty) {
                category = question.category ?? '';
              }
              answerTotal += question.answerAmount;
            }
          }
          return StreamBuilder<String>(
            stream: questionList[questionList.length - 1].answerStream,
            builder: (_, snapshot) {
              answerTotal = 0.00;
              if (questionList.isNotEmpty) {
                for (OtherLivingQuestion question in questionList) {
                  answerTotal += question.answerAmount;
                }
              }
              amountTotal = fundBloc.totalOtherLivingAmount();
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0),
                color: AppColorStyle.background(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // DEFAULT AUSTRALIA COUNTRY FLAG
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: SvgPicture.network(
                        Constants.australiaFlagURL,
                        width: 24.0,
                        height: 24.0,
                        fit: BoxFit.fill,
                        placeholderBuilder: (context) => Icon(
                          Icons.flag,
                          size: 24.0,
                          color: AppColorStyle.surfaceVariant(context),
                        ),
                      ),
                    ),
                    // ANSWER AMOUNT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Text(
                            category,
                            style: AppTextStyle.detailsRegular(
                              context,
                              AppColorStyle.textDetail(context),
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            "A\$ $answerTotal",
                            // "A\$ ${Utility.getAmountInCurrencyFormat(amount: answerTotal)}",
                            style: AppTextStyle.subTitleSemiBold(
                              context,
                              AppColorStyle.text(context),
                            ),
                            key: ValueKey<double>(answerTotal),
                          ),
                        )
                      ],
                    ),
                    // TOTAL FUND
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Text(
                            "Total Cost",
                            style: AppTextStyle.detailsRegular(
                              context,
                              AppColorStyle.textDetail(context),
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            "A\$ ${Utility.getAmountInCurrencyFormat(amount: amountTotal)}",
                            style: AppTextStyle.subTitleSemiBold(
                              context,
                              AppColorStyle.teal(context),
                            ),
                            key: ValueKey<double>(amountTotal),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
