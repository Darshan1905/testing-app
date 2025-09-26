import 'package:occusearch/common_widgets/google_apple_singin_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/get_my_policy/gmp_bloc.dart';

// ***************** Email Picker Widget ******************
showEmailPickerSheet(BuildContext context, Object data, GlobalBloc? globalBloc,
    int index, GetMyPolicyBloc? gmpBloc, bool isFromOVHC) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          color: AppColorStyle.background(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  StringHelper.emailRequired,
                  style: AppTextStyle.subHeadlineSemiBold(
                      context, AppColorStyle.text(context)),
                ),
                const SizedBox(height: 5.0),
                Divider(
                    color: AppColorStyle.disableVariant(context),
                    thickness: 0.5),
                const SizedBox(height: 10.0),
                Text(
                  "Choose your email address to proceed further",
                  style: AppTextStyle.detailsRegular(
                      context, AppColorStyle.text(context)),
                ),
                const SizedBox(height: 10.0),
                GoogleAppleSignInWidget(
                  isGoogle: true,
                  onTap: () {
                    //todo check loading and bool for this
                    if (gmpBloc!.isLoading) {
                      return;
                    }
                    if (NetworkController.isInternetConnected == false) {
                      Toast.show(context,
                          message: StringHelper.internetConnection,
                          type: Toast.toastError,
                          duration: 2);
                      return;
                    }
                    gmpBloc.googleSignIn(
                        context, data, globalBloc, index, isFromOVHC);
                  },
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        );
      });
}
