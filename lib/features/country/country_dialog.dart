import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/search_field_widget.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/country/model/country_model.dart';

import 'country_bloc.dart';

class CountryDialog {
  static Future countryDialog(
      {required BuildContext context,
      required Function onItemClick,
      required List<CountryModel> countryList}) async {
    final countrySearchController = TextEditingController();
    final CountryBloc countryBloc = CountryBloc();
    countryBloc.setSearchFieldController = countrySearchController;
    countryBloc.setCountryList = countryList;
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColorStyle.background(context),
      useSafeArea: true,
      builder: (BuildContext context) {
        return RxBlocProvider(
          create: (_) => countryBloc,
          child: Scaffold(
            body: Container(
              color: AppColorStyle.background(context),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, left: 25.0, right: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWellWidget(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            IconsSVG.arrowBack,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              AppColorStyle.text(context),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: SearchTextField(
                            controller: countrySearchController,
                            searchHintText: StringHelper.countryHintText,
                            onClear: () {
                              countrySearchController.text = '';
                              countryBloc.onSearch('');
                            },
                            onTextChanged: countryBloc.onSearch,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: StreamWidget(
                      stream: countryBloc.getCountryListStream,
                      onBuild: (_, snapshot) {
                        List<CountryModel>? countryModelList = snapshot;
                        return countryModelList!.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: countryModelList.length,
                                itemBuilder: (context, index) {
                                  final countryData = countryModelList[index];
                                  String flag = Constants.cdnFlagURL +
                                      (countryData.flag ?? "");
                                  return InkWellWidget(
                                    onTap: () {
                                      Navigator.pop(context);
                                      onItemClick(countryData);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          index != 0
                                              ? Divider(
                                                  color: AppColorStyle
                                                      .borderColors(context),
                                                  thickness: 0.5,
                                                )
                                              : Container(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SvgPicture.network(
                                                  flag,
                                                  width: 24.0,
                                                  height: 24.0,
                                                  fit: BoxFit.fill,
                                                  placeholderBuilder:
                                                      (context) => Icon(
                                                    Icons.flag,
                                                    size: 24.0,
                                                    color: AppColorStyle
                                                        .surfaceVariant(
                                                            context),
                                                  ),
                                                ),
                                                const SizedBox(width: 25),
                                                Expanded(
                                                  child: Text(
                                                    '${countryData.name}',
                                                    style: AppTextStyle
                                                        .subTitleRegular(
                                                            context,
                                                            AppColorStyle.text(
                                                                context)),
                                                  ),
                                                ),
                                                Text(
                                                  '(${countryData.dialCode})',
                                                  style: AppTextStyle
                                                      .titleSemiBold(
                                                          context,
                                                          AppColorStyle.primary(
                                                              context)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Expanded(
                                child: Center(
                                  child: NoDataFoundScreen(
                                    noDataTitle: StringHelper.noDataFound,
                                    noDataSubTitle:
                                        StringHelper.tryAgainWithDiffCriteria,
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
