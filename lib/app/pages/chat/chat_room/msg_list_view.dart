import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/entities/role_entity.dart';
import 'package:novatalk/app/pages/chat/chat_room/chat_room_controller.dart';
import 'package:novatalk/app/widgets/blur_background.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../generated/locales.g.dart';
import '../../../configs/constans.dart';
import '../../../entities/msg_res.dart';
import 'msg/msg_audio_item.dart';
import 'msg/msg_image_item.dart';
import 'msg/msg_intro_item.dart';
import 'msg/msg_send_item.dart';
import 'msg/msg_text_item.dart';
import 'msg/msg_tips_item.dart';
import 'msg/msg_video_item.dart';

class MsgListView extends StatefulWidget {
  const MsgListView({super.key, required this.role, required this.ctr});

  final RoleRecords role;
  final ChatRoomController ctr;

  @override
  State<MsgListView> createState() => _MsgListViewState();
}

class _MsgListViewState extends State<MsgListView> {
  late AutoScrollController autoController;

  @override
  void initState() {
    super.initState();
    autoController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bottom = 30.0;
    final listHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - 20;
    final top = listHeight * 0.5;

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        GestureDetector(
          onPanDown: (_) {
            try {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (currentFocus.focusedChild != null && !currentFocus.hasPrimaryFocus) {
                FocusManager.instance.primaryFocus?.unfocus();
              } else {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              }
            } catch (e) {}
          },
          child: Obx(() {
            var list = widget.ctr.pageData.value;
            list = list.reversed.toList();
            return ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) {
                return const LinearGradient(
                  colors: [Colors.transparent, Colors.transparent, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.2, 0.3],
                ).createShader(rect);
              },
              child: ListView.separated(
                controller: autoController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ).copyWith(top: top, bottom: bottom),
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index) {
                  var item = list[index];
                  return AutoScrollTag(
                    controller: autoController,
                    index: index,
                    key: ValueKey(index),
                    highlightColor: Colors.black.withOpacity(0.1),
                    child: _buildItem(item),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.w);
                },
                itemCount: list.length,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildItem(Msg msg) {
    final source = msg.source;

    // 定义不同 MsgSource 的组件映射
    final widgetBuilders = <MsgSource, Widget Function()>{
      MsgSource.tips: () => MsgTipsItem(text: msg.answer),
      MsgSource.scenario: () =>
          MsgIntroItem(title: "${LocaleKeys.scenario.tr}:", text: msg.answer ?? ''),
      MsgSource.welcome: () => MsgTextItem(msg: msg, ctr: widget.ctr),
      MsgSource.intro: () =>
          MsgIntroItem(title: "${LocaleKeys.profileOverview.tr}:", text: msg.answer ?? ''),
      MsgSource.sendText: () => MsgSendItem(msg: msg, ctr: widget.ctr),
      MsgSource.text: () => MsgTextItem(msg: msg, ctr: widget.ctr),
      MsgSource.photo: () => MsgImageItem(msg: msg, ctr: widget.ctr),
      MsgSource.video: () => MsgVideoItem(msg: msg, ctr: widget.ctr),
      MsgSource.audio: () => MsgAudioItem(msg: msg, ctr: widget.ctr),
      MsgSource.clothe: () => MsgImageItem(msg: msg, ctr: widget.ctr),
      MsgSource.maskTips: () => MsgTextItem(msg: msg, ctr: widget.ctr),
    };

    return widgetBuilders[source]?.call() ?? Container();
  }
}
