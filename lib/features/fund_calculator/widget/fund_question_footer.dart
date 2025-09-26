import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_bloc.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';

class FundQuestionFooterWidget extends StatelessWidget {
  const FundQuestionFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FundCalculatorBloc fundBloc =
        RxBlocProvider.of<FundCalculatorBloc>(context);
    return StreamBuilder<List<FundCalculatorQuestion>>(
      stream: fundBloc.currentQuestion,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          List<FundCalculatorQuestion> questionList =
              snapshot.data as List<FundCalculatorQuestion>;
          String category = "";
          double amountTotal = fundBloc.totalFundAmount();
          double answerTotal = 0.00;
          if (questionList.isNotEmpty) {
            for (FundCalculatorQuestion question in questionList) {
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
                for (FundCalculatorQuestion question in questionList) {
                  answerTotal += question.answerAmount;
                }
              }
              amountTotal = fundBloc.totalFundAmount();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                color: AppColorStyle.background(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // DEFAULT AUSTRALIA COUNTRY FLAG
                          SvgPicture.network(
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
                              //answer for fund calc question.
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: Text(
                                  "A\$ $answerTotal",
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
                                  StringHelper.totalCost,
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
                    ],
                  ),
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
