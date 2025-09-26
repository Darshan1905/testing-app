import 'package:occusearch/common_widgets/dash_divider_widget.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/custom_question/custom_question_bloc.dart';
import 'package:occusearch/features/custom_question/model/custom_question_model.dart';

class CustomQuestionOnbordingListWidget extends StatelessWidget {
  const CustomQuestionOnbordingListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StreamWidget(
        stream: CustomQuestionBloc.getCustomQuestionsListStream,
        onBuild: (_, snapshot) {
          List<CustomQuestions>? customQuestionsList = snapshot;
          return Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 60, bottom: 60),
                itemCount: customQuestionsList?.length,
                itemBuilder: (context, index) {
                  final item = customQuestionsList![index];
                  return (item.primary == true)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 12,
                                  width: 12,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColorStyle.primarySurface1(context),
                                  ),
                                ),

                                ///TODO remove static height
                                (customQuestionsList.length - 1 != index)
                                    ? Container(
                                        height: 60,
                                        alignment: Alignment.center,
                                        child: DashDividerWidget(
                                            direction: Axis.vertical))
                                    : Container()
                              ],
                            ),
                            const SizedBox(height: 40, width: 8),
                            Expanded(
                              child: Text(item.question ?? "",
                                  style: AppTextStyle.subTitleMedium(context,
                                      AppColorStyle.primaryText(context))),
                            ),
                          ],
                        )
                      : const SizedBox();
                }),
          );
        },
      ),
    );
  }
}
