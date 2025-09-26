import 'package:occusearch/constants/constants.dart';

class MoreMenuHeaderWidget extends StatelessWidget {
  final String fullName;
  final String phoneNumber;
  final String emailAddress;
  final Function onClick;

  const MoreMenuHeaderWidget(
      {Key? key,
      required this.fullName,
      required this.phoneNumber,
      required this.emailAddress,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String firstName = "";
    String lastName = "";
    if (fullName.toString().trim().contains(" ")) {
      firstName =
          fullName.toString().substring(0, fullName.toString().indexOf(" "));
      lastName = fullName.toString().substring(
          fullName.toString().indexOf(" "), fullName.toString().length);
    }
    return InkWellWidget(
      onTap: () {
        onClick();
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: AppColorStyle.primarySurface4(context).withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(right: 20.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColorStyle.primarySurface3(context)),
                  child: Text(
                    Utility.getInitials(fullName),
                    style: AppTextStyle.titleMedium(
                        context, AppColorStyle.cyan(context)),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      lastName.isNotEmpty
                          ? Text.rich(
                              TextSpan(
                                  text: Utility.capitalizeAllWords(firstName),
                                  style: AppTextStyle.titleMedium(
                                      context, AppColorStyle.text(context)),
                                  children: [
                                    TextSpan(
                                        text: Utility.capitalizeAllWords(
                                            lastName),
                                        style: AppTextStyle.titleMedium(context,
                                            AppColorStyle.text(context))),
                                  ]),
                            )
                          : Text(
                              fullName,
                              style: AppTextStyle.titleMedium(
                                  context, AppColorStyle.text(context)),
                            ),
                      (phoneNumber.isEmpty)
                          ? Text(
                              emailAddress,
                              style: AppTextStyle.detailsMedium(
                                  context, AppColorStyle.textDetail(context)),
                            )
                          : Text(
                              phoneNumber,
                              style: AppTextStyle.detailsMedium(
                                  context, AppColorStyle.textDetail(context)),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: SvgPicture.asset(IconsSVG.bgTopHeaderBlue, fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }
}
