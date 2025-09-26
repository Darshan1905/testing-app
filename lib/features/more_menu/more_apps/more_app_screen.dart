import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/more_menu/more_apps/more_app_widget.dart';
import 'package:occusearch/features/more_menu/more_menu_bloc.dart';

class MoreAppsScreen extends BaseApp {
  const MoreAppsScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _MoreAppsScreenState();
}

class _MoreAppsScreenState extends BaseState {
  final MoreMenuBloc _moreMenuBloc = MoreMenuBloc();

  @override
  Widget body(BuildContext context) {
    return Container(
      color: AppColorStyle.backgroundVariant(context),
      child: SafeArea(
        child: RxBlocProvider(
          create: (_) => _moreMenuBloc,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColorStyle.backgroundVariant(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
                  child: Row(children: [
                    InkWellWidget(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        IconsSVG.arrowBack,
                        colorFilter: ColorFilter.mode( AppColorStyle.text(context),
                      BlendMode.srcIn,
                          ),),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      StringHelper.moreApps,
                      style: AppTextStyle.subHeadlineSemiBold(context, AppColorStyle.text(context)),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
                const MoreAppWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  init() {
    dynamic param = widget.arguments;
    if (param != null) {
      _moreMenuBloc.setMoreAppList = param;
    }
  }

  @override
  onResume() {}
}
