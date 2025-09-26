import 'package:occusearch/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class LabourInsightScreenShimmer extends StatelessWidget {
  final bool isActionBarShow;

  const LabourInsightScreenShimmer({Key? key, this.isActionBarShow = true})
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
                Visibility(
                  visible: isActionBarShow,
                  child: Container(
                    height: 220,
                    color:
                    AppColorStyle.shimmerSecondary(context).withOpacity(0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 10),
                          child: Container(
                            width: 300,
                            height: 30,
                            color: AppColorStyle.surface(context),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 10, bottom: 20),
                              child: Container(
                                  width: 100,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: AppColorStyle.surface(context),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 20),
                              child: Container(
                                  width: 100,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: AppColorStyle.surface(context),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //details
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            height: 90,
                            width: double.infinity),
                      ),
                      //circular
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 20, bottom: 10),
                              child: Container(
                                  width: 100,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColorStyle.surface(context),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color:
                                            AppColorStyle.surface(context),
                                            borderRadius:
                                            BorderRadius.circular(100),
                                          ),
                                          height: 50,
                                          width: 50),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 80,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 100,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color:
                                            AppColorStyle.surface(context),
                                            borderRadius:
                                            BorderRadius.circular(100),
                                          ),
                                          height: 50,
                                          width: 50),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 80,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 100,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color:
                                            AppColorStyle.surface(context),
                                            borderRadius:
                                            BorderRadius.circular(100),
                                          ),
                                          height: 50,
                                          width: 50),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 80,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 100,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color:
                                            AppColorStyle.surface(context),
                                            borderRadius:
                                            BorderRadius.circular(100),
                                          ),
                                          height: 50,
                                          width: 50),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 80,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 100,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color:
                                            AppColorStyle.surface(context),
                                            borderRadius:
                                            BorderRadius.circular(100),
                                          ),
                                          height: 50,
                                          width: 50),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 80,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 100,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color:
                                            AppColorStyle.surface(context),
                                            borderRadius:
                                            BorderRadius.circular(100),
                                          ),
                                          height: 50,
                                          width: 50),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 80,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 100,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(
                                                      context),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //course discipline
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Container(
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.surface(context),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                height: 20,
                                width: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                children: [
                                  Container(
                                      width: 250,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: AppColorStyle.surface(context),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: AppColorStyle.surface(context),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                height: 20,
                                width: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                children: [
                                  Container(
                                      width: 250,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: AppColorStyle.surface(context),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: AppColorStyle.surface(context),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              height: 20,
                              width: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              children: [
                                Container(
                                    width: 250,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: AppColorStyle.surface(context),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //career outline
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Container(
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            )),
                      ),
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: AppColorStyle.surface(context),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              height: 20,
                              width: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: [
                                Container(
                                    width: 300,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: AppColorStyle.surface(context),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                      width: 300,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: AppColorStyle.surface(context),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColorStyle.surface(context),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
