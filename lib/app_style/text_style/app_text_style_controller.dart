import 'app_text_style.dart';

class AppTextStyleConfigController {

  AppTextStyleConfigController._internal();

  factory AppTextStyleConfigController() {
    return shared;
  }

  static final AppTextStyleConfigController shared = AppTextStyleConfigController._internal();

  ScreenType? deviceScreenType;

}
