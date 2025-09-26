import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/get_my_policy/gmp_bloc.dart';
import 'package:occusearch/features/get_my_policy/model/ovhc_data_model.dart';
import 'package:occusearch/features/get_my_policy/ovhc/widget/ovhc_card_widget.dart';
import 'package:occusearch/features/get_my_policy/widget/add_phone_number_bottom_sheet.dart';
import 'package:occusearch/features/get_my_policy/widget/email_picker_bottom_sheet.dart';

class GMPOVHCDetailsPage extends BaseApp {
  const GMPOVHCDetailsPage({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => GMPOVHCDetailsPageState();
}

class GMPOVHCDetailsPageState extends BaseState {
  GetMyPolicyBloc? gmpBloc;
  final AuthenticationBloc _authBloc = AuthenticationBloc();
  UserInfoData? info;
  static TextEditingController emailAddress = TextEditingController();
  static final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  @override
  init() async {
    dynamic argumentValue = widget.arguments;
    if (widget.arguments != null) {
      gmpBloc = argumentValue['bloc'];
    }
    info = await globalBloc?.getUserInfo(context);

    WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
        await globalBloc?.getDeviceCountryInfo();
        await Future.delayed(const Duration(milliseconds: 500));
        // Fetch list of country if not available
        if (globalBloc != null &&
            (globalBloc?.getCountryListValue == null ||
                globalBloc?.getCountryListValue == [])) {
          // printLog("Country data fetching...");
          await globalBloc?.getCountryListFromRemoteConfig();
        }
        // To set current country model based on device info
        if (globalBloc?.getCountryListValue != null &&
            globalBloc!.getCountryListValue.isNotEmpty) {
          CountryModel? model = globalBloc?.getCountryListValue.firstWhere(
                  (element) =>
              element.code == globalBloc?.getDeviceCountryShortcodeValue);
          if (model == null) {
            _authBloc.setSelectedCountryModel =
            globalBloc?.getCountryListValue[0];
          } else {
            _authBloc.setSelectedCountryModel = model;
          }
        }
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return RxMultiBlocProvider(
        providers: [
          RxBlocProvider<AuthenticationBloc>(create: (context) => _authBloc),
        ],
        child: Container(
          color: AppColorStyle.background(context),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColorStyle.background(context),
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWellWidget(
                          onTap: () {
                            context.pop();
                          },
                          child: SvgPicture.asset(
                            IconsSVG.arrowBack,
                            colorFilter: ColorFilter.mode(
                              AppColorStyle.text(context),
                              BlendMode.srcIn,
                            ),
                          )),
                      const SizedBox(width: 15),
                      Text(
                        StringHelper.ovhcPolicy,
                        style: AppTextStyle.subHeadlineSemiBold(
                            context, AppColorStyle.text(context)),
                      ),
                      const Spacer(),
                      InkWellWidget(
                          onTap: () {
                            return ShowSortingDialog.showSortingDialog(
                                context, gmpBloc!);
                          },
                          child: SvgPicture.asset(IconsSVG.icSort)),
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: gmpBloc?.getOVHCListStream,
                    builder: (context, snapshot) {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: GridView.builder(
                            itemCount:
                                snapshot.hasData ? snapshot.data?.length : 0,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 0.7),
                            itemBuilder: (BuildContext context, int index) {
                              DataModel data = snapshot.data![index];
                              return OvhcPolicyCard(
                                  model: data,
                                  index: index,
                                  gmpBloc: gmpBloc!,
                                  onTap: () {
                                    if (NetworkController.isInternetConnected) {
                                      if (info!.email != null &&
                                          info!.email!.isNotEmpty &&
                                          info!.phone != null &&
                                          info!.phone!.isNotEmpty) {
                                        gmpBloc?.buyOVHCGmpQuote(
                                            context, data, globalBloc, index);
                                      } else if (info!.email == null ||
                                          info!.email!.isEmpty) {
                                        showEmailPickerSheet(context, data,
                                            globalBloc, index, gmpBloc, true);
                                      } else if (info!.phone == null ||
                                          info!.phone!.isEmpty) {
                                        showPhoneNumberBottomSheet(
                                            context,
                                            data,
                                            globalBloc,
                                            index,
                                            gmpBloc,
                                            _authBloc,
                                            phoneFormKey,
                                            true);
                                      }
                                    } else {
                                      Toast.show(context,
                                          message:
                                              StringHelper.internetConnection,
                                          type: Toast.toastError,
                                          duration: 3);
                                    }
                                  });
                            },
                          ),
                        ),
                      );
                    }),
                // Add container filter option low to high and high to low
                StreamBuilder(
                    stream: gmpBloc?.selectedSortingStream,
                    builder: (context, snapshot) {
                      return Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWellWidget(
                              onTap: () {
                                if (snapshot.hasData &&
                                    snapshot.data == StringHelper.lowToHigh) {
                                  gmpBloc?.selectedSortingStream.add("");
                                  return;
                                }
                                gmpBloc?.selectedSortingStream
                                    .add(StringHelper.lowToHigh);
                                gmpBloc?.filterOVHCList(StringHelper.lowToHigh);
                              },
                              child: Text(
                                StringHelper.lowToHigh,
                                style: snapshot.hasData &&
                                        snapshot.data == StringHelper.lowToHigh
                                    ? AppTextStyle.detailsBold(
                                        context, AppColorStyle.primary(context))
                                    : AppTextStyle.detailsMedium(
                                        context, AppColorStyle.text(context)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWellWidget(
                              onTap: () {
                                if (snapshot.hasData &&
                                    snapshot.data == StringHelper.highToLow) {
                                  gmpBloc?.selectedSortingStream.add("");
                                  return;
                                }
                                gmpBloc?.selectedSortingStream
                                    .add(StringHelper.highToLow);
                                gmpBloc?.filterOVHCList(StringHelper.highToLow);
                              },
                              child: Text(
                                StringHelper.highToLow,
                                style: snapshot.hasData &&
                                        snapshot.data == StringHelper.highToLow
                                    ? AppTextStyle.detailsBold(
                                        context, AppColorStyle.primary(context))
                                    : AppTextStyle.detailsMedium(
                                        context, AppColorStyle.text(context)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ));
  }

  @override
  onResume() {}
}
