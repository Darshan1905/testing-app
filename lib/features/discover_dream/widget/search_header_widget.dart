// ignore_for_file: must_be_immutable

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_bloc.dart';

class SearchHeaderWidget extends StatelessWidget {
  final GlobalBloc? globalBloc;
  const SearchHeaderWidget({Key? key, this.globalBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(
              left: Constants.commonPadding, right: Constants.commonPadding, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(StringHelper.occupationDiscover,
                      style: AppTextStyle.subHeadlineBold(
                          context, AppColorStyle.text(context))),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child:
                    Lottie.asset(LottieAssets.occupationSearchHeader),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: StringHelper.occupationDreams,
                      style: AppTextStyle.subHeadlineBold(
                        context,
                        AppColorStyle.text(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          InkWellWidget(
            onTap: () {
              if (globalBloc!.subscriptionType == AppType.PAID) {
                GoRoutesPage.go(
                  mode: NavigatorMode.push,
                  moveTo: RouteName.myBookmarkListScreen
                );
              } else {
                GoRoutesPage.go(
                    mode: NavigatorMode.push,
                    moveTo: RouteName.myBookmarkListScreen,
                    param: BookmarkType.OCCUPATION.name
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColorStyle.primarySurface2(context)),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                IconsSVG.heartIcon,
                colorFilter: ColorFilter.mode(
                  AppColorStyle.text(context),
                  BlendMode.srcIn,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TabWidget extends StatelessWidget {
  int currentContributePage;
  SearchCategoryType? data;
  SearchCategoryType? searchCategoryType;

  TabWidget({Key? key,required this.currentContributePage, required this.data, required this.searchCategoryType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final occupationBloc = RxBlocProvider.of<OccupationListBloc>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.commonPadding, vertical: 20.0),
      child: Row(
        children: [
          InkWellWidget(
              onTap: () {
                occupationBloc.setCategoryType =
                    SearchCategoryType.OCCUPATION;
                currentContributePage = 0;
                searchCategoryType = SearchCategoryType.OCCUPATION;
              },
              child: Text(
                "Occupation",
                style: data == SearchCategoryType.OCCUPATION
                    ? AppTextStyle.subHeadlineSemiBold(
                    context, AppColorStyle.primary(context))
                    : AppTextStyle.detailsRegular(
                    context, AppColorStyle.textHint(context)),
              )),
          const SizedBox(width: 40),
          InkWellWidget(
              onTap: () {
                occupationBloc.setCategoryType = SearchCategoryType.COURSE;
                currentContributePage = 0;
                searchCategoryType = SearchCategoryType.COURSE;
              },
              child: Text(
                "Course",
                style: data == SearchCategoryType.COURSE
                    ? AppTextStyle.subHeadlineSemiBold(
                    context, AppColorStyle.primary(context))
                    : AppTextStyle.detailsRegular(
                    context, AppColorStyle.textHint(context)),
              )),
        ],
      ),
    );
  }
}

