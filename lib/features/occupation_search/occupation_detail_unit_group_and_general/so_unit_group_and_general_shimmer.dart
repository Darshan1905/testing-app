import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class SoUnitGroupAndGeneralShimmer extends StatelessWidget {
  const SoUnitGroupAndGeneralShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
          color: AppColorStyle.grayColor(context),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.all(20.0),
      child: Shimmer.fromColors(
          baseColor: AppColorStyle.shimmerPrimary(context),
          highlightColor: AppColorStyle.shimmerSecondary(context),
          period: const Duration(milliseconds: 1500),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 20, width: 60, color: AppColorStyle.grayColor(context)),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                    height: 80,
                    width: double.infinity,
                    color: AppColorStyle.grayColor(context)),
              ],
            ),
          )),
    );
  }

  static skillLevelShimmer(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
          color: AppColorStyle.grayColor(context),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.all(20.0),
      child: Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.shimmerSecondary(context),
        period: const Duration(milliseconds: 1500),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: double.infinity,
                color: AppColorStyle.grayColor(context),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                  height: 100,
                  width: double.infinity,
                  color: AppColorStyle.grayColor(context)),
            ],
          ),
        ),
      ),
    );
  }

  static otherInformationShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColorStyle.shimmerPrimary(context),
      highlightColor: AppColorStyle.shimmerSecondary(context),
      period: const Duration(milliseconds: 1500),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
                children: List.generate(
                    4,
                    (index) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            height: 20,
                            width: double.infinity,
                            color: AppColorStyle.grayColor(context),
                          ),
                        ))),
          ],
        ),
      ),
    );
  }

  static relatedOccupationShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColorStyle.shimmerPrimary(context),
      highlightColor: AppColorStyle.shimmerSecondary(context),
      period: const Duration(milliseconds: 1500),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
                children: List.generate(
                    4,
                    (index) => Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 60,
                                color: AppColorStyle.grayColor(context),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 20,
                                  color: AppColorStyle.grayColor(context),
                                ),
                              ),
                            ],
                          ),
                        ))),
          ],
        ),
      ),
    );
  }

  static Widget employmentStatisticShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColorStyle.shimmerPrimary(context),
      highlightColor: AppColorStyle.shimmerSecondary(context),
      period: const Duration(milliseconds: 1500),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, right: 20),
        child: Row(
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColorStyle.grayColor(context),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Container(
                height: 30,
                color: AppColorStyle.surface(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
