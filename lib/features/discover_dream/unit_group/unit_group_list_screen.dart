import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/search_field_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/widget/unit_group_list_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_bloc.dart';

class UnitGroupListScreen extends BaseApp {
  const UnitGroupListScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _UnitGroupListScreenState();
}

class _UnitGroupListScreenState extends BaseState {
  UnitGroupBloc unitGroupBloc = UnitGroupBloc();
  OccupationDetailBloc occupationDetailBloc = OccupationDetailBloc();

  @override
  init() {}

  @override
  onResume() async {
    //UNIT GROUP OCCUPATION LIST from firebase config
    await unitGroupBloc.getOccupationUnitGroupList();
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      color: AppColorStyle.background(context),
      child: SafeArea(
          bottom: false,
          child: StreamBuilder<bool>(
              stream: unitGroupBloc.unitGroupLoaderSubject,
              builder: (_, loaderSnapshot) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: Constants.commonPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWellWidget(
                            onTap: () {
                              context.pop();
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
                            StringHelper.unitGroup,
                            style: AppTextStyle.subHeadlineSemiBold(
                                context, AppColorStyle.text(context)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: Constants.commonPadding),
                      child: SearchTextField(
                        controller: unitGroupBloc.searchTextController,
                        searchHintText: StringHelper.searchHere,
                        onTextChanged: (value) {
                          unitGroupBloc.onSearch(value);
                        },
                        onClear: () {
                          unitGroupBloc.clearSearch();
                        },
                      ),
                    ),
                    loaderSnapshot.hasData &&
                            loaderSnapshot.data != null &&
                            loaderSnapshot.data == false
                        ? UnitGroupListWidget(unitGroupBloc: unitGroupBloc)
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: Constants.commonPadding),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 15,
                                  itemBuilder: (context, index) {
                                    return const OccupationListShimmer();
                                  }),
                            ),
                          )
                  ],
                );
              })),
    );
  }
}
