import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class VisaFeesSubclassShimmer extends StatelessWidget {
  const VisaFeesSubclassShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 90,
              child: Shimmer.fromColors(
                baseColor: AppColorStyle.shimmerPrimary(context),
                highlightColor: AppColorStyle.surface(context),
                period: const Duration(milliseconds: 1500),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        width: 100.0,
                        decoration: BoxDecoration(
                          color: AppColorStyle.surface(context),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColorStyle.surface(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
}

class VisaFeesQuestionShimmer extends StatelessWidget {
  const VisaFeesQuestionShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 450,
        child: Shimmer.fromColors(
          baseColor: AppColorStyle.shimmerPrimary(context),
          highlightColor: AppColorStyle.surface(context),
          period: const Duration(milliseconds: 1500),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColorStyle.surface(context),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
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
                    height: 50,
                    width: 150.0,
                    decoration: BoxDecoration(
                      color: AppColorStyle.surface(context),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
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
                    height: 50,
                    width: 150.0,
                    decoration: BoxDecoration(
                      color: AppColorStyle.surface(context),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
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
                    height: 50,
                    width: 150.0,
                    decoration: BoxDecoration(
                      color: AppColorStyle.surface(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VisaFeesApplicantShimmer extends StatelessWidget {
  const VisaFeesApplicantShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
          color: AppColorStyle.purpleVariant1(context),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(20.0),
      child: Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.surface(context),
        period: const Duration(milliseconds: 1500),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                color: AppColorStyle.surface(context),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VisaFeesCalculationShimmer extends StatelessWidget {
  const VisaFeesCalculationShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColorStyle.surface(context),
          borderRadius: const BorderRadius.all(Radius.circular(2.0))),
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
      child: Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.surface(context),
        period: const Duration(milliseconds: 1500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              height: 10.0,
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
              height: 10.0,
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
              height: 10.0,
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: AppColorStyle.surface(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

