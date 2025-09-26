import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:occusearch/app_style/text_style/app_text_style.dart';
import 'package:occusearch/app_style/theme/app_color_style.dart';
import 'package:occusearch/app_style/theme/theme_bloc.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/navigation/route_navigation.dart';
import 'package:occusearch/navigation/routes.dart';
import 'package:occusearch/resources/icons.dart';

class NoDataFoundScreen extends StatelessWidget {
  String? noDataTitle, noDataSubTitle, noDataIcon, buttonText;
  bool isButtonVisible, isOccupation;

  NoDataFoundScreen(
      {Key? key,
      this.noDataTitle,
      this.noDataSubTitle,
      this.noDataIcon,
      this.isButtonVisible = false,
      this.buttonText,
      this.isOccupation = true /*for Bookmark screen*/
      })
      : super(key: key);

  ThemeBloc? themeBloc;

  @override
  Widget build(BuildContext context) {
    themeBloc ??= RxBlocProvider.of<ThemeBloc>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: MediaQuery.of(context).size.height / 4),
          Center(
              child: SvgPicture.asset(noDataIcon ??
                  (themeBloc!.currentTheme
                      ? IconsSVG.icNoDataAvailableDark
                      : IconsSVG.icNoDataAvailable))),
          const SizedBox(height: 40),
          Text(noDataTitle ?? '',
              style: AppTextStyle.detailsMedium(
                  context, AppColorStyle.textDetail(context))),
          const SizedBox(height: 10.0),
          Text(noDataSubTitle ?? '',
              style: AppTextStyle.captionRegular(
                  context, AppColorStyle.textHint(context))),
          SizedBox(height: isButtonVisible ? 40 : 0),
          Visibility(
            visible: isButtonVisible,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ButtonWidget(
                  title: buttonText ?? '',
                  titleTextStyle: AppTextStyle.captionRegular(
                      context, AppColorStyle.textWhite(context)),
                  onTap: () {
                    var params = {"isFromCompare": false};
                    isOccupation
                        ? GoRoutesPage.go(
                            mode: NavigatorMode.push,
                            moveTo: RouteName.occupationListScreen,
                          )
                        : GoRoutesPage.go(
                            mode: NavigatorMode.push,
                            moveTo: RouteName.coursesListScreen,
                            param: params);
                  },
                  logActionEvent: '',
                  arrowIconVisibility: true),
            ),
          ),
        ],
      ),
    );
  }
}
