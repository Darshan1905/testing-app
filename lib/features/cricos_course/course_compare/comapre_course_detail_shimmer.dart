import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class CompareCourseDetailShimmer extends StatelessWidget {
  final bool isActionBarShow;

  const CompareCourseDetailShimmer({Key? key, this.isActionBarShow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColorStyle.backgroundVariant(context),
      child: Shimmer.fromColors(
          baseColor: AppColorStyle.shimmerPrimary(context),
          highlightColor: AppColorStyle.shimmerSecondary(context),
          period: const Duration(milliseconds: 1500),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //header
                Visibility(
                  visible: isActionBarShow,
                  child: Container(
                    height: 220,
                    color: AppColorStyle.shimmerSecondary(context)
                        .withOpacity(0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColorStyle.surface(context),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    )),
                              ),
                              Container(
                                  width: 150,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: AppColorStyle.surface(context),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 135,
                                  color: AppColorStyle.surface(context),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Container(
                                  height: 135,
                                  width: 1.0,
                                  color: AppColorStyle.surface(context),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 135,
                                  color: AppColorStyle.surface(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //details
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                          height: 35, color: AppColorStyle.surface(context)),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            height: 50,
                            width: 1.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity),
                          ),
                        ),
                      ],
                    ),

                    //details
                    Container(
                        height: 35, color: AppColorStyle.surface(context)),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            height: 50,
                            width: 1.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity),
                          ),
                        ),
                      ],
                    ),

                    //details
                    Container(
                        height: 35, color: AppColorStyle.surface(context)),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.commonPadding,
                      vertical: 10.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppColorStyle.shimmerPrimary(context),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      height: 50,
                      width: double.infinity),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: AppColorStyle.surface(context),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  height: 50,
                  width: 1.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.commonPadding,
                      vertical: 10.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppColorStyle.shimmerPrimary(context),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      height: 50,
                      width: double.infinity),
                ),
              ),
            ],
          ),

                    //details
                    Container(
                        height: 35, color: AppColorStyle.surface(context)),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            height: 50,
                            width: 1.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity),
                          ),
                        ),
                      ],
                    ),

                    //details
                    Container(
                        height: 35, color: AppColorStyle.surface(context)),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            height: 50,
                            width: 1.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity),
                          ),
                        ),
                      ],
                    ),

                    //details
                    Container(
                        height: 35, color: AppColorStyle.surface(context)),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            height: 50,
                            width: 1.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity),
                          ),
                        ),
                      ],
                    ),

                    //course discipline
                    Container(
                        height: 35, color: AppColorStyle.surface(context)),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 120,
                                width: double.infinity),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            height: 120,
                            width: 1.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 120,
                                width: double.infinity),
                          ),
                        ),
                      ],
                    ),

                    //Course Outline
                    Container(
                        height: 35, color: AppColorStyle.surface(context)),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 120,
                                width: double.infinity),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            height: 120,
                            width: 1.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 120,
                                width: double.infinity),
                          ),
                        ),
                      ],
                    ),

                    //Offering Institution
                    Container(
                        height: 35, color: AppColorStyle.surface(context)),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 120,
                                width: double.infinity),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            height: 120,
                            width: 1.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding,
                                vertical: 10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.shimmerPrimary(context),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                height: 120,
                                width: double.infinity),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50,)
                  ],
                )
              ],
            ),
          )),
    );
  }
}
