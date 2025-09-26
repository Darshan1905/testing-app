import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/custom_question/custom_question_bloc.dart';
import 'package:occusearch/features/custom_question/model/custom_question_model.dart';
import 'package:occusearch/features/custom_question/widgets/custom_question_answer_review_widget.dart';
import 'package:occusearch/features/visa_fees/model/visa_subclass_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';

class CustomQuestionAnswerReviewScreen extends BaseApp {
  const CustomQuestionAnswerReviewScreen({
    super.key,
    super.arguments,
  }) : super.builder();

  @override
  BaseState createState() => _CustomQuestionAnswerReviewScreenState();
}

class _CustomQuestionAnswerReviewScreenState extends BaseState {
  List<CustomQuestions>? customQuestionList = [];
  bool isFromEditProfileScreen = false;
  bool isFromDashboard = false;
  final VisaFeesBloc _visaBloc = VisaFeesBloc();
  final TextEditingController _searchController = TextEditingController();

  @override
  init() {
    _visaBloc.setSearchFieldController = _searchController;
    _visaBloc.getVisaSubclassData(context);
    Map<String, dynamic>? param = widget.arguments;
    if (param != null) {
      if (param['customQuestionList'] != null &&
          param['isFromEditProfileScreen'] != null) {
        customQuestionList = param['customQuestionList'];
        isFromEditProfileScreen = param['isFromEditProfileScreen'];
      }
      if(param['isFromDashboard'] != null){
        isFromDashboard = param['isFromDashboard'] != null;
      }
    }
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /*
        if (isFromEditProfileScreen) {
          context.popUntil(RouteName.editProfile);
        } else {
          GoRoutesPage.go(mode: NavigatorMode.push, moveTo: RouteName.home);
        }
        CustomQuestionBloc.setCurrentIndexValue = 0;
        */
        return false;
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColorStyle.primary(context),
        child: Padding(
            padding: const EdgeInsets.only(
                left: 30.0, top: 60, right: 30, bottom: 30),
            child: StreamWidget(
                stream: CustomQuestionBloc.getFirstAttemptStream,
                onBuild: (_, firstAttemptSnapShot) {
                  if (firstAttemptSnapShot != null) {
                    printLog("firstAttemptSnapShot====>$firstAttemptSnapShot");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Only ${customQuestionList?.length} simple steps",
                                style: AppTextStyle.subTitleRegular(context,
                                    AppColorStyle.primaryText(context))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(StringHelper.letsKnowYouBetter,
                            style: AppTextStyle.headlineSemiBold(
                                context, AppColorStyle.textWhite(context))),
                        StreamBuilder(
                            stream: _visaBloc.getVisaSubclassListStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                List<SubclassData>? visaFeesSubListValue =
                                    snapshot.data;
                                return CustomQuestionAnswerReviewWidget(
                                    customQuestionsList: customQuestionList,
                                    visaFeesSubListValue: visaFeesSubListValue,
                                    isFromEditProfileScreen:
                                        isFromEditProfileScreen,
                                    firstAttemptSnapShot: firstAttemptSnapShot);
                              }
                              return const Expanded(child: SizedBox(height: 50));
                            }),
                        ButtonWidget(
                          title: !isFromEditProfileScreen
                              ? StringHelper.submit
                              : StringHelper.savePreferences,
                          onTap: () {
                            //FINAL SUBMIT CALL
                            CustomQuestionBloc.submitCustomQuestionAnswersList(
                                context : context,
                                customQuestionsList:customQuestionList,
                                fromEditScreen: isFromEditProfileScreen,
                                firstAttemptFromEditScreen: firstAttemptSnapShot,
                                isFromDashboard : isFromDashboard,
                            );
                          },
                          logActionEvent:
                              FBActionEvent.fbActionCustomQuestionContinue,
                          textColor: AppColorStyle.primary(context),
                          buttonColor: AppColorStyle.textWhite(context),
                          arrowIconColor: AppColorStyle.primary(context),
                        ),
                        const SizedBox(height: 50),
                      ],
                    );
                  }
                })),
      ),
    );
  }
}
