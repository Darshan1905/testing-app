import 'package:flutter/material.dart';

@immutable
class CustomColorScheme extends ThemeExtension<CustomColorScheme> {
  // PRIMARY
  final Color? primary;
  final Color? primaryVariant1;
  final Color? primaryVariant2;
  final Color? primaryVariant3;
  final Color? primaryText;
  final Color? primarySurface1;
  final Color? primarySurface2;

  // BACKGROUND
  final Color? background;
  final Color? backgroundVariant;
  final Color? surface;
  final Color? surfaceVariant;
  final Color? disableVariant;

  // TEXT
  final Color? text;
  final Color? textDetail;
  final Color? textHint;
  final Color? textCaption;
  final Color? textWhite;

  // YELLOW
  final Color? yellow;
  final Color? yellowVariant1;
  final Color? yellowVariant2;
  final Color? yellowText;

  // CYAN
  final Color? cyan;
  final Color? cyanVariant1;
  final Color? cyanVariant2;
  final Color? cyanText;

  // TEAL
  final Color? teal;
  final Color? tealVariant1;
  final Color? tealVariant2;
  final Color? tealText;

  // PURPLE
  final Color? purple;
  final Color? purpleVariant1;
  final Color? purpleVariant2;
  final Color? purpleVariant3;
  final Color? purpleText;

  // RED
  final Color? red;
  final Color? redVariant1;
  final Color? redVariant2;
  final Color? redText;

  // RED
  final Color? green;
  final Color? greenVariant1;

  //Shimmer Colors
  final Color? shimmerPrimary;
  final Color? shimmerSecondary;

  final Color? gray;

  // Course Details
  final Color? blueVariant;
  final Color? pinkVariant;
  final Color? greenVariant;
  final Color? yellowVariant;
  final Color? purpleVariant;
  final Color? lightBlueVariant;
  final Color? tealVariant;
  final Color? primaryVariant;
  final Color? blackVariant;
  final Color? greyVariant;
  final Color? darkPinkVariant;
  final Color? navyBlueVariant;

  // New Colors
  final Color? whiteText;
  final Color? backgroundVariant1;
  final Color? primarySurfaceWithOpacity;
  final Color? borderColors;
  final Color? primarySurface3;
  final Color? primarySurface4;
  final Color? redBackground;

  const CustomColorScheme({
    // PRIMARY
    required this.primary,
    required this.primaryVariant1,
    required this.primaryVariant2,
    required this.primaryVariant3,
    required this.primaryText,
    required this.primarySurface1,
    required this.primarySurface2,
    // BACKGROUND
    required this.background,
    required this.backgroundVariant,
    required this.surface,
    required this.surfaceVariant,
    required this.disableVariant,
    // TEXT
    required this.text,
    required this.textDetail,
    required this.textHint,
    required this.textCaption,
    required this.textWhite,
    // YELLOW
    required this.yellow,
    required this.yellowVariant1,
    required this.yellowVariant2,
    required this.yellowText,
    // CYAN
    required this.cyan,
    required this.cyanVariant1,
    required this.cyanVariant2,
    required this.cyanText,
    // TEAL
    required this.teal,
    required this.tealVariant1,
    required this.tealVariant2,
    required this.tealText,
    // PURPLE
    required this.purple,
    required this.purpleVariant1,
    required this.purpleVariant2,
    required this.purpleVariant3,
    required this.purpleText,
    // RED
    required this.red,
    required this.redVariant1,
    required this.redVariant2,
    required this.redText,
    required this.green,
    required this.greenVariant1,
    required this.shimmerPrimary,
    required this.shimmerSecondary,
    required this.gray,
    // Course Details
    required this.blueVariant,
    required this.pinkVariant,
    required this.greenVariant,
    required this.yellowVariant,
    required this.purpleVariant,
    required this.lightBlueVariant,
    required this.tealVariant,
    required this.primaryVariant,
    required this.blackVariant,
    required this.greyVariant,
    required this.darkPinkVariant,
    required this.navyBlueVariant,
    // New Colors
    required this.whiteText,
    required this.backgroundVariant1,
    required this.primarySurfaceWithOpacity,
    required this.borderColors,
    required this.primarySurface3,
    required this.primarySurface4,
    required this.redBackground,
  });

  @override
  CustomColorScheme copyWith({
    // PRIMARY
    Color? primary,
    Color? primaryVariant1,
    Color? primaryVariant2,
    Color? primaryVariant3,
    Color? primaryText,
    Color? primarySurface1,
    Color? primarySurface2,
    // BACKGROUND
    Color? background,
    Color? backgroundVariant,
    Color? surface,
    Color? surfaceVariant,
    Color? disableVariant,
    // TEXT
    Color? text,
    Color? textDetail,
    Color? textHint,
    Color? textCaption,
    Color? textWhite,
    // YELLOW
    Color? yellow,
    Color? yellowVariant1,
    Color? yellowVariant2,
    Color? yellowText,
    // CYAN
    Color? cyan,
    Color? cyanVariant1,
    Color? cyanVariant2,
    Color? cyanText,
    // TEAL
    Color? teal,
    Color? tealVariant1,
    Color? tealVariant2,
    Color? tealText,
    // PURPLE
    Color? purple,
    Color? purpleVariant1,
    Color? purpleVariant2,
    Color? purpleVariant3,
    Color? purpleText,
    // RED
    Color? red,
    Color? redVariant1,
    Color? redVariant2,
    Color? redText,

    // RED
    final Color? green,
    final Color? greenVariant1,
    Color? shimmerPrimary,
    Color? shimmerSecondary,
    Color? gray,

    // Course Details
    Color? blueVariant,
    Color? pinkVariant,
    Color? greenVariant,
    Color? yellowVariant,
    Color? purpleVariant,
    Color? lightBlueVariant,
    Color? tealVariant,
    Color? primaryVariant,
    Color? blackVariant,
    Color? greyVariant,
    Color? darkPinkVariant,
    Color? navyBlueVariant,

    //New Colors
    Color? whiteText,
    Color? primaryVariant4,
    Color? primaryVariant5,
    Color? backgroundVariant1,
    Color? primarySurfaceWithOpacity,
    Color? borderColors,
    Color? primarySurface3,
    Color? primarySurface4,
    Color? redBackground,
  }) {
    return CustomColorScheme(
      // PRIMARY
      primary: primary ?? this.primary,
      primaryVariant1: primaryVariant1 ?? this.primaryVariant1,
      primaryVariant2: primaryVariant2 ?? this.primaryVariant2,
      primaryVariant3: primaryVariant3 ?? this.primaryVariant3,
      primaryText: primaryText ?? this.primaryText,
      primarySurface1: primarySurface1 ?? this.primarySurface1,
      primarySurface2: primarySurface2 ?? this.primarySurface2,
      // BACKGROUND
      background: background ?? this.background,
      backgroundVariant: backgroundVariant ?? this.backgroundVariant,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      disableVariant: disableVariant ?? this.disableVariant,
      // TEXT
      text: text ?? this.text,
      textDetail: textDetail ?? this.textDetail,
      textHint: textHint ?? this.textHint,
      textCaption: textCaption ?? this.textCaption,
      textWhite: textWhite ?? this.textWhite,
      // YELLOW
      yellow: yellow ?? this.yellow,
      yellowVariant1: yellowVariant1 ?? this.yellowVariant1,
      yellowVariant2: yellowVariant2 ?? this.yellowVariant2,
      yellowText: yellowText ?? this.yellowText,
      // CYAN
      cyan: cyan ?? this.cyan,
      cyanVariant1: cyanVariant1 ?? this.cyanVariant1,
      cyanVariant2: cyanVariant2 ?? this.cyanVariant2,
      cyanText: cyanText ?? this.cyanText,
      // TEAL
      teal: teal ?? this.teal,
      tealVariant1: tealVariant1 ?? this.tealVariant1,
      tealVariant2: tealVariant2 ?? this.tealVariant2,
      tealText: tealText ?? this.tealText,
      // PURPLE
      purple: purple ?? this.purple,
      purpleVariant1: purpleVariant1 ?? this.purpleVariant1,
      purpleVariant2: purpleVariant2 ?? this.purpleVariant2,
      purpleVariant3: purpleVariant3 ?? this.purpleVariant3,
      purpleText: purpleText ?? this.purpleText,
      // RED
      red: red ?? this.red,
      redVariant1: redVariant1 ?? this.redVariant1,
      redVariant2: redVariant2 ?? this.redVariant2,
      redText: redText ?? this.redText,
      green: green ?? this.green,
      greenVariant1: greenVariant1 ?? this.greenVariant1,
      shimmerPrimary: shimmerPrimary ?? this.shimmerPrimary,
      shimmerSecondary: shimmerSecondary ?? this.shimmerSecondary,
      gray: gray ?? this.gray,
      // Course Details
      blueVariant: blueVariant ?? this.blueVariant,
      pinkVariant: pinkVariant ?? this.pinkVariant,
      greenVariant: greenVariant ?? this.greenVariant,
      yellowVariant: yellowVariant ?? this.yellowVariant,
      purpleVariant: purpleVariant ?? this.purpleVariant,
      lightBlueVariant: lightBlueVariant ?? this.lightBlueVariant,
      tealVariant: tealVariant ?? this.tealVariant,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      blackVariant: blackVariant ?? this.blackVariant,
      greyVariant: greyVariant ?? this.greyVariant,
      darkPinkVariant: darkPinkVariant ?? this.darkPinkVariant,
      navyBlueVariant: navyBlueVariant ?? this.navyBlueVariant,
      //New Colors
      whiteText: whiteText ?? this.whiteText,
      backgroundVariant1: backgroundVariant1 ?? this.backgroundVariant1,
      primarySurfaceWithOpacity: primarySurfaceWithOpacity ?? this.primarySurfaceWithOpacity,
      borderColors: borderColors ?? this.borderColors,
      primarySurface3: primarySurface3 ?? this.primarySurface3,
      primarySurface4: primarySurface4 ?? this.primarySurface4,
      redBackground: redBackground ?? this.redBackground,
    );
  }

  // Controls how the properties change on theme changes
  @override
  CustomColorScheme lerp(ThemeExtension<CustomColorScheme>? other, double t) {
    if (other is! CustomColorScheme) {
      return this;
    }
    return CustomColorScheme(
      // PRIMARY
      primary: Color.lerp(primary, other.primary, t),
      primaryVariant1: Color.lerp(primaryVariant1, other.primaryVariant1, t),
      primaryVariant2: Color.lerp(primaryVariant2, other.primaryVariant2, t),
      primaryVariant3: Color.lerp(primaryVariant3, other.primaryVariant3, t),
      primaryText: Color.lerp(primaryText, other.primaryText, t),
      primarySurface1: Color.lerp(primarySurface1, other.primarySurface1, t),
      primarySurface2: Color.lerp(primarySurface2, other.primarySurface2, t),
      // BACKGROUND
      background: Color.lerp(background, other.background, t),
      backgroundVariant:
          Color.lerp(backgroundVariant, other.backgroundVariant, t),
      surface: Color.lerp(surface, other.surface, t),
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t),
      disableVariant: Color.lerp(disableVariant, other.disableVariant, t),
      // TEXT
      text: Color.lerp(text, other.text, t),
      textDetail: Color.lerp(textDetail, other.textDetail, t),
      textHint: Color.lerp(textHint, other.textHint, t),
      textCaption: Color.lerp(textCaption, other.textCaption, t),
      textWhite: Color.lerp(textWhite, other.textWhite, t),
      // YELLOW
      yellow: Color.lerp(yellow, other.yellow, t),
      yellowVariant1: Color.lerp(yellowVariant1, other.yellowVariant1, t),
      yellowVariant2: Color.lerp(yellowVariant2, other.yellowVariant2, t),
      yellowText: Color.lerp(yellowText, other.yellowText, t),
      // CYAN
      cyan: Color.lerp(cyan, other.cyan, t),
      cyanVariant1: Color.lerp(cyanVariant1, other.cyanVariant1, t),
      cyanVariant2: Color.lerp(cyanVariant2, other.cyanVariant2, t),
      cyanText: Color.lerp(cyanText, other.cyanText, t),
      // TEAL
      teal: Color.lerp(teal, other.teal, t),
      tealVariant1: Color.lerp(tealVariant1, other.tealVariant1, t),
      tealVariant2: Color.lerp(tealVariant2, other.tealVariant2, t),
      tealText: Color.lerp(tealText, other.tealText, t),
      // PURPLE
      purple: Color.lerp(purple, other.purple, t),
      purpleVariant1: Color.lerp(purpleVariant1, other.purpleVariant1, t),
      purpleVariant2: Color.lerp(purpleVariant2, other.purpleVariant2, t),
      purpleVariant3: Color.lerp(purpleVariant3, other.purpleVariant3, t),
      purpleText: Color.lerp(purpleText, other.purpleText, t),
      // RED
      red: Color.lerp(red, other.red, t),
      redVariant1: Color.lerp(redVariant1, other.redVariant1, t),
      redVariant2: Color.lerp(redVariant2, other.redVariant2, t),
      redText: Color.lerp(redText, other.redText, t),

      green: Color.lerp(green, other.green, t),
      greenVariant1: Color.lerp(greenVariant1, other.greenVariant1, t),

      shimmerPrimary: Color.lerp(shimmerPrimary, other.shimmerPrimary, t),
      shimmerSecondary: Color.lerp(shimmerSecondary, other.shimmerSecondary, t),

      gray: Color.lerp(gray, other.gray, t),

      // Course Details
      blueVariant: Color.lerp(blueVariant, other.blueVariant, t),
      pinkVariant: Color.lerp(pinkVariant, other.pinkVariant, t),
      greenVariant: Color.lerp(greenVariant, other.greenVariant, t),
      yellowVariant: Color.lerp(yellowVariant, other.yellowVariant, t),
      purpleVariant: Color.lerp(purpleVariant, other.purpleVariant, t),
      lightBlueVariant: Color.lerp(lightBlueVariant, other.lightBlueVariant, t),
      tealVariant: Color.lerp(tealVariant, other.tealVariant, t),
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t),
      blackVariant: Color.lerp(blackVariant, other.blackVariant, t),
      greyVariant: Color.lerp(greyVariant, other.greyVariant, t),
      darkPinkVariant: Color.lerp(darkPinkVariant, other.darkPinkVariant, t),
      navyBlueVariant: Color.lerp(navyBlueVariant, other.navyBlueVariant, t),

      // New Colors
      whiteText: Color.lerp(whiteText, other.whiteText, t),
      backgroundVariant1: Color.lerp(backgroundVariant1, other.backgroundVariant1, t),
      primarySurfaceWithOpacity: Color.lerp(primarySurfaceWithOpacity, other.primarySurfaceWithOpacity, t),
      borderColors: Color.lerp(borderColors, other.borderColors, t),
      primarySurface3: Color.lerp(primarySurface3, other.primarySurface3, t),
      primarySurface4: Color.lerp(primarySurface4, other.primarySurface4, t),
      redBackground: Color.lerp(redBackground, other.redBackground, t),
    );
  }
}
