import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/search_field_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/visa_fees/model/visa_subclass_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_shimmer.dart';
import 'package:occusearch/features/visa_fees/widget/visa_subclass_widget.dart';

class VisaFeesSubclassScreen extends BaseApp {
  const VisaFeesSubclassScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _VisaFeesSubclassState();
}

class _VisaFeesSubclassState extends BaseState {
  final VisaFeesBloc _visaBloc = VisaFeesBloc();
  final TextEditingController _searchController = TextEditingController();

  @override
  init() {
    _visaBloc.setSearchFieldController = _searchController;
    _visaBloc.getVisaSubclassData(context);
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      color: AppColorStyle.background(context),
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(StringHelper.visaSubclass,
                          style: AppTextStyle.headlineBold(
                              context, AppColorStyle.text(context))),
                    ],
                  ),
                  InkWellWidget(
                      onTap: () {
                        context.pop();
                      },
                      child: SvgPicture.asset(IconsSVG.closeIcon,
                          colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                  ),
                  ))
                ],
              ),
              const SizedBox(height: 15),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 100 / 3),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) => LinearProgressIndicator(
                  minHeight: 2.0,
                  value: 3,
                  backgroundColor: AppColorStyle.backgroundVariant(context),
                  color: AppColorStyle.purple(context),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<List<SubclassData>>(
                  stream: _visaBloc.getVisaSubclassListStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data is List<SubclassData>) {
                      List<SubclassData> subclassList =
                          snapshot.data as List<SubclassData>;
                      printLog(
                          "#VisaFeesSubclassScreen# SubclassList length :: ${subclassList.length}");
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SearchTextField(
                              onTextChanged: _visaBloc.onSearch,
                              onClear: () {
                                _searchController.text = '';
                                _visaBloc.onSearch("");
                              },
                              controller: _searchController,
                              searchHintText: StringHelper.visaTypeHintText,
                            ),
                          ),
                          subclassList.isNotEmpty
                              ? Expanded(
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                      itemCount: subclassList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (_, int index) {
                                        return AnimationConfiguration
                                            .staggeredList(
                                                position: index,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                child: SlideAnimation(
                                                    verticalOffset: 50.0,
                                                    child: FadeInAnimation(
                                                      child: VisaSubclassWidget(
                                                        subclass:
                                                            subclassList[index],
                                                        index: index,
                                                        isLastItem: subclassList
                                                                .length ==
                                                            index + 1,
                                                        onItemClick:
                                                            (SubclassData
                                                                subclassData) {
                                                          _visaBloc
                                                                  .setSelectedSubClassData =
                                                              subclassData;
                                                        },
                                                      ),
                                                    )));
                                      },
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Center(
                                    child: NoDataFoundScreen(
                                      noDataTitle: StringHelper.noDataFound,
                                      noDataSubTitle:
                                          StringHelper.tryAgainWithDiffCriteria,
                                    ),
                                  ),
                                ),
                        ],
                      );
                    } else {
                      return const VisaFeesSubclassShimmer();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  onResume() {}
}
