import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class SOEoiStatisticsShimmer extends StatelessWidget {
  const SOEoiStatisticsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
        color: AppColorStyle.surface(context),
      ),
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: AppColorStyle.shimmerPrimary(context),
            highlightColor: AppColorStyle.shimmerSecondary(context),
            period: const Duration(milliseconds: 1500),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)),
                color: AppColorStyle.surface(context),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: AppColorStyle.shimmerPrimary(context),
                    highlightColor: AppColorStyle.shimmerSecondary(context),
                    period: const Duration(milliseconds: 1500),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColorStyle.surface(context),
                              width: 0.5)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            tableValueRaw(context),
                            tableValueRaw(context),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  static Widget tableValueRaw(context) {
    return Container(
      height: 30,
      width: 70,
      decoration: BoxDecoration(
          color: AppColorStyle.surface(context), shape: BoxShape.rectangle),
    );
  }

  static Widget titleShimmer(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: AppColorStyle.grayColor(context),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Shimmer.fromColors(
        baseColor: AppColorStyle.shimmerPrimary(context),
        highlightColor: AppColorStyle.shimmerSecondary(context),
        period: const Duration(milliseconds: 1500),
        child: Container(
          height: 30,
          width: double.infinity,
          color: AppColorStyle.grayColor(context),
        ),
      ),
    );
  }

  static Widget graphShimmer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: AppColorStyle.shimmerPrimary(context),
              highlightColor: AppColorStyle.shimmerSecondary(context),
              period: const Duration(milliseconds: 1500),
              child: Center(
                child: Container(
                  height: 230,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColorStyle.grayColor(context),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: 140,
                width: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColorStyle.textWhite(context)),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Shimmer.fromColors(
          baseColor: AppColorStyle.shimmerPrimary(context),
          highlightColor: AppColorStyle.shimmerSecondary(context),
          period: const Duration(milliseconds: 1500),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColorStyle.grayColor(context)),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
