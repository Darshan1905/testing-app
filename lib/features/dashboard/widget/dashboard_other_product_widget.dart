import 'dart:io';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'dart:math' as math;
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/dashboard/dashboard_bloc.dart';
import 'package:occusearch/features/dashboard/model/other_services_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: must_be_immutable
class DashboardOtherProductWidget extends StatelessWidget {
  DashboardOtherProductWidget(this.theme, {Key? key}) : super(key: key);

  bool theme;
  DashboardBloc? _dashboardBloc;

  @override
  Widget build(BuildContext context) {
    _dashboardBloc ??= RxBlocProvider.of<DashboardBloc>(context);
    return Container(
      color: AppColorStyle.backgroundVariant(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                bottom: 20.0, right: 20.0, left: 20.0, top: 20),
            child: Text(
              StringHelper.dashboardOtherProduct,
              style: AppTextStyle.titleSemiBold(
                context,
                AppColorStyle.text(context),
              ),
            ),
          ),
          StreamBuilder<List<OtherServiceData>>(
            stream: _dashboardBloc?.getOtherProductList,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final List<OtherServiceData> otherProductList = snapshot.data ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: otherProductList.length,
                        itemBuilder: (context, index) => OtherProductRowWidget(
                            otherServiceData: otherProductList[index], index: index, theme: theme),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

class OtherProductRowWidget extends StatelessWidget {
  const OtherProductRowWidget(
      {Key? key, required this.otherServiceData, required this.index, required this.theme})
      : super(key: key);
  final OtherServiceData otherServiceData;
  final int index;
  final bool theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      margin: EdgeInsets.only(left: index == 0 ? 20 : 5.0, right: 15.0),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Color(int.parse(theme
            ? otherServiceData.theme!.dark!.secondary.toString()
            : otherServiceData.theme!.light!.secondary.toString())),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            right: -30,
            child: Transform.rotate(
                angle: -math.pi / 5,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: SvgPicture.network(
                    otherServiceData.logo ?? '',
                    colorFilter: ColorFilter.mode(
                      Color(int.parse(theme
                              ? otherServiceData.theme!.dark!.primary.toString()
                              : otherServiceData.theme!.light!.primary.toString()))
                          .withOpacity(0.2),
                      BlendMode.srcIn,
                    ),
                  ),
                )),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: Constants.commonPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  otherServiceData.title ?? "",
                  style: AppTextStyle.subTitleSemiBold(context, AppColorStyle.text(context)),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 55,
                  ),
                  child: HtmlWidget(
                    "${otherServiceData.description}",
                    textStyle: AppTextStyle.detailsRegular(
                      context,
                      AppColorStyle.textDetail(context),
                    ),
                    onTapUrl: (url) async => Utility.launchURL(url),
                    renderMode: RenderMode.column,
                  ),
                ),
                SizedBox(
                    height: (otherServiceData.notes != null &&
                            otherServiceData.notes != "" &&
                            otherServiceData.notes!.isNotEmpty)
                        ? 15
                        : 0),
                Text(
                  otherServiceData.notes ?? "",
                  style: AppTextStyle.detailsRegular(context, AppColorStyle.primary(context)),
                ),
                const Spacer(),
                InkWellWidget(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      if (otherServiceData.action!.link!.android != null) {
                        if (await canLaunchUrlString(
                            otherServiceData.action!.link!.android.toString())) {
                          await launchUrlString(otherServiceData.action!.link!.android.toString(),
                              mode: LaunchMode.externalApplication);
                        }
                      }
                    } else if (Platform.isIOS) {
                      if (otherServiceData.action!.link!.ios != null) {
                        if (await canLaunchUrlString(
                            otherServiceData.action!.link!.ios.toString())) {
                          await launchUrlString(otherServiceData.action!.link!.ios.toString(),
                              mode: LaunchMode.externalApplication);
                        }
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(int.parse(theme
                            ? otherServiceData.theme!.dark!.primary.toString()
                            : otherServiceData.theme!.light!.primary.toString()))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          otherServiceData.action!.title ?? "",
                          style: AppTextStyle.detailsRegular(
                              context, AppColorStyle.textWhite(context)),
                        ),
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          IconsSVG.arrowRight,
                          height: 14.0,
                          width: 14.0,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.textWhite(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
