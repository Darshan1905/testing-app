import 'package:occusearch/constants/constants.dart';

class AboutAndLegalWidget extends StatelessWidget {
  const AboutAndLegalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: AppColorStyle.background(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //privacy policy
            InkWellWidget(
              onTap: () {
                FirebaseAnalyticLog.shared.eventTracking(
                    screenName: RouteName.aboutAndLegal,
                    actionEvent: FBActionEvent.fbActionPrivacyPolicy,
                    message: Constants.policyURL,
                    subSectionName: FBSectionEvent.fbSectionPrivacyPolicy);

                Utility.launchURL(Constants.policyURL);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconsSVG.icPrivacyPolicy,
                      colorFilter: ColorFilter.mode(
                        AppColorStyle.text(context),
                        BlendMode.srcIn,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            StringHelper.menuPrivacyPolicy,
                            style: AppTextStyle.titleMedium(
                                context, AppColorStyle.text(context)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            StringHelper.privacySubNote,
                            style: AppTextStyle.subTitleRegular(
                                context, AppColorStyle.textHint(context)),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
            const SizedBox(
              height: 35,
            ),
            //terms and condition
            InkWellWidget(
              onTap: () {
                FirebaseAnalyticLog.shared.eventTracking(
                    screenName: RouteName.aboutAndLegal,
                    actionEvent: FBActionEvent.fbActionTermsAndCondition,
                    message: Constants.termsURL,
                    sectionName: FBSectionEvent.fbSectionTermsAndCondition);

                Utility.launchURL(Constants.termsURL);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconsSVG.icTermsConditions,
                      height: 24.0,
                      width: 24.0,
                      colorFilter: ColorFilter.mode(
                        AppColorStyle.text(context),
                        BlendMode.srcIn,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            StringHelper.menuTermsAndCondition,
                            style: AppTextStyle.titleMedium(
                                context, AppColorStyle.text(context)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            StringHelper.termsSubNote,
                            style: AppTextStyle.subTitleRegular(
                                context, AppColorStyle.textHint(context)),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
            const SizedBox(
              height: 35,
            ),
            //code of conduct
            InkWellWidget(
              onTap: () {
                FirebaseAnalyticLog.shared.eventTracking(
                    screenName: RouteName.aboutAndLegal,
                    actionEvent: FBActionEvent.fbCodeOfConduct,
                    message: Constants.cocURL,
                    sectionName: FBActionEvent.fbCodeOfConduct);

                GoRoutesPage.go(
                    mode: NavigatorMode.push, moveTo: RouteName.pdfViewer);

                //Utility.launchURL(Constants.cocURL);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconsSVG.icCodeOfConduct,
                      height: 24.0,
                      width: 24.0,
                      colorFilter: ColorFilter.mode(
                        AppColorStyle.text(context),
                        BlendMode.srcIn,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              StringHelper.codeOfConduct,
                              style: AppTextStyle.titleMedium(
                                  context, AppColorStyle.text(context)),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            StringHelper.codeOfConductSubNote,
                            style: AppTextStyle.subTitleRegular(
                                context, AppColorStyle.textHint(context)),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
