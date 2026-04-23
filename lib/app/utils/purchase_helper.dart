import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:novatalk/app/configs/app_config.dart';
import 'package:novatalk/app/utils/app_user.dart';

import '../../generated/locales.g.dart';
import '../configs/constans.dart';
import '../entities/order_and.dart';
import '../entities/order_ios.dart';
import '../entities/sku.dart';
import '../widgets/common_widget.dart';
import 'api_svc.dart';
import 'common_utils.dart';
import 'log/log_event.dart';

class PurchaseHelper {
  PurchaseHelper._() {
    _inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) => _processPurchaseDetails(purchaseDetailsList),
      onError: (error) => goPrint('Purchase error: $error'),
    );
  }

  static final PurchaseHelper inst = PurchaseHelper._();

  Function? _onCompletePurchase;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final skus = <Sku>[].obs;
  List<Sku> vipSkus = [];
  List<Sku> coinsSkus = [];

  VipFrom? _vipFrom;
  ConsumeFrom? _consFrom;
  OrderAnd? _andOrder;
  OrderIos? _iosOrder;
  Sku? _currentSku;
  bool _isUserBuy = false;

  final RxInt _eventCounter = 0.obs;

  Future<void> getProducts() async {
    final skus_ = await ApiSvc.getSkuList();
    if (skus_?.isNotEmpty == true) {
      skus.clear();
      skus.value.addAll(skus_!);
      coinsSkus =
          skus.where((element) => element.skuType == 0).map((e) => e).toList()
            ..sort((a, b) => (a.orderNum ?? 0).compareTo(b.orderNum ?? 0));

      vipSkus =
          skus.where((element) => element.skuType != 0).map((e) => e).toList()
            ..sort((a, b) => (a.orderNum ?? 0).compareTo(b.orderNum ?? 0));

      debugData();
      skus.refresh();
    }
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      SmartDialog.showToast(LocaleKeys.inAppPurchaseUnAvailable.tr);
      return;
    }
    final response = await _inAppPurchase.queryProductDetails(
      skus.map((v) => v.sku ?? "").toSet(),
    );
    for (final productDetails in response.productDetails) {
      final sku = skus.firstWhereOrNull((e) => e.sku == productDetails.id);
      if (sku != null) {
        sku.productDetails = productDetails;
      }
    }
    skus.refresh();
  }

  void debugData() {
    if (isAppDebug && kDebugMode) {
      coinsSkus.clear();
      vipSkus.clear();
      coinsSkus.addAll(
        List.generate(
          4,
          (i) => Sku(
            sku: "$i",
            number: 6300,
            tag: i,
            createImg: 3,
            createVideo: 3,
            skuType: 0,
            productDetails: ProductDetails(
              id: "1",
              title: "",
              description: "",
              price: "19\$",
              currencyCode: "USD",
              currencySymbol: "\$",
              rawPrice: 0.99,
            ),
          ),
        ),
      );
      vipSkus.addAll(
        List.generate(
          4,
          (i) => Sku(
            sku: "$i",
            tag: i,
            skuType: i + 1,
            number: 9999,
            defaultSku: i == 2,
            productDetails: ProductDetails(
              id: "1",
              title: "",
              description: "",
              price: "19\$",
              currencyCode: "USD",
              currencySymbol: "\$",
              rawPrice: 19,
            ),
          ),
        ),
      );
    }
  }

  // 购买产品
  Future<void> buy(
    Sku sku, {
    VipFrom? vipFrom,
    ConsumeFrom? consFrom,
    Function? onCompletePurchase,
  }) async {
    try {
      SmartDialog.showLoading();
      if (!await _isAvailable()) {
        return SmartDialog.dismiss(status: SmartStatus.loading);
      }
      await _finishTransaction();
      _vipFrom = vipFrom;
      _consFrom = consFrom;
      _currentSku = sku;
      _isUserBuy = true;
      _onCompletePurchase = onCompletePurchase;

      final productDetails = sku.productDetails;
      if (productDetails == null) {
        SmartDialog.dismiss();
        SmartDialog.showToast(LocaleKeys.unInfo.tr);
        return;
      }

      await _createOrder(productDetails);
      String? orderNo;
      if (Platform.isIOS) {
        orderNo = _iosOrder?.orderNo;
      } else {
        orderNo = _andOrder?.orderNo;
      }
      if (orderNo.isVoid) {
        SmartDialog.dismiss();
        SmartDialog.showToast(LocaleKeys.createOrderFailed.tr);
        return;
      }

      final purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: orderNo,
      );

      final isConsumable = sku.skuType == 0;

      await (isConsumable
          ? _inAppPurchase.buyConsumable(purchaseParam: purchaseParam)
          : _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam));
    } catch (e) {
      await SmartDialog.dismiss();
      SmartDialog.showNotify(msg: e.toString(), notifyType: NotifyType.error);
    }
  }

  // 恢复购买
  Future<void> restore({bool isNeedShowLoading = true}) async {
    if (!await _isAvailable()) return;

    _isUserBuy = true;
    await _inAppPurchase.restorePurchases();
  }

  // 处理购买详情
  Future<void> _processPurchaseDetails(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    if (purchaseDetailsList.isEmpty) return;

    // 按交易日期降序排序
    purchaseDetailsList.sort(
      (a, b) => (int.tryParse(b.transactionDate ?? '0') ?? 0).compareTo(
        int.tryParse(a.transactionDate ?? '0') ?? 0,
      ),
    );

    final first = purchaseDetailsList.first;

    for (var purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.purchased:
          if (first.purchaseID == purchaseDetails.purchaseID ||
              _currentSku?.sku == purchaseDetails.purchaseID) {
            await _handleSuccessfulPurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.restored:
          await _handleSuccessfulPurchase(purchaseDetails);
          break;

        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          _handlePurchaseError(purchaseDetails);
          break;

        case PurchaseStatus.pending:
          SmartDialog.showLoading();
          break;
      }

      // 处理挂起的交易
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    if (!_isUserBuy) {
      return;
    }

    // if (await _isPurchaseProcessed(purchaseDetails.purchaseID)) return;

    if (await _verifyAndCompletePurchase(purchaseDetails)) {
      // await _markPurchaseAsProcessed(purchaseDetails.purchaseID);
    } else {
      SmartDialog.showNotify(
        msg: LocaleKeys.orderVFailed.tr,
        notifyType: NotifyType.error,
      );
    }
    _isUserBuy = false;
    _currentSku = null;
    await _inAppPurchase.completePurchase(purchaseDetails);
    _onCompletePurchase?.call();
  }

  void _handlePurchaseError(PurchaseDetails purchaseDetails) {
    final error = purchaseDetails.error;
    _handleError(
      IAPError(
        source: error?.source ?? '',
        code: error?.code ?? '',
        message: purchaseDetails.status.name,
      ),
    );
  }

  Future<bool> _verifyAndCompletePurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    bool isValid = await verifyPurchaseWithServer(purchaseDetails);
    SmartDialog.dismiss();
    if (isValid) {
      _reportPurchase(purchaseDetails);
      AppUser.inst.refreshUser();
    }
    return isValid;
  }

  Future<bool> verifyPurchaseWithServer(PurchaseDetails purchaseDetails) async {
    if (Platform.isIOS) return await _verifyApple(purchaseDetails);
    if (Platform.isAndroid) return await _verifyGoogle(purchaseDetails);
    return false;
  }

  ({bool? createImg, bool? createVideo}) createAction() {
    var createImg =
        (_consFrom == ConsumeFrom.aiphoto || _consFrom == ConsumeFrom.undr)
        ? true
        : null;
    var createVideo = _consFrom == ConsumeFrom.img2v ? true : null;
    return (createImg: createImg, createVideo: createVideo);
  }

  Future<bool> _verifyApple(PurchaseDetails purchaseDetails) async {
    try {
      final purchaseID = purchaseDetails.purchaseID;
      final transactionDate = purchaseDetails.transactionDate;
      final productID = purchaseDetails.productID;

      final pvs = purchaseDetails.verificationData.serverVerificationData;
      final pvl = purchaseDetails.verificationData.localVerificationData;

      // 刷新并获取 v1 票据 ：
      final iosPlatformAddition = InAppPurchase.instance
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      PurchaseVerificationData? verificationData = await iosPlatformAddition
          .refreshPurchaseVerificationData();

      String? vdl =
          verificationData?.localVerificationData; // 这就是 v1 的 Base64 字符串
      String? vds = verificationData?.serverVerificationData;

      final receipt = vdl;
      final action = createAction();

      var result = await ApiSvc.verifyIosOrder(
        receipt: receipt,
        skuId: productID,
        transactionId: purchaseID,
        purchaseDate: transactionDate,
        orderId: _iosOrder?.id ?? 0,
        createImg: action.createImg,
        createVideo: action.createVideo,
      );
      return result;
    } catch (e) {
      _handleError(IAPError(source: '', code: '400', message: e.toString()));
      return false;
    } finally {
      _iosOrder = null;
    }
  }

  bool isVipOrder(String productID) {
    return vipSkus.firstWhereOrNull((v) => v.sku == productID) != null;
  }

  Future<bool> _verifyGoogle(PurchaseDetails purchaseDetails) async {
    try {
      final action = createAction();

      final googleDetail = purchaseDetails as GooglePlayPurchaseDetails;

      final result = await ApiSvc.verifyAndOrder(
        originalJson: googleDetail.billingClientPurchase.originalJson,
        purchaseToken: googleDetail.billingClientPurchase.purchaseToken,
        skuId: purchaseDetails.productID,
        orderType: isVipOrder(purchaseDetails.productID)
            ? 'SUBSCRIPTION'
            : 'GEMS',
        orderId: _andOrder?.orderNo ?? '',
        createImg: action.createImg,
        createVideo: action.createVideo,
      );

      _andOrder = null;
      return result;
    } catch (e) {
      _handleError(IAPError(source: '', code: '400', message: e.toString()));
      return false;
    }
  }

  Future<void> _createOrder(ProductDetails productDetails) async {
    final orderType = isVipOrder(productDetails.id) ? 'SUBSCRIPTION' : 'GEMS';
    final action = createAction();

    if (Platform.isIOS) {
      try {
        final order = await ApiSvc.makeIosOrder(
          orderType: orderType,
          skuId: productDetails.id,
          createImg: action.createImg,
          createVideo: action.createVideo,
        );
        if (order == null || order.id == null) {
          throw Exception(LocaleKeys.orderError.tr);
        }
        _iosOrder = order;
      } catch (e) {
        SmartDialog.showToast('${LocaleKeys.orderVFailed.tr} $e');
        rethrow;
      }
    }
    if (Platform.isAndroid) {
      try {
        final order = await ApiSvc.makeAndOrder(
          orderType: orderType,
          skuId: productDetails.id,
          createImg: action.createImg,
          createVideo: action.createVideo,
        );
        if (order == null || order.orderNo == null) {
          throw Exception(LocaleKeys.orderError.tr);
        }

        _andOrder = order;
      } catch (e) {
        SmartDialog.showToast('${LocaleKeys.orderVFailed.tr} $e');
        rethrow;
      }
    }
  }

  Future _finishTransaction() async {
    // iOS 平台特定逻辑
    if (Platform.isIOS) {
      final iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());

      // 清理挂起的交易
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (var transaction in transactions) {
        await SKPaymentQueueWrapper().finishTransaction(transaction);
      }
    }
  }

  Future<bool> _isAvailable() async {
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      SmartDialog.showNotify(
        msg: LocaleKeys.pSupported.tr,
        notifyType: NotifyType.error,
      );
    }
    return isAvailable;
  }

  void _reportPurchase(PurchaseDetails purchaseDetails) {
    final id = purchaseDetails.productID;
    var path = '';
    var from = '';
    _eventCounter.value++;

    if (!isVipOrder(id)) {
      path = 'gems';
      from = _consFrom?.name ?? '';
      logEvent('suc_gems');
      final name = 'suc_${path}_${id}_$from';
      logEvent(name);
      if (_consFrom != ConsumeFrom.undr &&
          _consFrom != ConsumeFrom.creaimg &&
          _consFrom != ConsumeFrom.creavideo &&
          _consFrom != ConsumeFrom.aiphoto &&
          _consFrom != ConsumeFrom.img2v) {
        _showRechargeSuccess(id);
      }
    } else {
      path = 'sub';
      from = _vipFrom?.name ?? '';
      logEvent('suc_sub');
      final name = 'suc_${path}_${id}_$from';
      logEvent(name);
      _handleVipSuccess();
    }
  }

  void _handleVipSuccess() {
    if (_vipFrom == VipFrom.dailyrd) {
      _dailyrdSubSuccess();
    } else {
      SmartDialog.showNotify(
        msg: LocaleKeys.subscribed.tr,
        notifyType: NotifyType.success,
      );
      Get.back();
    }
  }

  void _dailyrdSubSuccess() async {
    SmartDialog.showLoading();
    await ApiSvc.getDailyReward();
    await AppUser.inst.refreshUser();
    SmartDialog.dismiss(status: SmartStatus.loading);

    await SmartDialog.showNotify(
      msg: LocaleKeys.subscribed.tr,
      notifyType: NotifyType.success,
    );
    SmartDialog.dismiss(status: SmartStatus.loading);
    Get.back();
  }

  void _showRechargeSuccess(String productID) {
    logEvent('t_suc_gems');

    final number = _currentSku?.number ?? numberPart(productID);
    //
    // AppDialog.tips(
    //   messageWidget: SizedBox(
    //     width: double.infinity,
    //     child: Column(
    //       children: [
    //         Assets.images.imgGemsSucc.image(width: 150, height: 130, fit: BoxFit.cover),
    //         const SizedBox(height: 12),
    //         Text(
    //           'kg +$number',
    //           style: GoogleFonts.montserrat(
    //             color: ColorUtil.primary,
    //             fontSize: 24,
    //             fontWeight: FontWeight.w800,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  void _handleError(IAPError error) {
    SmartDialog.dismiss();
    SmartDialog.showNotify(msg: error.message, notifyType: NotifyType.error);
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
