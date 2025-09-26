import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:rive/rive.dart';

class PurchaseStatusDialog extends StatelessWidget {
  final bool isSuccess;
  final bool? isDismissible;

  const PurchaseStatusDialog(
      {super.key, required this.isSuccess, required this.isDismissible});

  @override
  Widget build(BuildContext context) {
    return WillPopScopeWidget(
      onWillPop: () async {
        return isDismissible ?? true;
      },
      child: AlertDialog(
        backgroundColor: AppColorStyle.background(context),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              isSuccess
                  ? SizedBox(
                    height: MediaQuery.of(context).size.height / 4.5,
                    width: MediaQuery.of(context).size.height / 4,
                    child: const RiveAnimation.asset(
                      RiveAssets.congratulations,
                    ),
                  ) : Container(),
              Center(
                child: Text(isSuccess ? StringHelper.paymentSuccess : StringHelper.paymentFailed,
                    style: AppTextStyle.titleBold(
                        context,
                        isSuccess
                            ? AppColorStyle.primary(context)
                            : AppColorStyle.text(context))),
              ),
              const SizedBox(height: 20.0),
              Text(
                  isSuccess
                      ? StringHelper.paymentSuccessMessage
                      : StringHelper.paymentFailedMessage,
                  style: AppTextStyle.subTitleMedium(
                      context, AppColorStyle.text(context)),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: Container(
              height: 45,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColorStyle.primary(context),
              ),
              child: TextButton(
                child: Text(StringHelper.menuHome,
                    style: AppTextStyle.subTitleSemiBold(
                        context,
                        AppColorStyle.textWhite(context))),
                onPressed: () {
                  if (isSuccess) {
                    GoRoutesPage.go(
                        mode: NavigatorMode.remove, moveTo: RouteName.home);
                  }
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ),
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
