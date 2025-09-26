import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';

class SnapShotDataWidget extends StatelessWidget {
  final UnitGroupDetailData ugDataModel;

  const SnapShotDataWidget({Key? key, required this.ugDataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Constants.commonPadding,vertical: ugDataModel.summary == null && ugDataModel.summary?.isEmpty == true ? 10 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Overview of Snapshot
              Text(StringHelper.snapshot,
                  style: AppTextStyle.titleSemiBold(
                      context, AppColorStyle.text(context))),
              const SizedBox(height: 25.0),

              //Snapshot Details data
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Employed
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SvgPicture.asset(
                                      IconsSVG.ugEmployed,
                                      width: 24,
                                      height: 24,
                                    ),
                                  )),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(StringHelper.employed,
                                          style: AppTextStyle.captionRegular(
                                              context,
                                              AppColorStyle.textDetail(context))),
                                      const SizedBox(height: 3.0),
                                      Text(
                                          ugDataModel.snapshotEmployed == "" || ugDataModel.snapshotEmployed == "n/a" ?
                                              "N/A" :  Utility.getIntAmountFormat(
                                              amount: int.parse((ugDataModel.snapshotEmployed ?? "0"))),
                                          style: AppTextStyle.detailsSemiBold(
                                              context, AppColorStyle.text(context)))
                                    ]),
                              )
                            ],
                          ),
                          const SizedBox(height: 15.0),

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Container(
                                  height: 1.0,
                                  color: AppColorStyle.backgroundVariant(context)),
                            ),
                          ),
                          const SizedBox(height: 15.0),

                          //Weekly Earnings
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ThemeConstant.greenVariant),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: SvgPicture.asset(
                                      IconsSVG.weeklyEarningsIcon,
                                      width: 24,
                                      height: 24,
                                    ),
                                  )),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(StringHelper.weeklyEarnings,
                                          style: AppTextStyle.captionRegular(
                                              context,
                                              AppColorStyle.textDetail(context))),
                                      const SizedBox(height: 3.0),
                                      Text(
                                          (ugDataModel.snapshotWeeklyEarnings ?? "")
                                                  .isEmpty
                                              ? "N/A"
                                              : ugDataModel.snapshotWeeklyEarnings?.toUpperCase() ??
                                                  "N/A",
                                          style: AppTextStyle.detailsSemiBold(context,
                                              AppColorStyle.text(context))),
                                    ]),
                              )
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Container(
                                  height: 1.0,
                                  color: AppColorStyle.backgroundVariant(context)),
                            ),
                          ),
                          const SizedBox(height: 15.0),

                          //Female Share
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
                                      color: ThemeConstant.purpleVariant),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: SvgPicture.asset(
                                      IconsSVG.femaleShareIcon,
                                      width: 24,
                                      height: 24,
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
                                      Text(
                                          (ugDataModel.snapshotFemaleShare ?? "")
                                                  .isEmpty
                                              ? "N/A"
                                              : (ugDataModel.snapshotFemaleShare?.toUpperCase()) ??
                                                  "N/A",
                                          style: AppTextStyle.detailsSemiBold(
                                              context, AppColorStyle.text(context)))
                                    ]),
                              )
                            ],
                          ),
                          const SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                            width: 1.0,
                            height: 200,
                            color: AppColorStyle.backgroundVariant(context)),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Future Growth
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
                                      color: ThemeConstant.yellowVariant),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: SvgPicture.asset(
                                      IconsSVG.futureGrowthIcon,
                                      width: 24,
                                      height: 24,
                                    ),
                                  )),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(StringHelper.futureGrowth,
                                          style: AppTextStyle.captionRegular(
                                              context,
                                              AppColorStyle.textDetail(context))),
                                      const SizedBox(height: 3.0),
                                      Text(
                                          (ugDataModel.snapshotFutureGrowth ?? "")
                                                  .isEmpty
                                              ? "N/A"
                                              : (ugDataModel.snapshotFutureGrowth)?.toUpperCase() ??
                                                  "N/A",
                                          style: AppTextStyle.detailsSemiBold(
                                              context, AppColorStyle.text(context)))
                                    ]),
                              )
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Container(
                                  height: 1.0,
                                  color: AppColorStyle.backgroundVariant(context)),
                            ),
                          ),
                          const SizedBox(height: 15.0),

                          //Full-Time Share
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ThemeConstant.pinkVariant,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SvgPicture.asset(
                                      IconsSVG.fullTimeShare,
                                      width: 24,
                                      height: 24,
                                    ),
                                  )),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(StringHelper.fullTimeShare,
                                          style: AppTextStyle.captionRegular(
                                              context,
                                              AppColorStyle.textDetail(context))),
                                      const SizedBox(height: 3.0),
                                      Text(
                                          (ugDataModel.snapshotFulltimeShare ?? "")
                                                  .isEmpty
                                              ? "N/A"
                                              : (ugDataModel.snapshotFulltimeShare)?.toUpperCase() ??
                                                  "N/A",
                                          style: AppTextStyle.detailsSemiBold(
                                              context, AppColorStyle.text(context)))
                                    ]),
                              )
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Container(
                                  height: 1.0,
                                  color: AppColorStyle.backgroundVariant(context)),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          //Average Age
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
                                    color: ThemeConstant.lightBlueVariant,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SvgPicture.asset(
                                      IconsSVG.averageAgeIcon,
                                      width: 24,
                                      height: 24,
                                    ),
                                  )),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(StringHelper.averageAge,
                                          style: AppTextStyle.captionRegular(
                                              context,
                                              AppColorStyle.textDetail(context))),
                                      const SizedBox(height: 3.0),
                                      Text(
                                          (ugDataModel.snapshotAverageAge ?? "")
                                                  .isEmpty
                                              ? "N/A"
                                              : (ugDataModel.snapshotAverageAge)?.toUpperCase() ??
                                                  "N/A",
                                          softWrap: true,
                                          style: AppTextStyle.detailsSemiBold(
                                              context, AppColorStyle.text(context)))
                                    ]),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        ugDataModel.tasks?.isEmpty == true ?  Container(height: 5.0, color: AppColorStyle.backgroundVariant(context)) : Container(),
        ugDataModel.tasks?.isEmpty == true ? const SizedBox(height: 20.0) : Container(),
      ],
    );
  }
}

class TaskWidget extends StatelessWidget {
  final UnitGroupDetailData ugDataModel;

  const TaskWidget({Key? key, required this.ugDataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (ugDataModel.tasks != null && ugDataModel.tasks!.isNotEmpty),
      child: Column(
        children: [
          Container(
            color: AppColorStyle.backgroundVariant(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.commonPadding),
                  child: Text(StringHelper.task,
                      style: AppTextStyle.titleSemiBold(
                          context, AppColorStyle.text(context))),
                ),
                const SizedBox(height: 10.0),
                //task list according to data
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.commonPadding),
                  child: Text(
                    ugDataModel.tasks ?? "",
                    textAlign: TextAlign.start,
                    style: AppTextStyle.captionRegular(
                      context,
                      AppColorStyle.text(context),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
