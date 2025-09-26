import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/no_internet_screen.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';
import 'package:occusearch/features/labour_insights/labour_insight_bloc.dart';
import 'package:occusearch/features/labour_insights/labour_insights_detail_screen.dart';
import 'package:occusearch/features/labour_insights/widgets/labour_insight_screen_shimmer.dart';

class LabourInsightOccupationScreen extends BaseApp {
  const LabourInsightOccupationScreen({super.key, super.arguments})
      : super.builder();

  @override
  BaseState createState() => _SoUnitGroupScreenState();
}

class _SoUnitGroupScreenState extends BaseState {
  LabourInsightBloc? labourInsightBloc;

  @override
  init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  initData() async {
    //unit_group group - labour Insights detail Api call
    var unitGroupId = widget.arguments;
    if (unitGroupId != null) {
      labourInsightBloc?.getLabourInsightsDetailData(
          context, unitGroupId, true);
    }
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    labourInsightBloc ??= RxBlocProvider.of<LabourInsightBloc>(context);
    return RxBlocProvider(
      create: (_) => labourInsightBloc!,
      child: StreamBuilder<bool>(
          stream: labourInsightBloc!.isLabourLoading.stream,
          builder: (context, snapshotLoader) {
            return StreamBuilder<UnitGroupDetailData>(
              stream: labourInsightBloc?.unitGroupDetailsDataObject.stream,
              builder: (context, snapshot) {
                if (snapshotLoader.hasData) {
                  if (snapshotLoader.data == true) {
                    return const LabourInsightScreenShimmer(
                      isActionBarShow: false,
                    );
                  }
                  if (snapshot.data != null) {
                    return const LabourInsightDetail();
                  } else {
                    return Container(
                      color: AppColorStyle.background(context),
                      child: Center(
                        child: NetworkController.isInternetConnected
                            ? NoDataFoundScreen(
                                noDataTitle: StringHelper.noDataFound,
                                noDataSubTitle:
                                    StringHelper.tryAgainWithDiffCriteria,
                              )
                            : NoInternetScreen(
                                onRetry: () {
                                  initData();
                                },
                              ),
                      ),
                    );
                  }
                } else {
                  return const SizedBox();
                }
              },
            );
          }),
    );
  }
}
