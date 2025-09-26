import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class PointTestShimmer extends StatelessWidget {
  const PointTestShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 800,
        child: Shimmer.fromColors(
          baseColor: AppColorStyle.shimmerPrimary(context),
          highlightColor: AppColorStyle.shimmerSecondary(context),
          period: const Duration(milliseconds: 1500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
                Container(
                  width: 180,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                          color: AppColorStyle.surface(context),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 15,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: 200,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                answerShimmer(context),
                const SizedBox(
                  height: 10.0,
                ),
                answerShimmer(context),
                const SizedBox(
                  height: 10.0,
                ),
                answerShimmer(context),
              ],
            ),
          ),
        ),
      );

  Widget answerShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColorStyle.shimmerPrimary(context),
      highlightColor: AppColorStyle.shimmerSecondary(context),
      period: const Duration(milliseconds: 1500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                  color: AppColorStyle.surface(context),
                  borderRadius: const BorderRadius.all(Radius.circular(10)))),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}
