import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/search_field_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_shimmer.dart';

class OccupationListScreen extends BaseApp {
  const OccupationListScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _OccupationListScreenState();
}

class _OccupationListScreenState extends BaseState {
  OccupationListBloc occupationBloc = OccupationListBloc();
  GlobalBloc? _globalBloc;
  List<MyBookmarkTable>? myBookmarkOccupationList;

  @override
  init() {}

  @override
  onResume() async {
    initData();
  }

  initData() async {
    myBookmarkOccupationList = await MyBookmarkTable.getBookmarkDataByType(
        bookmarkType: BookmarkType.OCCUPATION.name);
    await occupationBloc.getOccupationsList();
  }

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxBlocProvider(
      create: (_) => occupationBloc,
      child: Container(
        color: AppColorStyle.background(context),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: SearchTextField(
                    controller: occupationBloc.searchTextController,
                    searchHintText: StringHelper.searchHere,
                    prefixIcon: IconsSVG.arrowBack,
                    isBackIcon: true,
                    onTextChanged: (String typingText) {
                      occupationBloc.searchFilter = typingText;
                    },
                    onClear: () {
                      occupationBloc.clearSearch();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: StreamBuilder<bool>(
                    stream: occupationBloc.loadingStream,
                    builder: (_, snapshot) {
                      if (snapshot.hasData && snapshot.data == false) {
                        return StreamBuilder<List<OccupationRowData>>(
                          stream: occupationBloc.searchOccupationListStream,
                          builder: (context, snapData) {
                            if (snapData.hasData &&
                                snapData.data != null &&
                                snapData.data!.isNotEmpty) {
                              List<OccupationRowData> occupationList =
                                  snapData.data ?? [];
                              return AnimationLimiter(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 50),
                                  itemCount: occupationList.length,
                                  itemBuilder: (context, index) {
                                    final occupationData =
                                        occupationList[index];
                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: occupationRowView(
                                                  occupationData),
                                            )));
                                  },
                                ),
                              );
                            } else if (snapData.data != null &&
                                snapData.data!.isEmpty) {
                              return Center(
                                child: NoDataFoundScreen(
                                  noDataTitle: StringHelper.noDataFound,
                                  noDataSubTitle:
                                      StringHelper.tryAgainWithDiffCriteria,
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      } else {
                        return AnimationLimiter(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 50),
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: const SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: OccupationListShimmer(),
                                      )));
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget occupationRowView(OccupationRowData occupationData) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWellWidget(
            onTap: () async {
              /// add restricted based in recent search occupation for free plan
              if (NetworkController.isInternetConnected == true) {
                if (_globalBloc!.subscriptionType != AppType.PAID) {
                  //check whether the occupation is in already bookmarked or not, if it is bookmarked then move to next page
                  if (occupationData.isAdded == true) {
                    GoRoutesPage.go(
                        mode: NavigatorMode.push,
                        moveTo: RouteName.occupationSearchScreen,
                        param: occupationData);
                    occupationBloc.clearSearch();
                    return;
                  }
                  //check whether the bookmarked occupation is less than 3 or not, if it is less than 3 then move to next page
                  //else show toast message
                  if (myBookmarkOccupationList!.isNotEmpty) {
                    if (myBookmarkOccupationList!.length < 3) {
                      GoRoutesPage.go(
                          mode: NavigatorMode.push,
                          moveTo: RouteName.occupationSearchScreen,
                          param: occupationData);

                      occupationBloc.clearSearch();
                    } else {
                      GoRoutesPage.go(
                          mode: NavigatorMode.push,
                          moveTo: RouteName.subscription);
                    }
                  } else {
                    GoRoutesPage.go(
                        mode: NavigatorMode.push,
                        moveTo: RouteName.occupationSearchScreen,
                        param: occupationData);
                  }
                } else {
                  GoRoutesPage.go(
                      mode: NavigatorMode.push,
                      moveTo: RouteName.occupationSearchScreen,
                      param: occupationData);

                  occupationBloc.clearSearch();
                }
              } else {
                Toast.show(context,
                    message: StringHelper.internetConnection,
                    type: Toast.toastError);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: occupationData.name ?? "",
                      style: AppTextStyle.detailsMedium(
                          context, AppColorStyle.text(context)),
                      children: [
                        WidgetSpan(
                            child: (_globalBloc!.subscriptionType !=
                                        AppType.PAID &&
                                    myBookmarkOccupationList != null &&
                                    myBookmarkOccupationList!.isNotEmpty &&
                                    myBookmarkOccupationList!.length >= 3 &&
                                    occupationData.isAdded != true)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 5.0),
                                    child: SvgPicture.asset(
                                        IconsSVG.icPremiumFeature,
                                        height: 20.0,
                                        width: 20.0),
                                  )
                                : const SizedBox(),
                            alignment: PlaceholderAlignment.middle),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Text(
                        "ANZSCO-${occupationData.mainId ?? ''}",
                        style: AppTextStyle.captionSemiBold(
                          context,
                          AppColorStyle.primary(context),
                        ),
                      ),
                      Visibility(
                        visible: occupationData.isAdded ?? false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColorStyle.teal(context),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: Text(
                                StringHelper.added.toUpperCase(),
                                style: AppTextStyle.captionSemiBold(
                                  context,
                                  AppColorStyle.textWhite(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Divider(
                  color: AppColorStyle.borderColors(context),
                  thickness: 0.5,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
