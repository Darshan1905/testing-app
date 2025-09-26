import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class SoStateEligibilityShimmer extends StatelessWidget {
  const SoStateEligibilityShimmer({Key? key}) : super(key: key);

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

  static tabShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColorStyle.shimmerPrimary(context),
      highlightColor: AppColorStyle.shimmerSecondary(context),
      period: const Duration(milliseconds: 1500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tabShimmerWidget(context),
            tabShimmerWidget(context),
            tabShimmerWidget(context)
          ],
        ),
      ),
    );
  }

  static Widget tabShimmerWidget(context){
    return Container(
      height: 40,
      width: 90,
      decoration: BoxDecoration(
          color: AppColorStyle.grayColor(context),
          borderRadius: const BorderRadius.all(Radius.circular(3))),
    );
  }

  static stateEligibilityDetailsShimmer(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.shimmerSecondary(context),
        period: const Duration(milliseconds: 1500),
        child: Padding(
          padding: const EdgeInsets.only(top: 10,bottom: 20,left: 20,right: 20),
          child:  ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    color: AppColorStyle.surface(context),
                  ),
                );
              })
        ));
  }
}
