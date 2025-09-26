import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class RecentUpdateListShimmer extends StatelessWidget {
  RecentUpdateListShimmer(int count, {Key? key}) : super(key: key) {
    itemCount = count;
  }

  int itemCount = 0;

  @override
  Widget build(BuildContext context) => ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: itemCount,
        padding: const EdgeInsets.only(top:Constants.commonPadding),
        itemBuilder: (context, index) {
          return recentUpdateItemShimmer(context, index);
        },
      );

  Widget recentUpdateItemShimmer(BuildContext context, int index) {
    return Shimmer.fromColors(
      baseColor: AppColorStyle.shimmerPrimary(context),
      highlightColor: AppColorStyle.shimmerSecondary(context),
      period: const Duration(milliseconds: 1500),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: 15,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColorStyle.surface(context),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
