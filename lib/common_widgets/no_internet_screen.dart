import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:occusearch/app_style/text_style/app_text_style.dart';
import 'package:occusearch/app_style/theme/app_color_style.dart';
import 'package:occusearch/common_widgets/ink_well_widget.dart';
import 'package:occusearch/resources/icons.dart';
import 'package:occusearch/resources/string_helper.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key, required this.onRetry}) : super(key: key);
  final Function onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: SvgPicture.asset(IconsSVG.noInternetIcon)),
        const SizedBox(height: 40),
        Text(
          StringHelper.noInternet,
          style: AppTextStyle.detailsMedium(
              context, AppColorStyle.textDetail(context)),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          StringHelper.checkDiffNetwork,
          style: AppTextStyle.captionRegular(
              context, AppColorStyle.textHint(context)),
        ),
        const SizedBox(
          height: 30.0,
        ),
        InkWellWidget(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColorStyle.primary(context),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Text(
                "Retry",
                style: AppTextStyle.detailsMedium(
                  context,
                  AppColorStyle.textWhite(context),
                ),
              ),
            ),
            onTap: () {
              onRetry();
            })
      ],
    );
  }
}
