import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_all_visa_type/so_all_visa_type_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_all_visa_type/so_all_visa_type_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_all_visa_type_model.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

class SoAllVisaTypeScreen extends BaseApp {
  const SoAllVisaTypeScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _SoAllVisaTypeScreenState();
}

class _SoAllVisaTypeScreenState extends BaseState {
  SoAllVisaTypeBloc? soAllVisaTypeBloc;

  @override
  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
  }

  initData() {
    OccupationRowData occupationRowData = widget.arguments;
    soAllVisaTypeBloc!.callAllVisaTypeDetail(occupationRowData.id ?? '');
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    soAllVisaTypeBloc ??= RxBlocProvider.of<SoAllVisaTypeBloc>(context);
    final double bottomSafeArea = MediaQuery.of(context).viewPadding.bottom;
    return RxBlocProvider(
        create: (_) => soAllVisaTypeBloc!,
        child: Container(
          color: AppColorStyle.background(context),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<VisaTypeRow>>(
                    stream: soAllVisaTypeBloc!.allVisaTypeListStream,
                    builder: (context, snapshot) {
                      List<VisaTypeRow> visTypeList = snapshot.data ?? [];
                      return visaTypeTableWidget(visTypeList, bottomSafeArea);
                    }),
              ),
              sectionHeaderWidget(),
            ],
          ),
        ));
  }

  Widget sectionHeaderWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 10),
      child: Column(
        children: [
          Divider(color: AppColorStyle.borderColors(context), thickness: 1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Status:",
                style: AppTextStyle.detailsMedium(
                    context, AppColorStyle.textDetail(context)),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    IconsSVG.icCheckGreen,
                    width: 16.0,
                    height: 16.0,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    StringHelper.eligible,
                    style: AppTextStyle.captionMedium(
                        context, AppColorStyle.text(context)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 10),
                    child: SvgPicture.asset(
                      IconsSVG.redCrossIcon,
                      width: 16.0,
                      height: 16.0,
                    ),
                  ),
                  Text(
                    StringHelper.notEligible,
                    style: AppTextStyle.captionMedium(
                        context, AppColorStyle.text(context)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15)
        ],
      ),
    );
  }

  Widget visaTypeTableWidget(
      List<VisaTypeRow> visTypeList, double bottomSafeArea) {
    return (soAllVisaTypeBloc == null ||
            soAllVisaTypeBloc!.loading ||
            visTypeList.isEmpty)
        ? const Padding(
         padding: EdgeInsets.symmetric(horizontal: Constants.commonPadding),
        child: SoAllVisaTypeShimmer())
        : ListView.builder(
            padding: EdgeInsets.only(
                top: 30,
                left: Constants.commonPadding,
                right: Constants.commonPadding,
                bottom: bottomSafeArea > 0 ? bottomSafeArea : 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visTypeList.length,
            itemBuilder: (context, index) {
              final visaTypeRow = visTypeList[index];
              return visTypeTableView(visaTypeRow, index);
            });
  }

  Widget visTypeTableView(VisaTypeRow visaTypeRow, index) {
    if (visaTypeRow.visaType != null &&
        visaTypeRow.visaType!.contains("(") &&
        visaTypeRow.visaType!.contains(")")) {
/*      final String name = visaTypeRow.visaType!
          .substring(0, visaTypeRow.visaType!.indexOf("("));
      final visaClass = visaTypeRow.visaType!.substring(
          visaTypeRow.visaType!.indexOf("("), visaTypeRow.visaType!.length);*/
    }

    String name = visaTypeRow.visaType!.substring(
        visaTypeRow.visaType!.indexOf("("), visaTypeRow.visaType!.length);
    String visaTypeName = name.replaceAll("(", "");
    String finalVisaTypeName = visaTypeName.replaceAll(")", "");
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              bottom: (soAllVisaTypeBloc != null &&
                      index == soAllVisaTypeBloc!.getVisaTypeList.length - 1)
                  ? 25.0
                  : 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                visaTypeRow.isEligible == 1
                    ? IconsSVG.icCheckGreen //green
                    : IconsSVG.redCrossIcon, //red
              ),
              const SizedBox(width: 15),
              Expanded(
                child: InkWellWidget(
                  onTap: () {
                    if (visaTypeRow.link != null && visaTypeRow.link != "") {
                      Utility.launchURL(visaTypeRow.link ?? "");
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              finalVisaTypeName,
                              style: AppTextStyle.detailsSemiBold(
                                  context, AppColorStyle.text(context)),
                            ),
                          ),
                          const SizedBox(width: 5),
                          (visaTypeRow.link != null && visaTypeRow.link != "")
                              ? SvgPicture.asset(
                                  IconsSVG.linkIcon,
                                )
                              : Container(),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            visaTypeRow.visaType!.substring(
                                0, visaTypeRow.visaType!.indexOf("(")),
                            overflow: TextOverflow.fade,
                            style: AppTextStyle.captionRegular(
                                context, AppColorStyle.textDetail(context)),
                          ),
                          const SizedBox(width: 5),
                          visaTypeRow.eligibilityList != null &&
                                  visaTypeRow.eligibilityList!.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColorStyle.green(context)
                                          .withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Text(
                                    visaTypeRow.eligibilityList ?? "",
                                    style: AppTextStyle.captionMedium(
                                      context,
                                      AppColorStyle.green(context),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      if (visaTypeRow.visaStream != null) Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          visaTypeRow.visaStream ?? "",
                          overflow: TextOverflow.fade,
                          style: AppTextStyle.captionRegular(
                              context, AppColorStyle.textDetail(context)),
                        ),
                      ) else Container(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWellWidget(
                  onTap: () {
                    if (visaTypeRow.liLink != null &&
                        visaTypeRow.liLink != "") {
                      Utility.launchURL(visaTypeRow.liLink ?? "");
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      visaTypeRow.liLink != null && visaTypeRow.liLink != ""
                          ? Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      AppColorStyle.primarySurfaceWithOpacity(context)),
                              child: SvgPicture.asset(
                                IconsSVG.linkIcon,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  right: (visaTypeRow.eligibilityList != null &&
                                          visaTypeRow
                                              .eligibilityList!.isNotEmpty)
                                      ? 0.0
                                      : 10.0),
                              child: Text("-",
                                  style: AppTextStyle.captionRegular(context,
                                      AppColorStyle.textCaption(context))),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
