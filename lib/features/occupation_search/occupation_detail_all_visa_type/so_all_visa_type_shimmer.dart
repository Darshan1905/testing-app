import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class SoAllVisaTypeShimmer extends StatelessWidget {
  const SoAllVisaTypeShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColorStyle.shimmerPrimary(context),
      highlightColor: AppColorStyle.shimmerSecondary(context),
      period: const Duration(milliseconds: 1500),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 20, color: AppColorStyle.grayColor(context)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 100,
                                    color: AppColorStyle.grayColor(context)),
                                const SizedBox(width: 10),
                                Container(
                                    decoration: BoxDecoration(
                                      color: AppColorStyle.grayColor(context),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 20,
                                    width: 60)
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
