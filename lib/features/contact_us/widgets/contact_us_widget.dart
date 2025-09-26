import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/contact_us/contact_us_bloc.dart';
import 'package:occusearch/features/contact_us/model/contact_us_model.dart';
import 'package:occusearch/features/contact_us/model/country_wise_branch_model.dart';
import 'package:occusearch/features/contact_us/widgets/contact_us_shimmer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: must_be_immutable
class CountryTabNameWidget extends StatelessWidget {
  ItemScrollController branchWiseScrollController;
  ItemScrollController countryScrollController;

  CountryTabNameWidget(
      {Key? key,
      required this.branchWiseScrollController,
      required this.countryScrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contactUsBloc = RxBlocProvider.of<ContactUsBloc>(context);

    return StreamBuilder(
        stream: contactUsBloc.loadingStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return const ContactUsCountryShimmer();
            } else {
              return StreamWidget(
                  stream: contactUsBloc.getCountryWiseListStream,
                  onBuild: (_, snapshot) {
                    List<CountryWiseBranch>? countryModelList = snapshot;
                    return Container(
                      color: AppColorStyle.primarySurfaceWithOpacity(context),
                      height: 54,
                      width: double.infinity,
                      child: ScrollablePositionedList.builder(
                          itemScrollController: countryScrollController,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: countryModelList!.length,
                          itemBuilder: (context, index) {
                            return BranchNameTabWidget(
                                item: countryModelList[index],
                                index: index,
                                countryScrollController:
                                    countryScrollController,
                                branchWiseScrollController:
                                    branchWiseScrollController);
                          }),
                    );
                  });
            }
          } else {
            return const SizedBox();
          }
        });
  }
}

// ignore: must_be_immutable
class BranchNameTabWidget extends StatelessWidget {
  CountryWiseBranch item;
  int index;
  ItemScrollController countryScrollController, branchWiseScrollController;

  BranchNameTabWidget(
      {Key? key,
      required this.item,
      required this.index,
      required this.countryScrollController,
      required this.branchWiseScrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contactUsBloc = RxBlocProvider.of<ContactUsBloc>(context);

    final bool isActive =
        contactUsBloc.countryWiseBranchModel.valueOrNull != null &&
            (contactUsBloc.countryWiseBranchModel.value.countryName ==
                item.countryName);

    return TypeWidget(
        name: '${item.countryName}',
        isActive: isActive,
        onClick: () {
          //firebase tracking
          FirebaseAnalyticLog.shared.eventTracking(
              screenName: RouteName.contactUs,
              actionEvent: "${item.countryName} selected",
              sectionName: FBSectionEvent.fbSectionContactUs,
              subSectionName:
                  FBSubSectionEvent.fbSubSectionContactUsCountryname);

          contactUsBloc.onClickBranch(item);
          countryScrollController.scrollTo(
              index: index,
              duration: const Duration(seconds: 3),
              curve: Curves.easeOut);
        },
        index: index,
        itemScrollController: branchWiseScrollController);

    /*return StreamWidget(
      stream: contactUsBloc.getCountryWiseBranchModelStream,
      onBuild: (_, snapshot) {
        final bool isActive =
            contactUsBloc.countryWiseBranchModel.valueOrNull != null &&
                (contactUsBloc.countryWiseBranchModel.value.countryName ==
                    item.countryName);
        return TypeWidget(
            name: '${item.countryName}',
            isActive: isActive,
            onClick: () {
              //firebase tracking
              FirebaseAnalyticLog.shared.eventTracking(
                  screenName: RouteName.contactUs,
                  actionEvent: "${item.countryName} selected",
                  sectionName: FBSectionEvent.fbSectionContactUs,
                  subSectionName:
                      FBSubSectionEvent.fbSubSectionContactUsCountryname);

              contactUsBloc.onClickBranch(item);
              countryScrollController.scrollTo(
                  index: index,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn);
            },
            index: index,
            itemScrollController: branchWiseScrollController);
      },
    );*/
  }
}

// ignore: must_be_immutable
class TypeWidget extends StatelessWidget {
  String name;
  bool isActive;
  Function onClick;
  int index;
  ItemScrollController itemScrollController;

  TypeWidget(
      {Key? key,
      required this.name,
      required this.isActive,
      required this.onClick,
      required this.index,
      required this.itemScrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onTap: () {
        onClick();
      },
      child: Container(
        alignment: Alignment.center,
        margin: isActive
            ? const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)
            : const EdgeInsets.all(0.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: isActive ? AppColorStyle.primary(context) : Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.subTitleMedium(
              context,
              isActive
                  ? AppColorStyle.textWhite(context)
                  : AppColorStyle.text(context)),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AddressBranchWidget extends StatelessWidget {
  int index;

  AddressBranchWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contactUsBloc = RxBlocProvider.of<ContactUsBloc>(context);
    return StreamBuilder<CountryWiseBranch>(
      stream: contactUsBloc.countryWiseBranchModel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          AussizzBranches branchList;
          if (contactUsBloc.countryWiseBranchModel.value.branchDataList !=
                  null &&
              contactUsBloc
                      .countryWiseBranchModel.value.branchDataList!.length >
                  index) {
            branchList = contactUsBloc
                .countryWiseBranchModel.value.branchDataList![index];
          } else {
            branchList =
                contactUsBloc.countryWiseBranchModel.value.branchDataList![0];
          }

          String address = branchList.addressline1 == null &&
                  branchList.addressline2 == null &&
                  branchList.zipcode == null
              ? branchList.cityname ?? "address"
              : branchList.addressline1.toString() +
                  ((branchList.addressline1!.isNotEmpty) ? ", " : "") +
                  branchList.address2.toString() +
                  (branchList.address2!.isNotEmpty ? ", " : "") +
                  branchList.cityname.toString() +
                  ((branchList.cityname!.isNotEmpty ? ", " : "")) +
                  branchList.statename.toString() +
                  ((branchList.zipcode!.isNotEmpty) ? "- " : "") +
                  branchList.zipcode.toString() +
                  ((branchList.countryname!.isNotEmpty ? ", " : "")) +
                  branchList.countryname.toString();
          return Column(
            children: [
              const SizedBox(height: 15.0),
              // Branch address
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    IconsSVG.mapIcon,
                    colorFilter: ColorFilter.mode(
                      AppColorStyle.primary(context),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: InkWellWidget(
                      onTap: () {
                        /*if (branchList.latitude != null &&
                          branchList.longitude != null &&
                          branchList.latitude != "0.0" &&
                          branchList.longitude != "0.0") {
                        MapsLauncher.launchCoordinates(
                            double.parse(branchList.latitude ?? "0.0"),
                            double.parse(branchList.longitude ?? "0.0"),
                            address);
                      }*/
                      },
                      child: Text(address,
                          maxLines: 5,
                          style: AppTextStyle.subTitleMedium(
                              context, AppColorStyle.text(context))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              // Email address
              InkWellWidget(
                onTap: () async {
                  contactUsBloc.onGmail(branchList.emailaddress.toString());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconsSVG.contactMailIcon,
                      colorFilter: ColorFilter.mode(
                        AppColorStyle.primary(context),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: InkWellWidget(
                        onTap: () async {
                          contactUsBloc
                              .onGmail(branchList.emailaddress.toString());
                        },
                        child: Text(branchList.emailaddress.toString(),
                            maxLines: 2,
                            style: AppTextStyle.subTitleMedium(
                                context, AppColorStyle.text(context))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Phone number
              Row(
                children: [
                  SvgPicture.asset(
                    IconsSVG.phoneIcon,
                    colorFilter: ColorFilter.mode(
                      AppColorStyle.primary(context),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  InkWellWidget(
                    onTap: () {
                      launchUrlString("tel://${branchList.companyphone}");
                    },
                    child: Text(
                      branchList.companyphone.toString(),
                      style: AppTextStyle.subTitleMedium(
                          context, AppColorStyle.text(context)),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

// ignore: must_be_immutable
class SocialLinksWidget extends StatelessWidget {
  AussizzBranches aussizzBranches;

  SocialLinksWidget({Key? key, required this.aussizzBranches})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contactUsBloc = RxBlocProvider.of<ContactUsBloc>(context);

    return aussizzBranches.socialLinks != null
        ? Container(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                      aussizzBranches.socialLinks!.length,
                      (index) => (aussizzBranches
                                  .socialLinks![index].link!.isNotEmpty &&
                              aussizzBranches.socialLinks![index].link != "")
                          ? InkWellWidget(
                              onTap: () {
                                contactUsBloc.handleSocialMediaClickEvent(
                                    aussizzBranches.socialLinks![index],
                                    context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.network(
                                  aussizzBranches.socialLinks![index].icon ??
                                      "",
                                  height: 22,
                                  width: 22,
                                  fit: BoxFit.fill,
                                  filterQuality: FilterQuality.high,
                                ),
                              ))
                          : Container()),
                ),
                (aussizzBranches.marn != null &&
                        aussizzBranches.marn.toString().isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          "MARN ${aussizzBranches.marn ?? " "}",
                          style: AppTextStyle.captionMedium(
                              context, AppColorStyle.primary(context)),
                        ),
                      )
                    : Container()
              ],
            ),
          )
        : Container();
  }
}

class GoogleMapLoading extends StatelessWidget {
  const GoogleMapLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringHelper.mapLoadingMessage1,
              textAlign: TextAlign.center,
              style: AppTextStyle.detailsSemiBold(
                  context, AppColorStyle.text(context)),
            ),
            const SizedBox(
              height: 3.0,
            ),
            Text(
              StringHelper.mapLoadingMessage2,
              textAlign: TextAlign.center,
              style: AppTextStyle.captionRegular(
                  context, AppColorStyle.text(context)),
            ),
          ],
        ),
      ),
    );
  }
}
