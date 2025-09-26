import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';

class SubscriptionDetailsDialog extends StatelessWidget {
  final bool? isDismissible;

  const SubscriptionDetailsDialog({
    super.key,
    this.isDismissible,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScopeWidget(
      onWillPop: () async {
        return isDismissible ?? true;
      },
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text("Action required: Service Modification alert.",
              textAlign: TextAlign.center,
              style:
                  AppTextStyle.titleBold(context, AppColorStyle.text(context))),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text:
                        "Effective immediately, our app is transitioning to a premium subscription model. You currently have 7 days of free access remaining. Upgrade now to unlock the full potential of our app.\nClick",
                    style: AppTextStyle.detailsRegular(
                        context, AppColorStyle.textHint(context)),
                  ),
                  WidgetSpan(
                      child: InkWellWidget(
                        onTap: () {
                          GoRoutesPage.go(
                              mode: NavigatorMode.push,
                              moveTo: RouteName.subscription);
                        },
                        child: Text(
                          " Learn More ",
                          style: AppTextStyle.detailsSemiBold(
                            context,
                            AppColorStyle.primary(context),
                          ),
                        ),
                      ),
                      alignment: PlaceholderAlignment.bottom),
                  TextSpan(
                    text:
                        "for details and to explore the benefits of our premium subscription.",
                    style: AppTextStyle.detailsRegular(
                        context, AppColorStyle.textHint(context)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 45,
              child: InkWellWidget(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Ink(
                  decoration: BoxDecoration(
                      color: AppColorStyle.primary(context),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringHelper.close,
                        style: AppTextStyle.subTitleMedium(
                          context,
                          AppColorStyle.textWhite(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
        backgroundColor: AppColorStyle.background(context),
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
