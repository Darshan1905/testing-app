import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';

class AdsDialog {
  static showAdsDialog({required BuildContext context, required String bannerURL, required String redirectURL}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          onBannerClick: () async {
            await SharedPreferenceController.setAdsBannerClickStatus(true);
            Navigator.pop(context);
            Utility.launchURL(redirectURL);
          },
          onCloseClick: () {
            Navigator.pop(context);
          },
          adsBannerURL: bannerURL,
        );
      },
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final Function onBannerClick;
  final Function onCloseClick;
  final String adsBannerURL;

  const CustomAlertDialog(
      {super.key,
      required this.onBannerClick,
      required this.onCloseClick,
      required this.adsBannerURL});

  @override
  Widget build(BuildContext context) {
    return WillPopScopeWidget(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        title: null,
        content: Stack(
          children: [
            InkWellWidget(
              onTap: () {
                onBannerClick();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 25.0),
                color: Colors.transparent,
                child: Image.network(
                  adsBannerURL,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWellWidget(
                onTap: () {
                  onCloseClick();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 0.0),
                  padding: const EdgeInsets.all(0.1),
                  width: 20.0,
                  height: 20.0,
                  alignment: Alignment.topRight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: SvgPicture.asset(
                    IconsSVG.cross,
                    colorFilter: ColorFilter.mode(
                      AppColorStyle.red(context),
                      BlendMode.srcIn,
                    ),
                    width: 20.0,
                    height: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        scrollable: true,
      ),
    );
  }
}
