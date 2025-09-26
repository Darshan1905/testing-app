import 'package:occusearch/constants/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewDialog {
  static Future webview({required BuildContext context, required String url, isShow = false}) {
    final WebViewController controller = WebViewController()
      ..loadRequest(Uri.parse(url))
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    return showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Scaffold(
          body: Container(
            color: AppColorStyle.background(context),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                WebViewWidget(controller: controller),
                Container(
                  alignment: Alignment.topRight,
                  margin: isShow
                      ? const EdgeInsets.symmetric(vertical: 11.0, horizontal: 40.0)
                      : const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                  child: InkWellWidget(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      IconsSVG.cross,
                      colorFilter: ColorFilter.mode(
                        isShow ? Colors.black87 : Colors.white,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
