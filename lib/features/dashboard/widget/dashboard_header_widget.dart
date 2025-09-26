import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final UserInfoData? userData;
  GlobalBloc? globalBloc;

  DashboardHeaderWidget({Key? key, this.userData, this.globalBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello',
                  style: AppTextStyle.subTitleRegular(
                      context, AppColorStyle.textDetail(context)),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  Utility.capitalizeAllWords(
                    userData?.name ?? '',
                  ),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.subHeadlineSemiBold(
                      context, AppColorStyle.text(context)),
                ),
              ],
            ),
          ),
          InkWellWidget(
            onTap: () {
              GoRoutesPage.go(
                  mode: NavigatorMode.push, moveTo: RouteName.subscription);
            },
            child: Container(
              width: 90.0,
              alignment: Alignment.center,
              height: 30.0,
              margin: const EdgeInsets.only(right: 10.0, top: 20.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              decoration: BoxDecoration(
                  color: (userData!.subRemainingDays ?? 0) > 5 ? AppColorStyle.greenVariant(context) : AppColorStyle.redText(context),
                  borderRadius: BorderRadius.circular(100.0)),
              child: Text(
                "${userData?.subRemainingDays} Days Left",
                style: AppTextStyle.captionMedium(
                    context, (userData!.subRemainingDays ?? 0) > 5 ? AppColorStyle.green(context) : AppColorStyle.red(context)),
              ),
            ),
          )
          /*InkWellWidget(
            onTap: () {
              if (NetworkController.isInternetConnected) {
                GoRoutesPage.go(
                    mode: NavigatorMode.push,
                    moveTo: RouteName.recentUpdateScreen);
              } else {
                Toast.show(context,
                    message: StringHelper.internetConnection,
                    gravity: Toast.toastTop,
                    duration: 3,
                    type: Toast.toastError);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: AppColorStyle.backgroundVariant(context),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              child: SvgPicture.asset(
                IconsSVG.notification,
                height: 24.0,
                width: 24.0,
                colorFilter: ColorFilter.mode(
                    AppColorStyle.text(context), BlendMode.srcIn),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
