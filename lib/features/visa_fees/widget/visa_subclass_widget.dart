import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/visa_fees/model/visa_subclass_model.dart';

class VisaSubclassWidget extends StatelessWidget {
  final SubclassData subclass;
  final int index;
  final bool isLastItem;
  final Function onItemClick;

  const VisaSubclassWidget(
      {super.key,
      required this.subclass,
      required this.index,
      required this.isLastItem,
      required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    String subClassCode = "";
    String visaTypeName = subclass.name!.toLowerCase();
    if (visaTypeName.contains("(subclass") ||
        visaTypeName.contains("( subclass")) {
      int startingIndex = visaTypeName.contains("(subclass")
          ? visaTypeName.indexOf("(subclass")
          : visaTypeName.indexOf("( subclass");
      int endIndex = visaTypeName.indexOf(")", startingIndex);
      if (index != -1) {
        subClassCode = subclass.name!.substring(startingIndex,
            visaTypeName.length > endIndex ? endIndex + 1 : endIndex);
        visaTypeName = subclass.name!.replaceAll(subClassCode, "");
        subClassCode = subclass.name!.substring(startingIndex + 1, endIndex);
      }
    } else {
      visaTypeName = subclass.name!;
    }

    return InkWellWidget(
      onTap: () {
        if (NetworkController.isInternetConnected == true) {
          GoRoutesPage.go(
              mode: NavigatorMode.push,
              moveTo: RouteName.primaryApplicantScreen,
              param: subclass);
        } else {
          Toast.show(context,
              message: StringHelper.internetConnection,
              type: Toast.toastError,
              duration: 2);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Text(
              subClassCode,
              style: AppTextStyle.subTitleSemiBold(
                context,
                AppColorStyle.text(context),
              ),
            ),
            Text(
              visaTypeName,
              style:
                  AppTextStyle.detailsRegular(context, ThemeConstant.textDetail
                      // AppColorStyle.textDetail(context),
                      ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            isLastItem
                ? Container()
                : Divider(
                    thickness: 0.5,
                    color: AppColorStyle.surfaceVariant(context),
                  ),
          ],
        ),
      ),
    );
  }
}
