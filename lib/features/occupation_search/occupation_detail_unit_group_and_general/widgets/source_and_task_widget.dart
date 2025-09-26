import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';

// Source and Task Widget
class SourceAndTaskWidget extends StatelessWidget {
  const SourceAndTaskWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchOccupationBloc =
        RxBlocProvider.of<OccupationDetailBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (searchOccupationBloc.getOccupationOtherInfoData.ugTaskInclude !=
                    null &&
                searchOccupationBloc
                    .getOccupationOtherInfoData.ugTaskInclude!.isNotEmpty)
            ? showTaskDataWidget(context, searchOccupationBloc)
            : Container(),
        showSourceDataWidget(context, searchOccupationBloc)
      ],
    );
  }

  static showTaskDataWidget(
      BuildContext context, OccupationDetailBloc searchOccupationBloc) {
    List<String> taskList = [];
    if (searchOccupationBloc.getOccupationOtherInfoData.ugTaskInclude != null &&
        searchOccupationBloc
            .getOccupationOtherInfoData.ugTaskInclude!.isNotEmpty) {
      taskList = searchOccupationBloc.getOccupationOtherInfoData.ugTaskInclude!
          .split("\n");

      return taskList.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColorStyle.background(context),
              ),
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 15, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      StringHelper.tasks,
                      style: AppTextStyle.titleSemiBold(
                          context, AppColorStyle.text(context)),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                                taskList.length,
                                (index) =>
                                    tasksListWidget(context, taskList[index])),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          : Container();
    }
  }

  static tasksListWidget(BuildContext context, String index) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\u2022 ",
              style: AppTextStyle.captionRegular(
                context,
                AppColorStyle.text(context),
              ),
            ),
            Expanded(
              child: Text(
                index.toString(),
                textAlign: TextAlign.left,
                style: AppTextStyle.detailsRegular(
                    context, AppColorStyle.text(context)),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  static showSourceDataWidget(
      BuildContext context, OccupationDetailBloc searchOccupationBloc) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColorStyle.background(context),
      ),
      padding: const EdgeInsets.only(left: 20, bottom: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 15, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.sources,
              style: AppTextStyle.titleSemiBold(
                  context, AppColorStyle.text(context)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  searchOccupationBloc.getOccupationOtherInfoData.ugName !=
                              null &&
                          searchOccupationBloc
                              .getOccupationOtherInfoData.ugName!.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "\u2022 ",
                              style: AppTextStyle.captionRegular(
                                context,
                                AppColorStyle.text(context),
                              ),
                            ),
                            Expanded(
                              child: InkWellWidget(
                                child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      style: AppTextStyle.detailsRegular(
                                          context, AppColorStyle.text(context)),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${StringHelper.australianStatistics} ${searchOccupationBloc.getOccupationOtherInfoData.ugCode}: ${searchOccupationBloc.getOccupationOtherInfoData.ugName}, viewed on ${searchOccupationBloc.getOccupationOtherInfoData.updatedDate}.',
                                        ),
                                        WidgetSpan(
                                          child: searchOccupationBloc
                                                          .getOccupationOtherInfoData
                                                          .sourceLink !=
                                                      null &&
                                                  searchOccupationBloc
                                                      .getOccupationOtherInfoData
                                                      .sourceLink!
                                                      .isNotEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, bottom: 3),
                                                  child: SvgPicture.asset(
                                                    IconsSVG.linkIcon,
                                                    width: 15.0,
                                                    height: 15.0,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      AppColorStyle.primary(
                                                          context),
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                )
                                              : Container(width: 12.0),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  if (searchOccupationBloc
                                              .getOccupationOtherInfoData
                                              .sourceLink !=
                                          null &&
                                      searchOccupationBloc
                                          .getOccupationOtherInfoData
                                          .sourceLink!
                                          .isNotEmpty) {
                                    Utility.launchURL(searchOccupationBloc
                                            .getOccupationOtherInfoData
                                            .sourceLink ??
                                        '');
                                  }
                                },
                              ),
                            )
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "\u2022 ",
                        style: AppTextStyle.captionRegular(
                          context,
                          AppColorStyle.text(context),
                        ),
                      ),
                      Expanded(
                        child: InkWellWidget(
                          child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                style: AppTextStyle.detailsRegular(
                                    context, AppColorStyle.text(context)),
                                children: [
                                  TextSpan(
                                    text:
                                        '${StringHelper.departmentOfHome} ${searchOccupationBloc.getOccupationOtherInfoData.updatedDateCeiling ?? ""}.',
                                  ),
                                  WidgetSpan(
                                    child: searchOccupationBloc
                                                    .getOccupationOtherInfoData
                                                    .sourceLink !=
                                                null &&
                                            searchOccupationBloc
                                                .getOccupationOtherInfoData
                                                .sourceLink!
                                                .isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, bottom: 3.0),
                                            child: SvgPicture.asset(
                                              IconsSVG.linkIcon,
                                              width: 15.0,
                                              height: 15.0,
                                              colorFilter: ColorFilter.mode(
                                                AppColorStyle.primary(context),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          )
                                        : Container(width: 12.0),
                                  ),
                                ],
                              )),
                          onTap: () {
                            Utility.launchURL(
                                StringHelper.homeAffairsOccupationCeilingUrl);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: (searchOccupationBloc
                                    .getOccupationOtherInfoData.ugName !=
                                null &&
                            searchOccupationBloc
                                .getOccupationOtherInfoData.ugName!.isNotEmpty)
                        ? 10.0
                        : 0.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
