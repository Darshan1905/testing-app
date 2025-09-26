import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/more_menu/model/more_app_model.dart';
import 'package:occusearch/features/more_menu/more_menu_bloc.dart';

class MoreAppsWidget extends StatelessWidget {
  const MoreAppsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moreMenuBloc = RxBlocProvider.of<MoreMenuBloc>(context);
    return StreamBuilder(
        stream: moreMenuBloc.getMoreAppListStream,
        builder: (context, snapshot) {
          final List<ApplicationList>? list = snapshot.data;
          if (snapshot.hasData && snapshot.data != null) {
            return Column(
              children: [
                InkWellWidget(
                  onTap: () {
                    GoRoutesPage.go(
                        mode: NavigatorMode.push,
                        moveTo: RouteName.moreApps,
                        param: snapshot.data);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 25.0),
                    color: AppColorStyle.background(context),
                    // decoration: BoxDecoration(
                    //   color: AppColorStyle.background(context),
                    //   borderRadius:
                    //       const BorderRadius.all(Radius.circular(10.0)),
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40.0,
                          width: 100.0,
                          child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: List.generate(
                                  list!.length,
                                  (index) => MoreAppsListWidget(
                                      context,
                                      list[index].images ?? "",
                                      list.length - index))),
                        ),
                        Flexible(
                          child: Text(
                            StringHelper.exploreOurOtherProducts,
                            style: AppTextStyle.subTitleMedium(
                                context, AppColorStyle.text(context)),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //about and legal
                InkWellWidget(
                  onTap: () {
                    GoRoutesPage.go(
                        mode: NavigatorMode.push,
                        moveTo: RouteName.aboutAndLegal);
                  },
                  child: Container(
                    color: AppColorStyle.background(context),
                    // decoration: BoxDecoration(
                    //   color: AppColorStyle.background(context),
                    //   borderRadius:
                    //       const BorderRadius.all(Radius.circular(10.0)),
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            IconsSVG.aboutAndLegalMenu,
                            colorFilter: ColorFilter.mode(
                              AppColorStyle.text(context),
                              BlendMode.srcIn,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    StringHelper.aboutAndLegal,
                                    style: AppTextStyle.subTitleMedium(
                                        context, AppColorStyle.text(context)),
                                  ),
                                  Text(
                                    StringHelper.subTitleAboutAndLegal,
                                    style: AppTextStyle.captionRegular(context,
                                        AppColorStyle.textCaption(context)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15)
              ],
            );
          } else {
            return const SizedBox();
          }
        });
  }
}

class MoreAppsListWidget extends StatelessWidget {
  final String applicationLogoUrl;
  final BuildContext context;
  final int index;

  const MoreAppsListWidget(this.context, this.applicationLogoUrl, this.index,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (index * 20.0) - 20.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColorStyle.backgroundVariant(context),
              blurRadius: 5,
              offset: const Offset(2, 0), // Shadow position
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
              height: 30,
              width: 30,
              imageUrl: applicationLogoUrl,
              //color: Colors.white,
              fit: BoxFit.cover,
              placeholder: (context, error) =>
                  SvgPicture.asset(IconsSVG.placeholder),
              errorWidget: (context, url, error) => Icon(
                    Icons.photo,
                    color: AppColorStyle.backgroundVariant(context),
                  )),
        ),
      ),
    );
  }
}
