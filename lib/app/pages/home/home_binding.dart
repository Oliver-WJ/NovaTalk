import 'package:novatalk/app/pages/home/picture/picture_controller.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/pages/chat/chat_controller.dart';
import 'package:novatalk/app/pages/me/me_controller.dart';

import '../setting/setting_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RolesController>(() => RolesController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<MeController>(() => MeController());
    Get.lazyPut<SettingController>(() => SettingController());
    Get.lazyPut<PictureController>(() => PictureController());
  }
}
