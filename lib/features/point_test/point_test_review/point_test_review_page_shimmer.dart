import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class PointTestCardShimmer extends StatelessWidget {
  const PointTestCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        shape: BoxShape.rectangle,
        color: AppColorStyle.surface(context),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.shimmerSecondary(context),
        period: const Duration(milliseconds: 1500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 1.8,
                  decoration: BoxDecoration(
                      color: AppColorStyle.surface(context),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PointTestReviewListShimmer extends StatelessWidget {
  const PointTestReviewListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const PointTestCardShimmer(),
              const SizedBox(height: 20),
              Shimmer.fromColors(
                baseColor: AppColorStyle.shimmerPrimary(context),
                highlightColor: AppColorStyle.shimmerSecondary(context),
                period: const Duration(milliseconds: 1500),
                child: SizedBox(
                  height: 600,
                  width: double.infinity,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        color: AppColorStyle.surface(
                                            context),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5.0)),
                                            color: AppColorStyle.surface(
                                                context),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          margin: const EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5.0)),
                                            color: AppColorStyle.surface(
                                                context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0)
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      );
}
