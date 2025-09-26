import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/webview_dialog.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/more_menu/edit_profile/edit_profile_bloc.dart';

class DeleteAccountDialog extends StatelessWidget {
  final Function? onPositivePressed;
  final EditProfileBloc editprofileBloc;

  const DeleteAccountDialog({
    super.key,
    this.onPositivePressed,
    required this.editprofileBloc,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> deleteAccountContent = [
      StringHelper.profileDeleteDialogDesc1,
      StringHelper.profileDeleteDialogDesc2,
      StringHelper.profileDeleteDialogDesc3,
      StringHelper.profileDeleteDialogDesc4
    ];

    return Scaffold(
      body: Container(
        color: AppColorStyle.background(context),
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: InkWellWidget(
                      child: SvgPicture.asset(
                        IconsSVG.arrowBack,
                        height: 24.0,
                        width: 24.0,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        ),
                      ),
                      onTap: () => Navigator.pop(context)),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(StringHelper.profileDeleteAccountDialogTitle,
                      style: AppTextStyle.subHeadlineSemiBold(
                          context, AppColorStyle.primaryVariant1(context))),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    deleteAccountContent.length,
                    (index) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 1.5),
                              child: Text(
                                '●   ',
                                style: AppTextStyle.detailsSemiBold(
                                  context,
                                  AppColorStyle.text(context),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                deleteAccountContent[index],
                                textAlign: TextAlign.justify,
                                style: AppTextStyle.detailsMedium(
                                  context,
                                  AppColorStyle.text(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<bool>(
                  stream: editprofileBloc.getConditionAgree,
                  builder: (_, snapshot) {
                    return snapshot.hasData && snapshot.data == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: InkWellWidget(
                              onTap: () => editprofileBloc
                                  .onClickConditionCheckbox(false),
                              child: SvgPicture.asset(
                                IconsSVG.redCheckBoxFill,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: InkWellWidget(
                              onTap: () => editprofileBloc
                                  .onClickConditionCheckbox(true),
                              child: SvgPicture.asset(IconsSVG.redCheckBox,
                                  width: 24, height: 24),
                            ),
                          );
                  },
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: StringHelper.createAccountTerms1,
                          style: AppTextStyle.detailsRegular(
                            context,
                            AppColorStyle.textDetail(context),
                          ),
                        ),
                        WidgetSpan(
                          child: InkWellWidget(
                            onTap: () {
                              WebviewDialog.webview(
                                  context: context, url: Constants.termsURL);
                            },
                            child: Text(
                              StringHelper.createAccountTerms2,
                              style: AppTextStyle.detailsMedium(
                                context,
                                AppColorStyle.primary(context),
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: StringHelper.createAccountTerms3,
                          style: AppTextStyle.detailsRegular(
                            context,
                            AppColorStyle.textDetail(context),
                          ),
                        ),
                        WidgetSpan(
                          child: InkWellWidget(
                            onTap: () {
                              WebviewDialog.webview(
                                  context: context, url: Constants.policyURL);
                            },
                            child: Text(
                              StringHelper.createAccountTerms4,
                              style: AppTextStyle.detailsMedium(
                                context,
                                AppColorStyle.primary(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            InkWellWidget(
              child: Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  color: AppColorStyle.primary(context),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                margin: const EdgeInsets.only(bottom: 15.0),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Center(
                  child: Text(StringHelper.profileDeleteAccountDialogButton,
                      style: AppTextStyle.subTitleMedium(
                          context, AppColorStyle.textWhite(context))),
                ),
              ),
              onTap: () {
                if (NetworkController.isInternetConnected) {
                  if (editprofileBloc.getConditionAgreeOrNot == true) {
                    if (onPositivePressed != null) {
                      onPositivePressed!();
                    }
                  } else {
                    Toast.show(context,
                        message: StringHelper.createAccountTermsCondition,
                        type: Toast.toastError,
                        gravity: Toast.toastTop,
                        duration: 3);
                  }
                } else {
                  Toast.show(context,
                      message: StringHelper.internetConnection,
                      type: Toast.toastError,
                      gravity: Toast.toastTop,
                      duration: 3);
                }
              },
            ),
          ],
        ),
      ),
    );
    /*return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Row(
        children: [
          Expanded(
            child: Text(StringHelper.profileDeleteAccountDialogTitle,
                style: AppTextStyle.subHeadlineSemiBold(
                    context, AppColorStyle.primaryVariant1(context))),
          ),
          InkWellWidget(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                child: SvgPicture.asset(
                  IconsSVG.cross,
                  height: 20.0,
                  width: 20.0,
                  colorFilter: ColorFilter.mode(
                    AppColorStyle.textHint(context),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              onTap: () => Navigator.pop(context))
        ],
      ),
      content: Column(
        children: List.generate(
          deleteAccountContent.length,
          (index) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.5),
                child: Text(
                  '●  ',
                  style: AppTextStyle.detailsSemiBold(
                    context,
                    AppColorStyle.text(context),
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  deleteAccountContent[index],
                  textAlign: TextAlign.justify,
                  style: AppTextStyle.detailsMedium(
                    context,
                    AppColorStyle.text(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColorStyle.background(context),
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      actions: <Widget>[
        InkWellWidget(
          child: Container(
            decoration: BoxDecoration(
              color: AppColorStyle.primary(context),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            margin: const EdgeInsets.only(bottom: 15.0),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Text(StringHelper.profileDeleteAccountDialogButton,
                style: AppTextStyle.subTitleMedium(
                    context, AppColorStyle.textWhite(context))),
          ),
          onTap: () {
            if (NetworkController.isInternetConnected) {
              if (onPositivePressed != null) {
                onPositivePressed!();
              }
            } else {
              Toast.show(context,
                  message: StringHelper.internetConnection,
                  type: Toast.toastError,
                  gravity: Toast.toastTop,
                  duration: 3);
            }
          },
        ),
      ],
    );*/
  }
}
