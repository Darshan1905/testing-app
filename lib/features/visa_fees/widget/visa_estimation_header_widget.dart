import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/country_with_currency.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_detail_widget.dart';
import 'package:occusearch/features/visa_fees/widget/visa_price_subclass_widget.dart';

class VisaEstimationHeaderWidget extends StatelessWidget {
  const VisaEstimationHeaderWidget({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final VisaFeesBloc visaFeesBloc = RxBlocProvider.of<VisaFeesBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      // padding: const EdgeInsets.all(Constants.commonPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      StringHelper.visaYourEstimation,
                      style: AppTextStyle.titleSemiBold(
                          context, AppColorStyle.text(context)),
                    ),
                    InkWellWidget(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset(
                          IconsSVG.fundBulb,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.purple(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (visaFeesBloc
                                .selectedVisaFeesPriceTableModel.valueOrNull !=
                            null) {
                          List<String> notesList = visaFeesBloc
                              .selectedVisaFeesPriceTableModel.value.notesList;
                          if (notesList.isNotEmpty) {
                            WidgetHelper.showAlertNotesDialog(context,
                                contentText: notesList,
                                title: StringHelper.visaNoteTitle);
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4.0,
                ),
                const VisaPriceSubclassWidget()
              ],
            ),
          ),

          // [COUNTRY CURRENCY SECTION]
          StreamWidget(
            stream: visaFeesBloc.getCountryListStream,
            onBuild: (_, snapshot) {
              List<CountryWithCurrencyModel>? countryModelList = snapshot;
              return VisaFeesCountryCurrencyWidget(
                  animationController: animationController,
                  selectedCurrency:
                      visaFeesBloc.selectedCountrySubject.valueOrNull ??
                          countryModelList?[0],
                  countrySearchController:
                      visaFeesBloc.countrySearchController ??
                          TextEditingController());
            },
          ),
        ],
      ),
    );
  }
}
