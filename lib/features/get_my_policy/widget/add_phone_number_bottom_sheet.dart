// ***************** phone number Widget ******************
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/authentication/login/login_mobile_widget.dart';
import 'package:occusearch/features/country/country_dialog.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/get_my_policy/gmp_bloc.dart';

showPhoneNumberBottomSheet(
    BuildContext context,
    Object data,
    GlobalBloc? globalBloc,
    int index,
    GetMyPolicyBloc? gmpBloc,
    AuthenticationBloc authBLoc,
    GlobalKey<FormState> phoneFormKey,
    bool isFromOVHC) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: AppColorStyle.background(context),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: phoneFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        StringHelper.profilePhoneNumber,
                        style: AppTextStyle.subHeadlineSemiBold(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 5.0),
                      Divider(
                          color: AppColorStyle.disableVariant(context),
                          thickness: 0.5),
                      const SizedBox(height: 10.0),
                      Text(
                        "Enter your phone number to proceed further",
                        style: AppTextStyle.detailsRegular(
                            context, AppColorStyle.text(context)),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColorStyle.backgroundVariant(context),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            InkWellWidget(
                              onTap: () {
                                CountryDialog.countryDialog(
                                  context: context,
                                  onItemClick: (CountryModel country) {
                                    authBLoc.setSelectedCountryModel = country;
                                  },
                                  countryList:
                                      globalBloc?.getCountryListValue ?? [],
                                );
                              },
                              child: StreamBuilder<CountryModel>(
                                stream: authBLoc.getSelectedCountryModel,
                                builder: (context,
                                    AsyncSnapshot<CountryModel> snapshot) {
                                  return Row(
                                    children: [
                                      const SizedBox(
                                        width: 14.0,
                                      ),
                                      if (snapshot.hasData)
                                        SvgPicture.network(
                                          '${Constants.cdnFlagURL}${snapshot.data?.flag}',
                                          width: 24.0,
                                          height: 24.0,
                                          alignment: Alignment.center,
                                          fit: BoxFit.fill,
                                          placeholderBuilder: (context) => Icon(
                                            Icons.flag,
                                            size: 24.0,
                                            color: AppColorStyle.surfaceVariant(
                                                context),
                                          ),
                                        )
                                      else
                                        Icon(
                                          Icons.flag,
                                          size: 24.0,
                                          color: AppColorStyle.surfaceVariant(
                                              context),
                                        ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        snapshot.hasData
                                            ? "${snapshot.data?.dialCode}"
                                            : '',
                                        style: AppTextStyle.titleSemiBold(
                                          context,
                                          (snapshot.hasData)
                                              ? AppColorStyle.textHint(context)
                                              : AppColorStyle.text(context),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: MobileTextFieldWidget(
                                stream: gmpBloc!.mobileStream,
                                readOnly: false,
                                initialValue: "",
                                isErrorShow: false,
                                keyboardKey: TextInputType.number,
                                hintText: StringHelper.profilePhoneNumber,
                                onTextChanged: (String number) {
                                  gmpBloc.onChangePhone(number);
                                  /* if (number.isNotEmpty &&
                                    number.trim() != userInfo?.phone &&
                                    _editProfileBloc.isPhoneVerified == true) {
                                  gmpBloc!.isPhoneNumberChangeValue =
                                      true;
                                } else {
                                  gmpBloc!.isPhoneNumberChangeValue =
                                      false;
                                }*/
                                },
                              ),
                            ),
                            StreamBuilder(
                              stream: authBLoc.getLoadingSubject,
                              builder: (context, snapshotLoader) {
                                if (snapshotLoader.hasData &&
                                    snapshotLoader.data == false) {
                                  return StreamBuilder(
                                    stream: gmpBloc.mobileStream,
                                    builder:
                                        (_, AsyncSnapshot<String> snapshot) {
                                      return InkWellWidget(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            StringHelper.profileGetOTP,
                                            style: AppTextStyle.detailsRegular(
                                              context,
                                              (snapshot.hasData &&
                                                      snapshot
                                                          .data!.isNotEmpty &&
                                                      snapshot.data!.length > 6)
                                                  ? AppColorStyle.primary(
                                                      context)
                                                  : AppColorStyle.textHint(
                                                      context),
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          if (NetworkController
                                                  .isInternetConnected ==
                                              false) {
                                            Toast.show(context,
                                                message: StringHelper
                                                    .internetConnection,
                                                type: Toast.toastError);
                                            return;
                                          }
                                          if (snapshot.hasData &&
                                              snapshot.data!.isNotEmpty &&
                                              snapshot.data!.length > 6) {
                                            bool flag = gmpBloc
                                                .validationForPhoneNumber(
                                                    context);
                                            if (flag) {
                                              printLog(
                                                  "#EditProfileScreen# send OTP on ${gmpBloc.getPhoneNumberValue}");
                                              authBLoc.setMobileNumber =
                                                  gmpBloc.getPhoneNumberValue;
                                              //FocusManager.instance.primaryFocus?.unfocus();
                                              // SENDING OTP
                                              var result =
                                                  await authBLoc.sendOTP(
                                                      RouteName
                                                          .gmpOVHCDetailsScreen,
                                                      context);
                                              // PROCESS RESULT
                                              gmpBloc.verifyPhoneNumber(
                                                  result,
                                                  context,
                                                  data,
                                                  globalBloc,
                                                  index,
                                                  isFromOVHC);
                                            }
                                          } else {
                                            //do nothing because of invalid phone number
                                          }
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: AppColorStyle.primary(context),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ));
      });
}
