// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:io';

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/contact_us/contact_us_bloc.dart';
import 'package:occusearch/features/contact_us/model/country_wise_branch_model.dart';
import 'package:occusearch/features/contact_us/widgets/contact_us_shimmer.dart';
import 'package:occusearch/features/contact_us/widgets/contact_us_widget.dart';
import 'package:occusearch/utility/map_launcher.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ContactUsScreen extends BaseApp {
  const ContactUsScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends BaseState {
  final ContactUsBloc _contactUsBloc = ContactUsBloc();
  GlobalBloc? _globalBloc;

  ItemScrollController branchWiseScrollController = ItemScrollController();
  ItemScrollController countryScrollController = ItemScrollController();
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markers = <Marker>[];

  //For location
  var userLatitude, userLongitude;

  //update latitude longitude
  Future<void> updateMapPos(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;

    //update camera position of google map
    CameraPosition updatedCameraPosition =
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15);

    controller
        .animateCamera(CameraUpdate.newCameraPosition(updatedCameraPosition));
  }

  @override
  init() {
    //GET USER LIVE LOCATION FROM ARGUMENTS
    var argValue = widget.arguments;

    Future.delayed(Duration.zero, () {
      _contactUsBloc.getContactUsDataFromFirebaseRealtimeDB(_markers, argValue);
    });

    // Once the lat/long received it will update the camera position
    _contactUsBloc.initStreamController.stream.listen((bool key) {
      if (key) {
        updateMapPos(
            double.parse(
                _contactUsBloc.selectedBranchIndexLatitude.value.toString()),
            double.parse(
                _contactUsBloc.selectedBranchIndexLongitude.value.toString()));

        if (_contactUsBloc.countryWiseBranchListSubject.valueOrNull != null &&
            (_contactUsBloc.countryWiseBranchListSubject.valueOrNull != null &&
                _contactUsBloc.countryWiseBranchListSubject.value.isNotEmpty &&
                _contactUsBloc.countryWiseBranchModel.valueOrNull != null &&
                _contactUsBloc.countryWiseBranchModel.value.countryName !=
                    null)) {
          int index = _contactUsBloc.countryWiseBranchListSubject.value
              .indexWhere((element) =>
                  element.countryName ==
                  _contactUsBloc.countryWiseBranchModel.value.countryName);
          Future.delayed(const Duration(milliseconds: 100), () async {
            countryScrollController.jumpTo(index: index);
          });
        }
      }
    });
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    _contactUsBloc.setCountryCodeValue =
        _globalBloc?.getDeviceCountryShortcodeValue;
    return RxBlocProvider(
      create: (_) => _contactUsBloc,
      child: Container(
        color: AppColorStyle.background(context),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: Constants.commonPadding,
                    right: Constants.commonPadding,
                    top: 20,
                    bottom: 20),
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
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      StringHelper.contactUs,
                      style: AppTextStyle.subHeadlineSemiBold(
                          context, AppColorStyle.text(context)),
                    ),
                  ],
                ),
              ),
              //Google Map
              Stack(
                alignment: Alignment.topRight,
                children: [
                  StreamBuilder(
                      stream: _contactUsBloc.loadingStream,
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == true) {
                            return const GoogleMapLoading();
                          } else {
                            return StreamWidget(
                              stream: _contactUsBloc
                                  .getSelectedBranchIndexLatitudeStream,
                              onBuild: (_, snapshot) {
                                final double lat = snapshot;
                                return StreamWidget(
                                    stream: _contactUsBloc
                                        .getSelectedBranchIndexLongitudeStream,
                                    onBuild: (_, snapshot) {
                                      final double long = snapshot;
                                      return SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height /
                                                3,
                                        child: GoogleMap(
                                          mapToolbarEnabled: false,
                                          scrollGesturesEnabled: false,
                                          zoomGesturesEnabled: false,
                                          onMapCreated:
                                              (GoogleMapController controller) {
                                            _controller.complete(controller);
                                          },
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(lat.toDouble(),
                                                long.toDouble()),
                                            zoom: 15.0,
                                          ),
                                          markers: Set<Marker>.of(_markers),
                                          zoomControlsEnabled: false,
                                          rotateGesturesEnabled: false,
                                          mapType: MapType.normal,
                                        ),
                                      );
                                    });
                              },
                            );
                          }
                        } else {
                          return const SizedBox();
                        }
                      }),
                  StreamWidget(
                    stream: _contactUsBloc.getSelectedBranchStateNameStream,
                    onBuild: (_, snapshot) {
                      final String branchName = snapshot;
                      return Container(
                        height: MediaQuery.sizeOf(context).height / 3,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Constants.commonPadding, vertical: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Text(
                              branchName,
                              style: AppTextStyle.captionSemiBold(
                                  context, AppColorStyle.textWhite(context)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // location direction icon
                  StreamBuilder<bool>(
                      stream: _contactUsBloc.loadingStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == false && Platform.isAndroid) {
                          return Positioned(
                            top: (MediaQuery.sizeOf(context).height / 3) - 50,
                            left: MediaQuery.sizeOf(context).width - 50,
                            child: InkWellWidget(
                              onTap: () {
                                //firebase tracking
                                FirebaseAnalyticLog.shared.eventTracking(
                                    screenName: RouteName.contactUs,
                                    actionEvent:
                                        "${_contactUsBloc.selectedBranchIndexLatitude.value.toDouble()}"
                                        ", "
                                        "${_contactUsBloc.selectedBranchIndexLongitude.value.toDouble()}",
                                    sectionName:
                                        FBSectionEvent.fbSectionContactUs,
                                    subSectionName: FBSubSectionEvent
                                        .fbSubSectionContactUsGooglemap);

                                if (_contactUsBloc.selectedBranchIndexLatitude
                                            .valueOrNull !=
                                        null &&
                                    _contactUsBloc.selectedBranchIndexLongitude
                                            .valueOrNull !=
                                        null &&
                                    _contactUsBloc.selectedBranchIndexLatitude
                                            .valueOrNull !=
                                        0.0 &&
                                    _contactUsBloc.selectedBranchIndexLongitude
                                            .valueOrNull !=
                                        0.0) {
                                  MapsLauncher.launchCoordinates(
                                      _contactUsBloc
                                          .selectedBranchIndexLatitude.value
                                          .toDouble(),
                                      _contactUsBloc
                                          .selectedBranchIndexLongitude.value
                                          .toDouble());
                                }
                              },
                              child: SvgPicture.asset(
                                IconsSVG.locationDirection,
                                width: 38,
                                height: 38,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ],
              ),
              // country tab bar widgets
              CountryTabNameWidget(
                  branchWiseScrollController: branchWiseScrollController,
                  countryScrollController: countryScrollController),
              const SizedBox(height: 20),
              //Contact Us Branch List Detail
              StreamBuilder(
                stream: _contactUsBloc.loadingStream,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      return const ContactUsBranchListShimmer();
                    } else {
                      return StreamWidget(
                        stream: _contactUsBloc.getCountryWiseBranchModelStream,
                        onBuild: (_, snapshot) {
                          CountryWiseBranch? countryWiseBranchData = snapshot;
                          Future.delayed(
                            const Duration(milliseconds: 500),
                            () async {
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) {
                                  if (branchWiseScrollController.isAttached) {
                                    branchWiseScrollController.jumpTo(
                                      index: _contactUsBloc
                                          .selectedAddressCurrentIndex
                                          .stream
                                          .value,
                                    );
                                  }
                                },
                              );
                            },
                          );
                          return SizedBox(
                            height: MediaQuery.sizeOf(context).height / 2.8,
                            child: ScrollablePositionedList.builder(
                              itemScrollController: branchWiseScrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  countryWiseBranchData!.branchDataList!.length,
                              itemBuilder: (context, index) {
                                final addressRow = countryWiseBranchData
                                    .branchDataList![index];

                                return InkWellWidget(
                                  onTap: () {
                                    //firebase tracking
                                    FirebaseAnalyticLog.shared.eventTracking(
                                        screenName: RouteName.contactUs,
                                        actionEvent:
                                            "${addressRow.cityname} selected",
                                        sectionName:
                                            FBSectionEvent.fbSectionContactUs,
                                        subSectionName: FBSubSectionEvent
                                            .fbSubSectionContactUsCitynameList);

                                    printLog(
                                        "companyname=>${addressRow.companyname}");
                                    //set company name according to selected company
                                    _contactUsBloc.setStateNameBranchWise =
                                        addressRow.companyname ?? "";

                                    //set address
                                    _contactUsBloc.setAddress =
                                        addressRow.addressline1 == null &&
                                                addressRow.addressline2 ==
                                                    null &&
                                                addressRow.zipcode == null
                                            ? addressRow.cityname ?? "address"
                                            : addressRow.addressline1
                                                    .toString() +
                                                ((addressRow.addressline1!
                                                        .isNotEmpty)
                                                    ? ", "
                                                    : "") +
                                                addressRow.address2.toString() +
                                                (addressRow.address2!.isNotEmpty
                                                    ? ", "
                                                    : "") +
                                                addressRow.cityname.toString() +
                                                ((addressRow
                                                        .cityname!.isNotEmpty
                                                    ? ", "
                                                    : "")) +
                                                addressRow
                                                    .statename
                                                    .toString() +
                                                ((addressRow
                                                        .zipcode!.isNotEmpty)
                                                    ? "- "
                                                    : "") +
                                                addressRow.zipcode.toString() +
                                                ((addressRow
                                                        .countryname!.isNotEmpty
                                                    ? ", "
                                                    : "")) +
                                                addressRow.countryname
                                                    .toString();

                                    //set index, latitude and longitude according to selected company
                                    _contactUsBloc.setBranchAddressIndex(
                                        index, addressRow);

                                    branchWiseScrollController.scrollTo(
                                        index: index,
                                        duration: const Duration(seconds: 1));

                                    //update latitude and longitude of google map
                                    if (addressRow.latitude != null &&
                                        addressRow.latitude != "" &&
                                        addressRow.longitude != null &&
                                        addressRow.longitude != "") {
                                      updateMapPos(
                                          double.parse(
                                              addressRow.latitude ?? "0.0"),
                                          double.parse(
                                              addressRow.longitude ?? "0.0"));
                                    }
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    margin: EdgeInsets.only(
                                        right: index ==
                                                (countryWiseBranchData
                                                        .branchDataList!
                                                        .length -
                                                    1)
                                            ? 20.0
                                            : 0.0,
                                        left: 20),
                                    decoration: BoxDecoration(
                                        color: AppColorStyle.backgroundVariant(
                                            context),
                                        border: Border.all(
                                            color:
                                                AppColorStyle.backgroundVariant(
                                                    context),
                                            width: 1.0,
                                            style: BorderStyle.solid),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          StreamBuilder<int>(
                                              stream: _contactUsBloc
                                                  .selectedAddressCurrentIndex
                                                  .stream,
                                              builder: (context, snapshot) {
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.2,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Constants
                                                          .commonPadding,
                                                      vertical: 15.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: (snapshot
                                                                    .data ??
                                                                0) ==
                                                            index
                                                        ? const BorderRadius
                                                            .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10))
                                                        : const BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                10)),
                                                    color: (snapshot
                                                                    .data ??
                                                                0) ==
                                                            index
                                                        ? AppColorStyle.primary(
                                                            context)
                                                        : AppColorStyle
                                                            .backgroundVariant(
                                                                context),
                                                  ),
                                                  child: Text(
                                                    addressRow.companyname
                                                        .toString(),
                                                    style: AppTextStyle
                                                        .subTitleSemiBold(
                                                      context,
                                                      (snapshot.data ?? 0) ==
                                                              index
                                                          ? AppColorStyle
                                                              .textWhite(
                                                                  context)
                                                          : AppColorStyle.text(
                                                              context),
                                                    ),
                                                  ),
                                                );
                                              }),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: Constants.commonPadding,
                                                right: Constants.commonPadding),
                                            child: AddressBranchWidget(
                                                index: index),
                                          ),
                                          const SizedBox(height: 20),
                                          SocialLinksWidget(
                                            aussizzBranches: addressRow,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
