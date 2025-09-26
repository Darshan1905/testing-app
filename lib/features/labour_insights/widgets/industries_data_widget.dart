import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';

class IndustriesDataWidget extends StatelessWidget {
  final UnitGroupDetailData ugDataModel;

  const IndustriesDataWidget({Key? key, required this.ugDataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(ugDataModel.industries != null && ugDataModel.industries!.isNotEmpty){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.commonPadding),
            child: Text(StringHelper.industries,
                style: AppTextStyle.titleSemiBold(
                    context, AppColorStyle.text(context))),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            height: 120,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: ugDataModel.industries?.length ?? 0,
                itemBuilder: (context, index) {
                  final Industries universityList =
                      ugDataModel.industries?[index] ?? Industries();
                  return Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.all(15.0),
                    margin: EdgeInsets.only(
                        left: Constants.commonPadding,
                        right: index ==
                            (ugDataModel.industries?.length ?? 0) - 1
                            ? Constants.commonPadding
                            : 0.0),
                    decoration: BoxDecoration(
                      color: universityList.randomColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        universityList.industryName ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.detailsRegular(
                            context, AppColorStyle.text(context)),
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(height: 15.0),
        ],
      );
    }
    return const SizedBox();
  }
}

class AnzscoGroupWidget extends StatelessWidget {
  final UnitGroupDetailData ugDataModel;

  const AnzscoGroupWidget({Key? key, required this.ugDataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if((ugDataModel.occupations?.length ?? 0) > 0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
            child: Text(StringHelper.anzscoOccupationGroup,
                style: AppTextStyle.subTitleSemiBold(
                    context, AppColorStyle.textDetail(context))),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            height: 120,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: ugDataModel.occupations?.length ?? 0,
                itemBuilder: (context, index) {
                  final Occupations? universityList =
                  ugDataModel.occupations?[index];
                  return Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.all(15.0),
                    margin: EdgeInsets.only(
                        left: Constants.commonPadding,
                        right: index == (ugDataModel.occupations?.length ?? 0) - 1
                            ? Constants.commonPadding
                            : 0.0),
                    decoration: BoxDecoration(
                      color: universityList?.randomColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            universityList?.occupation ?? "",
                            maxLines: 2,
                            style: AppTextStyle.subTitleSemiBold(
                                context, AppColorStyle.text(context)),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            universityList?.name ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.detailsRegular(
                                context, AppColorStyle.text(context)),
                          ),
                        ]),
                  );
                }),
          ),
          const SizedBox(height: 20.0),
          Container(height: 5.0, color: AppColorStyle.backgroundVariant(context)),
          const SizedBox(height: 20.0),
        ],
      );
    }
    return Container();
  }
}
