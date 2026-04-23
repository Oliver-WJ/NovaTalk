import 'package:get/get.dart';

import '../pages/call/phone_ctr.dart';
import '../pages/call/phone_guide_page.dart';
import '../pages/call/phone_page.dart';
import '../pages/chat/chat_binding.dart';
import '../pages/chat/chat_room/chat_room_binding.dart';
import '../pages/chat/chat_room/chat_room_view.dart';
import '../pages/chat/chat_view.dart';
import '../pages/chat/role_profile/role_profile_binding.dart';
import '../pages/chat/role_profile/role_profile_view.dart';
import '../pages/gem/gem_binding.dart';
import '../pages/gem/gem_view.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/home/picture/creations/creations_binding.dart';
import '../pages/home/picture/creations/creations_view.dart';
import '../pages/home/picture/picture_binding.dart';
import '../pages/home/picture/picture_view.dart';
import '../pages/home/search/search_binding.dart';
import '../pages/home/search/search_view.dart';
import '../pages/lang/choose_lang_page.dart';
import '../pages/me/me_binding.dart';
import '../pages/me/me_view.dart';
import '../pages/setting/setting_binding.dart';
import '../pages/setting/setting_view.dart';
import '../pages/splash/splash_binding.dart';
import '../pages/splash/splash_view.dart';
import '../pages/undr/ctls/purchase_controller.dart';
import '../pages/undr/ctls/undress_page_controller.dart';
import '../pages/undr/purchase_page.dart';
import '../pages/undr/undr_page.dart';
import '../pages/vip/vip_binding.dart';
import '../pages/vip/vip_view.dart';
import '../widgets/image_preview_page.dart';
import '../widgets/video_preview_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () => const ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.ROLE_PROFILE,
      page: () => const RoleProfilePage(),
      binding: RoleProfileBinding(),
    ),
    GetPage(name: _Paths.ME, page: () => const MeView(), binding: MeBinding()),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.VIP,
      page: () => const VipView(),
      binding: VipBinding(),
    ),
    GetPage(
      name: _Paths.GEM,
      page: () => const GemView(),
      binding: GemBinding(),
    ),
    GetPage(name: _Paths.IMAGEP_REVIEW, page: () => const ImagePreviewPage()),
    GetPage(name: _Paths.VIDEO_REVIEW, page: () => const VideoPreviewPage()),
    GetPage(
      name: _Paths.CALL,
      page: () => const PhonePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PhoneCtr());
      }),
    ),
    GetPage(name: _Paths.CHOOSE_LANG, page: () => const ChooseLangPage()),
    GetPage(
      name: _Paths.PURCHASE,
      page: () => const PurchasePage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<PurchaseController>(() => PurchaseController()),
      ),
    ),
    GetPage(
      name: _Paths.UND,
      page: () => UndressPage(),
      binding: BindingsBuilder(
        () => Get.lazyPut<UndressPageController>(() => UndressPageController()),
      ),
    ),
    GetPage(name: _Paths.PHONE_GUIDE, page: () => const PhoneGuidePage()),
    GetPage(
      name: _Paths.PICTURE,
      page: () => const PictureView(),
      binding: PictureBinding(),
    ),
    GetPage(
      name: _Paths.CREATIONS,
      page: () => const CreationsView(),
      binding: CreationsBinding(),
    ),
  ];
}
