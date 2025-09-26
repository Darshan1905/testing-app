import 'package:flutter/services.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/vevo_check/model/vevo_check_model.dart';
import 'package:occusearch/features/vevo_check/vevo_check_bloc.dart';
import 'package:occusearch/features/vevo_check/widgets/generate_pdf_for_vevo_check.dart';
import 'package:printing/printing.dart';

class VevoCheckVisaCardWidget extends StatelessWidget {
  const VevoCheckVisaCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vevoCheckBloc = RxBlocProvider.of<VevoCheckBloc>(context);

    return StreamBuilder(
        stream: vevoCheckBloc.getVevoCheckDetailsModelStream,
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            if (snapshot.data != null) {
              VevoVisaDetailModel? vevoVisaDetailModel = snapshot.data;

              return Container(
                decoration: BoxDecoration(
                  color: AppColorStyle.red(context),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (vevoVisaDetailModel!.givenName != null)
                                ? "${vevoVisaDetailModel.givenName} ${vevoVisaDetailModel.familyName}"
                                : "-",
                            style: AppTextStyle.titleMedium(
                                context, AppColorStyle.background(context)),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            (vevoCheckBloc.isSelectedRefType.value)
                                ? StringHelper.visaVGN
                                : StringHelper.visaTRN,
                            style: AppTextStyle.detailsMedium(
                                context, AppColorStyle.redVariant2(context)),
                          ),
                          Text(
                            (vevoVisaDetailModel.visaGrantNumber != null)
                                ? vevoVisaDetailModel.visaGrantNumber.toString()
                                : "-",
                            style: AppTextStyle.subTitleMedium(
                                context, AppColorStyle.background(context)),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    StringHelper.visaClassOrSubclass,
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.redVariant2(context)),
                                  ),
                                  Text(
                                    (vevoVisaDetailModel.visaClassSubclass !=
                                            null)
                                        ? vevoVisaDetailModel.visaClassSubclass
                                            .toString()
                                        : "-",
                                    style: AppTextStyle.subTitleMedium(context,
                                        AppColorStyle.background(context)),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    StringHelper.periodOfStay,
                                    style: AppTextStyle.detailsMedium(context,
                                        AppColorStyle.redVariant2(context)),
                                  ),
                                  Text(
                                    (vevoVisaDetailModel.periodOfStay != null)
                                        ? vevoVisaDetailModel.periodOfStay
                                            .toString()
                                        : "-",
                                    style: AppTextStyle.subTitleMedium(context,
                                        AppColorStyle.background(context)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10.0),
                            height: 35.0,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: (vevoVisaDetailModel.visaStatus ==
                                        "In Effect")
                                    ? AppColorStyle.yellow(context)
                                    : (vevoVisaDetailModel.visaStatus ==
                                            "Temporarily Ceased")
                                        ? AppColorStyle.textDetail(context)
                                        : const Color(0xffDA2128)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: Text(
                                    (vevoVisaDetailModel.visaStatus != null)
                                        ? vevoVisaDetailModel.visaStatus
                                            .toString()
                                        : "-",
                                    style: AppTextStyle.subTitleSemiBold(
                                        context,
                                        AppColorStyle.background(context)),
                                  ),
                                ),
                                const PopUpMenuWidget(),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              StreamBuilder(
                                  stream: vevoCheckBloc.getWorkPlaceValueStream,
                                  builder: (context, workPlaceSnapshot) {
                                    final String? workPlace =
                                        workPlaceSnapshot.data;
                                    return StreamBuilder(
                                        stream: vevoCheckBloc
                                            .getWorkPlaceLinkValueStream,
                                        builder:
                                            (context, workPlaceLinkSnapshot) {
                                          final String? workPlaceLink =
                                              workPlaceLinkSnapshot.data;
                                          return StreamBuilder<bool>(
                                            stream: vevoCheckBloc
                                                .loadingShare.stream,
                                            builder: (_, snapshot) {
                                              return snapshot.hasData &&
                                                      snapshot.data == true
                                                  ? SizedBox(
                                                      width: 24.0,
                                                      height: 24.0,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppColorStyle
                                                              .background(
                                                                  context),
                                                          strokeWidth: 1.5,
                                                        ),
                                                      ),
                                                    )
                                                  : InkWellWidget(
                                                      onTap: () async {
                                                        vevoCheckBloc
                                                            .loadingShare
                                                            .add(true);
                                                        await Printing.sharePdf(
                                                          bytes: await generatePDFForVevoCheck(
                                                              vevoVisaDetailModel,
                                                              workPlace,
                                                              workPlaceLink),
                                                          filename: Constants
                                                              .vevoCheckReportFilePDFName,
                                                        );
                                                        vevoCheckBloc
                                                            .loadingShare
                                                            .add(false);
                                                      },
                                                      child: SvgPicture.asset(
                                                        IconsSVG.icShareFill,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          AppColorStyle
                                                              .background(
                                                                  context),
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                    );
                                            },
                                          );
                                        });
                                  }),
                              const SizedBox(width: 15),
                              Container(
                                height: 18,
                                width: 1,
                                color: AppColorStyle.backgroundVariant(context),
                              ),
                              const SizedBox(width: 15),
                              GestureDetector(
                                onTap: () {
                                  //Copy data to clipboard
                                  Clipboard.setData(ClipboardData(
                                      text: ("${"Name: "}${vevoVisaDetailModel.givenName}"
                                          " ${vevoVisaDetailModel.familyName}"
                                          "\n"
                                          "${(vevoCheckBloc.isSelectedRefType.value) ? StringHelper.visaVGN_ : StringHelper.visaTRN_} ${vevoVisaDetailModel.visaGrantNumber}"
                                          "\n"
                                          "${"Visa Class/ Subclass: "}${vevoVisaDetailModel.visaClassSubclass}"
                                          "\n"
                                          "${"Visa validity: "}${vevoVisaDetailModel.periodOfStay}"
                                          "\n"
                                          "${"Visa status: "}${vevoVisaDetailModel.visaStatus}")));
                                  Toast.show(
                                      message: "Copied to clipboard",
                                      context,
                                      gravity: Toast.toastTop);
                                },
                                child: SvgPicture.asset(
                                  IconsSVG.copyIcon,
                                  colorFilter: ColorFilter.mode(
                                    AppColorStyle.background(context),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const Center(child: Text("Data not found"));
            }
          } else {
            return const SizedBox();
          }
        });
  }
}

class PopUpMenuWidget extends StatelessWidget {
  const PopUpMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: SvgPicture.asset(
        IconsSVG.icI,
        height: 14.0,
        width: 14.0,
        colorFilter: ColorFilter.mode(
          AppColorStyle.background(context),
          BlendMode.srcIn,
        ),
      ),
      padding: EdgeInsets.zero,
      color: AppColorStyle.backgroundVariant(context),
      offset: const Offset(0, 30),
      // shape: const TooltipShape(),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: Column(
            children: [
              Text.rich(
                textAlign: TextAlign.start,
                TextSpan(
                    text: "•",
                    style: AppTextStyle.detailsBold(
                        context, AppColorStyle.text(context)),
                    children: [
                      TextSpan(
                        text: " In effect",
                        style: AppTextStyle.detailsSemiBold(
                            context, AppColorStyle.textHint(context)),
                      ),
                      TextSpan(
                        text:
                            " means that your visa has started, but it will not be activated until you enter Australia\n",
                        style: AppTextStyle.detailsRegular(
                            context, AppColorStyle.textHint(context)),
                      ),
                    ]),
              ),
              Text.rich(
                textAlign: TextAlign.start,
                TextSpan(
                  text: "•",
                  style: AppTextStyle.detailsBold(
                      context, AppColorStyle.text(context)),
                  children: [
                    TextSpan(
                      text: " Temporarily ceased",
                      style: AppTextStyle.detailsSemiBold(
                          context, AppColorStyle.textHint(context)),
                    ),
                    TextSpan(
                      text:
                          " means your ‘Longer Validity’ Visitor visa has temporarily ceased.",
                      style: AppTextStyle.detailsRegular(
                          context, AppColorStyle.textHint(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VevoCheckDetailsWidget extends StatelessWidget {
  const VevoCheckDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vevoCheckBloc = RxBlocProvider.of<VevoCheckBloc>(context);

    return StreamBuilder(
        stream: vevoCheckBloc.getVevoCheckDetailsModelStream,
        builder: (context, snapshot) {
          VevoVisaDetailModel? vevoVisaDetailModel = snapshot.data;

          if (snapshot.hasData == true) {
            return Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      bottom: 20.0,
                      left: Constants.commonPadding,
                      right: Constants.commonPadding),
                  color: AppColorStyle.background(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          StringHelper.visaDescription,
                          style: AppTextStyle.detailsMedium(
                              context, AppColorStyle.textHint(context)),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel!.visaDescription != null ||
                                vevoVisaDetailModel.visaDescription!.isNotEmpty)
                            ? vevoVisaDetailModel.visaDescription.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.documentNumber,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.documentNumber != null)
                            ? vevoVisaDetailModel.documentNumber.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.educationSector,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.educationSector != null)
                            ? vevoVisaDetailModel.educationSector.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.visaApplicant,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.visaApplicant != null)
                            ? vevoVisaDetailModel.visaApplicant.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.visaGrantDate,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.visaGrantDate != null)
                            ? vevoVisaDetailModel.visaGrantDate.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.visaExpiryDate,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.visaExpiryDate != null)
                            ? vevoVisaDetailModel.visaExpiryDate.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.documentNumber,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.documentNumber != null)
                            ? vevoVisaDetailModel.documentNumber.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.location,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.location != null)
                            ? vevoVisaDetailModel.location.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.entriesAllowed,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.entriesAllowed != null)
                            ? vevoVisaDetailModel.entriesAllowed.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.mustNotArriveAfter,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.mustNotArriveAfter != null)
                            ? vevoVisaDetailModel.mustNotArriveAfter.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.visaType,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.visaType != null)
                            ? vevoVisaDetailModel.visaType.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.workEntitlements,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.workEntitlements != null)
                            ? vevoVisaDetailModel.workEntitlements.toString()
                            : "=",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.workplaceRights,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        softWrap: true,
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: vevoCheckBloc.workPlaceValue.valueOrNull ?? "-",
                          style: AppTextStyle.subTitleRegular(
                              context, AppColorStyle.text(context)),
                          children: [
                            if (vevoCheckBloc.workPlaceLinkValue.valueOrNull !=
                                null)
                              WidgetSpan(
                                  child: InkWellWidget(
                                    onTap: () {
                                      Utility.launchURL(vevoCheckBloc
                                          .workPlaceLinkValue.value);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        "this link",
                                        style: AppTextStyle.subTitleMedium(
                                            context,
                                            AppColorStyle.primary(context)),
                                      ),
                                    ),
                                  ),
                                  alignment: PlaceholderAlignment.middle),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.studyEntitlements,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.studyEntitlements != null)
                            ? vevoVisaDetailModel.studyEntitlements.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringHelper.visaConditions,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (vevoVisaDetailModel.visaConditions != null)
                            ? vevoVisaDetailModel.visaConditions.toString()
                            : "-",
                        style: AppTextStyle.subTitleRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
