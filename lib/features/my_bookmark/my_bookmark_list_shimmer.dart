import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class MyBookmarkListShimmer extends StatelessWidget {
  const MyBookmarkListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 15, bottom: 8),
    child: Shimmer.fromColors(
      baseColor: AppColorStyle.shimmerPrimary(context),
      highlightColor: AppColorStyle.shimmerSecondary(context),
      period: const Duration(milliseconds: 1500),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: AppColorStyle.surface(context),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              height: 30,
              width: 150,
              decoration: BoxDecoration(
                color: AppColorStyle.surface(context),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
