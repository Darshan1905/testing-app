import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class MostVisitedOccupationShimmer extends StatelessWidget {
  const MostVisitedOccupationShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorStyle.background(context),
      child: Shimmer.fromColors(
          baseColor: AppColorStyle.backgroundVariant(context),
          highlightColor: AppColorStyle.shimmerPrimary(context),
          period: const Duration(milliseconds: 1500),
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 80.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 80.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class RecentSearchShimmer extends StatelessWidget {
  const RecentSearchShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Shimmer.fromColors(
          baseColor: AppColorStyle.surface(context),
          highlightColor: AppColorStyle.shimmerPrimary(context),
          period: const Duration(milliseconds: 1500),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColorStyle.shimmerPrimary(context),
              ),
              width: MediaQuery.of(context).size.width -
                  (Constants.commonPadding * 2),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                                height: 25,
                                width: 70,
                                color: AppColorStyle.shimmerPrimary(context))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Container(
                                  height: 25,
                                  width: 150,
                                  color: AppColorStyle.shimmerPrimary(context)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

