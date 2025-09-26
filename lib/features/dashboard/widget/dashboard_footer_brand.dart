import 'package:occusearch/constants/constants.dart';

class DashboardFooterBrandWidget extends StatelessWidget {
  const DashboardFooterBrandWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorStyle.backgroundVariant(context),
      width: double.infinity,
      padding:
          const EdgeInsets.only(top: 25.0, bottom: 40, left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Know",
            style: TextStyle(
                color: AppColorStyle.textHint(context),
                fontSize: 32.0,
                fontWeight: FontWeight.bold),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -5.0, 0.0),
            child: Text(
              "it here!",
              style: TextStyle(
                  color: AppColorStyle.textHint(context),
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -0.0, 0.0),
            child: FittedBox(
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: "and fulfill your dreams with ",
                      style: AppTextStyle.titleMedium(
                          context, AppColorStyle.textHint(context)),
                    ),
                    WidgetSpan(
                        child: InkWellWidget(
                          onTap: () {
                            Utility.launchURL(Constants.aussizzWebsiteUrl);
                          },
                          child: Image.asset(
                            IconsPNG.icAussizzLogo,
                            fit: BoxFit.contain,
                            scale: 1,
                            height: 30,
                          ),
                        ),
                        alignment: PlaceholderAlignment.middle),
                    TextSpan(
                      text: "  Aussizz Group",
                      style: AppTextStyle.titleSemiBold(
                          context, AppColorStyle.textHint(context)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
