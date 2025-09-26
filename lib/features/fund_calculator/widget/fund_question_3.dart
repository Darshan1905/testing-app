import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'fund_question_header.dart';

class FundQuestion3Widget extends StatelessWidget {
  final int index;
  final int max;
  final FundCalculatorQuestion questionData;
  final bool themeBloc;

  const FundQuestion3Widget(
      {Key? key,
      required this.index,
      required this.max,
      required this.questionData,
      required this.themeBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> noOfChildren = [0, 1, 2, 3, 4, 5, 6];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FundQuestionHeader(
              index: index,
              max: max,
              question: questionData.questionTitle ?? '',
            ),
            questionData.amount != null && questionData.amount != 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                    child: Text(
                      "A\$ ${questionData.amount}",
                      style: AppTextStyle.titleBold(
                        context,
                        AppColorStyle.teal(context),
                      ),
                    ),
                  )
                : const SizedBox(),
            questionData.questionLabel != null &&
                    questionData.questionLabel != ""
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "${questionData.questionLabel}",
                      style: AppTextStyle.detailsRegular(
                        context,
                        AppColorStyle.text(context),
                      ),
                    ),
                  )
                : const SizedBox(),
            Text(
              StringHelper.livingCostAdded,
              style: AppTextStyle.detailsRegular(
                context,
                AppColorStyle.textDetail(context),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Center(
              child: SizedBox(
                width: 150.0,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Center(
                        child: SvgPicture.asset(
                          IconsSVG.childIcon,
                          width: 150.0,
                        ),
                      ),
                    ),
                    Container(
                      width: 150.0,
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        margin: const EdgeInsets.only(top: 10.0, right: 5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColorStyle.background(context),
                          border: Border.all(
                              color: AppColorStyle.teal(context), width: 1.0),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: StreamBuilder<String>(
                            stream: questionData.answerStream,
                            builder: (context, snapshot) {
                              int selectedChildren = snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data != ""
                                  ? int.parse(snapshot.data ?? '0')
                                  : 0;
                              return Text(
                                "$selectedChildren",
                                style: AppTextStyle.titleBold(
                                  context,
                                  AppColorStyle.teal(context),
                                ),
                                key: ValueKey<int>(selectedChildren),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),
            StreamBuilder<String>(
              stream: questionData.answerStream,
              builder: (context, snapshot) {
                double selectedChildren = snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data != ""
                    ? double.parse(snapshot.data ?? '0.0')
                    : 0.0;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWellWidget(
                      onTap: () async {
                        //MINUS SELECTED CHILDREN
                        double addedChildrenValue = selectedChildren - 1;
                        addedChildrenValue =
                            addedChildrenValue >= 0 ? addedChildrenValue : 0;
                        await setPrice(addedChildrenValue);
                      },
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: AppColorStyle.backgroundVariant(context),
                          // color: AppColorStyle.surfaceVariant(context),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: AppColorStyle.textHint(context),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 20.0,
                            width: double.infinity,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColorStyle.teal(context).withOpacity(
                                0.1,
                              ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(),
                            child: SfSliderTheme(
                              data: SfSliderThemeData(
                                  activeTrackColor: AppColorStyle.teal(context),
                                  thumbStrokeWidth: 1,
                                  thumbRadius: 15.0,
                                  thumbColor: AppColorStyle.background(context),
                                  thumbStrokeColor:
                                      AppColorStyle.teal(context)),
                              child: SfSlider(
                                min: 0.0,
                                max: noOfChildren.length.toDouble() - 1.0,
                                value: selectedChildren,
                                inactiveColor: Colors.transparent,
                                onChanged: (dynamic newValue) async {
                                  //PASS SELECTED CHILDREN
                                  await setPrice(newValue);
                                },
                                thumbIcon: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      selectedChildren.toString().substring(
                                          0,
                                          selectedChildren
                                              .toString()
                                              .indexOf('.')),
                                      style: AppTextStyle.detailsSemiBold(
                                        context,
                                        AppColorStyle.teal(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWellWidget(
                      onTap: () async {
                        //ADD SELECTED CHILDREN
                        double addedChildrenValue = selectedChildren + 1;
                        addedChildrenValue = addedChildrenValue >
                                noOfChildren.length.toDouble() - 1.0
                            ? noOfChildren.length.toDouble() - 1.0
                            : addedChildrenValue;
                        await setPrice(addedChildrenValue);
                      },
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: AppColorStyle.teal(context),
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppColorStyle.textWhite(context),
                        ),
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
  }

  setPrice(double childrenValue) {
    double amount =
        (childrenValue.round() * (questionData.amount ?? 0.0)).toDouble();
    questionData.setAnswer('${childrenValue.round()}', amount);
  }
}
