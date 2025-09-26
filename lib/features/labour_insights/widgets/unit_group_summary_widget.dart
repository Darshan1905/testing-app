import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/labour_insights/labour_insight_bloc.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';

class UnitGroupSummaryWidget extends StatelessWidget {
  final UnitGroupDetailData ugDataModel;

  const UnitGroupSummaryWidget({Key? key, required this.ugDataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labourInsightBloc = RxBlocProvider.of<LabourInsightBloc>(context);
    String firstHalf = "", secondHalf = "",summaryValue="";
    if(ugDataModel.summary != null && ugDataModel.summary?.isNotEmpty == true && ugDataModel.summary != ""){

      summaryValue =  Utility.capitalizeAll(ugDataModel.summary.toString().toLowerCase());
      int stringLength = summaryValue.length;
      if (stringLength > 150) {
        firstHalf = summaryValue.substring(0, 150);
        secondHalf = summaryValue.substring(151, stringLength);
      } else {
        firstHalf = summaryValue;
        secondHalf = "";
      }
    }

    return Visibility(
      visible: (ugDataModel.summary != null && ugDataModel.summary!.isNotEmpty),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColorStyle.backgroundVariant(context),
            padding: const EdgeInsets.only(
                left: Constants.commonPadding,
                right: Constants.commonPadding,
                top: Constants.commonPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringHelper.summary,
                    style: AppTextStyle.titleSemiBold(
                        context, AppColorStyle.text(context))),
                const SizedBox(height: 10.0),

                //Course Description
                StreamWidget(
                  stream: labourInsightBloc.isViewMoreSubject,
                  onBuild: (_, snapshot) {
                    if (snapshot != null) {
                      return secondHalf == ""
                          ? Text(
                          summaryValue,
                          // "${ugDataModel.summary}",
                          style: AppTextStyle.captionRegular(
                              context, AppColorStyle.text(context)))
                          : RichText(
                        softWrap: true,
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text:
                          !labourInsightBloc.getViewMoreSubjectValue
                              ? "$firstHalf..."
                              : summaryValue,
                          style: AppTextStyle.captionRegular(
                              context, AppColorStyle.text(context)),
                          children: [
                            WidgetSpan(
                                child: InkWellWidget(
                                  onTap: () {
                                    labourInsightBloc.isViewMoreSubject.value =
                                    !labourInsightBloc
                                        .getViewMoreSubjectValue;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:8.0, right: 8.0),
                                    child: Text(
                                        labourInsightBloc
                                            .getViewMoreSubjectValue
                                            ? StringHelper.viewLess
                                            : StringHelper.viewMore,
                                        style: AppTextStyle.captionSemiBold(
                                            context,
                                            AppColorStyle.primary(context))),
                                  ),
                                ),
                                alignment: PlaceholderAlignment.middle)
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: Constants.commonPadding),
        ],
      ),
    );
  }
}
