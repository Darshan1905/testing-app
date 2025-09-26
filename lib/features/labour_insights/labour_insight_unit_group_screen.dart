import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/labour_insights/labour_insight_bloc.dart';
import 'package:occusearch/features/labour_insights/labour_insights_detail_screen.dart';
import 'package:occusearch/features/labour_insights/widgets/labour_insight_screen_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_shimmer.dart';

class LabourInsightUnitGroupScreen extends BaseApp {
  const LabourInsightUnitGroupScreen({super.key, super.arguments})
      : super.builder();

  @override
  BaseState createState() => _UnitGroupDetailScreenState();
}

class _UnitGroupDetailScreenState extends BaseState
    with TickerProviderStateMixin {
  final LabourInsightBloc labourInsightBloc = LabourInsightBloc();
  final ScrollController _scrollController = ScrollController();

  bool _showBackToTopButton = false;

  @override
  init() async {
    dynamic unitGroupCode = widget.arguments;
    printLog("UgCode param: ${widget.arguments}");
    if (unitGroupCode != null && unitGroupCode != "") {
      //get course detail data
      await labourInsightBloc.getLabourInsightsDetailData(
          context, unitGroupCode, false);
    }
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset >= 50) {
          _showBackToTopButton = true;
        } else {
          _showBackToTopButton = false;
        }
      });
    });
  }

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider(
      create: (_) => labourInsightBloc,
      child: Container(
        color: AppColorStyle.primary(context),
        child: StreamBuilder(
          stream: labourInsightBloc.unitGroupDetailsDataObject.stream,
          builder: (_, snapshot) {
            return (snapshot.data != null &&
                    snapshot.hasData &&
                    labourInsightBloc.isLabourLoading.value == false)
                ? SafeArea(
                    bottom: false,
                    child: Stack(
                      children: [
                        NestedScrollView(
                          controller: _scrollController,
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverAppBar(
                                  expandedHeight: 200,
                                  backgroundColor:
                                      AppColorStyle.primary(context),
                                  floating: true,
                                  elevation: 0,
                                  toolbarHeight: 50,
                                  pinned: true,
                                  automaticallyImplyLeading: false,
                                  leadingWidth: 50,
                                  leading: InkWellWidget(
                                    onTap: () {
                                      context.pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: Constants.commonPadding),
                                      child: SvgPicture.asset(
                                        IconsSVG.arrowBack,
                                        colorFilter: ColorFilter.mode(
                                          AppColorStyle.textWhite(context),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: innerBoxIsScrolled &&
                                          _scrollController.offset >= 50
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Column(
                                            children: [
                                              Text(snapshot.data!.name!,
                                                  style: AppTextStyle
                                                      .detailsSemiBold(
                                                          context,
                                                          AppColorStyle
                                                              .textWhite(
                                                                  context))),
                                              const SizedBox(height: 3.0),
                                              Text(
                                                  "UNIT CODE ${snapshot.data!.code!}",
                                                  style: AppTextStyle
                                                      .captionRegular(
                                                          context,
                                                          AppColorStyle
                                                              .textWhite(
                                                                  context))),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                  centerTitle: true,
                                  flexibleSpace: flexibleTitleBar(context,
                                      title: snapshot.data!.name!,
                                      isShowAlternateTitle: false,
                                      innerBoxIsScrolled: innerBoxIsScrolled)),
                            ];
                          },
                          body: const LabourInsightDetail(),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 30, right: 20),
                                child: _showBackToTopButton
                                    ? InkWellWidget(
                                        onTap: () => {
                                          _scrollController.animateTo(0.0,
                                              curve: Curves.ease,
                                              duration: const Duration(
                                                  milliseconds: 1200))
                                        },
                                        child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              top: 5,
                                              bottom: 5,
                                              right: 15),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              color: AppColorStyle.text(context)
                                                  .withOpacity(0.3),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColorStyle.text(
                                                          context)
                                                      .withOpacity(0.3),
                                                ),
                                              ]),
                                          child: Icon(
                                            Icons.arrow_upward,
                                            color: AppColorStyle.textWhite(
                                                context),
                                          ),
                                        ),
                                      )
                                    : null))
                      ],
                    ),
                  )
                : Container(
                    color: AppColorStyle.backgroundVariant(context),
                    child: const LabourInsightScreenShimmer(),
                  );
          },
        ),
      ),
    );
  }

  @override
  onResume() {}

  double get maxHeight => 80 + MediaQuery.of(context).padding.top;

  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  Widget flexibleTitleBar(BuildContext context,
      {String? title, bool? isShowAlternateTitle, bool? innerBoxIsScrolled}) {
    double calculateExpandRatio(BoxConstraints constraints) {
      var expandRatio =
          (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
      if (expandRatio > 1.0) expandRatio = 1.0;
      if (expandRatio < 0.0) expandRatio = 0.0;
      return expandRatio;
    }

    Widget buildTitle(Animation<double> animation) {
      return Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          innerBoxIsScrolled == true
              ? const SizedBox()
              : Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: SvgPicture.asset(
                    IconsSVG.headerBg,
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(
                left: Constants.commonPadding,
                right: Constants.commonPadding,
                top: 65),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    innerBoxIsScrolled == false
                        ? title!.isNotEmpty
                            ? RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  text: title,
                                  style: AppTextStyle.titleSemiBold(context,
                                      AppColorStyle.textWhite(context)),
                                  children: [
                                    WidgetSpan(
                                      child: isShowAlternateTitle == true
                                          ? PopupMenuButton(
                                              icon: SvgPicture.asset(
                                                IconsSVG.icInfo,
                                                colorFilter: ColorFilter.mode(
                                                  AppColorStyle.textWhite(
                                                      context),
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              color:
                                                  AppColorStyle.primaryVariant1(
                                                      context),
                                              // shape: const TooltipShape(),
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                        PopupMenuItem(
                                                            //  padding: EdgeInsets.all(5),
                                                            child: Text(
                                                          "alternative title",
                                                          style: AppTextStyle
                                                              .captionItalic(
                                                                  context,
                                                                  AppColorStyle
                                                                      .textWhite(
                                                                          context)),
                                                        )),
                                                      ])
                                          : const SizedBox(
                                              height: 0,
                                              width: 0,
                                            ),
                                      alignment: PlaceholderAlignment.top,
                                    ),
                                  ],
                                ),
                              )
                            : const OccupationDetailShimmer()
                        : const SizedBox(),
                    SizedBox(
                      height: isShowAlternateTitle == true ? 0 : 15,
                      //height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColorStyle.primaryVariant1(context),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              "UNIT CODE ${labourInsightBloc.unitGroupDetailsDataObject.value.code!}",
                              style: AppTextStyle.detailsMedium(
                                  context, AppColorStyle.textWhite(context)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final expandRatio = calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);
        return buildTitle(animation);
      },
    );
  }
}
