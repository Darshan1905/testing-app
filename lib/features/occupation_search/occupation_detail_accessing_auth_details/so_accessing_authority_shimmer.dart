import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class SoAccessingAuthorityShimmer extends StatelessWidget {
  const SoAccessingAuthorityShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.shimmerSecondary(context),
        period: const Duration(milliseconds: 1500),
        child: Padding(
          padding: EdgeInsets.only(
            top: 15.0 + MediaQuery.of(context).viewPadding.top,
            left: 25.0,
            right: 25.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    IconsSVG.arrowBack,
                    colorFilter: ColorFilter.mode(
                      AppColorStyle.grayColor(context),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    height: 25,
                    width: 250,
                    color: AppColorStyle.grayColor(context),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                height: 25,
                width: 150,
                color: AppColorStyle.grayColor(context),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ));
  }

  static Widget titleShimmer(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.shimmerSecondary(context),
        period: const Duration(milliseconds: 1500),
        child: Container(
          height: 25,
          width: double.infinity,
          color: AppColorStyle.grayColor(context),
        ));
  }

  static Widget feesLinkShimmer(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.shimmerSecondary(context),
        period: const Duration(milliseconds: 1500),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 20.0,
              height: 20.0,
              color: AppColorStyle.grayColor(context),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 15,
                  width: 80,
                  color: AppColorStyle.grayColor(context),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Container(
                      height: 15,
                      width: 80,
                      color: AppColorStyle.grayColor(context),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      width: 10.0,
                      height: 10.0,
                      color: AppColorStyle.grayColor(context),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
