import 'dart:ui';

import 'package:novatalk/app/configs/app_config.dart';
import 'package:novatalk/app/utils/storage_util.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:novatalk/generated/assets.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/utils/api_svc.dart';

import '../configs/constans.dart';
import '../entities/caht_level_config.dart';
import '../entities/lang.dart';
import '../entities/price_config_bean.dart';
import '../entities/user_entity.dart';
import 'common_utils.dart';

class AppUser {
  AppUser._();

  static const String kUserTab = "kAppUser";
  static final AppUser inst = AppUser._();

  UserEntity? user;
  final nickname = "".obs;
  final balance = 0.obs;
  final isVip = false.obs;
  final autoTranslate = false.obs;
  final createImg = 0.obs;
  final createVideo = 0.obs;
  final targetLanguage = Lang().obs;

  List<ChatLevelConfig> chatLevelConfigs = [];

  PriceConfigBean? prices;

  String get maskPrice => (prices?.profileChange).isVoid ? "" : "5";

  String get sendMsgPrice => (prices?.textMessage).isVoid ? "" : "2";

  String get sendAudioMsgPrice => (prices?.audioMessage).isVoid ? "" : "4";

  String get callPrice => (prices?.callAiCharacters).isVoid ? "" : "10";

  bool isBalanceEnough(ConsumeFrom from) {
    return balance.value >= from.gems;
  }

  void setUser(UserEntity user, {bool isCache = true}) {
    this.user = user;
    if (isCache) {
      appStore.write(kUserTab, user.toJson());
    }
    nickname.value = user.nickname ?? "";
    balance.value = user.gems ?? 0;
    isVip.value =
        (user.subscriptionEnd ?? 0) > DateTime.now().millisecondsSinceEpoch;
    autoTranslate.value = user.autoTranslate ?? false;
    createImg.value = user.createImg ?? 0;
    createVideo.value = user.createVideo ?? 0;

    matchUserLang().then((v) {
      targetLanguage.value = v;
    });
  }

  Future<UserEntity> getUser() async {
    if (this.user != null) {
      return this.user!;
    }
    var user = await appStore.read(kUserTab);
    if (user != null) {
      user = UserEntity.fromJson(user);
      setUser(user, isCache: false);
    } else {
      user = await ApiSvc.register();
      setUser(user);

      ///注册没有targetLanguage
      await matchUserLang().then((v) {
        targetLanguage.value = v;
        ApiSvc.updateEventParams(lang: targetLanguage.value.value);
      });
    }
    return user;
  }

  Future<void> refreshUser() async {
    var user = await ApiSvc.getUserInfo();
    if (user != null) {
      setUser(user);
    }
    matchUserLang().then((v) => targetLanguage.value = v);
    ApiSvc.getPriceConfig().then((v) => prices = v);
  }

  Future updateUser(String nickname) async {
    try {
      final body = {'id': user?.id, 'nickname': nickname};
      final success = await ApiSvc.updateUserInfo(body);
      if (success) {
        user!.nickname = nickname;
        setUser(user!);
      }
    } catch (e) {
      goPrint('updateUser error: $e');
    }
  }

  Future<List<ChatLevelConfig>> fetchChatLevelConfigs() async {
    if (chatLevelConfigs.isNotEmpty) {
      return chatLevelConfigs;
    }
    final datas = await ApiSvc.getChatLevelConfig();
    if (datas != null) {
      chatLevelConfigs = datas;
    }
    return chatLevelConfigs;
  }

  Future<void> consume(ConsumeFrom from) async {
    try {
      final result = await ApiSvc.consumeReq(from.gems, from.name);
      balance.value = result;
    } catch (e) {
      goPrint('$e');
    }
  }

  /// 获取所有可用语言列表
  Future<List<Lang>> _getAllAvailableLangs() async {
    Map<String, dynamic> appLangs = {};
    try {
      appLangs = await AppConfig.supportLang.future.timeout(10.seconds);
    } catch (_) {}
    List<Lang> allLangs = [];

    // 遍历每个字母分组
    appLangs.forEach((key, value) {
      if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            try {
              final lang = Lang.fromJson(item);
              if (lang.label != null && lang.value != null) {
                allLangs.add(lang);
              }
            } catch (_) {}
          }
        }
      }
    });

    return allLangs;
  }

  /// 从appLangs匹配用户语言
  Future<Lang> matchUserLang() async {
    // 获取所有可用语言列表
    final allLangs = await _getAllAvailableLangs();
    if (allLangs.isEmpty) {
      return Lang(label: 'English', value: 'en');
    }
    final userLang = user?.targetLanguage;
    if (userLang == null || userLang.isEmpty) {
      return _matchDeviceLanguage(allLangs);
    } else {
      return _matchUserLanguage(userLang, allLangs);
    }
  }

  /// 匹配设备语言
  Lang _matchDeviceLanguage(List<Lang> allLangs) {
    final locale = Get.deviceLocale ?? const Locale('en', 'US');

    // 1. 优先匹配完整的语言标签 (例如: zh-CN, en-US)
    final fullTag = locale.toLanguageTag();
    for (var lang in allLangs) {
      if (lang.value == fullTag) {
        return lang;
      }
    }

    // 2. 匹配 locale.toString() 格式 (例如: zh_CN)
    final localeString = locale.toString();
    for (var lang in allLangs) {
      if (lang.value == localeString) {
        return lang;
      }
    }

    // 3. 匹配语言代码 (例如: zh, en)
    final languageCode = locale.languageCode;
    for (var lang in allLangs) {
      if (lang.value == languageCode) {
        return lang;
      }
    }

    // 4. 匹配语言代码前缀 (例如: zh-CN 匹配 zh)
    for (var lang in allLangs) {
      if (lang.value?.startsWith('$languageCode-') == true ||
          lang.value?.startsWith('${languageCode}_') == true) {
        return lang;
      }
    }

    // 5. 默认返回英语
    return _findDefaultLanguage(allLangs);
  }

  /// 查找默认语言 (优先英语)
  Lang _findDefaultLanguage(List<Lang> allLangs) {
    // 优先查找英语
    for (var lang in allLangs) {
      if (lang.value == 'en' || lang.value == 'en-US') {
        return lang;
      }
    }

    // 最后的兜底
    return Lang(label: 'English', value: 'en');
  }

  /// 匹配用户设置的语言
  Lang _matchUserLanguage(String userLang, List<Lang> allLangs) {
    // 1. 精确匹配
    for (var lang in allLangs) {
      if (lang.value == userLang) {
        return lang;
      }
    }

    // 2. 如果用户语言包含分隔符，尝试匹配语言代码部分
    if (userLang.contains('-') || userLang.contains('_')) {
      final languageCode = userLang.split(RegExp(r'[-_]')).first;
      for (var lang in allLangs) {
        if (lang.value == languageCode) {
          return lang;
        }
      }

      // 3. 尝试匹配相同语言代码的其他变体
      for (var lang in allLangs) {
        if (lang.value?.startsWith('$languageCode-') == true ||
            lang.value?.startsWith('${languageCode}_') == true) {
          return lang;
        }
      }
    } else {
      // 3. 如果用户语言是纯语言代码，尝试匹配带国家代码的变体
      for (var lang in allLangs) {
        if (lang.value?.startsWith('$userLang-') == true ||
            lang.value?.startsWith('${userLang}_') == true) {
          return lang;
        }
      }
    }

    // 4. 都没有匹配到，返回默认语言
    return _findDefaultLanguage(allLangs);
  }
}
