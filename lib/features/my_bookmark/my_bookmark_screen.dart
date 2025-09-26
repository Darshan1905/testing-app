import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/my_bookmark/my_bookmark_bloc.dart';
import 'package:occusearch/features/my_bookmark/widget/my_bookmark_list_widget.dart';

class MyBookmarkListScreen extends BaseApp {
  const MyBookmarkListScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _MyBookmarkListScreenState();
}

class _MyBookmarkListScreenState extends BaseState
    with SingleTickerProviderStateMixin {
  GlobalBloc? _globalBloc;
  UserInfoData? info;
  MyBookmarkBloc myBookmarkBloc = MyBookmarkBloc();
  TabController? _tabController;
  dynamic type = "";

  @override
  init() async {
    type = widget.arguments ?? "";
    _tabController = TabController(length: globalBloc?.subscriptionType == AppType.PAID ? 3 : 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      info = await _globalBloc?.getUserInfo(context);
    });
    _tabController?.index = 0;
    _tabController?.addListener(() {});
  }

  @override
  onResume() {
    int index =
        BookmarkType.values.indexWhere((element) => element.name == type);
    if (index != -1) {
      _tabController?.index = globalBloc?.subscriptionType == AppType.PAID ? index : 0;
    } else {
      _tabController?.index =
          _tabController == null ? 0 : _tabController!.index;
      type = BookmarkType.values[_tabController!.index].name;
    }
    myBookmarkBloc.getAllBookmarkList(type: type);
    if (globalBloc?.subscriptionType == AppType.PAID) {
      myBookmarkBloc.setBookmarkType = BookmarkType.values[_tabController!.index];
    } else {
      myBookmarkBloc.setBookmarkType = BookmarkType.OCCUPATION;
    }
  }

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxBlocProvider(
      create: (_) => myBookmarkBloc,
      child: Container(
        color: AppColorStyle.background(context),
        child: SafeArea(
          child: Column(
            children: [
              Card(
                color: AppColorStyle.background(context),
                elevation: 0.8,
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWellWidget(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                IconsSVG.arrowBack,
                                colorFilter: ColorFilter.mode(
                                  AppColorStyle.text(context),
                                  BlendMode.srcIn,
                                ),
                              )),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Text(StringHelper.myBookmarks,
                              style: AppTextStyle.titleSemiBold(
                                context,
                                AppColorStyle.text(context),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder(
                      stream: myBookmarkBloc.getBookmarkListStream,
                      builder: (context, snapshot) {
                        return globalBloc?.subscriptionType == AppType.PAID ? TabBar(
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          onTap: (position) {
                            switch (position) {
                              case 0:
                                myBookmarkBloc.setBookmarkType =
                                    BookmarkType.ALL;
                                myBookmarkBloc.setBookmarkListByType(
                                    bookmarkType: "");
                                type = "";
                                break;
                              case 1:
                                myBookmarkBloc.setBookmarkType =
                                    BookmarkType.OCCUPATION;

                                if (myBookmarkBloc.bookmarkTypeStream.value ==
                                    BookmarkType.OCCUPATION) {
                                  myBookmarkBloc.setBookmarkListByType(
                                      bookmarkType:
                                      BookmarkType.OCCUPATION.name);
                                  type = BookmarkType.OCCUPATION.name;
                                }
                                break;
                              case 2:
                                myBookmarkBloc.setBookmarkType =
                                    BookmarkType.COURSE;

                                if (myBookmarkBloc.bookmarkTypeStream.value ==
                                    BookmarkType.COURSE) {
                                  myBookmarkBloc.setBookmarkListByType(
                                      bookmarkType: BookmarkType.COURSE.name);
                                  type = BookmarkType.COURSE.name;
                                }
                                break;
                            }
                          },
                          indicatorColor: AppColorStyle.primary(context),
                          unselectedLabelColor:
                          AppColorStyle.textDetail(context),
                          labelColor: AppColorStyle.primary(context),
                          indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                          indicatorWeight: 3,
                          unselectedLabelStyle: AppTextStyle.detailsRegular(
                              context, AppColorStyle.textDetail(context)),
                          labelStyle: AppTextStyle.detailsMedium(
                              context, AppColorStyle.textDetail(context)),
                          isScrollable: true,
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            const Text(
                              'Show All',
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Occupation',
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                      color: AppColorStyle
                                          .primarySurfaceWithOpacity(context),
                                      borderRadius:
                                      BorderRadius.circular(50.0)),
                                  child: Text(
                                    myBookmarkBloc.occupationBookmarkTypeCount
                                        .valueOrNull !=
                                        null
                                        ? myBookmarkBloc
                                        .occupationBookmarkTypeCount
                                        .value
                                        .toString()
                                        .length >
                                        1
                                        ? myBookmarkBloc
                                        .occupationBookmarkTypeCount
                                        .value
                                        .toString()
                                        : '0${myBookmarkBloc.occupationBookmarkTypeCount.value.toString()}'
                                        : "",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.primary(context)),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Course',
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                      color: AppColorStyle
                                          .primarySurfaceWithOpacity(context),
                                      borderRadius:
                                      BorderRadius.circular(50.0)),
                                  child: Text(
                                    myBookmarkBloc.courseBookmarkTypeCount
                                        .valueOrNull !=
                                        null
                                        ? myBookmarkBloc.courseBookmarkTypeCount
                                        .value
                                        .toString()
                                        .length >
                                        1
                                        ? myBookmarkBloc
                                        .courseBookmarkTypeCount.value
                                        .toString()
                                        : '0${myBookmarkBloc.courseBookmarkTypeCount.value.toString()}'
                                        : "",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.primary(context)),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ) : TabBar(
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          onTap: (position) {
                            switch (position) {
                              case 0:
                                myBookmarkBloc.setBookmarkType =
                                    BookmarkType.ALL;
                                myBookmarkBloc.setBookmarkListByType(
                                    bookmarkType: "");
                                type = "";
                                break;
                              case 1:
                                myBookmarkBloc.setBookmarkType =
                                    BookmarkType.OCCUPATION;

                                if (myBookmarkBloc.bookmarkTypeStream.value ==
                                    BookmarkType.OCCUPATION) {
                                  myBookmarkBloc.setBookmarkListByType(
                                      bookmarkType:
                                      BookmarkType.OCCUPATION.name);
                                  type = BookmarkType.OCCUPATION.name;
                                }
                                break;
                              case 2:
                                myBookmarkBloc.setBookmarkType =
                                    BookmarkType.COURSE;

                                if (myBookmarkBloc.bookmarkTypeStream.value ==
                                    BookmarkType.COURSE) {
                                  myBookmarkBloc.setBookmarkListByType(
                                      bookmarkType: BookmarkType.COURSE.name);
                                  type = BookmarkType.COURSE.name;
                                }
                                break;
                            }
                          },
                          indicatorColor: AppColorStyle.primary(context),
                          unselectedLabelColor:
                          AppColorStyle.textDetail(context),
                          labelColor: AppColorStyle.primary(context),
                          indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                          indicatorWeight: 3,
                          unselectedLabelStyle: AppTextStyle.detailsRegular(
                              context, AppColorStyle.textDetail(context)),
                          labelStyle: AppTextStyle.detailsMedium(
                              context, AppColorStyle.textDetail(context)),
                          isScrollable: true,
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Occupation',
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                      color: AppColorStyle
                                          .primarySurfaceWithOpacity(context),
                                      borderRadius:
                                      BorderRadius.circular(50.0)),
                                  child: Text(
                                    myBookmarkBloc.occupationBookmarkTypeCount
                                        .valueOrNull !=
                                        null
                                        ? myBookmarkBloc
                                        .occupationBookmarkTypeCount
                                        .value
                                        .toString()
                                        .length >
                                        1
                                        ? myBookmarkBloc
                                        .occupationBookmarkTypeCount
                                        .value
                                        .toString()
                                        : '0${myBookmarkBloc.occupationBookmarkTypeCount.value.toString()}'
                                        : "",
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.primary(context)),
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //Bookmark List
              MyBookmarkListWidget(
                myBookmarkBloc: myBookmarkBloc,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
}
