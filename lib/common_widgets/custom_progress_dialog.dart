import 'package:occusearch/constants/constants.dart';
import 'package:rive/rive.dart';

class CustomProgressDialog extends StatelessWidget {
  const CustomProgressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
          color: AppColorStyle.backgroundVariant(context),
          borderRadius: const BorderRadius.all(Radius.circular(100))),
      child: const SizedBox(
        height: 50,
        width: 50,
        child: RiveAnimation.asset(RiveAssets.loader),
      ),
    );
  }
}
