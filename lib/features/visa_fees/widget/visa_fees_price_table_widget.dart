import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/features/visa_fees/model/visa_fees_table_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_shimmer.dart';

import '../../../constants/constants.dart';

class VisaFeesPriceTable extends StatelessWidget {
  const VisaFeesPriceTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visaBloc = RxBlocProvider.of<VisaFeesBloc>(context);
    return StreamBuilder<VisaFeesPriceTableModel>(
      stream: visaBloc.selectedVisaFeesPriceTableModel,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final VisaFeesPriceTableModel priceTableModel =
              snapshot.data as VisaFeesPriceTableModel;
          return Container(
            color: AppColorStyle.background(context),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Primary & secondary applicant
                ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: priceTableModel.priceTable.length,
                    itemBuilder: (context, index) {
                      PriceTableRowModel priceModel =
                          priceTableModel.priceTable[index];
                      return Column(
                        children: [
                          index != 0 && priceModel.feesAud.isEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Divider(
                                    color: AppColorStyle.surface(context),
                                    thickness: 0.5,
                                  ),
                                )
                              : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    priceModel.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: priceModel.feesAud.isEmpty
                                        ? AppTextStyle.subTitleSemiBold(
                                            context,
                                            AppColorStyle.purple(context),
                                          )
                                        : AppTextStyle.detailsRegular(
                                            context,
                                            AppColorStyle.textDetail(context),
                                          ),
                                  ),
                                  Visibility(
                                    visible: priceModel.feesAud.isEmpty &&
                                        !priceModel.label
                                            .toLowerCase()
                                            .contains("main"),
                                    child: InkWellWidget(
                                      onTap: () => {
                                        // Delete applicant
                                        ///Here, we default pass 0 index because we delete applicant with title comparison
                                        visaBloc.deleteApplicant(0, priceModel),
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: SvgPicture.asset(
                                          IconsSVG.deleteIcon,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          /*    Text(
                                priceModel.fees_aud.isNotEmpty
                                    ? "${priceModel.fees.toStringAsFixed(2)}  ${priceTableModel.currency_short_code}"
                                    : "",
                                style: AppTextStyle.detailsMedium(
                                    context, AppColorStyle.textDetail(context)
                                    // AppColorStyle.text(context)
                                    ),
                              ),*/


                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: priceModel.feesAud.isNotEmpty
                                          ? priceModel.fees.toStringAsFixed(2)
                                          : "",
                                      style: AppTextStyle.detailsMedium(
                                        context,
                                        AppColorStyle.textDetail(context),
                                      ),
                                    ),
                                    TextSpan(
                                      text: priceModel.feesAud.isNotEmpty
                                          ? "  ${priceTableModel.currencyShortCode}"
                                          : "",
                                      style: AppTextStyle.captionRegular(
                                        context,
                                        AppColorStyle.textCaption(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                        ],
                      );
                    }),
                // Sub Total
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(
                    color: AppColorStyle.surface(context),
                    thickness: 0.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub Total:",
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: AppTextStyle.detailsRegular(
                          context, AppColorStyle.text(context)),
                    ),
                    /*Text(
                      "${priceTableModel.subTotal.toStringAsFixed(2)}  ${priceTableModel.currency_short_code}",
                      style: AppTextStyle.detailsMedium(
                          context, AppColorStyle.text(context)),
                    ),*/
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: priceTableModel.subTotal.toStringAsFixed(2),
                            style: AppTextStyle.detailsMedium(
                              context,
                              AppColorStyle.text(context),
                            ),
                          ),
                          TextSpan(
                            text: "  ${priceTableModel.currencyShortCode}",
                            style: AppTextStyle.captionRegular(
                              context,
                              AppColorStyle.textCaption(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3.0,
                ),
                // Non-Internet charge
                if (priceTableModel.nonInternetCharge > 0)
                  const SizedBox(
                    height: 3.0,
                  ),
                if (priceTableModel.nonInternetCharge > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Non-internet\nApp. charge:",
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: AppTextStyle.detailsRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      /*Text(
                        "${priceTableModel.non_internet_charge.toStringAsFixed(2)}  ${priceTableModel.currency_short_code}",
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.text(context)),
                      ),*/
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: priceTableModel.nonInternetCharge.toStringAsFixed(2),
                              style: AppTextStyle.detailsMedium(
                                context,
                                AppColorStyle.text(context),
                              ),
                            ),
                            TextSpan(
                              text: "  ${priceTableModel.currencyShortCode}",
                              style: AppTextStyle.captionRegular(
                                context,
                                AppColorStyle.textCaption(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 3.0,
                ),
                // Surcharge(0%)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Surcharge (${priceTableModel.surchargesPercentage}%):",
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: AppTextStyle.detailsRegular(
                            context, AppColorStyle.text(context))),
                    /*Text(
                      "${priceTableModel.surcharges.toStringAsFixed(2)}  ${priceTableModel.currency_short_code}",
                      style: AppTextStyle.detailsMedium(
                          context, AppColorStyle.text(context)),
                    ),*/
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: priceTableModel.surcharges.toStringAsFixed(2),
                            style: AppTextStyle.detailsMedium(
                              context,
                              AppColorStyle.text(context),
                            ),
                          ),
                          TextSpan(
                            text: "  ${priceTableModel.currencyShortCode}",
                            style: AppTextStyle.captionRegular(
                              context,
                              AppColorStyle.textCaption(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                // Total
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Divider(
                    color: AppColorStyle.surface(context),
                    thickness: 1,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total:",
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: AppTextStyle.titleSemiBold(
                            context, AppColorStyle.text(context))),
                    /*Text(
                      "${priceTableModel.total.toStringAsFixed(2)}  ${priceTableModel.currency_short_code}",
                      style: AppTextStyle.titleSemiBold(
                          context, AppColorStyle.text(context)),
                    ),*/
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: priceTableModel.total.toStringAsFixed(2),
                            style: AppTextStyle.titleSemiBold(
                              context,
                              AppColorStyle.text(context),
                            ),
                          ),
                          TextSpan(
                            text: "  ${priceTableModel.currencyShortCode}",
                            style: AppTextStyle.captionRegular(
                              context,
                              AppColorStyle.textCaption(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const VisaFeesCalculationShimmer();
        }
      },
    );
  }
}
