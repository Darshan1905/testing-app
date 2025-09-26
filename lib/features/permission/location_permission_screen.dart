import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:occusearch/app_style/text_style/app_text_style.dart';
import 'package:occusearch/app_style/theme/app_color_style.dart';
import 'package:occusearch/common_widgets/ink_well_widget.dart';
import 'package:occusearch/features/app/base_app.dart';
import 'package:occusearch/features/contact_us/contact_us_bloc.dart';
import 'package:occusearch/navigation/route_navigation.dart';
import 'package:occusearch/navigation/routes.dart';
import 'package:occusearch/resources/icons.dart';
import 'package:occusearch/resources/string_helper.dart';

class LocationPermissionScreen extends BaseApp {
  const LocationPermissionScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends BaseState {
  final ContactUsBloc _contactUsBloc = ContactUsBloc();

  @override
  init() {}

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColorStyle.background(context)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 8,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: AppColorStyle.primary(context),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: SvgPicture.asset(IconsSVG.icLocationPermission),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "To not keep you restricted, we need access...",
                        style: AppTextStyle.titleSemiBold(
                            context, AppColorStyle.textWhite(context)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              flex: 7,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      IconsSVG.icLocation,
                      colorFilter: ColorFilter.mode(
                        AppColorStyle.text(context),
                        BlendMode.srcIn,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Location access",
                                style: AppTextStyle.titleSemiBold(
                                    context, AppColorStyle.text(context))),
                            Text(
                              StringHelper.locationAccess,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.subTitleRegular(
                                  context, AppColorStyle.textDetail(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    child: InkWell(
                      onTap: () async {
                        await _contactUsBloc.getCurrentLocation(
                            NavigatorMode.replace, context);
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                            color: AppColorStyle.primary(context),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              StringHelper.allowAccess,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.subTitleMedium(
                                context,
                                AppColorStyle.textWhite(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWellWidget(
                    onTap: () {
                      GoRoutesPage.go(
                          mode: NavigatorMode.replace,
                          moveTo: RouteName.contactUs,
                          param: {});
                    },
                    child: Text(
                      StringHelper.skipForNow,
                      style: AppTextStyle.subTitleMedium(
                        context,
                        AppColorStyle.primary(context),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
