import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_config.dart';

import '../../configs/constans.dart';
import '../../entities/sku.dart';
import '../../utils/clo_util.dart';
import '../../utils/log/log_event.dart';
import '../../utils/purchase_helper.dart';

class VipController extends GetxController {
  //TODO: Implement VipController

  late Sku selectedSku = Sku();
  late final VipFrom? from = Get.arguments;
  final count = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    if (PurchaseHelper.inst.vipSkus.isEmpty) {
      PurchaseHelper.inst.getProducts().then((v) {
        initSelected();
      });
    } else {
      initSelected();
    }
  }


  void initSelected() {
    selectedSku =
        PurchaseHelper.inst.vipSkus.firstWhereOrNull(
          (element) => element.defaultSku == true,
        ) ??
        PurchaseHelper.inst.vipSkus.first;
    update();
  }

  @override
  void onReady() {
    logEvent(CloUtil.isCloB ? 't_vipb' : 't_vipa');
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void buy(Sku sku) {
    logEvent(CloUtil.isCloB ? 'c_vipb_subs' : 'c_vipa_subs');
    PurchaseHelper.inst.buy(sku, vipFrom: from);
  }
}
