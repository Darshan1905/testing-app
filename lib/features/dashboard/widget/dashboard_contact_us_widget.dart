import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/contact_us/contact_us_bloc.dart';
import 'package:occusearch/features/contact_us/model/contact_us_model.dart';
import 'package:occusearch/features/dashboard/dashboard_bloc.dart';

class DashboardContactUsWidget extends StatelessWidget {
  final DashboardBloc dashboardBloc;

  const DashboardContactUsWidget({Key? key, required this.dashboardBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContactUsBloc contactUsBloc = ContactUsBloc();

    return Container(
      color: AppColorStyle.backgroundVariant(context),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringHelper.communicateWithUs,
            style: AppTextStyle.titleSemiBold(
                context, AppColorStyle.text(context)),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWellWidget(
            onTap: () async {
              await contactUsBloc.contactUsOnTap(context);
            },
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 2.0, right: 2.0, top: 10),
                  width: MediaQuery.of(context).size.width * 0.90,
                  constraints: const BoxConstraints(minHeight: 120.0),
                  decoration: BoxDecoration(
                      color: AppColorStyle.primary(context),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0))),
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset(
                    IconsSVG.dashboardRecentUpdateCard,
                    colorFilter: ColorFilter.mode(
                      AppColorStyle.primarySurface2(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        IconsSVG.contactUsMenu,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.textWhite(context),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        StringHelper.contactUs,
                        style: AppTextStyle.subTitleMedium(
                            context, AppColorStyle.textWhite(context)),
                      ),
                      Text(
                        StringHelper.subTitleContactUs,
                        style: AppTextStyle.captionRegular(
                            context, AppColorStyle.textWhite(context)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            StringHelper.connectWithUs,
            style: AppTextStyle.titleSemiBold(
                context, AppColorStyle.text(context)),
          ),
          const SizedBox(
            height: 15,
          ),
          StreamBuilder(
            stream: dashboardBloc.contactBranchStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                AussizzBranches? aussizzBranches = snapshot.data;
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColorStyle.blackVariant(context),
                    border: Border.all(
                      color: AppColorStyle.surface(context),
                      width: 0.5,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                          (aussizzBranches?.socialLinks?.length ?? 0),
                          (index) => (aussizzBranches?.socialLinks![index].link!
                                          .isNotEmpty ==
                                      true &&
                                  aussizzBranches?.socialLinks![index].link != "")
                              ? InkWellWidget(
                                  onTap: () {
                                    contactUsBloc.handleSocialMediaClickEvent(
                                        aussizzBranches!.socialLinks![index],
                                        context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Image.network(
                                      aussizzBranches?.socialLinks![index].icon ??
                                          "",
                                      height: 40,
                                      width: 40,
                                      colorBlendMode: BlendMode.srcATop,
                                      fit: BoxFit.fill,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                )
                              : const SizedBox()),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
