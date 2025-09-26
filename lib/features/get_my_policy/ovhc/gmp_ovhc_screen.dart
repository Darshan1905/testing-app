import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/text_field_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/get_my_policy/gmp_bloc.dart';
import 'package:occusearch/features/get_my_policy/model/ovhc_data_model.dart';
import 'package:occusearch/features/get_my_policy/widget/cover_type_widget.dart';
import 'package:occusearch/features/get_my_policy/widget/visa_type_widget.dart';

class GMPOVHCPage extends BaseApp {
  const GMPOVHCPage({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => GMPOVHCPageState();
}

class GMPOVHCPageState extends BaseState {
  GetMyPolicyBloc gmpBloc = GetMyPolicyBloc();

  @override
  init() {
    gmpBloc.initData();
  }

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider<GetMyPolicyBloc>(
      create: (context) => GetMyPolicyBloc(),
      child: Container(
        color: AppColorStyle.background(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(StringHelper.ovhcPolicy,
                            style: AppTextStyle.headlineBold(
                                context, AppColorStyle.text(context))),
                      ],
                    ),
                    InkWellWidget(
                        onTap: () {
                          context.pop();
                        },
                        child: SvgPicture.asset(
                          IconsSVG.closeIcon,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.text(context),
                            BlendMode.srcIn,
                          ),
                        ))
                  ],
                ),
                const SizedBox(height: 15),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 100 / 3),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, _) => LinearProgressIndicator(
                    minHeight: 2.0,
                    value: 3,
                    backgroundColor: AppColorStyle.backgroundVariant(context),
                    color: AppColorStyle.primary(context).withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(StringHelper.ovhcVisaType,
                              style: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                        const SizedBox(height: 15),
                        VisaTypeWidget(gmpBloc: gmpBloc),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(StringHelper.ovhcCoverType,
                              style: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                        const SizedBox(height: 15),
                        CoverTypeWidget(gmpBloc: gmpBloc, type: "OVHC"),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(StringHelper.oshcStartDate,
                              style: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                        const SizedBox(height: 15),
                        Stack(
                          children: [
                            TextFieldWithoutStreamWidget(
                              onTextChanged: gmpBloc.onChangeStartingDate,
                              controller: gmpBloc.ovhcDateEditingController,
                              hintStyle: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.textHint(context)),
                              hintText: StringHelper.hintDateFormat,
                              keyboardKey: TextInputType.datetime,
                              readOnly: true,
                              onTap: () {
                                gmpBloc.selectDate(context,
                                    ovscStartingDate: true,
                                    initDate:
                                        gmpBloc.ovhcDateEditingController.text);
                              },
                            ),
                            InkWellWidget(
                              onTap: () {
                                gmpBloc.selectDate(context,
                                    ovscStartingDate: true,
                                    initDate:
                                        gmpBloc.ovhcDateEditingController.text);
                              },
                              child: Container(
                                height: 50.0,
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SvgPicture.asset(
                                    IconsSVG.icCalendar,
                                    colorFilter: ColorFilter.mode(
                                      AppColorStyle.text(context),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(StringHelper.ovhcPolicyNote,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                        const SizedBox(height: 40),
                        SvgPicture.asset(
                          IconsSVG.oVHCProviders,
                        ),
                        const SizedBox(height: 40),
                        StreamBuilder<bool>(
                            stream: gmpBloc.getLoadingSubject,
                            builder: (context, snapshot) {
                              if (snapshot.data == false) {
                                return InkWellWidget(
                                  onTap: onTapGetQuote,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 45.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: AppColorStyle.primary(context)),
                                    child: Text(
                                      StringHelper.getAQuote,
                                      style: AppTextStyle.subTitleMedium(
                                          context,
                                          AppColorStyle.textWhite(context)),
                                    ),
                                  ),
                                );
                              } else {
                                return Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColorStyle.backgroundVariant(
                                            context),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: SizedBox(
                                      height: 45.0,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: StreamBuilder<List<String>?>(
                                          stream: gmpBloc.getLoadingMessage,
                                          builder: (context, snapshot) {
                                            List<RotateAnimatedText> messages =
                                                [
                                              RotateAnimatedText(
                                                "Please wait...",
                                                textStyle:
                                                    AppTextStyle.subTitleMedium(
                                                  context,
                                                  AppColorStyle.primary(
                                                      context),
                                                ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ];
                                            if (snapshot.hasData &&
                                                snapshot.data != null &&
                                                snapshot.data!.isNotEmpty) {
                                              messages = List.generate(
                                                snapshot.data!.length,
                                                (index) => RotateAnimatedText(
                                                  snapshot.data![index],
                                                  textStyle: AppTextStyle
                                                      .subTitleMedium(
                                                    context,
                                                    AppColorStyle.primary(
                                                        context),
                                                  ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                ),
                                              );
                                            }
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AnimatedTextKit(
                                                  animatedTexts: messages,
                                                  repeatForever: true,
                                                  pause: const Duration(
                                                      milliseconds: 0),
                                                ),
                                                SizedBox(
                                                  width: 20.0,
                                                  height: 20.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                    color:
                                                        AppColorStyle.primary(
                                                            context),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  onResume() {}

  onTapGetQuote() async {
    if (NetworkController.isInternetConnected == true) {
      if (gmpBloc.selectedVisaTypeStream.hasValue == false) {
        Toast.show(context,
            message: StringHelper.selectVisaType, type: Toast.toastError);
        return;
      } else if (gmpBloc.selectedCoverTypeStream.hasValue == false) {
        Toast.show(context,
            message: StringHelper.selectCoverType, type: Toast.toastError);
        return;
      } else if (gmpBloc.ovhcDateEditingController.text.isEmpty) {
        Toast.show(context,
            message: StringHelper.selectStartDate, type: Toast.toastError);
        return;
      } else {
        //Reset selected provider value to default
        gmpBloc.selectedProviderStream.add(gmpBloc.providerStream.value.first);
        gmpBloc.selectedSortingStream.add("");
        OVHCDataModel model = await gmpBloc.getOVHCDetails(context, false);
        if (model.data == null) {
          return;
        }
        gmpBloc.oVHCListStream.add(model.data!);
        var param = {
          "bloc": gmpBloc,
        };

        GoRoutesPage.go(
            mode: NavigatorMode.push,
            moveTo: RouteName.gmpOVHCDetailsScreen,
            param: param);
      }
    } else {
      Toast.show(context,
          message: StringHelper.internetConnection,
          type: Toast.toastError,
          duration: 3);
    }
  }
}
