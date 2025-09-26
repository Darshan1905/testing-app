import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';

class EmployeeOutlookDataWidget extends StatelessWidget {
  final UnitGroupDetailData ugDataModel;

  const EmployeeOutlookDataWidget({Key? key, required this.ugDataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var outLookFromValue = Utility.getIntAmountFormat(
        amount: int.parse(ugDataModel.outlookFrom.toString()));
    var outLookToValue = Utility.getIntAmountFormat(
        amount: int.parse(ugDataModel.outlookTo.toString()));
    var jobDifference = int.parse(ugDataModel.outlookTo ?? '0') >=
            int.parse(ugDataModel.outlookFrom ?? '0')
        ? (int.parse(ugDataModel.outlookFrom ?? '0') -
                int.parse(ugDataModel.outlookTo ?? '0'))
            .abs()
        : (int.parse(ugDataModel.outlookFrom ?? '0') -
            int.parse(ugDataModel.outlookTo ?? '0'));

    return Visibility(
      visible: (ugDataModel.outlookFrom != null &&
          ugDataModel.outlookFrom != "0" &&
          ugDataModel.outlookTo != null &&
          ugDataModel.outlookTo != "0"),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringHelper.employmentOutlook,
                    style: AppTextStyle.titleSemiBold(
                        context, AppColorStyle.text(context))),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Flexible(
                      child: Text.rich(
                        textAlign: TextAlign.start,
                        TextSpan(
                            text: StringHelper.projectedChanger,
                            style: AppTextStyle.captionRegular(
                                context, AppColorStyle.text(context)),
                            children: [
                              TextSpan(
                                  text: StringHelper.detailYears,
                                  style: AppTextStyle.captionSemiBold(
                                      context, AppColorStyle.text(context))),
                            ]),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Flexible(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ThemeConstant.blueVariant,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 2, bottom: 2),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: Text.rich(
                                  textAlign: TextAlign.start,
                                  TextSpan(
                                      text:
                                          "${ugDataModel.outlookProjectedChange}",
                                      style: AppTextStyle.captionSemiBold(
                                          context,
                                          AppColorStyle.primary(context)),
                                      children: [
                                        TextSpan(
                                            text:
                                                " or ${int.parse(ugDataModel.outlookTo ?? '0') >= int.parse(ugDataModel.outlookFrom ?? '0') ? Utility.getIntAmountFormat(amount: jobDifference) : "-${Utility.getIntAmountFormat(amount: jobDifference)}"} jobs",
                                            style: AppTextStyle.captionRegular(
                                                context,
                                                AppColorStyle.primary(
                                                    context))),
                                      ]),
                                ),
                              ),
                              const SizedBox(width: 5),
                              SvgPicture.asset(
                                int.parse(ugDataModel.outlookTo ?? '0') >=
                                        int.parse(
                                            ugDataModel.outlookFrom ?? '0')
                                    ? IconsSVG.graphUpIcon
                                    : IconsSVG.graphDownIcon,
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //outlook from year
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          color: ThemeConstant.purpleVariant,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                IconsSVG.twoUsersIcon,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "In ${ugDataModel.outlookFromYear ?? ""}",
                                        style: AppTextStyle.captionRegular(
                                            context,
                                            AppColorStyle.textDetail(context))),
                                    const SizedBox(height: 3.0),
                                    Text(
                                        ugDataModel.outlookFrom == "0"
                                            ? "-"
                                            : outLookFromValue,
                                        softWrap: true,
                                        style: AppTextStyle.detailsBold(context,
                                            AppColorStyle.text(context)))
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    //outlook from year
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ThemeConstant.greenVariant,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                IconsSVG.threeUsersIcon,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("In ${ugDataModel.outlookYear}",
                                        style: AppTextStyle.captionRegular(
                                            context,
                                            AppColorStyle.textDetail(context))),
                                    const SizedBox(height: 3.0),
                                    Text(
                                        ugDataModel.outlookTo == "0"
                                            ? "-"
                                            : outLookToValue,
                                        softWrap: true,
                                        style: AppTextStyle.detailsBold(context,
                                            AppColorStyle.text(context)))
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
              height: 5.0, color: AppColorStyle.backgroundVariant(context)),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class MainIndustriesDataWidget extends StatelessWidget {
  final UnitGroupDetailData ugDataModel;

  const MainIndustriesDataWidget({Key? key, required this.ugDataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ugDataModel.mainIndustries != null &&
        ugDataModel.mainIndustries!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
            child: Text(StringHelper.mainIndustries,
                style: AppTextStyle.titleSemiBold(
                    context, AppColorStyle.text(context))),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            height: 120,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: ugDataModel.mainIndustries?.length ?? 0,
                itemBuilder: (context, index) {
                  final MainIndustries? universityList =
                      ugDataModel.mainIndustries?[index];
                  return (universityList?.industryValue != null &&
                          universityList!.industryValue!.isNotEmpty &&
                          universityList.industryValue != "n/a" &&
                          universityList.industryValue != "n/a%")
                      ? Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: const EdgeInsets.all(15.0),
                          margin: EdgeInsets.only(
                              left: Constants.commonPadding,
                              right: index ==
                                      (ugDataModel.mainIndustries?.length ??
                                              0) -
                                          1
                                  ? Constants.commonPadding
                                  : 0.0),
                          decoration: BoxDecoration(
                            color: universityList.randomColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                universityList.industryName ?? "",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.detailsRegular(
                                    context, AppColorStyle.text(context)),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                universityList.industryValue ?? "",
                                style: AppTextStyle.subTitleSemiBold(
                                    context, AppColorStyle.text(context)),
                              )
                            ],
                          ),
                        )
                      : const SizedBox();
                }),
          ),
          const SizedBox(height: 20.0),
          Container(
              height: 5.0, color: AppColorStyle.backgroundVariant(context)),
          const SizedBox(height: 20.0),
        ],
      );
    }
    return const SizedBox();
  }
}

class WorkProfileDataWidget extends StatelessWidget {
  final UnitGroupDetailData ugDataModel;

  const WorkProfileDataWidget({Key? key, required this.ugDataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(StringHelper.workerProfile,
                  style: AppTextStyle.titleSemiBold(
                      context, AppColorStyle.text(context))),
              const SizedBox(height: 25.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(StringHelper.ageAndGender,
                      style: AppTextStyle.subTitleSemiBold(
                          context, AppColorStyle.textDetail(context))),
                  const SizedBox(width: 5.0),
                  Visibility(
                    visible: (ugDataModel.workersProfileSource != null &&
                        ugDataModel.workersProfileSource!.isNotEmpty),
                    child: InkWellWidget(
                      onTap: () {
                        WidgetHelper.showAlertDialog(
                          context,
                          contentText: ugDataModel.workersProfileSource ?? "",
                          isHTml: true,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SvgPicture.asset(
                          IconsSVG.fundBulb,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.primary(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //outlook from year
                  Expanded(
                    child: Column(children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeConstant.blueVariant,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: SvgPicture.asset(
                              IconsSVG.averageAgeIcon,
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                ThemeConstant.primaryVariant1,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15.0),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(StringHelper.ageInYears,
                                      style: AppTextStyle.captionRegular(
                                          context,
                                          AppColorStyle.textDetail(context))),
                                  const SizedBox(height: 3.0),
                                  Text(ugDataModel.profileAgeInYear ?? "",
                                      softWrap: true,
                                      style: AppTextStyle.detailsBold(
                                          context, AppColorStyle.text(context)))
                                ]),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(StringHelper.avgJobRange,
                          style: AppTextStyle.captionRegular(
                              context, AppColorStyle.textHint(context))),
                    ]),
                  ),

                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: Constants.commonPadding),
                      color: AppColorStyle.backgroundVariant(context),
                      height: 80,
                      width: 1),
                  //outlook from year
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ThemeConstant.purpleVariant,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset(
                                    IconsSVG.workedFemaleShare,
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                      AppColorStyle.purple(context),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                )),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(StringHelper.femaleShare,
                                        style: AppTextStyle.captionRegular(
                                            context,
                                            AppColorStyle.textDetail(context))),
                                    const SizedBox(height: 3.0),
                                    Text(ugDataModel.profileFemaleShare ?? "",
                                        softWrap: true,
                                        style: AppTextStyle.detailsBold(context,
                                            AppColorStyle.text(context)))
                                  ]),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(StringHelper.avgJobRange,
                            style: AppTextStyle.captionRegular(
                                context, AppColorStyle.textHint(context))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        Container(height: 5.0, color: AppColorStyle.backgroundVariant(context)),
        const SizedBox(height: 15.0),
      ],
    );
  }
}
