import 'package:get/get.dart';

import 'gem_controller.dart';

class GemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GemController>(
      () => GemController(),
    );
  }
}
