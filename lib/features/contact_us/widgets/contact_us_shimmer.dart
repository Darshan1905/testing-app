import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class ContactUsCountryShimmer extends StatelessWidget {
  const ContactUsCountryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorStyle.surface(context),
      height: 54,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.shimmerSecondary(context),
        period: const Duration(milliseconds: 1500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                  color: AppColorStyle.surface(context),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            ),
            Container(
              width: 80,
              decoration: BoxDecoration(
                  color: AppColorStyle.surface(context),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            ),
            Container(
              width: 80,
              decoration: BoxDecoration(
                  color: AppColorStyle.surface(context),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactUsBranchListShimmer extends StatelessWidget {
  const ContactUsBranchListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        decoration: BoxDecoration(
            color: AppColorStyle.surface(context),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        height: 180,
        child: Shimmer.fromColors(
          baseColor: AppColorStyle.shimmerPrimary(context),
          highlightColor: AppColorStyle.shimmerSecondary(context),
          period: const Duration(milliseconds: 1500),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          height: 20,
                          width: 100,
                          color: AppColorStyle.surface(context)),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 20,
                            width: 20,
                            color: AppColorStyle.surface(context)),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Container(
                              height: 50,
                              color: AppColorStyle.surface(context)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Container(
                            height: 20,
                            width: 20,
                            color: AppColorStyle.surface(context)),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Container(
                              height: 20,
                              color: AppColorStyle.surface(context)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
