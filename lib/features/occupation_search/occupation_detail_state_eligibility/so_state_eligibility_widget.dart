import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_se_visa_type_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_state_eligibility/so_state_eligibility_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_state_eligibility/so_state_eligibility_shimmer.dart';

class SoStateEligibilityWidget {
  static Widget sectionHeaderWidget(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 30, right: 30, bottom: 20.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringHelper.stateEligibility,
            style:
                AppTextStyle.detailsBold(context, AppColorStyle.text(context)),
          ),
          const Spacer(),
          SvgPicture.asset(
            IconsSVG.eligibility,
          ),
        ],
      ),
    );
  }

  static Widget eligibilityInfoWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Row(
            children: [
              SvgPicture.asset(
                IconsSVG.icGreenState,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(
                  "High Eligibility",
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  style: AppTextStyle.captionRegular(
                      context, AppColorStyle.text(context)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Row(
            children: [
              SvgPicture.asset(
                IconsSVG.icYellowState,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(
                  "Conditions Applied",
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  style: AppTextStyle.captionRegular(
                      context, AppColorStyle.text(context)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Row(
            children: [
              SvgPicture.asset(
                IconsSVG.redCrossIcon,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(
                  "Low Eligibility",
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  style: AppTextStyle.captionRegular(
                      context, AppColorStyle.text(context)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget tabWidget(BuildContext context, SoStateEligibilityBloc soSEBloc,
      String occupationCode, List<VisaTypeData> visaTypeList) {
    if (soSEBloc.tabLoader) {
      return SoStateEligibilityShimmer.tabShimmer(context);
    } else if (visaTypeList.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var varTypeDataModel in visaTypeList)
            InkWellWidget(
              onTap: () {
                if (soSEBloc.loading == false) {
                  if (soSEBloc.getStateEligibilityDataLength > 0) {
                    soSEBloc.manageTabs(varTypeDataModel, occupationCode);
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: varTypeDataModel.isTabSelected == true
                      ? AppColorStyle.surface(context)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  // Here I put this fix condition because of web api
                  // We are not getting title from API because there is no have any title column in database table...
                  varTypeDataModel.visaType == 291 // 291 = DAMA fix condition
                      ? "DAMA"
                      : "${varTypeDataModel.visaType ?? 0}",
                  textAlign: TextAlign.center,
                  style: varTypeDataModel.isTabSelected == true
                      ? AppTextStyle.subTitleSemiBold(
                          context, AppColorStyle.primary(context))
                      : AppTextStyle.subTitleRegular(
                          context, AppColorStyle.textDetail(context)),
                ),
              ),
            ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  static Color getColorByClass(
      String strClass, int isOpen, BuildContext context) {
    if (strClass == "check-green" && isOpen == 1) {
      return AppColorStyle.cyan(context);
    } else if (strClass == "minus-circle" && isOpen == 1) {
      return AppColorStyle.cyanText(context);
    } else if (strClass == "close-red" && isOpen == 0) {
      return AppColorStyle.cyanVariant1(context);
    } else {
      return AppColorStyle.cyanVariant2(context);
    }
  }

  static String getIconByClass(String strClass, int isOpen, isDarkTheme) {
    if (strClass == "check-green" && isOpen == 1) {
      return isDarkTheme
          ? IconsSVG.icGreenStateDark
          : IconsSVG.icGreenState;
    } else if (strClass == "minus-circle" && isOpen == 1) {
      return isDarkTheme
          ? IconsSVG.icYellowStateDark
          : IconsSVG.icYellowState;
    } else if (strClass == "close-red" && isOpen == 0) {
      return isDarkTheme ? IconsSVG.redCrossIconDark : IconsSVG.redCrossIcon;
    } else {
      return isDarkTheme ? IconsSVG.redCrossIconDark : IconsSVG.redCrossIcon;
    }
  }

  static String getStateStatusClass(String strClass, int isOpen) {
    if (strClass == "check-green" && isOpen == 1) {
      return "High Eligibility";
    } else if (strClass == "minus-circle" && isOpen == 1) {
      return "Conditions Applied";
    } else if (strClass == "close-red" && isOpen == 0) {
      return "Low Eligibility";
    } else {
      return "Low Eligibility";
    }
  }

  static Color getStateStatusColor(String strClass, int isOpen, context) {
    if (strClass == "check-green" && isOpen == 1) {
      return AppColorStyle.green(context);
    } else if (strClass == "minus-circle" && isOpen == 1) {
      return AppColorStyle.yellow(context);
    } else if (strClass == "close-red" && isOpen == 0) {
      return AppColorStyle.red(context);
    } else {
      return AppColorStyle.red(context);
    }
  }

  static Color getStateStatusBgColor(String strClass, int isOpen, context) {
    if (strClass == "check-green" && isOpen == 1) {
      return AppColorStyle.green(context);
    } else if (strClass == "minus-circle" && isOpen == 1) {
      return AppColorStyle.yellowVariant1(context);
    } else if (strClass == "close-red" && isOpen == 0) {
      return AppColorStyle.redText(context);
    } else {
      return AppColorStyle.redVariant2(context);
    }
  }
}
