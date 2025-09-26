import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_bloc.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_model.dart';

class UnitGroupListWidget extends StatelessWidget {
  final UnitGroupBloc unitGroupBloc;

  const UnitGroupListWidget({Key? key, required this.unitGroupBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamWidget(
        stream: unitGroupBloc.getUnitListOccupationStream,
        onBuild: (_, snapshot) {
          List<UnitGroupListData> unitGroupList =
              (snapshot != null && snapshot != []) ? snapshot : [];
          if (unitGroupList.isNotEmpty) {
            return Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                    itemCount: unitGroupList.length,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(top: 5),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = unitGroupList[index];
                      var skillColorList =
                          Utility.getSkillLevelWithDefaultColor(
                              item.skillLevel!);
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: InkWellWidget(
                                    onTap: () {
                                      GoRoutesPage.go(
                                          mode: NavigatorMode.push,
                                          moveTo: RouteName
                                              .labourInsightUnitGroupScreen,
                                          param: unitGroupList[index].ugCode);
                                      unitGroupBloc.searchTextController.text = "";
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            AppColorStyle.background(context),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal:
                                                    Constants.commonPadding),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("${item.name}",
                                                          style: AppTextStyle
                                                              .detailsRegular(
                                                                  context,
                                                                  AppColorStyle
                                                                      .text(
                                                                          context))),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("${item.ugCode}",
                                                              style: AppTextStyle
                                                                  .detailsSemiBold(
                                                                      context,
                                                                      AppColorStyle
                                                                          .primary(
                                                                              context))),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  StringHelper
                                                                      .skillLevelText,
                                                                  style: AppTextStyle.captionRegular(
                                                                      context,
                                                                      AppColorStyle
                                                                          .text(
                                                                              context))),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              for (var item
                                                                  in skillColorList)
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 10,
                                                                      height:
                                                                          10,
                                                                      color:
                                                                          item,
                                                                      // color: ThemeConstant.redVariantTemp,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ((unitGroupList.length) - 1) != index
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: Constants
                                                              .commonPadding),
                                                  child: Divider(
                                                      color: AppColorStyle
                                                          .borderColors(
                                                              context),
                                                      thickness: 0.5),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    )),
                              )));
                    }),
              ),
            );
          } else {
            return Expanded(
              child: Center(
                child: NoDataFoundScreen(
                  noDataTitle: StringHelper.noDataFound,
                  noDataSubTitle: StringHelper.tryAgainWithDiffCriteria,
                ),
              ),
            );
          }
        });
  }
}
