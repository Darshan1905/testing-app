import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/app_style/text_style/app_text_style.dart';
import 'package:occusearch/app_style/theme/app_color_style.dart';
import 'package:occusearch/common_widgets/dot_animation.dart';
import 'package:occusearch/common_widgets/expandablepageview/expandable_page_view.dart';
import 'package:occusearch/features/visa_fees/model/visa_fees_price_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';

class VisaPriceSubclassWidget extends StatelessWidget {
  const VisaPriceSubclassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final VisaFeesBloc visaFeesBloc = RxBlocProvider.of<VisaFeesBloc>(context);
    return StreamBuilder<List<PriceVisasubclassModel>?>(
      stream: visaFeesBloc.visaPriceSubclass,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          List<PriceVisasubclassModel> subclassList = snapshot.data ?? [];
          return subclassList.isNotEmpty ? Column(
            children: [
              Container(
                constraints: const BoxConstraints(minHeight: 40.0),
                child: ExpandablePageView.builder(
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (value) {
                      visaFeesBloc.setPriceSubclassIndex(value);
                    },
                    itemCount: subclassList.length,
                    itemBuilder: (context, index) {
                      return Text(
                        subclassList[index].visaSubclass ?? '',
                        overflow: TextOverflow.fade,
                        style: AppTextStyle.detailsRegular(
                          context,
                          AppColorStyle.text(context),
                        ),
                      );
                    }),
              ),
              if (subclassList.length > 1)
                const SizedBox(
                  height: 10.0,
                ),
              if (subclassList.length > 1)
                StreamBuilder<int>(
                    stream: visaFeesBloc.visaPriceSubclassIndex,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final int currentIndex = snapshot.data ?? 0;
                        return Row(
                          children: List.generate(
                            subclassList.length,
                            (index) => DotAnimation(
                                context: context,
                                currentPage: currentIndex,
                                primaryColor: AppColorStyle.purple(context),
                                index: index),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
            ],
          ) : const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
