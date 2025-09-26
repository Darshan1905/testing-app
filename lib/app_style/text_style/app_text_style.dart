import 'package:flutter/material.dart';
import 'package:occusearch/utility/utils.dart';

enum ScreenType { maximum, xHigh, high, medium, low, minimum, unknown }

enum FontType {
  heading,
  subHeading,
  title,
  subTitle,
  detail,
  caption,
  small,
  extraSmall,
  extraBold
}

class FontsHelper {
  static const String notosansThin = 'NotoThin';
  static const String notosansLight = 'NotoLight';
  static const String notosansRegular = 'NotoRegular';
  static const String notosansMedium = 'NotoMedium';
  static const String notosansSemiBold = 'NotoSemiBold';
  static const String notosansBold = 'NotoBold';
  static const String notosansItalic = 'NotoItalic';
}

class AppTextStyle {
  /// ******  ExtraBold  ******
  static extraBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.extraBold);
    return Theme.of(context).textTheme.displayLarge!.copyWith(
        color: color, fontFamily: FontsHelper.notosansBold, fontSize: fontSize);
  }

  /// ******  Headline  ******
  static headlineThin(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.heading);
    return Theme.of(context).textTheme.displayLarge!.copyWith(
        color: color, fontFamily: FontsHelper.notosansThin, fontSize: fontSize);
  }

  static headlineLight(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.heading);
    return Theme.of(context).textTheme.displayLarge!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansLight,
        fontSize: fontSize);
  }

  static headlineRegular(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.heading);
    return Theme.of(context).textTheme.displayLarge!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansRegular,
        fontSize: fontSize);
  }

  static displayMedium(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.heading);
    return Theme.of(context).textTheme.displayLarge!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansMedium,
        fontSize: fontSize);
  }

  static headlineSemiBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.heading);
    return Theme.of(context).textTheme.displayLarge!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansSemiBold,
        fontSize: fontSize);
  }

  static headlineBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.heading);
    return Theme.of(context).textTheme.displayLarge!.copyWith(
        color: color, fontFamily: FontsHelper.notosansBold, fontSize: fontSize);
  }

  static headlineItalic(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.heading);
    return Theme.of(context).textTheme.displayLarge!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansItalic,
        fontSize: fontSize);
  }

  /// ******  Sub Headline  ******
  static subHeadlineThin(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subHeading);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color, fontFamily: FontsHelper.notosansThin, fontSize: fontSize);
  }

  static subHeadlineLight(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subHeading);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansLight,
        fontSize: fontSize);
  }

  static subHeadlineRegular(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subHeading);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansRegular,
        fontSize: fontSize);
  }

  static subHeadlineMedium(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subHeading);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansMedium,
        fontSize: fontSize);
  }

  static subHeadlineSemiBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subHeading);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansSemiBold,
        fontSize: fontSize);
  }

  static subHeadlineBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subHeading);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color, fontFamily: FontsHelper.notosansBold, fontSize: fontSize);
  }

  static subHeadlineItalic(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subHeading);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansItalic,
        fontSize: fontSize);
  }

  /// ******  Title  ******
  static titleThin(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.title);
    return Theme.of(context).textTheme.titleSmall!.copyWith(
        color: color, fontFamily: FontsHelper.notosansThin, fontSize: fontSize);
  }

  static titleLight(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.title);
    return Theme.of(context).textTheme.titleSmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansLight,
        fontSize: fontSize);
  }

  static titleRegular(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.title);
    return Theme.of(context).textTheme.titleSmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansRegular,
        fontSize: fontSize);
  }

  static titleMedium(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.title);
    return Theme.of(context).textTheme.titleSmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansMedium,
        fontSize: fontSize);
  }

  static titleSemiBold(BuildContext context, Color color, {double height = 1}) {
    var fontSize = _getFontSize(FontType.title);
    return Theme.of(context).textTheme.titleSmall!.copyWith(
        color: color,
        height: height,
        fontFamily: FontsHelper.notosansSemiBold,
        fontSize: fontSize);
  }

  static titleBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.title);
    return Theme.of(context).textTheme.titleSmall!.copyWith(
        color: color, fontFamily: FontsHelper.notosansBold, fontSize: fontSize);
  }

  static titleItalic(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.title);
    return Theme.of(context).textTheme.titleSmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansItalic,
        fontSize: fontSize);
  }

  /// ******  Sub Title  ******
  static subTitleThin(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subTitle);
    return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: color, fontFamily: FontsHelper.notosansThin, fontSize: fontSize);
  }

  static subTitleLight(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subTitle);
    return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansLight,
        fontSize: fontSize);
  }

  static subTitleRegular(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subTitle);
    return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansRegular,
        fontSize: fontSize);
  }

  static subTitleMedium(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subTitle);
    return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansMedium,
        fontSize: fontSize);
  }

  static subTitleSemiBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subTitle);
    return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansSemiBold,
        fontSize: fontSize);
  }

  static subTitleBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subTitle);
    return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: color, fontFamily: FontsHelper.notosansBold, fontSize: fontSize);
  }

  static subTitleItalic(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.subTitle);
    return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansItalic,
        fontSize: fontSize);
  }

  /// ******  Details  ******
  static detailsThin(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.detail);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color, fontFamily: FontsHelper.notosansThin, fontSize: fontSize);
  }

  static detailsLight(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.detail);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansLight,
        fontSize: fontSize);
  }

  static detailsRegular(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.detail);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansRegular,
        fontSize: fontSize);
  }

  static detailsMedium(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.detail);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansMedium,
        fontSize: fontSize);
  }

  static detailsSemiBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.detail);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansSemiBold,
        fontSize: fontSize);
  }

  static detailsBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.detail);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color, fontFamily: FontsHelper.notosansBold, fontSize: fontSize);
  }

  static detailsItalic(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.detail);
    return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansItalic,
        fontSize: fontSize);
  }

  /// ******  Caption  ******
  static captionThin(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.caption);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color, fontFamily: FontsHelper.notosansThin, fontSize: fontSize);
  }

  static captionLight(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.caption);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansLight,
        fontSize: fontSize);
  }

  static captionRegular(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.caption);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansRegular,
        fontSize: fontSize);
  }

  static captionMedium(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.caption);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansMedium,
        fontSize: fontSize);
  }

  static captionSemiBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.caption);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansSemiBold,
        fontSize: fontSize);
  }

  static captionBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.caption);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color, fontFamily: FontsHelper.notosansBold, fontSize: fontSize);
  }

  static captionItalic(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.caption);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansItalic,
        fontSize: fontSize);
  }

  /// ******  Small  ******
  static smallThin(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.small);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color, fontFamily: FontsHelper.notosansThin, fontSize: fontSize);
  }

  static smallLight(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.small);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansLight,
        fontSize: fontSize);
  }

  static smallRegular(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.small);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansRegular,
        fontSize: fontSize);
  }

  static smallMedium(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.small);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansMedium,
        fontSize: fontSize);
  }

  static smallSemiBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.small);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansSemiBold,
        fontSize: fontSize);
  }

  static smallBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.small);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color, fontFamily: FontsHelper.notosansBold, fontSize: fontSize);
  }

  static smallItalic(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.small);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansItalic,
        fontSize: fontSize);
  }

  /// ******  Extra Small  ******
  static extraSmallThin(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.extraSmall);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color, fontFamily: FontsHelper.notosansThin, fontSize: fontSize);
  }

  static extraSmallLight(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.extraSmall);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansLight,
        fontSize: fontSize);
  }

  static extraSmallRegular(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.extraSmall);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansRegular,
        fontSize: fontSize);
  }

  static extraSmallMedium(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.extraSmall);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansMedium,
        fontSize: fontSize);
  }

  static extraSmallSemiBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.extraSmall);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansSemiBold,
        fontSize: fontSize);
  }

  static extraSmallBold(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.extraSmall);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color, fontFamily: FontsHelper.notosansBold, fontSize: fontSize);
  }

  static extraSmallItalic(BuildContext context, Color color) {
    var fontSize = _getFontSize(FontType.extraSmall);
    return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: color,
        fontFamily: FontsHelper.notosansItalic,
        fontSize: fontSize);
  }

  /// Scale text font size as per device ratio

  static ScreenType getScreenRatio(BuildContext context) {
    double dprValue = _getDevicePixelRatio(context);
    printLog("Device DPR value:: $dprValue");

    if (dprValue >= 0 && dprValue < 1) {
      printLog("Device Size:: ${ScreenType.minimum}");
      return ScreenType.minimum;
    } else if (dprValue >= 1 && dprValue < 1.5) {
      printLog("Device Size:: ${ScreenType.low}");
      return ScreenType.low;
    } else if (dprValue >= 1.5 && dprValue < 2) {
      printLog("Device Size:: ${ScreenType.medium}");
      return ScreenType.medium;
    } else if (dprValue >= 2 && dprValue < 3) {
      printLog("Device Size:: ${ScreenType.high}");
      return ScreenType.high;
    } else if (dprValue >= 3 && dprValue < 4) {
      printLog("Device Size:: ${ScreenType.xHigh}");
      return ScreenType.xHigh;
    } else if (dprValue >= 4) {
      printLog("Device Size:: ${ScreenType.maximum}");
      return ScreenType.maximum;
    } else {
      printLog("Device Size:: ${ScreenType.unknown}");
      return ScreenType.unknown;
    }
  }

  static double _getFontSize(FontType type) {
    //if (AppTextStyleConfigController.shared.deviceScreenType == ScreenType.maximum) {
    switch (type) {
      case FontType.heading:
        return 26;
      case FontType.subHeading:
        return 22;
      case FontType.title:
        return 18;
      case FontType.subTitle:
        return 16;
      case FontType.detail:
        return 14;
      case FontType.caption:
        return 12;
      case FontType.small:
        return 10;
      case FontType.extraSmall:
        return 8;
      case FontType.extraBold:
        return 30;
    }
    // } else if (AppTextStyleConfigController.shared.deviceScreenType == ScreenType.xHigh) {
    //   switch (type) {
    //     case FontType.heading:
    //       return 24;
    //     case FontType.subHeading:
    //       return 20;
    //     case FontType.title:
    //       return 18;
    //     case FontType.subTitle:
    //       return 16;
    //     case FontType.detail:
    //       return 14;
    //     case FontType.caption:
    //       return 12;
    //     case FontType.extraBold:
    //       return 28;
    //   }
    // }
    // else if (AppTextStyleConfigController.shared.deviceScreenType == ScreenType.high) {
    //   switch (type) {
    //     case FontType.heading:
    //       return 22;
    //     case FontType.subHeading:
    //       return 18;
    //     case FontType.title:
    //       return 16;
    //     case FontType.subTitle:
    //       return 14;
    //     case FontType.detail:
    //       return 12;
    //     case FontType.caption:
    //       return 10;
    //     case FontType.extraBold:
    //       return 26;
    //   }
    // } else if (AppTextStyleConfigController.shared.deviceScreenType == ScreenType.medium) {
    //   switch (type) {
    //     case FontType.heading:
    //       return 20;
    //     case FontType.subHeading:
    //       return 18;
    //     case FontType.title:
    //       return 16;
    //     case FontType.subTitle:
    //       return 14;
    //     case FontType.detail:
    //       return 12;
    //     case FontType.caption:
    //       return 10;
    //     case FontType.extraBold:
    //       return 24;
    //   }
    // }
    // else if (AppTextStyleConfigController.shared.deviceScreenType == ScreenType.low || AppTextStyleConfigController.shared.deviceScreenType == ScreenType.minimum) {
    //   switch (type) {
    //     case FontType.heading:
    //       return 20;
    //     case FontType.subHeading:
    //       return 18;
    //     case FontType.title:
    //       return 16;
    //     case FontType.subTitle:
    //       return 14;
    //     case FontType.detail:
    //       return 12;
    //     case FontType.caption:
    //       return 10;
    //     case FontType.extraBold:
    //       return 24;
    //   }
    // }
    // else {
    //   switch (type) {
    //     case FontType.heading:
    //       return 20;
    //     case FontType.subHeading:
    //       return 18;
    //     case FontType.title:
    //       return 16;
    //     case FontType.subTitle:
    //       return 14;
    //     case FontType.detail:
    //       return 12;
    //     case FontType.caption:
    //       return 10;
    //     case FontType.extraBold:
    //       return 24;
    //   }
    // }
  }

  static double _getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }
}
