import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class FundCalculatorQuestionShimmer extends StatelessWidget {
  const FundCalculatorQuestionShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
          baseColor: AppColorStyle.shimmerPrimary(context),
          highlightColor: AppColorStyle.shimmerSecondary(context),
          period: const Duration(milliseconds: 1500),
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30.0,
                  width: 180.0,
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 5.0,
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
                  height: 100.0,
                ),
                Container(
                  height: 50.0,
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

class SummaryChartHeaderShimmer extends StatelessWidget {
  const SummaryChartHeaderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      color: AppColorStyle.surface(context),
      child: Shimmer.fromColors(
          baseColor: AppColorStyle.backgroundVariant(context),
          highlightColor: AppColorStyle.shimmerPrimary(context),
          period: const Duration(milliseconds: 1500),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 5.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width / 5.5,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width / 5.5,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width / 5.5,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width / 5.5,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class SummaryChartShimmer extends StatelessWidget {
  const SummaryChartShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.shimmerSecondary(context),
        period: const Duration(milliseconds: 1500),
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30.0,
                width: 100.0,
                decoration: BoxDecoration(
                  color: AppColorStyle.surface(context),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: AppColorStyle.surface(context),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: AppColorStyle.surface(context),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: AppColorStyle.surface(context),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: AppColorStyle.surface(context),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: AppColorStyle.surface(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
