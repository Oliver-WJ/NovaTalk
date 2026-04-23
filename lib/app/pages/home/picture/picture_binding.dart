import 'package:get/get.dart';

import 'picture_controller.dart';

class PictureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PictureController>(
      () => PictureController(),
    );
  }
}
