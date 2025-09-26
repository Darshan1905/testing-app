import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/subscription/subscription_bloc.dart';

class ShowBuyDialog {
  static Future showBuyNowDialog(
      BuildContext buildContext, SubscriptionBloc subscriptionBloc, int index) {
    bool isPromoApplied = false;
    return showModalBottomSheet(
        context: buildContext,
        //scrollControlDisabledMaxHeightRatio: 0.62,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            color: AppColorStyle.background(context),
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("Checkout",
                              style: AppTextStyle.titleBold(context, AppColorStyle.text(context))),
                        ],
                      ),
                      InkWellWidget(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            IconsSVG.closeIcon,
                            colorFilter: ColorFilter.mode(
                              AppColorStyle.text(context),
                              BlendMode.srcIn,
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(index == 0 ? IconsSVG.icBasicPlan : IconsSVG.icPremiumPlan,
                          fit: BoxFit.fill, height: 30, width: 30),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            subscriptionBloc.products[index].title.split("(").first,
                            style: AppTextStyle.titleBold(context, AppColorStyle.primary(context)),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            index == 0 ? "${StringHelper.miniPlanType} / 15 days" : "${StringHelper.subscription} / 30 days",
                            style:
                                AppTextStyle.captionMedium(context, AppColorStyle.text(context)),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const Spacer(),
                      Text.rich(
                        TextSpan(
                            text: subscriptionBloc.products[index].price,
                            style: AppTextStyle.titleBold(context, AppColorStyle.text(context))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    StringHelper.promoCode,
                    style: AppTextStyle.detailsRegular(context, AppColorStyle.text(context)),
                  ),
                  const SizedBox(height: 5),
                  StreamBuilder<bool>(
                      stream: subscriptionBloc.getPromoCodeSubject,
                      builder: (context, snapshot) {
                        isPromoApplied = snapshot.data ?? false;
                        return SearchTextField(
                          controller: subscriptionBloc.promoCodeTextController,
                          searchHintText: "Enter promo code",
                          isClearIcon: snapshot.data ?? false,
                          onTextChanged: (String typingText) {
                            if(isPromoApplied == true) {
                              subscriptionBloc.isPromoApplied = false;
                            }

                            if (typingText.isEmpty) {
                              subscriptionBloc.isPromoApplied = false;
                            }
                          },
                          onClear: () {
                            subscriptionBloc.isPromoApplied = false;
                            subscriptionBloc.promoCodeTextController.text = "";
                          },
                          onApplyTap: () {
                            if (subscriptionBloc.promoCodeTextController.text.isNotEmpty) {
                              subscriptionBloc.updatePromoCodeValue(context,
                                  subscriptionBloc.promoCodeTextController.text.trim(), index);
                            } else {
                              subscriptionBloc.isPromoApplied = false;
                              Toast.show(context,
                                  message: "Please enter promo code", type: Toast.toastError);
                            }
                          },
                        );
                      }),
                  const SizedBox(height: 15),
                  StreamBuilder(
                      stream: subscriptionBloc.getPromoCodeSubject,
                      builder: (context, snapshot) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Subtotal:",
                                  style: AppTextStyle.detailsRegular(
                                      context, AppColorStyle.text(context)),
                                ),
                                const Spacer(),
                                Text.rich(
                                  TextSpan(
                                      text: subscriptionBloc.products[index].price,
                                      style: AppTextStyle.titleBold(
                                          context, AppColorStyle.text(context))),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Visibility(
                              visible: snapshot.hasData && snapshot.data == true,
                              child: Row(
                                children: [
                                  StreamBuilder(
                                      stream: subscriptionBloc.promoCodeListStream,
                                      builder: (context, snapshot) {
                                        int position = 0;
                                        if (subscriptionBloc.promoCodeTextController.text
                                            .toLowerCase()
                                            .trim()
                                            .contains(FirebaseRemoteConfigController
                                            .shared.subscriptionAussizzData?.subscriptionAussizzText ?? "@aussizzgroup.com")) {
                                          position = 0;
                                        } else {
                                          position = snapshot.hasData
                                              ? snapshot.data!.indexWhere((item) =>
                                                  item.promocode ==
                                                      subscriptionBloc
                                                          .promoCodeTextController.text &&
                                                  item.planname ==
                                                      subscriptionBloc.products[index].title
                                                          .split("(")
                                                          .first
                                                          .trim())
                                              : 0;
                                        }
                                        return Text(
                                          subscriptionBloc.promoCodeTextController.text
                                                  .trim()
                                                  .toLowerCase()
                                                  .contains(FirebaseRemoteConfigController
                                              .shared.subscriptionAussizzData?.subscriptionAussizzText ?? "@aussizzgroup.com")
                                              ? "Discount(${FirebaseRemoteConfigController.shared.subscriptionAussizzData?.noOfDays??1825} Days Free)"
                                              : "Discount (${snapshot.hasData ? "${snapshot.data![position].noofdays} Free)" : " (30 Days Free)"}",
                                          style: AppTextStyle.detailsRegular(
                                              context, AppColorStyle.text(context)),
                                        );
                                      }),
                                  const Spacer(),
                                  Text.rich(
                                    TextSpan(
                                        text: '${"-"} ${subscriptionBloc.products[index].price}',
                                        style: AppTextStyle.titleBold(
                                            context, AppColorStyle.text(context))),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  "Total:",
                                  style: AppTextStyle.detailsBold(
                                      context, AppColorStyle.text(context)),
                                ),
                                const Spacer(),
                                Text.rich(
                                  TextSpan(
                                      text: snapshot.hasData && snapshot.data == true
                                          ? "${subscriptionBloc.products[index].currencySymbol} 0.00"
                                          : subscriptionBloc.products[index].price,
                                      style: AppTextStyle.titleBold(
                                          context, AppColorStyle.text(context))),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                  const SizedBox(height: 15),
                  StreamBuilder<bool>(
                      stream: subscriptionBloc.getLoadingSubject,
                      builder: (context, snapshot) {
                        if (snapshot.data == false) {
                          return ButtonWidget(
                            buttonColor: AppColorStyle.primary(context),
                            onTap: () async {
                              if (isPromoApplied == true) {
                                await subscriptionBloc.buyPromoSubscriptionPlan(
                                    buildContext, index);
                              } else {
                                subscriptionBloc.buyProduct(subscriptionBloc.products[index]);
                                Navigator.pop(context);
                              }
                            },
                            title: StringHelper.buyNow,
                            logActionEvent: "",
                          );
                        } else {
                          return Material(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColorStyle.backgroundVariant(context),
                                  borderRadius: const BorderRadius.all(Radius.circular(5))),
                              child: SizedBox(
                                height: 45.0,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: StreamBuilder<List<String>?>(
                                    stream: subscriptionBloc.getLoadingMessage,
                                    builder: (context, snapshot) {
                                      List<RotateAnimatedText> messages = [
                                        RotateAnimatedText(
                                          "Please wait...",
                                          textStyle: AppTextStyle.subTitleMedium(
                                            context,
                                            AppColorStyle.primary(context),
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ];
                                      if (snapshot.hasData &&
                                          snapshot.data != null &&
                                          snapshot.data!.isNotEmpty) {
                                        messages = List.generate(
                                          snapshot.data!.length,
                                          (index) => RotateAnimatedText(
                                            snapshot.data![index],
                                            textStyle: AppTextStyle.subTitleMedium(
                                              context,
                                              AppColorStyle.primary(context),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        );
                                      }
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AnimatedTextKit(
                                            animatedTexts: messages,
                                            repeatForever: true,
                                            pause: const Duration(milliseconds: 0),
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              color: AppColorStyle.primary(context),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onTextChanged;
  final Function? onApplyTap;
  final Function onClear;
  final String searchHintText;
  final bool isClearIcon;

  const SearchTextField(
      {super.key,
      required this.controller,
      required this.onTextChanged,
      required this.onApplyTap,
      required this.onClear,
      this.searchHintText = '',
      this.isClearIcon = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      onChanged: (searchText) => onTextChanged(searchText),
      cursorColor: AppColorStyle.text(context),
      //maxLength: 20,
      controller: controller,
      style: AppTextStyle.detailsRegular(context, AppColorStyle.text(context)),
      decoration: InputDecoration(
        counterText: "",
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
        filled: true,
        fillColor: AppColorStyle.backgroundVariant(context),
        hintText: searchHintText,
        hintStyle: TextStyle(color: AppColorStyle.textHint(context)),
        suffixIcon: isClearIcon
            ? IconButton(
                onPressed: () => onClear(),
                icon: SvgPicture.asset(IconsSVG.cross, height: 14, width: 14),
              )
            : IconButton(
                iconSize: 35,
                onPressed: () => onApplyTap!(),
                icon: Container(
                  alignment: Alignment.center,
                  child: Text("Apply",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.detailsRegular(context, AppColorStyle.primary(context))),
                ),
              ),
      ),
    );
  }
}
