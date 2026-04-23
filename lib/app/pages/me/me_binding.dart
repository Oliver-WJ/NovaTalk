import 'package:get/get.dart';

import 'me_controller.dart';

class MeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeController>(
      () => MeController(),
    );
  }
}
