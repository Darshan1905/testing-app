// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:intl/intl.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/push_notification/push_notification.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database_constants.dart';
import 'package:occusearch/data_provider/firebase/remote_config/model/plan_compare_list_model.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/authentication/authentication_repository.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/subscription/consumable_store.dart';
import 'package:occusearch/features/subscription/dialog/purchase_status_dialog.dart';
import 'package:occusearch/features/subscription/model/buy_subcription_model.dart';
import 'package:occusearch/features/subscription/model/mu_subscripion_plan_model.dart';
import 'package:occusearch/features/subscription/model/my_sub_plan_trans_history_model.dart';
import 'package:occusearch/features/subscription/model/promo_code_model.dart';
import 'package:occusearch/features/subscription/model/promo_code_res_model.dart';
import 'package:occusearch/features/subscription/model/subscription_plan_data_model.dart';
import 'package:occusearch/features/subscription/payment_queue_delegate.dart';
import 'package:occusearch/features/subscription/subscription_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

@RxBloc()
class SubscriptionBloc extends RxBlocTypeBase {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  /*For iPhone premium plan id is com.aussizzgroup.occusearch.premium_plans*/
  List<String> productIds = <String>[
    StringHelper.miniPlanId,
    Platform.isIOS ? StringHelper.iphonePremiumPlanId : StringHelper.premiumPlanId,
  ];

  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> notFoundIds = <String>[];
  List<ProductDetails> products = <ProductDetails>[];
  List<PurchaseDetails> purchases = <PurchaseDetails>[];
  String? queryProductError;

  final productListStream = BehaviorSubject<List<ProductDetails>>();

  Stream<List<ProductDetails>> get getProductListStream => productListStream.stream;

  final subscriptionPlanListStream = BehaviorSubject<List<SubscriptionPlanData>>();

  Stream<List<SubscriptionPlanData>> get getSubscriptionPlanList =>
      subscriptionPlanListStream.stream;

  set setSubscriptionPlanList(List<SubscriptionPlanData> subscriptionData) =>
      subscriptionPlanListStream.sink.add(subscriptionData);

  final comparePlanListStream = BehaviorSubject<List<PlanCompareModel>>();

  Stream<List<PlanCompareModel>> get getComparePlanList => comparePlanListStream.stream;

  set setComparePlanList(List<PlanCompareModel> planCompareData) =>
      comparePlanListStream.sink.add(planCompareData);

  final mySubscriptionPlanListStream = BehaviorSubject<List<MySubscriptionPlanData>>();

  Stream<List<MySubscriptionPlanData>> get getMySubscriptionPlanList =>
      mySubscriptionPlanListStream.stream;

  set setMySubscriptionPlanList(List<MySubscriptionPlanData> subscriptionData) =>
      mySubscriptionPlanListStream.sink.add(subscriptionData);

  final planTransactionHistoryListStream = BehaviorSubject<List<SubPlanTransHistoryData>>();

  Stream<List<SubPlanTransHistoryData>> get getSubPlanTransHistoryList =>
      planTransactionHistoryListStream.stream;

  set setSubPlanTransHistoryList(List<SubPlanTransHistoryData> subscriptionData) =>
      planTransactionHistoryListStream.sink.add(subscriptionData);

  final promoCodeListStream = BehaviorSubject<List<PromoCodeListModel>>();

  //Stream<List<PromoCodeListModel>> get getPromoCodeListStream => promoCodeListStream.stream;

  final _loading = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get getLoadingSubject => _loading.stream;

  set setLoading(flag) => _loading.sink.add(flag);

  final _loadingMessage = BehaviorSubject<List<String>?>();

  Stream<List<String>?> get getLoadingMessage => _loadingMessage.stream;

  set setLoadingMessage(messages) => _loadingMessage.sink.add(messages);

  //promo code text field
  TextEditingController promoCodeTextController = TextEditingController();

  final _promoApply = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get getPromoCodeSubject => _promoApply.stream;

  set isPromoApplied(flag) => _promoApply.sink.add(flag);

  BuildContext? context;
  GlobalBloc? globalBloc;
  UserInfoData? userInfoData;
  List<PlanCompareModel> planCompareList = [];
  bool showCheckout = false, showPremiumCheckout = false;

  Future<void> initStoreInfo(BuildContext context, GlobalBloc globalBloc) async {
    this.context = context;
    this.globalBloc = globalBloc;
    userInfoData = userInfoData = await SharedPreferenceController.getUserData();

    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
      //Utility.showSnackBar('subscription onDone');
    }, onError: (error) {
      // handle error here.
      printLog(error.toString());
      //Utility.showSnackBar('subscription onError');
    });

    /*final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      isAvailableProduct = isAvailable;
      products = <ProductDetails>[];
      purchases = <PurchaseDetails>[];
      notFoundIds = <String>[];
      purchasePending = false;
      loading = false;
      return;
    }*/

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(productIds.toSet());
    if (productDetailResponse.error != null) {
      queryProductError = productDetailResponse.error!.message;
      products = productDetailResponse.productDetails;
      purchases = <PurchaseDetails>[];
      notFoundIds = productDetailResponse.notFoundIDs;
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      queryProductError = null;
      products = productDetailResponse.productDetails;
      purchases = <PurchaseDetails>[];
      notFoundIds = productDetailResponse.notFoundIDs;
      return;
    }

    // final List<String> consumables = await ConsumableStore.load();

    products = productDetailResponse.productDetails;
    notFoundIds = productDetailResponse.notFoundIDs;
    productListStream.sink.add(products);
  }

  Future<void> buyProduct(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (var transaction in transactions) {
        await SKPaymentQueueWrapper().finishTransaction(transaction);
      }
    }

    if (productDetails.id == StringHelper.premiumPlanId ||
        productDetails.id == StringHelper.iphonePremiumPlanId) {
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        printLog("show pending UI");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error ||
            purchaseDetails.status == PurchaseStatus.canceled) {
          printLog("show error UI and handle errors");
          _handleInvalidPurchase(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            printLog("verify purchase");
            deliverProduct(purchaseDetails);
          } else {
            printLog("show invalid purchase");
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (Platform.isAndroid) {
          if (productIds.contains(purchaseDetails.productID)) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (productIds.contains(purchaseDetails.productID)) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      List<String> consumables = await ConsumableStore.load();
      // this.consumables = consumables;
      printLog(consumables);
    } else {
      purchases.add(purchaseDetails);
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    ProductDetails productDetails =
        products.firstWhere((element) => element.id == purchaseDetails.productID);
    var subscriptionId = productDetails.id;
    for (var plan in subscriptionPlanListStream.value) {
      if (plan.productID == purchaseDetails.productID ||
          plan.productID == StringHelper.premiumPlanId) {
        subscriptionId = plan.planId.toString();
        continue; // Exit the loop early if a match is found
      }
    }

    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');

    await buySubscription(
        context!,
        userInfoData?.userId ?? 0,
        BuySubscriptionModel(
          subscriptionId: subscriptionId,
          currency: productDetails.currencyCode,
          price: productDetails.rawPrice.toString(),
          orderId: purchaseDetails.purchaseID,
          productID: purchaseDetails.productID == StringHelper.iphonePremiumPlanId
              ? StringHelper.premiumPlanId
              : purchaseDetails.productID,
          purchaseToken: purchaseDetails.verificationData.serverVerificationData,
          isAutoRenewing: (productDetails.id == StringHelper.iphonePremiumPlanId ||
                  productDetails.id == StringHelper.premiumPlanId)
              ? true
              : false,
          quantity: "1",
          source: purchaseDetails.verificationData.source,
          transactionDate: purchaseDetails.transactionDate.toString(),
          status: purchaseDetails.status.toString(),
          startDate: formatter.format(now),
          endDate: null,
          promoCode: promoCodeTextController.text.trim(),
        ));
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<bool> buyFreeSubscription(BuildContext context) async {
    // Parse the input date string
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    userInfoData = await SharedPreferenceController.getUserData();
    // if (!context.mounted) return false;

    bool response = await buySubscription(
        context,
        userInfoData?.userId ?? 0,
        BuySubscriptionModel(
          subscriptionId: "1",
          currency: userInfoData?.countryCode ?? "",
          price: "0.0",
          orderId: "",
          productID: StringHelper.freePlanId,
          purchaseToken: "",
          isAutoRenewing: false,
          quantity: "1",
          source: Platform.isIOS ? "ios" : "android",
          transactionDate: now.millisecondsSinceEpoch.toString(),
          status: "PurchaseStatus.purchased",
          startDate: formatter.format(now),
          endDate: null,
          promoCode: promoCodeTextController.text.trim(),
        ),
        isRedirect: false);
    return response;
  }

  Future<bool> buySubscription(BuildContext context, int userId, BuySubscriptionModel model,
      {bool isRedirect = true, bool hideCheckout = false}) async {
    var param = {
      NetworkAPIConstant.reqResKeys.userId: userId,
      RequestParameterKey.companyIdf: userInfoData?.companyId,
      RequestParameterKey.branchIdf: userInfoData?.branchId!,
      RequestParameterKey.subscriptionId: model.subscriptionId,
      RequestParameterKey.currency: model.currency,
      RequestParameterKey.price: model.price,
      RequestParameterKey.orderId: model.orderId,
      RequestParameterKey.productID: model.productID,
      RequestParameterKey.purchaseToken: model.purchaseToken,
      RequestParameterKey.isAutoRenewing: model.isAutoRenewing,
      RequestParameterKey.quantity: model.quantity,
      RequestParameterKey.source: model.source,
      RequestParameterKey.transactionDate: model.transactionDate,
      RequestParameterKey.status: model.status,
      RequestParameterKey.startDate: model.startDate,
      RequestParameterKey.endDate: model.endDate,
      RequestParameterKey.promoCode: model.promoCode,
    };

    BaseResponseModel result = await SubscriptionRepository.buySubscriptionPlan(param);

    if (hideCheckout) {
      Navigator.of(context).pop(); // Close the checkout dialog
    }

    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess && result.flag == true) {
      Utility.writeFacebookEventsLog(
          eventName: model.productID == StringHelper.miniPlanId
              ? Platform.isIOS
                  ? EventsKey.IPHONE_PURCHASE_BASIC_PLAN
                  : EventsKey.ANDROID_PURCHASE_BASIC_PLAN
              : Platform.isIOS
                  ? EventsKey.IPHONE_PURCHASE_PREMIUM_PLAN
                  : EventsKey.ANDROID_PURCHASE_PREMIUM_PLAN,
          screenName: EventsKey.SCREEN_SUBSCRIPTION,
          sectionName: EventsKey.SECTION_PURCHASE_PLAN);

      // if (!context.mounted) return false;
      await callUserProfileAPI(context);
      if (isRedirect) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return const PurchaseStatusDialog(isSuccess: true, isDismissible: false);
          },
        );
      }
      return true;
    } else {
      // if (!context.mounted) return false;
      if (isRedirect) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return const PurchaseStatusDialog(isSuccess: false, isDismissible: false);
          },
        );
      }
      return false;
    }
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
  }

  getSubscriptionPlanData(BuildContext context) async {
    UserInfoData info = await SharedPreferenceController.getUserData();
    var param = {
      NetworkAPIConstant.reqResKeys.userid: info.userId!,
      RequestParameterKey.companyIdf: info.companyId!,
      RequestParameterKey.branchIdf: info.branchId!
    };

    //Subscription Plan detail Api call
    BaseResponseModel result = await SubscriptionRepository.getOccuSubscriptionPlan(param);

    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess && result.flag == true) {
      SubscriptionPlanDataModel model = SubscriptionPlanDataModel.fromJson(result.data);

      List<PlanCompareModel> planCompareList = [];
      if (model.data != null) {
        setSubscriptionPlanList = model.data!;
        for (int i = 0; i < model.data!.length; i++) {
          if (model.data![i].features != null) {
            if (model.data![i].productID == StringHelper.freePlanId) {
              if (planCompareList.isEmpty) {
                for (int j = 0; j < model.data![i].features!.length; j++) {
                  //add blank model as length of features list
                  planCompareList.add(PlanCompareModel(
                      featureName: "",
                      featureDesc: dynamic,
                      freePlan: dynamic,
                      basicPlan: dynamic,
                      premiumPlan: dynamic));
                }
              }
              //add feature name and value to model fo free plan
              for (int j = 0; j < model.data![i].features!.length; j++) {
                planCompareList[j].featureName = model.data![i].features![j].featureName;

                planCompareList[j].featureDesc =
                    getFeatureDescription(model.data![i].features![j].featureDesc ?? "");
                planCompareList[j].freePlan = (model.data![i].features![j].featureDetail == null ||
                        model.data![i].features![j].featureDetail.toString().isEmpty)
                    ? model.data![i].features![j].isActive
                    : model.data![i].features![j].featureDetail;
              }
            }
          }
          //add feature name and value to model for mini plan
          if (model.data![i].productID == StringHelper.miniPlanId) {
            for (int j = 0; j < model.data![i].features!.length; j++) {
              planCompareList[j].basicPlan = (model.data![i].features![j].featureDetail == null ||
                      model.data![i].features![j].featureDetail.toString().isEmpty)
                  ? model.data![i].features![j].isActive
                  : model.data![i].features![j].featureDetail;
            }
          }

          //add feature name and value to model for premium plan
          if (model.data![i].productID == StringHelper.premiumPlanId) {
            for (int j = 0; j < model.data![i].features!.length; j++) {
              planCompareList[j].premiumPlan = (model.data![i].features![j].featureDetail == null ||
                      model.data![i].features![j].featureDetail.toString().isEmpty)
                  ? model.data![i].features![j].isActive
                  : model.data![i].features![j].featureDetail;
            }
            setComparePlanList = planCompareList;
          }
        }
      } else {
        setSubscriptionPlanList = [];
      }
    } else {
      Toast.show(context, message: result.message.toString(), type: Toast.toastError);
    }
  }

  String getFeatureDescription(String featureDesc) {
    if (featureDesc.isEmpty) {
      return "";
    }
    List<String> parts = featureDesc.split(',');

    // Create a new list to store the numbered parts
    List<String> numberedParts = [];

    // Iterate over the parts and add numbers
    for (int i = 0; i < parts.length; i++) {
      numberedParts.add('${i + 1}. ${parts[i]}');
    }

    // Join the numbered parts into a single string if needed
    String result = numberedParts.join(', ');

    return result;
  }

  getMyOccuSubscriptionPlan(BuildContext context) async {
    UserInfoData info = await SharedPreferenceController.getUserData();
    var param = {
      NetworkAPIConstant.reqResKeys.userid: info.userId!,
      RequestParameterKey.companyIdf: info.companyId!,
      RequestParameterKey.branchIdf: info.branchId!
    };

    //Subscription Plan detail Api call
    BaseResponseModel result = await SubscriptionRepository.getMyOccuSubscriptionPlan(param);

    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess && result.flag == true) {
      MySubscriptionPlanModel model = MySubscriptionPlanModel.fromJson(result.data);
      if (model.data != null) {
        setMySubscriptionPlanList = model.data!;
      } else {
        setMySubscriptionPlanList = [];
      }
    } else {
      Toast.show(context, message: result.message.toString(), type: Toast.toastError);
    }
  }

  ///Loader for transaction history to sho shimmer
  bool loader = false;

  bool get loading => loader;

  set loading(bool loading) {
    loader = loading;
  }

  getMyOccuSubTransactionHistory(BuildContext context) async {
    UserInfoData info = await SharedPreferenceController.getUserData();
    var param = {
      NetworkAPIConstant.reqResKeys.userid: info.userId!,
      RequestParameterKey.companyIdf: info.companyId!,
      RequestParameterKey.branchIdf: info.branchId!
    };
    loading = true;

    //Subscription Plan detail Api call
    BaseResponseModel result = await SubscriptionRepository.getMyOccuSubTransHistory(param);

    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess && result.flag == true) {
      MySubscriptionPlanTransHistoryModel model =
          MySubscriptionPlanTransHistoryModel.fromJson(result.data);
      if (model.data != null) {
        setSubPlanTransHistoryList = model.data!;
        loading = false;
      } else {
        setSubPlanTransHistoryList = [];
        loading = false;
      }
    } else {
      loading = false;
      Toast.show(context, message: result.message.toString(), type: Toast.toastError);
    }
  }

  Future<bool> callUserProfileAPI(BuildContext context) async {
    if (false == await NetworkController.isConnected()) {
      Toast.show(context,
          message: StringHelper.internetConnection,
          type: Toast.toastError,
          gravity: Toast.toastTop,
          duration: 3);
      return false;
    }

    // String deviceID = await Utility.getDeviceId();
    // Check Device ID match with any User account
    Map<String, dynamic> param = {
      RequestParameterKey.session: "",
      RequestParameterKey.contact:
          userInfoData?.phone?.isNotEmpty ?? true ? userInfoData?.phone : '',
      RequestParameterKey.email: userInfoData?.email?.isNotEmpty ?? true ? userInfoData?.email : '',
      RequestParameterKey.fcmToken: FirebasePushNotification.shared.token,
      RequestParameterKey.deviceId: ''
    };
    BaseResponseModel response = await AuthenticationRepository.getUserProfileData(param);
    printLog(response.data);
    if (response.flag == true && response.statusCode == NetworkAPIConstant.statusCodeSuccess) {
      UserDataModel userModel = UserDataModel.fromJson(response.data);
      if (userModel.flag == true && userModel.data != null) {
        globalBloc?.userInfoStream.sink.add(userModel.data!);
        await SharedPreferenceController.setUserData(userModel.data!);
      }
      return true;
    } else {
      Utility.showToastErrorMessage(context, response.statusCode);
      return false;
    }
  }

  getPromoCodeListFromFirebase() async {
    final response = await FirebaseDatabaseController.getRealtimeData(
        key: FirebaseRealtimeDatabaseConstants.subscriptionPromoCode);
    if (response != null) {
      final promoCodeData = jsonEncode(response);
      List<PromoCodeListModel> promoCodeList = (jsonDecode(promoCodeData) as List)
          .map<PromoCodeListModel>((json) => PromoCodeListModel.fromJson(json))
          .toList();
      final currentList = promoCodeListStream.valueOrNull ?? [];

      final updatedList = List<PromoCodeListModel>.from(currentList)..addAll(promoCodeList);

      promoCodeListStream.sink.add(updatedList);
      showCheckout = promoCodeListStream.value.any((item) => item.planname == "Basic Plan");
      showPremiumCheckout =
          promoCodeListStream.value.any((item) => item.planname == "Premium Plan");
      return promoCodeList;
    }
  }

  getPromoCodeListDataApi(BuildContext context) async {
    UserInfoData info = await SharedPreferenceController.getUserData();
    var param = {
      //NetworkAPIConstant.reqResKeys.userid: info.userId!,
      RequestParameterKey.companyIdf: info.companyId!,
      RequestParameterKey.branchIdf: info.branchId!
    };

    //Subscription Plan detail Api call
    BaseResponseModel result = await SubscriptionRepository.getPromoCodeList(param);

    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess && result.flag == true) {
      PromoCodeListResponse model = PromoCodeListResponse.fromJson(result.data);
      if (model.data != null) {
        final currentList = promoCodeListStream.valueOrNull ?? [];

        final updatedList = List<PromoCodeListModel>.from(currentList)..addAll(model.data!);

        promoCodeListStream.sink.add(updatedList);
        // promoCodeListStream.sink.add(model.data!);
      }
    } else {
      Toast.show(context, message: result.message.toString(), type: Toast.toastError);
    }
  }

  bool isPromoCodeValid(PromoCodeListModel promoCode) {
    final DateTime currentDate = DateTime.now();
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateTime endDate = dateFormat.parse(promoCode.enddate ?? "");

    return currentDate.isBefore(endDate);
  }

  Future<void> updatePromoCodeValue(BuildContext context, String promoCode, int index) async {
    try {
      setLoadingMessage = ["Please wait..."];
      setLoading = true;

      // Check if the promo code exists
      bool exists = promoCodeListStream.value.any((item) => item.promocode == promoCode);

      // get the promo code data
      final PromoCodeListModel promoCodeData = promoCodeListStream.value.firstWhere(
        (item) =>
            item.promocode == promoCode &&
            item.planname == products[index].title.split("(").first.trim(),
        orElse: () => PromoCodeListModel(),
      );

      if (promoCode.trim().toLowerCase().contains(
          FirebaseRemoteConfigController.shared.subscriptionAussizzData?.subscriptionAussizzText ??
              "@aussizzgroup.com")) {
        //bypass to next process we don't nee dto stop if it contains this text in promo code
      } else {
        if (!exists) {
          setLoadingMessage = null;
          setLoading = false;
          Toast.show(context, message: "Please enter valid promo code.", type: Toast.toastError);
          return;
        } else if (!isPromoCodeValid(promoCodeData)) {
          setLoadingMessage = null;
          setLoading = false;
          Toast.show(context, message: "The promo code has expired.", type: Toast.toastError);
          return;
        }
      }

      UserInfoData info = await SharedPreferenceController.getUserData();
      var param = {
        NetworkAPIConstant.reqResKeys.userId: info.userId!,
        RequestParameterKey.companyIdf: info.companyId!,
        RequestParameterKey.branchIdf: info.branchId!,
        RequestParameterKey.promoCode: promoCode,
      };

      //Subscription Plan detail Api call
      BaseResponseModel result = await SubscriptionRepository.applyPromoCode(param);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess && result.flag == true) {
        PromoCodeResModel promoCodeResModel = PromoCodeResModel.fromJson(result.data);
        setLoadingMessage = null;
        setLoading = false;
        if (promoCodeResModel.data != null) {
          if (promoCodeResModel.data!.isPromoCodeUsed == 1) {
            Toast.show(context, message: "Promo code already used.", type: Toast.toastError);
          } else {
            isPromoApplied = true;
            Toast.show(context,
                message: "The promo code has been successfully applied.", type: Toast.toastSuccess);
          }
        } else {
          Toast.show(context, message: result.message.toString(), type: Toast.toastError);
        }
      } else {
        setLoadingMessage = null;
        setLoading = false;
        Toast.show(context, message: result.message.toString(), type: Toast.toastError);
      }
    } catch (e) {
      print('Failed to update promo code: $e');
    }
  }

  Future<bool> buyPromoSubscriptionPlan(BuildContext context, int index) async {
    // Parse the input date string
    setLoadingMessage = ["Please wait..."];
    setLoading = true;

    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    userInfoData = await SharedPreferenceController.getUserData();
    if (!context.mounted) return false;
    ProductDetails productDetails = productListStream.value[index];
    int noOfDays = 0;
    PromoCodeListModel? model;
    if (promoCodeTextController.text.trim().toLowerCase().contains(
        FirebaseRemoteConfigController.shared.subscriptionAussizzData?.subscriptionAussizzText ??
            "@aussizzgroup.com")) {
      //1825 days- for 5 years
      noOfDays = int.parse(
          FirebaseRemoteConfigController.shared.subscriptionAussizzData?.noOfDays ?? "1825");
    } else {
      model = promoCodeListStream.value.firstWhere((promo) =>
          promo.promocode == promoCodeTextController.text.trim() &&
          promo.planname == products[index].title.split("(").first.trim());
      var days = model.noofdays?.replaceAll(RegExp(r'[^0-9]'), '');
      noOfDays = int.parse(days ?? "0");
    }
    // Calculate the end date
    DateTime endDate = now.add(Duration(days: noOfDays));

    // Format the end date to the desired format
    String endDateString = DateFormat('dd-MM-yyyy').format(endDate);

    bool response = await buySubscription(
        context,
        userInfoData?.userId ?? 0,
        BuySubscriptionModel(
          subscriptionId: model?.planid.toString() ?? "1",
          currency: productDetails.currencyCode,
          price: "0.0",
          orderId: "",
          productID: productDetails.id,
          purchaseToken: "",
          isAutoRenewing: false,
          quantity: "1",
          source: Platform.isIOS ? "ios" : "android",
          transactionDate: now.millisecondsSinceEpoch.toString(),
          status: "PurchaseStatus.purchased",
          startDate: formatter.format(now),
          endDate: endDateString,
          promoCode: promoCodeTextController.text.trim(),
        ),
        isRedirect: true,
        hideCheckout: true);

    // Update the number of uses for the promo code and if not come from aussizzGroup id
    if (promoCodeTextController.text.trim().toLowerCase().contains(
        FirebaseRemoteConfigController.shared.subscriptionAussizzData?.subscriptionAussizzText ??
            "@aussizzgroup.com")) {
      setLoadingMessage = null;
      setLoading = false;

      return response;
    } else {
      int position = promoCodeListStream.value.indexWhere((item) =>
          item.promocode == promoCodeTextController.text.trim() &&
          item.planname == products[index].title.split("(").first.trim());
      final DatabaseReference ref = FirebaseDatabase.instance
          .ref()
          .child(FirebaseRealtimeDatabaseConstants.subscriptionPromoCode)
          .child(position.toString())
          .child("noofuses");
      if (Platform.isIOS) {
        await ref.update({'iPhone': promoCodeListStream.value[position].noofuses!.iPhone! + 1});
      } else {
        await ref.update({'android': promoCodeListStream.value[position].noofuses!.android! + 1});
      }

      setLoadingMessage = null;
      setLoading = false;

      return response;
    }
    int position = promoCodeListStream.value.indexWhere((item) =>
        item.promocode == promoCodeTextController.text.trim() &&
        item.planname == products[index].title.split("(").first.trim());
    final DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child(FirebaseRealtimeDatabaseConstants.subscriptionPromoCode)
        .child(position.toString())
        .child("noofuses");
    if (Platform.isIOS) {
      await ref.update({'iPhone': promoCodeListStream.value[position].noofuses!.iPhone! + 1});
    } else {
      await ref.update({'android': promoCodeListStream.value[position].noofuses!.android! + 1});
    }

    setLoadingMessage = null;
    setLoading = false;

    return false;
  }
}
