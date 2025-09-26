import 'package:occusearch/constants/constants.dart';

class LabelLineWidget extends StatelessWidget {
  const LabelLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    printLog(
      MediaQuery.of(context).size.width / 3,
    );
    return SizedBox(
      height: 20.0,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 3.0,
              decoration: const BoxDecoration(),
              width: MediaQuery.of(context).size.width / 3,
              color: AppColorStyle.primary(context),
            ),
          ),
          Container(
            height: 1.0,
            color: AppColorStyle.red(context),
          ),
        ],
      ),
    );
  }
}
