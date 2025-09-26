import 'package:occusearch/constants/constants.dart';

class WidgetProcess extends StatelessWidget {
  const WidgetProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.0,
      height: 20.0,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColorStyle.primary(context),
        ),
      ),
    );
  }
}
