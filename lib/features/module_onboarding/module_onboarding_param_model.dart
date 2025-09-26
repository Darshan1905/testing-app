import 'package:flutter/material.dart';

class ModuleOnBoardingParameterModel {
  static const String keyBackgroundIcon = "background_icon";
  static const String keyRiveIcon = "rive_icon";
  static const String keyTitle = "title_text";
  static const String keySubtitle = "subtitle_text";
  static const String keyDetail = "detail_text";
  static const String keyButtonText = "button_text";
  static const String keyRedirectionScreenName = "redirection_screen";
  static const String keyBackgroundIconColor = "background_color";
  static const String keyTitleColor = "title_color";
  static const String keySubtitleColor = "subtitle_color";
  static const String keyDetailColor = "detail_color";
  static const String keyButtonColor= "button_color";

  static Map<String, dynamic> parameter(
      {required String backgroundIcon,
        required String riveIcon,
        required String title,
        required String subtitle,
        required String detail,
        required String buttonText,
        required String redirectionScreenName,
        required Color backgroundIconColor,
        required Color titleColor,
        required Color subtitleColor,
        required Color detailColor,
        required Color buttonColor
      }) {
    Map<String, dynamic> param = {
      keyBackgroundIcon: backgroundIcon,
      keyRiveIcon: riveIcon,
      keyTitle: title,
      keySubtitle: subtitle,
      keyDetail: detail,
      keyButtonText: buttonText,
      keyRedirectionScreenName: redirectionScreenName,
      keyBackgroundIconColor: backgroundIconColor,
      keyTitleColor: titleColor,
      keySubtitleColor: subtitleColor,
      keyDetailColor: detailColor,
      keyButtonColor: buttonColor,
    };
    return param;
  }
}
