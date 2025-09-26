// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_constants.dart';
import 'package:occusearch/features/visa_fees/model/visa_payment_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';
import 'package:occusearch/features/visa_fees/widget/visa_estimation_header_widget.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_applicant_list_widget.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_footer_widget.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_price_table_widget.dart';
import 'package:occusearch/utility/rating/dynamic_rating_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class VisaFeesDetailScreen extends BaseApp {
  late VisaFeesBloc visaFeesBloc;

  VisaFeesDetailScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _VisaFeesDetailScreenState();
}

class _VisaFeesDetailScreenState extends BaseState
    with TickerProviderStateMixin {
  VisaFeesBloc visaFeesBloc = VisaFeesBloc();
  GlobalBloc? _globalBloc;
  final TextEditingController _countrySearchController =
      TextEditingController();

  late AnimationController animationController;

  static final ItemScrollController itemScrollController =
      ItemScrollController();

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxBlocProvider(
      create: (_) => visaFeesBloc,
      child: WillPopScopeWidget(
        onWillPop: () async {
          WidgetHelper.alertDialogWidget(
            context: context,
            title: StringHelper.visaFees,
            buttonColor: AppColorStyle.purple(context),
            message: StringHelper.fundConfirmDialogMessage,
            positiveButtonTitle: StringHelper.yesQuit,
            negativeButtonTitle: StringHelper.cancel,
            onPositiveButtonClick: () {
              GoRoutesPage.go(
                  mode: NavigatorMode.remove, moveTo: RouteName.home);
            },
          );
          return false;
        },
        child: Container(
          color: AppColorStyle.purple(context),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // [APPLICANT LIST SECTION]
                const VisaFeesApplicantWidget(),
                Expanded(
                  child: Container(
                    color: AppColorStyle.background(context),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // [VISA ESTIMATION SECTION]
                          VisaEstimationHeaderWidget(
                            animationController: animationController,
                          ),

                          Container(
                            height: 10,
                            color: AppColorStyle.backgroundVariant(context),
                          ),
                          //PAYMENT METHOD SELECTION LIST SCROLLABLE SLIDER
                          StreamBuilder(
                            stream: visaFeesBloc.getSelectedPaymentData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWellWidget(
                                        onTap: () {
                                          _scrollToIndex(0);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: SvgPicture.asset(
                                            IconsSVG.fundBackIcon,
                                            height: 20,
                                            width: 25,
                                            colorFilter: ColorFilter.mode(
                                              AppColorStyle.purple(context),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: SizedBox(
                                            height: 62,
                                            child: ScrollablePositionedList
                                                .builder(
                                              itemScrollController:
                                                  itemScrollController,
                                              scrollDirection: Axis.horizontal,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: visaFeesBloc
                                                  .paymentMethodList
                                                  .value
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return estimationWidgetItem(
                                                    context,
                                                    visaFeesBloc
                                                        .paymentMethodList
                                                        .value[index],
                                                    visaFeesBloc,
                                                    index);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: InkWellWidget(
                                          onTap: () {
                                            _scrollToIndex(visaFeesBloc
                                                .paymentMethodList
                                                .value
                                                .length);
                                          },
                                          child: SvgPicture.asset(
                                            IconsSVG.fundNextIcon,
                                            height: 20,
                                            width: 25,
                                            colorFilter: ColorFilter.mode(
                                              AppColorStyle.purple(context),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          Container(
                            height: 10,
                            color: AppColorStyle.backgroundVariant(context),
                          ),

                          // [PRICE TABLE SECTION]
                          const VisaFeesPriceTable(),
                          // [DISCLAIMER SECTION]
                          const SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            color: AppColorStyle.backgroundVariant(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringHelper.visaDisclaimerTitle,
                                  textAlign: TextAlign.justify,
                                  style: AppTextStyle.detailsSemiBold(
                                      context, AppColorStyle.text(context)),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  StringHelper.visaDisclaimer,
                                  style: AppTextStyle.captionRegular(context,
                                      AppColorStyle.textDetail(context)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // [PAYMENT SECTION]
                VisaFeesFooterWidget(animationController: animationController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _scrollToIndex(index) {
    itemScrollController.scrollTo(
        index: index,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn);
  }

  static Widget estimationWidgetItem(
      BuildContext context,
      PaymentMethodData? paymentMethodList,
      VisaFeesBloc? visaFeesBloc,
      int index) {
    return InkWellWidget(
      onTap: () {
        visaFeesBloc?.onClickPaymentMethod(paymentMethodList!);
        itemScrollController.scrollTo(
            index: index, duration: const Duration(seconds: 1));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(
                    color: visaFeesBloc?.selectedPaymentMethod.value?.cardId ==
                            paymentMethodList?.cardId
                        ? AppColorStyle.purple(context)
                        : AppColorStyle.surfaceVariant(context),
                    width: 0.5,
                  )),
              child: Utility.imageCache(
                  paymentMethodList?.vcIconPath ?? '', context),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text("${paymentMethodList?.charges ?? 0.0}%",
                textAlign: TextAlign.center,
                style: AppTextStyle.detailsSemiBold(
                    context, AppColorStyle.text(context))),
          ],
        ),
      ),
    );
  }

  @override
  init() async {
    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = const Duration(milliseconds: 500);

    //await _globalBloc?.setUserInfoData(context);
    visaFeesBloc.userInfo.value = await _globalBloc?.getUserInfo(context);

    dynamic param = widget.arguments;
    if (param != null) {
      printLog(
          "#VisaFeesDetailScreen# navigation param :: ${param.runtimeType}");
      VisaFeesBloc bloc = param as VisaFeesBloc;
      if (bloc.getPrimaryApplicantQuesValue != null) {
        visaFeesBloc.setPrimaryApplicantQuestionList =
            bloc.getPrimaryApplicantQuesValue;
      }
      if (bloc.getSecondaryApplicantQuesValue != null) {
        visaFeesBloc.setSecondaryApplicantQuestionList =
            bloc.getSecondaryApplicantQuesValue;
      }
      visaFeesBloc.setVisaQuestionSubclassList =
          bloc.getVisaQuestionSubclassList;
      if (bloc.getSelectedSubClassValue != null) {
        visaFeesBloc.setSelectedSubClassData = bloc.getSelectedSubClassValue;
      }
      visaFeesBloc.count = bloc.count;
      visaFeesBloc.setApplicantList = bloc.getApplicantListValue;
    }

    Future.delayed(Duration.zero, () async {
      //payment method API
      visaFeesBloc.getVisaPaymentMethodListAPI();
      //fetch country with currency list from firebase
      visaFeesBloc.setupRemoteConfigForCountryList();
      visaFeesBloc.setSearchCountryFieldController = _countrySearchController;
    });

    // GET VISA PRICE
    await visaFeesBloc.getVisaPriceAPI(context);

    // increase local count of dynamic rating according to module into stored data of shared preference...
    DynamicRatingCalculation.updateRatingLocalCountByModuleName(
        SharedPreferenceConstants.visaFees);
  }
}
