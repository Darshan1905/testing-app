import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/country/country_bloc.dart';
import 'package:occusearch/features/country/model/country_model.dart';

class CountryListWidget extends StatelessWidget {
  const CountryListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CountryBloc countryBloc = RxBlocProvider.of<CountryBloc>(context);
    return StreamWidget(
      stream: countryBloc.getCountryListStream,
      onBuild: (_, BaseResponseModel<List<CountryModel>> snapshot) {
        List<CountryModel>? countryModelList = snapshot.data;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Theme(
            data: ThemeData(
              scrollbarTheme: ScrollbarThemeData(
                thickness: MaterialStateProperty.all(30.0),
              ),
            ),
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 4,
              trackVisibility: false,
              radius: const Radius.circular(10),
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.only(left: 30.0, right: 15.0),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: countryModelList?.length,
                    itemBuilder: (context, index) {
                      final item = countryModelList![index];
                      String flag = Constants.cdnFlagURL + (item.flag ?? "");
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          index != 0
                              ? Divider(
                                  color: AppColorStyle.surfaceVariant(context),
                                  thickness: 0.5,
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: SvgPicture.network(
                                    flag,
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.fill,
                                    placeholderBuilder: (context) => Icon(
                                      Icons.flag,
                                      size: 24.0,
                                      color:
                                          AppColorStyle.surfaceVariant(context),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: Text(
                                    '${item.name}',
                                    style: AppTextStyle.subTitleRegular(
                                        context, AppColorStyle.text(context)),
                                  ),
                                ),
                                Text(
                                  '(${item.dialCode})',
                                  style: AppTextStyle.titleBold(
                                      context, AppColorStyle.primary(context)),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ),
        );
      },
    );
  }
}
