import 'package:occusearch/common_widgets/no_internet_screen.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AIWebViewPage extends BaseApp {
  const AIWebViewPage({super.key}) : super.builder();

  @override
  AIWebViewPageState createState() => AIWebViewPageState();
}

class AIWebViewPageState extends BaseState {
  String link = "";

  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    link = FirebaseRemoteConfigController
            .shared.dynamicEndUrl!.general!.chatBotUrl ??
        "";

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(link))
      ..enableZoom(false);

    // if (Platform.isAndroid)
    //WebViewWidget.platform = SurfaceAndroidWebView(); // <<== THIS
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  init() {}

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColorStyle.background(context),
      body: NetworkController.isInternetConnected
          ? Container(
              color: AppColorStyle.backgroundVariant(context),
              child: SafeArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: WebViewWidget(
                        controller: controller,
                      ),
                    ),
                  ),
                ],
              )))
          : Center(
              child: NoInternetScreen(onRetry: () {
                if (NetworkController.isInternetConnected) {
                  setState(() {});
                } else {
                  Toast.show(context,
                      message: StringHelper.internetConnection,
                      type: Toast.toastError);
                }
              }),
            ),
    );
  }
}
