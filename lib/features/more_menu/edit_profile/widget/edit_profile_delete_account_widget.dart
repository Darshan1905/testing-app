import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/more_menu/edit_profile/edit_profile_bloc.dart';

import 'delete_account_dialog.dart';

class DeleteAccountWidget extends StatelessWidget {
  final Function onDeleteClick;
  final EditProfileBloc editProfileBloc;

  const DeleteAccountWidget({Key? key, required this.onDeleteClick, required this.editProfileBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColorStyle.surface(context),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            StringHelper.profileDeleteAccount,
            style: AppTextStyle.subTitleSemiBold(
              context,
              AppColorStyle.text(context),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            StringHelper.profileDeleteAccountDescription1,
            style: AppTextStyle.detailsRegular(
              context,
              AppColorStyle.textHint(context),
            ),
          ),
          const SizedBox(height: 15),
          InkWellWidget(
            onTap: () {
              if (editProfileBloc.isLoading) {
                return;
              }
              if (!NetworkController.isInternetConnected) {
                Toast.show(context,
                    message: StringHelper.internetConnection,
                    type: Toast.toastError);
                return;
              }
              deleteAccountDialog(
                  context: context,
                  onPositiveButtonClick: () {
                    FirebaseAnalyticLog.shared.eventTracking(
                        screenName: RouteName.moreMenu,
                        sectionName:
                            FBSectionEvent.fbSectionDeleteAccountRequest,
                        actionEvent: FBActionEvent.fbActionClick,
                        message: "Delete Account button click");
                    onDeleteClick();
                  },
                  editProfileBloc: editProfileBloc);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  StringHelper.profileDeleteMyAccount,
                  style: AppTextStyle.detailsSemiBold(
                    context,
                    ThemeConstant.red,
                  ),
                ),
                SvgPicture.asset(
                  IconsSVG.arrowRight,
                  height: 18.0,
                  width: 18.0,
                  colorFilter: ColorFilter.mode(
                    AppColorStyle.red(context),
                    BlendMode.srcIn,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future deleteAccountDialog(
      {required BuildContext context,
      required Function onPositiveButtonClick, required EditProfileBloc editProfileBloc}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteAccountDialog(
          onPositivePressed: () {
            Navigator.pop(context);
            onPositiveButtonClick();
          },
          editprofileBloc: editProfileBloc,
        );
      },
    );
  }
}
