import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';

class CharacteristicDataWidget extends StatelessWidget {
  final UnitGroupDetailData ugDataModel;

  const CharacteristicDataWidget({Key? key, required this.ugDataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 5.0, color: AppColorStyle.backgroundVariant(context)),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Characteristics title
              Text(StringHelper.characteristics,
                  style: AppTextStyle.titleSemiBold(
                      context, AppColorStyle.text(context))),
              const SizedBox(height: Constants.commonPadding),

              //Snapshot Details data
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Job Type
                          Text(StringHelper.jobType,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.textDetail(context))),
                          const SizedBox(height: 3.0),
                          Text(
                              (ugDataModel.jobType ?? "").isEmpty
                                  ? "-"
                                  : ugDataModel.jobType ?? "-",
                              style: AppTextStyle.detailsMedium(
                                  context, AppColorStyle.text(context))),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //Skill Level
                          Text(StringHelper.skillLevelText,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.textDetail(context))),
                          const SizedBox(height: 3.0),
                          Text(
                              Utility.getSkillLevel(
                                  context, ugDataModel.skillLevel ?? 1),
                              style: AppTextStyle.detailsSemiBold(
                                  context, AppColorStyle.text(context))),
                        ],
                      ),
                    ),
                  ]),
              //for Divider
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      height: 20,
                      color: AppColorStyle.backgroundVariant(context),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      height: 20,
                      color: AppColorStyle.backgroundVariant(context),
                    ),
                  ),
                ],
              ),

              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Unemployment Rate
                          Text(StringHelper.unEmploymentRate,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.textDetail(context))),
                          const SizedBox(height: 3.0),
                          Text(
                              (ugDataModel.unemploymentRate ?? "").isEmpty
                                  ? "-"
                                  : ugDataModel.unemploymentRate ?? "-",
                              style: AppTextStyle.detailsMedium(
                                  context, AppColorStyle.text(context))),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //Physical Demand
                          Text(StringHelper.physicalDemand,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.textDetail(context))),
                          const SizedBox(height: 3.0),
                          Text(
                              (ugDataModel.physicalDamand ?? "").isEmpty
                                  ? "-"
                                  : ugDataModel.physicalDamand ?? "-",
                              style: AppTextStyle.detailsMedium(
                                  context, AppColorStyle.text(context))),
                        ],
                      ),
                    ),
                  ]),
              //for Divider
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      height: 20,
                      color: AppColorStyle.backgroundVariant(context),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      height: 20,
                      color: AppColorStyle.backgroundVariant(context),
                    ),
                  ),
                ],
              ),

              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Interests
                          Text(StringHelper.interests,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.textDetail(context))),
                          const SizedBox(height: 3.0),
                          Text(
                              (ugDataModel.interests ?? "").isEmpty
                                  ? "-"
                                  : ugDataModel.interests ?? "-",
                              style: AppTextStyle.detailsMedium(
                                  context, AppColorStyle.text(context))),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //Pathways
                          Text(StringHelper.pathWays,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.textDetail(context))),
                          const SizedBox(height: 3.0),
                          Text(
                              (ugDataModel.pathWay ?? "").isEmpty
                                  ? "-"
                                  : ugDataModel.pathWay ?? "-",
                              textAlign: TextAlign.end,
                              style: AppTextStyle.detailsMedium(
                                  context, AppColorStyle.text(context))),
                        ],
                      ),
                    ),
                  ]),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        Container(height: 5.0, color: AppColorStyle.backgroundVariant(context)),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
