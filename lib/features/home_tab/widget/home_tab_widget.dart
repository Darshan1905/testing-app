// ignore_for_file: must_be_immutable

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/home_tab/bottom_navigation_model.dart';
import 'package:occusearch/features/home_tab/home_tab_bloc.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  BottomNavigationBarWidget({Key? key, required this.theme, required this.appType}) : super(key: key);

  bool theme;
  AppType? appType;


  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  HomeBloc? _homeBloc;

  final List<BottomNavigationBarModel> _bottomNavigationMenuList = [
    BottomNavigationBarModel(
      selectedLight: IconsSVG.menuHomeSelectedLight,
      deselectedLight: IconsSVG.menuHomeUnselectedLight,
      selectedDark: IconsSVG.menuHomeSelectedDark,
      deselectedDark: IconsSVG.menuHomeUnselectedDark,
      title: StringHelper.menuHome,
      index: 0,
    ),
    BottomNavigationBarModel(
      selectedLight: IconsSVG.menuSearchSelectedLight,
      deselectedLight: IconsSVG.menuSearchUnselectedLight,
      selectedDark: IconsSVG.menuSearchSelectedDark,
      deselectedDark: IconsSVG.menuSearchUnselectedDark,
      title: StringHelper.menuSearch,
      index: 1,
    ),
    BottomNavigationBarModel(
      selectedLight: IconsSVG.menuAiCrownSelectedLight,
      deselectedLight: IconsSVG.menuAiCrownUnselectedLight,
      selectedDark: IconsSVG.menuAiCrownSelectedDark,
      deselectedDark: IconsSVG.menuAiCrownUnselectedDark,
      title: StringHelper.menuAI,
      index: 2,
    ),
    BottomNavigationBarModel(
      selectedLight: IconsSVG.menuMoreSelectedLight,
      deselectedLight: IconsSVG.menuMoreUnselectedLight,
      selectedDark: IconsSVG.menuMoreSelectedDark,
      deselectedDark: IconsSVG.menuMoreUnselectedDark,
      title: StringHelper.menuMore,
      index: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    _homeBloc ??= RxBlocProvider.of<HomeBloc>(context);
    double displayWidth = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return StreamBuilder<int>(
      stream: _homeBloc?.currentIndexStream,
      builder: (_, snapshot) {
        if (snapshot.data != null) {
          final int indexValue = snapshot.data ?? 0;
          return Container(
            decoration: BoxDecoration(
              color: AppColorStyle.background(context),
              boxShadow: [
                BoxShadow(
                  color: AppColorStyle.surface(context),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, -5), // changes position of shadow
                ),
              ],
            ),
            height: 70,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            margin: EdgeInsets.only(bottom: bottomPadding > 0 ? 15 : 0),
            child: ListView.builder(
              itemCount: _bottomNavigationMenuList.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  _homeBloc?.setTabBarIndex(index);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == indexValue ? displayWidth * .26 : displayWidth * .22,
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: index == indexValue ? displayWidth * .12 : 0,
                        width: index == indexValue ? displayWidth * .32 : 0,
                        decoration: BoxDecoration(
                          color: index == indexValue
                              ? AppColorStyle.primary(context)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == indexValue ? displayWidth * .25 : displayWidth * .20,
                      alignment: Alignment.center,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.center,
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == indexValue ? index == 2 ? displayWidth * .14 : displayWidth * .09 : 0,
                              ),
                              AnimatedOpacity(
                                opacity: index == indexValue ? 1 : 0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: Text(
                                  index == indexValue
                                      ? _bottomNavigationMenuList[index].title
                                      : '',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.titleMedium(
                                    context,
                                    AppColorStyle.textWhite(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == indexValue ? index == 2 ? displayWidth * .03 : displayWidth * .00 : 8,
                              ),
                              SizedBox(
                                width: index == indexValue ? 8 : 20,
                              ),
                              SvgPicture.asset(
                                widget.theme
                                    ? (index == indexValue)
                                      ? index == 2 && widget.appType == AppType.PAID ? IconsSVG.menuAiSelectedDark : _bottomNavigationMenuList[index].selectedDark
                                      : index == 2 && widget.appType == AppType.PAID ? IconsSVG.menuAiUnselectedDark : _bottomNavigationMenuList[index].deselectedDark
                                    : (index == indexValue)
                                      ? index == 2 && widget.appType == AppType.PAID ? IconsSVG.menuAiSelectedLight : _bottomNavigationMenuList[index].selectedLight
                                      : index == 2 && widget.appType == AppType.PAID ? IconsSVG.menuAiUnselectedLight : _bottomNavigationMenuList[index].deselectedLight,
                                height: 24,
                                width: 24,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
