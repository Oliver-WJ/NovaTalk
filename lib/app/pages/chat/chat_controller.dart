import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/entities/conversation_entity.dart';
import 'package:novatalk/app/pages/chat/chat_room/chat_room_controller.dart';
import 'package:novatalk/app/utils/api_svc.dart';

import '../../utils/common_utils.dart';

class ChatController extends GetxController {
  late final SessionListController sessionListController =
      SessionListController(isLiked: false);
  late final SessionListController likedSessionListController =
      SessionListController(isLiked: true);
  int tabIndex = 0;

  void refreshLikedSessionList() {
    likedSessionListController.onRefresh();
  }

  void refreshSessionListController() {
    sessionListController.onRefresh();
  }

  void refreshData() {
    refreshSessionListController();
    refreshLikedSessionList();
  }

  @override
  void onInit() {
    refreshData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void setTabIndex(int index) {
    tabIndex = index;
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class SessionListController with MxPageData<ConversationRecords> {
  @override
  Future<List<ConversationRecords>> loadData() async {
    pageSize = 9999;
    if (isLiked) {
      var data = await ApiSvc.collectList(page, pageSize);
      return data?.records
              ?.map(
                (v) => ConversationRecords()
                  ..id = v.id
                  ..avatar = v.avatar
                  ..updateTime = v.updateTime.toInt
                  ..title = v.name,
              )
              .toList() ??
          [];
    }
    var data = await ApiSvc.sessionList(page, pageSize);
    return data?.records ?? [];
  }

  void onItemTap(ConversationRecords item) {
    pushChatRoom(isLiked ? item.id : item.characterId);
  }

  final bool isLiked;

  SessionListController({required this.isLiked});
}
