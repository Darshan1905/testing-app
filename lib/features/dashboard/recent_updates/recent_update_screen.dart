import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/dashboard/recent_updates/recent_update_bloc.dart';
import 'package:occusearch/features/dashboard/recent_updates/recent_update_list_shimmer.dart';
import 'package:occusearch/features/dashboard/recent_updates/recent_update_widget.dart';

class RecentUpdateScreen extends BaseApp {
  const RecentUpdateScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _RecentUpdateScreenState();
}

class _RecentUpdateScreenState extends BaseState with TickerProviderStateMixin {
  late AnimationController animationController;
  late ScrollController _controller;
  bool isFirstTime = true;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  final RecentUpdatesBloc _recentUpdatesBloc = RecentUpdatesBloc();
  GlobalBloc? _globalBloc;

  @override
  init() {
    try {
      animationController = BottomSheet.createAnimationController(this);
      animationController.duration = const Duration(milliseconds: 500);

      Future.delayed(Duration.zero, () async {
        _recentUpdatesBloc.pageNo.value = 1;
        if (NetworkController.isInternetConnected) {
          // if user came from dynamic link sharing...
          dynamic args = widget.arguments;
          if (args != null && args != "" && args != "0") {
            bool flag = await _recentUpdatesBloc.getRecentUpdateDataList(
                context, true, args);
            if (flag && _recentUpdatesBloc.recentPostData != null) {
              RecentUpdateWidget.showRecentUpdateInSheet(context,
                  _recentUpdatesBloc.recentPostData!, 15, animationController);
            }
          }
          // Load recent update posts...
          await _recentUpdatesBloc.getRecentUpdateDataList(context, false, "0");
          setState(() {
            isFirstTime = false;
          });
        }
      });
    } catch (e) {
      printLog(e);
    }
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    _controller = ScrollController()..addListener(_loadMore);
    return Container(
      color: AppColorStyle.background(context),
      child: RxBlocProvider(
        create: (_) => _recentUpdatesBloc,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.commonPadding, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(children: [
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
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      StringHelper.recentUpdates,
                      style: AppTextStyle.subHeadlineSemiBold(
                          context, AppColorStyle.text(context)),
                    ),
                  ]),
                ),
                // const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    color: AppColorStyle.background(context),
                    child: StreamBuilder(
                      stream: _recentUpdatesBloc.recentUpdateList.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        return (snapshot.hasData && snapshot.data != null)
                            ? ListView.builder(
                                controller: _controller,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    globalBloc?.subscriptionType == AppType.PAID
                                        ? _recentUpdatesBloc
                                            .recentUpdateList.value.length
                                        : _recentUpdatesBloc.recentUpdateList
                                                    .value.length >=
                                                3
                                            ? 3
                                            : _recentUpdatesBloc
                                                .recentUpdateList.value.length,
                                itemBuilder: (context, index) {
                                  return RecentUpdateWidget.updateWidgetBlock(
                                      context,
                                      index,
                                      _recentUpdatesBloc
                                          .recentUpdateList.value[index],
                                      _recentUpdatesBloc
                                          .recentUpdateList.value.length,
                                      animationController);
                                })
                            : (NetworkController.isInternetConnected ||
                                    _recentUpdatesBloc.loading == true)
                                ? SizedBox(
                                    height: 500,
                                    child: RecentUpdateListShimmer(10))
                                : //if no data found then use below widget!
                                Center(
                                    child: Text(
                                      StringHelper
                                          .recentUpdatesDataNotAvailable,
                                      style: AppTextStyle.captionMedium(
                                        context,
                                        AppColorStyle.text(context),
                                      ),
                                    ),
                                  );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadMore() async {
    try {
      if (NetworkController.isInternetConnected) {
        if (_isLoadMoreRunning == false &&
            _controller.position.maxScrollExtent == _controller.offset) {
          setState(() {
            _isLoadMoreRunning =
                true; // Display a progress indicator at the bottom
          });
          _controller.position.animateTo(_controller.offset + 120,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut);
          _recentUpdatesBloc.pageNo.value += 1; // Increase _page by 1
          try {
            await _recentUpdatesBloc.getRecentUpdateDataList(
                context, false, "0");
          } catch (err) {
            debugPrint('Something went wrong!');
          }
          setState(() {
            _isLoadMoreRunning = false;
            isFirstTime = false;
          });
        }
      } else {
        Toast.show(context,
            message: StringHelper.internetConnection, type: Toast.toastError);
      }
    } catch (e) {
      printLog(e);
    }
  }
}
