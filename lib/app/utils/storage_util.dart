import 'package:get_storage/get_storage.dart';

final appStore = GetStorage(StorageUtils.storeTag);

class StorageUtils {
  static const String storeTag = "anytalk_storage_vault";
  static const String kChatBgImagePath = "chat_background_image";
  static const String kFirstClickChatInputBox = "initial_input_box_click";
  static const String kSendMsgCount = "total_messages_sent";
  static const String kSessionIds = "active_session_identifiers";
  static const String kRateMsgCount = "message_rating_count";
  static const String kHasShownTranslationDialog = "translation_popup_displayed";
  static const String kOnlyOneMaskTips = "mask_guide_completed";
  static const String kShowTranslationMsgList = "translated_message_ids";
  static const String kFirstLaunch = "app_first_time_run";
  static const String kLastRewardDate = "previous_reward_timestamp";
  static const String kIsRestartApp = "restart_state_indicator";
  static const String kInstallTime = "app_installation_time";
  static const String kShowedHelpUsS1 = "help_request_step1";
  static const String kShowedHelpUsS2 = "help_request_step2";
  static const String kShowedHelpUsS3 = "help_request_step3";
  static const String kRoleSendCount = "role_specific_message_total";
  static const String kLikedRole = "favorited_character_id";
  static const String kRandomAvatar = "randomized_user_avatar";
  static const String keyCloUtil = 'app_utility_config';

  StorageUtils._();

  static set showedHelpUsS1(bool isShowed) {
    appStore.write(kShowedHelpUsS1, isShowed);
  }

  static bool get showedHelpUsS1 {
    return appStore.read(kShowedHelpUsS1) ?? false;
  }

  static set showedHelpUsS2(bool isShowed) {
    appStore.write(kShowedHelpUsS2, isShowed);
  }

  static bool get showedHelpUsS2 {
    return appStore.read(kShowedHelpUsS2) ?? false;
  }

  static set showedHelpUsS3(bool isShowed) {
    appStore.write(kShowedHelpUsS3, isShowed);
  }

  static bool get showedHelpUsS3 {
    return appStore.read(kShowedHelpUsS3) ?? false;
  }

  static void likedRole(String roleId) {
    appStore.write("$kLikedRole$roleId", true);
  }

  static bool isLikedRole(String roleId) {
    return appStore.read("$kLikedRole$roleId") ?? false;
  }

  static void roleSendCount(int count, String roleId) {
    appStore.write("$kRoleSendCount$roleId", count);
  }

  static int getRoleSendCount(String roleId) {
    return appStore.read("$kRoleSendCount$roleId") ?? 0;
  }

  static set installTime(int date) {
    appStore.write(kInstallTime, date);
  }

  static int get installTime {
    return appStore.read(kInstallTime) ?? 0;
  }

  static set isRestartApp(bool isRestart) {
    appStore.write(kIsRestartApp, isRestart);
  }

  static bool get isRestartApp {
    return appStore.read(kIsRestartApp) ?? false;
  }

  static set lastRewardDate(int date) {
    appStore.write(kLastRewardDate, date);
  }

  static int get lastRewardDate {
    return appStore.read(kLastRewardDate) ?? 0;
  }

  static set firstLaunch(bool isFirst) => appStore.write(kFirstLaunch, isFirst);

  static bool get firstLaunch {
    return appStore.read(kFirstLaunch) ?? true;
  }

  static set chatBgImagePath(String path) {
    appStore.write(kChatBgImagePath, path);
  }

  static String get chatBgImagePath {
    return appStore.read(kChatBgImagePath) ?? "";
  }

  static set firstClickChatInputBox(bool isFirst) {
    appStore.write(kFirstClickChatInputBox, isFirst);
  }

  static bool get firstClickChatInputBox {
    return appStore.read(kFirstClickChatInputBox) ?? true;
  }

  static set sendMsgCount(int count) {
    appStore.write(kSendMsgCount, count);
  }

  static int get sendMsgCount {
    return appStore.read(kSendMsgCount) ?? 0;
  }

  static set rateMsgCount(int count) {
    appStore.write(kRateMsgCount, count);
  }

  static int get rateMsgCount {
    return appStore.read(kRateMsgCount) ?? 0;
  }

  static set hasShownTranslationDialog(bool hasShown) {
    appStore.write(kHasShownTranslationDialog, hasShown);
  }

  static bool get hasShownTranslationDialog {
    return appStore.read(kHasShownTranslationDialog) ?? false;
  }

  static set onlyOneMaskTips(bool hasShown) {
    appStore.write(kOnlyOneMaskTips, hasShown);
  }

  static bool get onlyOneMaskTips {
    return appStore.read(kOnlyOneMaskTips) ?? false;
  }

  static Set<String> get showTranslationMsgIds {
    return appStore.read<Set<String>>(kShowTranslationMsgList) ?? {};
  }

  static set showTranslationMsgIds(Set<String> ids) {
    appStore.write(kShowTranslationMsgList, ids);
  }

  static List<int> _getSessionIds() {
    List<dynamic> sessionIds = appStore.read<List<dynamic>>(kSessionIds) ?? [];
    return sessionIds.map((e) => e as int).toList();
  }

  static void addSessionId(int sessionId) {
    List<int> sessionIds = _getSessionIds();

    // 只添加不重复的会话 ID
    if (!sessionIds.contains(sessionId)) {
      sessionIds.add(sessionId);
      appStore.write(kSessionIds, sessionIds); // 更新缓存
    }
  }

  static bool isSessionExist(int sessionId) {
    List<int> sessionIds = _getSessionIds();
    return sessionIds.contains(sessionId);
  }

  static void removeSessionId(int sessionId) {
    List<int> sessionIds = _getSessionIds();
    sessionIds.remove(sessionId);
    appStore.write(kSessionIds, sessionIds); // 更新缓存
  }
}
