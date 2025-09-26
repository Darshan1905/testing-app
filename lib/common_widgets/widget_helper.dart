import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:occusearch/constants/constants.dart';

import 'custom_alert_dialog.dart';

class WidgetHelper {
  static Future alertDialogWidget(
      {required BuildContext context,
      required String title,
      required String message,
      Color? buttonColor,
      String positiveButtonTitle = "Save",
      String negativeButtonTitle = "Dismiss",
      bool isFromAppUpdate = false,
      required Function onPositiveButtonClick,
      bool isDismissible = true}) {
    //is isDismissible is true because if dialog should dismiss on back press, it is false only for force update dialog
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          isDismissible: isDismissible,
          message: message,
          bgColor: AppColorStyle.background(context),
          title: title,
          buttonColor: buttonColor,
          positiveBtnText: positiveButtonTitle,
          isFromAppUpdate: isFromAppUpdate,
          onPositivePressed: () {
            Navigator.pop(context);
            onPositiveButtonClick();
          },
          negativeBtnText: negativeButtonTitle,
          onNegativePressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  static showAlertDialog(BuildContext context,
      {String contentText = '', bool isHTml = false, String title = ''}) {
    // set up the close button
    Widget popUpContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isHTml
            ? HtmlWidget(
                contentText,
                textStyle: AppTextStyle.captionRegular(
                  context,
                  AppColorStyle.text(context),
                ),
                renderMode: RenderMode.column,
              )
            : Text(
                contentText,
                style: AppTextStyle.captionRegular(
                  context,
                  AppColorStyle.text(context),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InkWellWidget(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Text(StringHelper.close,
                  style: AppTextStyle.detailsMedium(
                    context,
                    AppColorStyle.textHint(context),
                  )),
            ),
          ),
        ),
      ],
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: AppColorStyle.background(context),
      title: title.isNotEmpty
          ? Text(title,
              style: AppTextStyle.titleSemiBold(
                context,
                AppColorStyle.text(context),
              ))
          : null,
      titlePadding: title.isNotEmpty
          ? const EdgeInsets.only(top: 15, left: 15, right: 15)
          : null,
      content: popUpContent,
      contentPadding: const EdgeInsets.all(15),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showAlertNotesDialog(BuildContext context,
      {required List<String> contentText, String title = ''}) {
    // set up the close button
    Widget popUpContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Column(
            children: List.generate(
              contentText.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 5.0,
                      height: 5.0,
                      margin: const EdgeInsets.only(right: 5.0, top: 6.0),
                      decoration: BoxDecoration(
                          color: AppColorStyle.text(context),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0))),
                    ),
                    Expanded(
                      child: Text(
                        contentText[index],
                        textAlign: TextAlign.start,
                        style: AppTextStyle.captionRegular(
                          context,
                          AppColorStyle.text(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InkWellWidget(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Text(StringHelper.close,
                  style: AppTextStyle.detailsMedium(
                    context,
                    AppColorStyle.textHint(context),
                  )),
            ),
          ),
        ),
      ],
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: title.isNotEmpty
          ? Center(
              child: Text(title,
                  style: AppTextStyle.titleSemiBold(
                    context,
                    AppColorStyle.text(context),
                  )),
            )
          : null,
      titlePadding: title.isNotEmpty
          ? const EdgeInsets.only(top: 15, left: 15, right: 15)
          : null,
      content: popUpContent,
      contentPadding: const EdgeInsets.all(15),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
