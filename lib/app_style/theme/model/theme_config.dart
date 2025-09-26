import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'theme_color_scheme.dart';

class ThemeConfig {
  ThemeConfig._privateConstructor();

  static final ThemeConfig instance = ThemeConfig._privateConstructor();

  factory ThemeConfig() {
    return instance;
  }

  /// [LIGHT THEME]
  final _lightTheme = ThemeData(
    textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
    useMaterial3: false,
    extensions: const <ThemeExtension<dynamic>>[
      CustomColorScheme(
        // PRIMARY
        primary: ThemeConstant.primary,
        primaryVariant1: ThemeConstant.primaryVariant1,
        primaryVariant2: ThemeConstant.primaryVariant2,
        primaryVariant3: ThemeConstant.primaryVariant3,
        primaryText: ThemeConstant.primaryText,
        primarySurface1: ThemeConstant.primarySurface1,
        primarySurface2: ThemeConstant.primarySurface2,
        // BACKGROUND
        background: ThemeConstant.background,
        backgroundVariant: ThemeConstant.backgroundVariant,
        surface: ThemeConstant.surface,
        surfaceVariant: ThemeConstant.surfaceVariant,
        disableVariant: ThemeConstant.disableVariant,
        // TEXT
        text: ThemeConstant.text,
        textDetail: ThemeConstant.textDetail,
        textHint: ThemeConstant.textHint,
        textCaption: ThemeConstant.textCaption,
        textWhite: ThemeConstant.textWhite,
        // YELLOW
        yellow: ThemeConstant.yellow,
        yellowVariant1: ThemeConstant.yellowVariant1,
        yellowVariant2: ThemeConstant.yellowVariant2,
        yellowText: ThemeConstant.yellowText,
        // CYAN
        cyan: ThemeConstant.cyan,
        cyanVariant1: ThemeConstant.cyanVariant1,
        cyanVariant2: ThemeConstant.cyanVariant2,
        cyanText: ThemeConstant.cyanText,
        // TEAL
        teal: ThemeConstant.teal,
        tealVariant1: ThemeConstant.tealVariant1,
        tealVariant2: ThemeConstant.tealVariant2,
        tealText: ThemeConstant.tealText,
        // PURPLE
        purple: ThemeConstant.purple,
        purpleVariant1: ThemeConstant.purpleVariant1,
        purpleVariant2: ThemeConstant.purpleVariant2,
        purpleVariant3: ThemeConstant.purpleVariant3,
        purpleText: ThemeConstant.purpleText,
        // RED
        red: ThemeConstant.red,
        redVariant1: ThemeConstant.redVariant1,
        redVariant2: ThemeConstant.redVariant2,
        redText: ThemeConstant.redText,
        green: ThemeConstant.green,
        greenVariant1: ThemeConstant.greenVariant1,

        //Shimmer Colors
        shimmerPrimary: ThemeConstant.shimmerLightPrimary,
        shimmerSecondary: ThemeConstant.shimmerLightSecondary,
        gray: ThemeConstant.grayLight,

        // Course Details
        blueVariant: ThemeConstant.blueVariant,
        pinkVariant: ThemeConstant.pinkVariant,
        greenVariant: ThemeConstant.greenVariant,
        yellowVariant: ThemeConstant.yellowVariant,
        purpleVariant: ThemeConstant.purpleVariant,
        lightBlueVariant: ThemeConstant.lightBlueVariant,
        tealVariant: ThemeConstant.tealVariant,
        primaryVariant: ThemeConstant.primaryVariant,
        blackVariant: ThemeConstant.blackVariant,
        greyVariant: ThemeConstant.greyVariant,
        darkPinkVariant: ThemeConstant.darkPinkVariant,
        navyBlueVariant: ThemeConstant.navyBlueVariant,

        //New Colors
        whiteText: ThemeConstant.whiteText,
        backgroundVariant1: ThemeConstant.backgroundVariant1,
        primarySurfaceWithOpacity: ThemeConstant.primarySurfaceWithOpacity,
        borderColors: ThemeConstant.borderColors,
        primarySurface3: ThemeConstant.primarySurface3,
        primarySurface4: ThemeConstant.primarySurface4,
        redBackground: ThemeConstant.redBackground,
      ),
    ],
  );

  /// [DARK THEME]
  final _darkTheme = ThemeData(
    textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
    useMaterial3: false,
    extensions: const <ThemeExtension<dynamic>>[
      CustomColorScheme(
        // PRIMARY
        primary: ThemeConstant.primary,
        primaryVariant1: ThemeConstant.primaryVariant1,
        primaryVariant2: ThemeConstant.primaryVariant2,
        primaryVariant3: ThemeConstant.primaryVariant3Dark,
        primaryText: ThemeConstant.primaryText,
        primarySurface1: ThemeConstant.primarySurface1Dark,
        primarySurface2: ThemeConstant.primarySurface2Dark,
        // BACKGROUND
        background: ThemeConstant.backgroundDark,
        backgroundVariant: ThemeConstant.backgroundVariantDark,
        surface: ThemeConstant.surfaceDark,
        surfaceVariant: ThemeConstant.surfaceVariantDark,
        disableVariant: ThemeConstant.disableVariant,
        // TEXT
        text: ThemeConstant.textDark,
        textDetail: ThemeConstant.textDetailDark,
        textHint: ThemeConstant.textHintDark,
        textCaption: ThemeConstant.textCaption,
        textWhite: ThemeConstant.textWhite,
        // YELLOW
        yellow: ThemeConstant.yellow,
        yellowVariant1: ThemeConstant.yellowVariant1,
        yellowVariant2: ThemeConstant.yellowVariant2,
        yellowText: ThemeConstant.yellowTextDark,
        // CYAN
        cyan: ThemeConstant.cyan,
        cyanVariant1: ThemeConstant.cyanVariant1,
        cyanVariant2: ThemeConstant.cyanVariant2,
        cyanText: ThemeConstant.cyanTextDark,
        // TEAL
        teal: ThemeConstant.teal,
        tealVariant1: ThemeConstant.tealVariant1,
        tealVariant2: ThemeConstant.tealVariant2,
        tealText: ThemeConstant.tealTextDark,
        // PURPLE
        purple: ThemeConstant.purple,
        purpleVariant1: ThemeConstant.purpleVariant1,
        purpleVariant2: ThemeConstant.purpleVariant2,
        purpleVariant3: ThemeConstant.purpleVariant3Dark,
        purpleText: ThemeConstant.purpleTextDark,
        // RED
        red: ThemeConstant.red,
        redVariant1: ThemeConstant.redVariant1,
        redVariant2: ThemeConstant.redVariant2,
        redText: ThemeConstant.redTextDark,
        green: ThemeConstant.green,
        greenVariant1: ThemeConstant.greenVariant1,
        //Shimmer Colors
        shimmerPrimary: ThemeConstant.shimmerDarkPrimary,
        shimmerSecondary: ThemeConstant.shimmerSecondaryDark,
        gray: ThemeConstant.grayDark,

        // Course Details
        blueVariant: ThemeConstant.blueVariantDark,
        pinkVariant: ThemeConstant.pinkVariantDark,
        greenVariant: ThemeConstant.greenVariantDark,
        yellowVariant: ThemeConstant.yellowVariantDark,
        purpleVariant: ThemeConstant.purpleVariantDark,
        lightBlueVariant: ThemeConstant.lightBlueVariantDark,
        tealVariant: ThemeConstant.tealVariantDark,
        primaryVariant: ThemeConstant.primaryVariantDark,
        blackVariant: ThemeConstant.blackVariantDark,
        greyVariant: ThemeConstant.greyVariantDark,
        darkPinkVariant: ThemeConstant.darkPinkVariantDark,
        navyBlueVariant: ThemeConstant.navyBlueVariantDark,

        // New Colors
        whiteText: ThemeConstant.whiteText,
        backgroundVariant1: ThemeConstant.backgroundVariant1Dark,
        primarySurfaceWithOpacity: ThemeConstant.primarySurfaceWithOpacityDark,
        borderColors: ThemeConstant.borderColorsDark,
        primarySurface3: ThemeConstant.primarySurface3,
        primarySurface4: ThemeConstant.primarySurface4Dark,
        redBackground: ThemeConstant.redBackground,
      ),
    ],
  );

  buildThemeData(bool? isDark) {
    return isDark == true ? _darkTheme : _lightTheme;
  }
}
