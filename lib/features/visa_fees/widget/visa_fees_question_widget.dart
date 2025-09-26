import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/visa_fees/model/question_model.dart';
import 'package:occusearch/features/visa_fees/model/visa_subclass_model.dart';

class VisaRadioButtonWidget extends StatelessWidget {
  const VisaRadioButtonWidget({Key? key, required this.questionModel})
      : super(key: key);
  final QuestionModel questionModel;

  final double width = 200;
  final double height = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          questionModel.question ?? "",
          style: AppTextStyle.subTitleRegular(
              context, AppColorStyle.textDetail(context)),
        ),
        const SizedBox(height: 30),
        StreamBuilder<bool>(
          stream: questionModel.selectedOptionStream,
          builder: (context, snapshot) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: AppColorStyle.backgroundVariant(context),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedAlign(
                    alignment: Alignment(
                        snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data == true
                            ? -1
                            : 1,
                        0),
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: width * 0.5,
                      height: height,
                      decoration: BoxDecoration(
                        color: AppColorStyle.purple(context),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      questionModel.setOptionStream = true;
                    },
                    child: Align(
                      alignment: const Alignment(-1, 0),
                      child: Container(
                        width: width * 0.5,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(
                          "YES",
                          style: AppTextStyle.subTitleSemiBold(
                              context,
                              snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data == true
                                  ? AppColorStyle.textWhite(context)
                                  : AppColorStyle.textDetail(context)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      questionModel.setOptionStream = false;
                    },
                    child: Align(
                      alignment: const Alignment(1, 0),
                      child: Container(
                        width: width * 0.5,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(
                          "NO",
                          style: AppTextStyle.subTitleSemiBold(
                              context,
                              snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data == false
                                  ? AppColorStyle.textWhite(context)
                                  : AppColorStyle.textDetail(context)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class VisaDropdownWidget extends StatelessWidget {
  const VisaDropdownWidget(
      {Key? key, required this.questionModel, required this.subclassList})
      : super(key: key);
  final QuestionModel questionModel;
  final List<SubclassData> subclassList;

  final double width = 200;
  final double height = 50;

  @override
  Widget build(BuildContext context) {
    if (questionModel.selectedSubclass == null ||
        (questionModel.selectedSubclass?.name == null ||
            questionModel.selectedSubclass?.name == '')) {
      questionModel.setSubclassStream = subclassList[0];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          questionModel.question ?? "",
          style: AppTextStyle.subTitleRegular(
              context, AppColorStyle.textDetail(context)),
        ),
        const SizedBox(height: 30),
        StreamBuilder<SubclassData>(
          stream: questionModel.selectedSubclassStream,
          builder: (context, snapshot) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppColorStyle.backgroundVariant(context)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SubclassData>(
                  value: questionModel.selectedSubclass ?? subclassList[0],
                  borderRadius: BorderRadius.circular(10.0),
                  isExpanded: true,
                  icon: SvgPicture.asset(
                    IconsSVG.arrowDownIcon,
                    colorFilter: ColorFilter.mode(
                      AppColorStyle.purple(context),
                      BlendMode.srcIn,
                    ),
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return subclassList.map<Widget>((SubclassData item) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 5.0, top: 0, bottom: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.name ?? "",
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            style: AppTextStyle.subTitleRegular(
                                context, AppColorStyle.purple(context)),
                          ),
                        ),
                      );
                    }).toList();
                  },
                  items: subclassList.map<DropdownMenuItem<SubclassData>>(
                      (SubclassData value) {
                    //print(vProvider.subclassList.length);
                    return DropdownMenuItem<SubclassData>(
                      value: value,
                      onTap: () {
                        //provider.onDropdownChange(questionModel, value);
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                value.name ?? "",
                                maxLines: 3,
                                overflow: TextOverflow.visible,
                                style: AppTextStyle.detailsMedium(
                                    context,
                                    questionModel.selectedSubclass != null &&
                                            questionModel
                                                    .selectedSubclass!.id ==
                                                value.id
                                        ? AppColorStyle.purple(context)
                                        : AppColorStyle.text(context)),
                              ),
                            ),
                          ),
                          Divider(
                              color: AppColorStyle.surfaceVariant(context),
                              thickness: 0.5),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (SubclassData? value) {
                    questionModel.setSubclassStream = value!;
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
