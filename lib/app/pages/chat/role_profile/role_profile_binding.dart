import 'package:get/get.dart';

import 'role_profile_controller.dart';

class RoleProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoleProfileController>(
      () => RoleProfileController(),
    );
  }
}
