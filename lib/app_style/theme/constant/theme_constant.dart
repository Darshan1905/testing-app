import 'package:flutter/material.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';

class ThemeConstant {

  ///////////////////////// LIGHT THEME /////////////////////////
  static const primary = Color(0xFF00549A);
  static const primaryVariant1 = Color(0xFF3374AE);
  static const primaryVariant2 = Color(0xFF5990BD);
  static const primaryVariant3 = Color(0xFFE6EEF5);

  static const primaryText = Color(0xFFA6C3DC);
  static const primarySurface1 = Color(0xFFD7EBFB);
  static const primarySurface2 = Color(0xFFDEF2FE);

  static const background = Color(0xFFFFFFFF);
  static const backgroundVariant = Color(0xFFF9F9F9);
  static const surface = Color(0xFFF1F1F1);
  static const surfaceVariant = Color(0xFFD9D9D9);
  static const disableVariant = Color(0xFFE1E1E1);

  static const text = Color(0xFF212427);
  static const textDetail = Color(0xFF595959);
  static const textHint = Color(0xFFA4A4A4);
  static const textCaption = Color(0xFF9E9E9E);
  static const textWhite = Color(0xFFFFFFFF);

  static const yellow = Color(0xFFDDAD00);
  static const yellowVariant1 = Color(0xFFE9CA59);
  static const yellowVariant2 = Color(0xFFF1DE99);
  static const yellowText = Color(0xFFFCF7E5);

  static const cyan = Color(0xFF00B4D8);
  static const cyanVariant1 = Color(0xFF40C7E2);
  static const cyanVariant2 = Color(0xFFB2E9F3);
  static const cyanText = Color(0xFFE0F7FA);

  static const teal = Color(0xFF00BFA5);
  static const tealVariant1 = Color(0xFF26C9B3);
  static const tealVariant2 = Color(0xFFA6E9DF);
  static const tealText = Color(0xFFE8F5E9);

  static const purple = Color(0xFF9575CD);
  static const purpleVariant1 = Color(0xFFA58AD5);
  static const purpleVariant2 = Color(0xFFDACFEE);
  static const purpleText = Color(0xFFEDE7F6);
  static const purpleVariant3 = Color(0xFFE8EFFC);

  static const red = Color(0xFFD76176);
  static const redVariant1 = Color(0xFFDF8191);
  static const redVariant2 = Color(0xFFEBB0BB);
  static const redText = Color(0xFFF7DFE4);
  static const redTextVariant = Color(0xFFF05242);

  //green color
  static const green = Color(0xFF1FA363);
  static const greenVariant1 = Color(0xFF1FA363);

//Shimmer colors
  //LIGHT
  static const shimmerLightPrimary = Color(0xffE8E8E8);
  static const shimmerLightSecondary = Color(0xcccccccc);
  //DARK
  static const shimmerDarkPrimary = Color(0x1af9f9f9);
  static const shimmerDarkSecondary = Color(0x26f9f9f9);

  static const grayDark = Color(0xff363636);
  static const grayDarkOne = Color(0xff878787);
  static const grayDarkTwo = Color(0xffF1F1F1);
  static const grayLight = Color(0xffF4F4F4);

  // Theme getter - setter method
  static String themeMode = SharedPreferenceConstants.themeMode;

  // Graph legend colors
  static const legendPrimary = Color(0xff4B87B9);
  static const legendSecondary = Color(0xffC06C84);

  //Occupation dashboard screen
  static const redVariantTemp = Color(0xffF57F7F);
  static const orangeVariantTemp = Color(0xffECA182);
  static const yellowVariantTemp = Color(0xffE1BC7F);
  static const lightGreenVariantTemp = Color(0xffADD383);
  static const greenVariantTemp = Color(0xff75CB95);

  //Course detail screen
  static const blueVariant = Color(0x100074C9);
  static const pinkVariant = Color(0x10FF6082);
  static const greenVariant = Color(0x1000A424);
  static const yellowVariant = Color(0x10DDAD00);
  static const purpleVariant = Color(0x109575CD);
  static const lightBlueVariant = Color(0x1000B4D8);
  static const tealVariant = Color(0x1000BFA5);
  static const primaryVariant = Color(0x2000549A);
  static const blackVariant = Color(0x90E1E1E1);
  static const greyVariant = Color(0x10878787);
  static const darkPinkVariant = Color(0x20D42EEA);
  static const navyBlueVariant = Color(0x2014228F);

  //Visa Subclass List in Custom Question
  static const cyanColor = Color(0xff009688);
  static const orangeColor = Color(0xffFF9E22);
  static const blueColor = Color(0xff29B6F6);
  static const yellowColor = Color(0xffFFCD2C);
  static const redColor = Color(0xffEF5350);
  static const purpleColor = Color(0xff7E57C2);
  static const greenColor = Color(0xff009688);
  static const peachColor = Color(0xffECA182);

  static List arrRandomColors = [
    blueVariant,
    pinkVariant,
    greenVariant,
    yellowVariant,
    purpleVariant,
    lightBlueVariant,
    tealVariant,
    primaryVariant,
    blackVariant,
    greyVariant,
    darkPinkVariant,
    navyBlueVariant
  ];

  static List arrRandomVisaListColors = [
    cyanColor,
    orangeColor,
    blueColor,
    yellowColor,
    redColor,
    purpleColor,
    greenColor,
    greenColor,
    peachColor
  ];

  // New added colors
  static const whiteText = Color(0xFF80A9CC);
  static const backgroundVariant1 = Color(0xFFF9F9F9);
  static const primarySurfaceWithOpacity = Color(0x1000549A);
  static const borderColors = Color(0x30000000);
  static const primarySurface3 = Color(0xFFD7EBFB);
  static const primarySurface4 = Color(0x30DEF2FE);
  static const primarySurface5 = Color(0x99FFFFFF);
  static const redBackground = Color(0xFFF7DFE4);

  ///////////////////////// DARK THEME /////////////////////////
  // static const primaryDark = Color(0xFF00549A);
  // static const primaryVariant1Dark = Color(0xFF3374AE);
  // static const primaryVariant2Dark = Color(0xFF5990BD);
  static const primaryVariant3Dark = Color(0xFF161616);

  //static const primaryTextDark = Color(0xFFA6C3DC);
  static const primarySurface1Dark = Color(0xFF3376AE);
  static const primarySurface2Dark = Color(0xFF212427);


  static const backgroundDark = Color(0xFF161616);
  static const backgroundVariantDark = Color(0xFF212427);
  static const surfaceDark = Color(0xFF212427);
  static const surfaceVariantDark = Color(0xFF595959);
  // static const surfaceVariantDark = Color(0xFFD9D9D9);
  // static const disableVariantDark = Color(0xFFE1E1E1);

  static const textDark = Color(0xBFFFFFFF);
  static const textDetailDark = Color(0xFF8b8b8b);
  // static const textDetailDark = Color(0xFFBDB2B2);
  static const textHintDark = Color(0xFF595959);
  static const textCaptionDark = Color(0xFF9E9E9E);
  static const textWhiteDark = Color(0xFFFFFFFF);

  // static const yellowDark = Color(0xFFDDAD00);
  // static const yellowVariant1Dark = Color(0xFFE9CA59);
  // static const yellowVariant2Dark = Color(0xFFF1DE99);
  static const yellowTextDark = Color(0x10FFFDE7);

  // static const cyanDark = Color(0xFF00B4D8);
  // static const cyanVariant1Dark = Color(0xFF40C7E2);
  // static const cyanVariant2Dark = Color(0xFFB2E9F3);
  static const cyanTextDark = Color(0x10DFF4FE);

  // static const tealDark = Color(0xFF00BFA5);
  // static const tealVariant1Dark = Color(0xFF26C9B3);
  // static const tealVariant2Dark = Color(0xFFA6E9DF);
  static const tealTextDark = Color(0x10E8F5E9);

  // static const purpleDark = Color(0xFF9575CD);
  // static const purpleVariant1Dark = Color(0xFFA58AD5);
  // static const purpleVariant2Dark = Color(0xFFDACFEE);
  static const purpleTextDark = Color(0x10EDE7F6);

  // static const redDark = Color(0xFFD76176);
  // static const redVariant1Dark = Color(0xFFDF8191);
  // static const redVariant2Dark = Color(0xFFEBB0BB);
  static const redTextDark = Color(0x10FFEBEE);
  static const purpleVariant3Dark = Color(0x10FFEBEE);

  //green color
  static const greenDark = Color(0xFF1FA363);
  static const greenVariant1Dark = Color(0xFF1FA363);

//Shimmer colors
  //DARK
  static const shimmerPrimaryDark = Color(0x334a4a4a);
  static const shimmerSecondaryDark = Color(0xcc3a3a3a);

  // ------------- Need Give Another Name -----------------
  static const grayDarkTheme = Color(0xff363636);

  // Theme getter - setter method
  static String themeModeDark = SharedPreferenceConstants.themeMode;

  // Graph legend colors
  static const legendPrimaryDark = Color(0xff4B87B9);
  static const legendSecondaryDark = Color(0xffC06C84);

  //Occupation dashboard screen
  static const redVariantTempDark = Color(0xffF57F7F);
  static const orangeVariantTempDark = Color(0xffECA182);
  static const yellowVariantTempDark = Color(0xffE1BC7F);
  static const lightGreenVariantTempDark = Color(0xffADD383);
  static const greenVariantTempDark = Color(0xff75CB95);

  //Course detail screen
  static const blueVariantDark = Color(0x260074C9);
  static const pinkVariantDark = Color(0x26FF6082);
  static const greenVariantDark = Color(0x2600A424);
  static const yellowVariantDark = Color(0x26DDAD00);
  static const purpleVariantDark = Color(0x269575CD);
  static const lightBlueVariantDark = Color(0x2600B4D8);
  static const tealVariantDark = Color(0x2600BFA5);
  static const primaryVariantDark = Color(0x2600549A);
  static const blackVariantDark = Color(0x26E1E1E1);
  static const greyVariantDark = Color(0x26878787);
  static const darkPinkVariantDark = Color(0x26D42EEA);
  static const navyBlueVariantDark = Color(0x2614228F);

  //Visa Subclass List in Custom Question
  static const cyanColorDark = Color(0xff009688);
  static const orangeColorDark = Color(0xffFF9E22);
  static const blueColorDark = Color(0xff29B6F6);
  static const yellowColorDark = Color(0xffFFCD2C);
  static const redColorDark = Color(0xffEF5350);
  static const purpleColorDark = Color(0xff7E57C2);
  static const greenColorDark = Color(0xff009688);
  static const peachColorDark = Color(0xffECA182);

  static List arrRandomColorsDark = [
    blueVariantDark,
    pinkVariantDark,
    greenVariantDark,
    yellowVariantDark,
    purpleVariantDark,
    lightBlueVariantDark,
    tealVariantDark,
    primaryVariantDark,
    blackVariantDark,
    greyVariantDark,
    darkPinkVariantDark,
    navyBlueVariantDark
  ];

  static List arrRandomVisaListColorsDark = [
    cyanColorDark,
    orangeColorDark,
    blueColorDark,
    yellowColorDark,
    redColorDark,
    purpleColorDark,
    greenColorDark,
    greenColorDark,
    peachColorDark
  ];

  //New Colors
  static const backgroundVariant1Dark = Color(0xFF2D2E2F);
  static const primarySurfaceWithOpacityDark = Color(0x3000549A);
  static const borderColorsDark = Color(0xFF383838);
  static const primarySurface4Dark = Color(0xFF2A2C2D);
  static const primaryVariant5Dark = Color(0x3000549A);

  static setTheme(bool value) async {
    await SharedPreferenceController.setBool(themeMode, value);
  }

  static getTheme() async {
    return await SharedPreferenceController.getBool(themeMode);
  }
}
