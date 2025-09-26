import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class OccupationDetailShimmer extends StatelessWidget {
  const OccupationDetailShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
    baseColor: AppColorStyle.shimmerPrimary(context),
    highlightColor: AppColorStyle.shimmerSecondary(context),
    period: const Duration(milliseconds: 1500),
    child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Row(
    children: [
    Container(
    height: 20,
    width: MediaQuery.of(context).size.width / 1.5,
    color: AppColorStyle.grayColor(context),
    )
    ],
    ),
    ),
    );
  }
}

