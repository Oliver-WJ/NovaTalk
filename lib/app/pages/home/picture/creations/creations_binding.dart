import 'package:get/get.dart';

import 'creations_controller.dart';

class CreationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreationsController>(
      () => CreationsController(),
    );
  }
}
