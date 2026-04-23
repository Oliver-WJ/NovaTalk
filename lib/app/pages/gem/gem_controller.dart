import 'package:novatalk/generated/locales.g.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/entities/sku.dart';

import '../../configs/constans.dart';
import '../../utils/clo_util.dart';
import '../../utils/log/log_event.dart';
import '../../utils/purchase_helper.dart';

class GemController extends GetxController {
  Sku? selectedSku;
  late final ConsumeFrom? from = Get.arguments;
  final count = 0.obs;
  final discount = [
    LocaleKeys.discount.trParams({"n": "90"}).tr,
    LocaleKeys.discount.trParams({"n": "70"}).tr,
    LocaleKeys.discount.trParams({"n": "30"}).tr,
    LocaleKeys.discount.trParams({"n": "0"}).tr,
  ];

  @override
  void onInit() {
    super.onInit();
    if (PurchaseHelper.inst.coinsSkus.isEmpty) {
      PurchaseHelper.inst.getProducts().then((v) {
        initSelected();
      });
    } else {
      initSelected();
    }
  }

  void initSelected() {
    selectedSku =
        PurchaseHelper.inst.coinsSkus.firstWhereOrNull(
          (element) => element.defaultSku == true,
        ) ??
        PurchaseHelper.inst.coinsSkus.first;
    update();
  }

  @override
  void onReady() {
    logEvent('t_paygems');
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void buy({Function? onCompletePurchase}) {
    if (selectedSku == null) return;
    logEvent(CloUtil.isCloB ? 'c_vipb_subs' : 'c_vipa_subs');
    PurchaseHelper.inst.buy(
      selectedSku!,
      consFrom: from,
      onCompletePurchase: onCompletePurchase,
    );
  }
}
