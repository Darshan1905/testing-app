import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_bloc.dart';

class LabourInsightChartWidget {
  static Widget viewModeWidget(BuildContext context,
      UnitGroupBloc? unitGroupBloc, UnitGroupChartDataType chart) {
    return StreamBuilder<bool>(
        stream: chart == UnitGroupChartDataType.WORKERS
            ? unitGroupBloc?.viewWorkersChartMode
            : chart == UnitGroupChartDataType.EARNINGS
                ? unitGroupBloc?.viewEarningsMode
                : chart == UnitGroupChartDataType.AGEPROFILE
                    ? unitGroupBloc?.viewAgeMode
                    : unitGroupBloc?.viewEducationMode,
        builder: (context, snapshot) {
          return InkWellWidget(
              onTap: () {
                if (chart == UnitGroupChartDataType.WORKERS) {
                  unitGroupBloc.setViewWorkersChartMode();
                } else if (chart == UnitGroupChartDataType.EARNINGS) {
                  unitGroupBloc.setViewEarningsChartMode();
                } else if (chart == UnitGroupChartDataType.AGEPROFILE) {
                  unitGroupBloc.setViewAgeChartMode();
                } else {
                  unitGroupBloc.setViewEducationChartMode();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: AppColorStyle.primarySurface1(context),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                width: 56,
                height: 28,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 1.0, left: 1.0),
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                      width: (chart == UnitGroupChartDataType.WORKERS
                              ? unitGroupBloc!.getViewWorkersChartMode
                              : chart == UnitGroupChartDataType.EARNINGS
                                  ? unitGroupBloc!.getViewEarningsChartMode
                                  : chart == UnitGroupChartDataType.AGEPROFILE
                                      ? unitGroupBloc!.getViewAgeChartMode
                                      : unitGroupBloc!
                                          .getViewEducationChartMode)
                          ? 26.0
                          : 82.0,
                      height: 26,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                      child: SvgPicture.asset(
                        (chart == UnitGroupChartDataType.WORKERS
                                ? unitGroupBloc.getViewWorkersChartMode
                                : chart == UnitGroupChartDataType.EARNINGS
                                    ? unitGroupBloc.getViewEarningsChartMode
                                    : chart == UnitGroupChartDataType.AGEPROFILE
                                        ? unitGroupBloc.getViewAgeChartMode
                                        : unitGroupBloc
                                            .getViewEducationChartMode)
                            ? IconsSVG.tableSolidViewIcon
                            : IconsSVG.barChartViewIcon,
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
