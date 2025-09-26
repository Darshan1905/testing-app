import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/text_field_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/get_my_policy/gmp_bloc.dart';
import 'package:occusearch/features/get_my_policy/model/ovhc_data_model.dart';
import 'package:occusearch/features/get_my_policy/widget/cover_type_widget.dart';
import 'package:occusearch/features/get_my_policy/widget/provider_widget.dart';
import 'package:occusearch/features/get_my_policy/widget/visa_type_widget.dart';

class OvhcPolicyCard extends StatelessWidget {
  final DataModel model;
  final int index;
  final GetMyPolicyBloc gmpBloc;
  final Function onTap;

  const OvhcPolicyCard({
    Key? key,
    required this.model,
    required this.index,
    required this.gmpBloc,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColorStyle.backgroundVariant(context),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      elevation: 5,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          StreamBuilder<Map<int, bool>>(
              stream: gmpBloc.loadingStream,
              builder: (context, snapshot) {
                final loadingMap = snapshot.data ?? {};
                final isLoading = loadingMap[index] ?? false;
                if (isLoading == false) {
                  return InkWellWidget(
                    onTap: () {
                      onTap();
                    },
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4)),
                          color: AppColorStyle.primary(context)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            StringHelper.buyNow,
                            style: AppTextStyle.detailsRegular(
                                context, AppColorStyle.textWhite(context)),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColorStyle.backgroundVariant(context),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: SizedBox(
                        height: 45.0,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: StreamBuilder<List<String>?>(
                            stream: gmpBloc.getLoadingMessage,
                            builder: (context, snapshot) {
                              List<RotateAnimatedText> messages = [
                                RotateAnimatedText(
                                  "Please wait...",
                                  textStyle: AppTextStyle.subTitleMedium(
                                    context,
                                    AppColorStyle.primary(context),
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
                                    textStyle: AppTextStyle.subTitleMedium(
                                      context,
                                      AppColorStyle.primary(context),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                );
                              }
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AnimatedTextKit(
                                    animatedTexts: messages,
                                    repeatForever: true,
                                    pause: const Duration(milliseconds: 0),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: AppColorStyle.primary(context),
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
          Stack(
            alignment: Alignment.topRight,
            children: [
              /*InkWellWidget(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  child: SvgPicture.asset(
                    IconsSVG.icCirclePlus,
                  ),
                ),
              ),*/
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: CachedNetworkImage(
                        imageUrl: model.logourl ?? "",
                        fit: BoxFit.fill,
                        placeholder: (context, error) =>
                            SvgPicture.asset(IconsSVG.placeholder),
                        errorWidget: (context, url, error) => Icon(
                              Icons.photo,
                              color: AppColorStyle.backgroundVariant(context),
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(model.planname ?? "",
                        style: AppTextStyle.detailsBold(
                            context, AppColorStyle.text(context))),
                  ),
                  Text('${model.name} - ${model.covertypename}',
                      style: AppTextStyle.captionMedium(
                          context, AppColorStyle.text(context))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('\$ ${model.price}',
                          style: AppTextStyle.subTitleBold(
                              context, AppColorStyle.text(context))),
                      const SizedBox(width: 10),
                      model.broserurl!.isNotEmpty
                          ? InkWellWidget(
                              onTap: () {
                                Utility.launchURL(model.broserurl ?? "");
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, right: 5),
                                child: SvgPicture.asset(
                                  IconsSVG.icDownloadPolicy,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowSortingDialog {
  static Future showSortingDialog(
      BuildContext context, GetMyPolicyBloc gmpBloc) {
    return showModalBottomSheet(
        context: context,
        //scrollControlDisabledMaxHeightRatio: 0.62,
        builder: (BuildContext context) {
          return Container(
            color: AppColorStyle.background(context),
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(StringHelper.editQuote,
                              style: AppTextStyle.titleBold(
                                  context, AppColorStyle.text(context))),
                        ],
                      ),
                      InkWellWidget(
                          onTap: () {
                            Navigator.pop(context);
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
                  const SizedBox(height: 10),
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
                              initDate: gmpBloc.ovhcDateEditingController.text);
                        },
                      ),
                      InkWellWidget(
                        onTap: () {
                          gmpBloc.selectDate(context,
                              ovscStartingDate: true,
                              initDate: gmpBloc.ovhcDateEditingController.text);
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(StringHelper.ovhcProvider,
                        style: AppTextStyle.detailsRegular(
                            context, AppColorStyle.text(context))),
                  ),
                  const SizedBox(height: 10),
                  ProviderWidget(gmpBloc: gmpBloc),
                  const SizedBox(height: 10),
                  StreamBuilder<bool>(
                      stream: gmpBloc.getLoadingSubject,
                      builder: (context, snapshot) {
                        if (snapshot.data == false) {
                          return ButtonWidget(
                            buttonColor: AppColorStyle.primary(context),
                            onTap: () async {
                              gmpBloc.selectedSortingStream.add("");
                              OVHCDataModel model =
                                  await gmpBloc.getOVHCDetails(context, true);
                              if (model.data == null || model.data!.isEmpty) {
                                return;
                              }
                              gmpBloc.oVHCListStream.add(model.data!);
                              Navigator.pop(context);
                            },
                            title: StringHelper.updateQuote,
                            logActionEvent: "",
                          );
                        } else {
                          return Material(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      AppColorStyle.backgroundVariant(context),
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
                                      List<RotateAnimatedText> messages = [
                                        RotateAnimatedText(
                                          "Please wait...",
                                          textStyle:
                                              AppTextStyle.subTitleMedium(
                                            context,
                                            AppColorStyle.primary(context),
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
                                            textStyle:
                                                AppTextStyle.subTitleMedium(
                                              context,
                                              AppColorStyle.primary(context),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        );
                                      }
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AnimatedTextKit(
                                            animatedTexts: messages,
                                            repeatForever: true,
                                            pause:
                                                const Duration(milliseconds: 0),
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              color: AppColorStyle.primary(
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
                ],
              ),
            ),
          );
        });
  }
}
