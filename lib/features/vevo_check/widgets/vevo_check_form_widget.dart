// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:intl/intl.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/common_widgets/text_field_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/country/country_dialog.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/vevo_check/vevo_check_bloc.dart';

class VevoTabBarWidget extends StatelessWidget {
  const VevoTabBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vevoCheckBloc = RxBlocProvider.of<VevoCheckBloc>(context);

    return StreamWidget(
        stream: vevoCheckBloc.getIsSelectedRefType,
        onBuild: (_, snapshot) {
          final bool isSelectedRef = snapshot;
          return Container(
            constraints: const BoxConstraints(minHeight: 64.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: AppColorStyle.redBackground(context),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWellWidget(
                    onTap: () {
                      vevoCheckBloc.setIsSelectedRefType = true;
                    },
                    child: Container(
                      height: 76,
                      margin: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(minHeight: 72.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelectedRef
                            ? AppColorStyle.red(context)
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text(StringHelper.visaGrantVGNumber,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.detailsMedium(
                                context,
                                isSelectedRef
                                    ? AppColorStyle.background(context)
                                    : AppColorStyle.red(context))),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWellWidget(
                    onTap: () {
                      vevoCheckBloc.setIsSelectedRefType = false;
                    },
                    child: Container(
                      height: 76,
                      margin: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(minHeight: 72.0),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: !isSelectedRef
                            ? AppColorStyle.red(context)
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Text(StringHelper.transactionReferenceNumber,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.detailsMedium(
                                context,
                                !isSelectedRef
                                    ? AppColorStyle.background(context)
                                    : AppColorStyle.red(context))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class VevoFormWidget extends StatelessWidget {
  final GlobalKey<FormState> vevoFormKey;

  const VevoFormWidget({Key? key, required this.vevoFormKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vevoCheckBloc = RxBlocProvider.of<VevoCheckBloc>(context);
    final globalBloc = RxBlocProvider.of<GlobalBloc>(context);
    final authBloc = RxBlocProvider.of<AuthenticationBloc>(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColorStyle.background(context),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Form(
        key: vevoFormKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //reference number TextField
              StreamWidget(
                  stream: vevoCheckBloc.getSelectedReference,
                  onBuild: (_, snapshot) {
                    final String selectedRefType = snapshot;
                    return Text(
                      selectedRefType,
                      style: AppTextStyle.detailsMedium(
                          context, AppColorStyle.textDetail(context)),
                    );
                  }),
              const SizedBox(height: 10),
              StreamWidget(
                  stream: vevoCheckBloc.getIsSelectedRefType,
                  onBuild: (_, snapshot) {
                    final bool isSelectedRef = snapshot;
                    return isSelectedRef
                        ? TextFieldWithoutStreamWidget(
                            onTextChanged: vevoCheckBloc.onChangeVGNNumber,
                            controller: vevoCheckBloc.vgnEditingController,
                            hintStyle: AppTextStyle.detailsRegular(
                                context, AppColorStyle.textHint(context)),
                            hintText: StringHelper.enterYourVisaGrant,
                            maxLength: 13,
                          )
                        : TextFieldWithoutStreamWidget(
                            onTextChanged: vevoCheckBloc.onChangeVGNNumber,
                            controller: vevoCheckBloc.trnEditingController,
                            hintStyle: AppTextStyle.detailsRegular(
                                context, AppColorStyle.textHint(context)),
                            hintText: StringHelper.enterYourTransactionRef,
                            maxLength: 12,
                          );
                  }),
              const SizedBox(height: 20),
              //date of birth TextField
              Text(
                StringHelper.dateOfBirth,
                style: AppTextStyle.detailsMedium(
                    context, AppColorStyle.textDetail(context)),
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  TextFieldWithoutStreamWidget(
                    onTextChanged: vevoCheckBloc.onChangeDOBNumber,
                    controller: vevoCheckBloc.dobEditingController,
                    hintStyle: AppTextStyle.detailsRegular(
                        context, AppColorStyle.textHint(context)),
                    hintText: StringHelper.hintDateFormat,
                    keyboardKey: TextInputType.datetime,
                    readOnly: true,
                    onTap: () {
                      selectDate(context, bloc: vevoCheckBloc);
                    },
                  ),
                  InkWellWidget(
                    onTap: () {
                      selectDate(context, bloc: vevoCheckBloc);
                    },
                    child: Container(
                      height: 50.0,
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                          IconsSVG.icCalendar,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.red(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //passport number TextField
              Text(
                StringHelper.passportNumber,
                style: AppTextStyle.detailsMedium(
                    context, AppColorStyle.textDetail(context)),
              ),
              const SizedBox(height: 10),
              TextFieldWithoutStreamWidget(
                onTextChanged: vevoCheckBloc.onChangePassportNumber,
                controller: vevoCheckBloc.passportEditingController,
                hintStyle: AppTextStyle.detailsRegular(
                    context, AppColorStyle.textHint(context)),
                hintText: StringHelper.passportExample,
                keyboardKey: TextInputType.name,
                maxLength: 12,
              ),
              const SizedBox(height: 20),
              //select country TextField
              Text(
                StringHelper.selectCountryOfDocument,
                style: AppTextStyle.detailsMedium(
                    context, AppColorStyle.textDetail(context)),
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  StreamBuilder<CountryModel>(
                      stream: vevoCheckBloc.selectedCountryStream,
                      builder: (context, snapshot) {
                        CountryModel? selectedCountry = snapshot.data;
                        String flag = Constants.cdnFlagURL +
                            (selectedCountry?.flag ?? "");
                        return TextFieldWithoutStreamWidget(
                          onTextChanged:
                              vevoCheckBloc.onChangeCountryDocumentValue,
                          controller: vevoCheckBloc.countryEditingController,
                          hintStyle: AppTextStyle.detailsRegular(
                              context, AppColorStyle.textHint(context)),
                          prefixIcon: prefixIcon(snapshot, flag),
                          hintText: StringHelper.selectCountryOfDocument,
                          keyboardKey: TextInputType.text,
                          readOnly: true,
                        );
                      }),
                  InkWellWidget(
                    onTap: () {
                      CountryDialog.countryDialog(
                        context: context,
                        onItemClick: (CountryModel country) {
                          authBloc.setSelectedCountryModel = country;
                          vevoCheckBloc.setCountryModel = country;
                          vevoCheckBloc.countryEditingController.text =
                              "${country.name}";
                        },
                        countryList: globalBloc.getCountryListValue,
                      );
                    },
                    child: Container(
                      height: 50.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget prefixIcon(snapshot, flag) {
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 10),
    child: snapshot.data == null
        ? const SizedBox(
            height: 0,
            width: 0,
          )
        : SvgPicture.network(
            flag,
            width: 24.0,
            height: 24.0,
            //fit: BoxFit.fill,
            placeholderBuilder: (context) => Icon(
              Icons.flag,
              size: 24.0,
              color: AppColorStyle.surfaceVariant(context),
            ),
          ),
  );
}

selectDate(BuildContext context, {VevoCheckBloc? bloc}) async {
  DateTime currentDate = DateTime.now();
  late final dateFormat = DateFormat('dd-MM-yyyy');
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate:
        DateTime(currentDate.year - 18, currentDate.month, currentDate.day),
    firstDate: DateTime(currentDate.year - 70),
    lastDate: DateTime(currentDate.year, currentDate.month, currentDate.day),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColorStyle.red(context),
            onPrimary: Colors.white,
            surface: AppColorStyle.primary(context),
            onSurface: AppColorStyle.text(context),
          ),
          dialogBackgroundColor: AppColorStyle.background(context),
        ),
        child: child!,
      );
    },
  );
  if (pickedDate != null) {
    bloc?.dobEditingController.text = dateFormat.format(pickedDate);
  }
}
