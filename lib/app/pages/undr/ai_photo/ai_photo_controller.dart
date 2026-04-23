import 'package:novatalk/app/utils/app_user.dart';
import 'package:get/get.dart';
import '../ctls/undress_page_controller.dart';
import '../ctls/undrvideo_page_controller.dart';

class AiPhotoController extends GetxController {
  final createImg = true.obs;
  late UndressPageController undressPageController;
  static const String tag = "homeReuse";

  @override
  void onInit() {
    super.onInit();
    undressPageController = Get.put(
        UndressPageController()..args = UndressPageArgs(homeReuse: true), tag: tag);
    Get.put(UndrVideoPageController());
  }

  @override
  void onReady() {
    super.onReady();
    AppUser.inst.refreshUser();
  }
}
