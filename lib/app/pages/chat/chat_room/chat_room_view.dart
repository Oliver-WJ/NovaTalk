import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/utils/clo_util.dart';
import 'package:novatalk/app/utils/storage_util.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:novatalk/generated/locales.g.dart';

import '../../../../generated/assets.dart';
import '../../../configs/constans.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/log/log_event.dart';
import '../../../widgets/gradient_bound_painter.dart';
import 'chat_float_items.dart';
import 'chat_level.dart';
import 'msg_list_view.dart';
import 'role_images.dart';
import 'vip_role_lock.dart';
import 'chat_room_controller.dart';
import 'msg_app_bar.dart';
import 'msg_input.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final role = controller.role;

    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    var msgBottom = 4 + bottomPadding + 48 + 12 + 26 + 4;

    return Stack(
      children: [
        StorageUtils.chatBgImagePath.isNotEmpty
            ? Positioned.fill(
                child: Image.file(
                  File(StorageUtils.chatBgImagePath),
                  fit: BoxFit.cover,
                ),
              )
            : Positioned.fill(child: role.avatar.iv()),
        Positioned(
          top: 0,
          width: Get.width,
          height: 108.h,
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.r)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withValues(alpha: 0.25)),
            ),
          ),
        ),

        // Positioned(
        //   top: 0,
        //   width: Get.width,
        //   height: 130.h,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Colors.black.withValues(alpha: 0.75),
        //       gradient: LinearGradient(
        //         begin: Alignment.bottomCenter,
        //         end: Alignment.topCenter,
        //         colors: [
        //           Colors.transparent,
        //           Colors.black.withValues(alpha: 0.75),
        //         ],
        //         stops: [0.0, 0.7],
        //       ),
        //     ),
        //   ),
        // ),
        // Positioned(
        //   bottom: 0,
        //   width: Get.width,
        //   height: 125.h,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter,
        //         colors: [
        //           Colors.transparent,
        //           Colors.black.withValues(alpha: 0.99),
        //         ],
        //         stops: [0.0, 0.73],
        //       ),
        //     ),
        //   ),
        // ),
        Scaffold(
          appBar: MsgAppBar(role: role, ctr: controller),
          // extendBodyBehindAppBar: true,
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                bottom: msgBottom,
                top: 50.h,
                child: MsgListView(
                  role: role,
                  ctr: controller,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Obx(() {
                  return MsgInput(
                    ctr: controller,
                    inputTags: controller.inputTags.toList(),
                  );
                }),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: kMinInteractiveDimension +6.h,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.verticalSpace,
                const RoleImages(),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (CloUtil.isCloB)
                        ChatMsgFloatItems(
                          role: role,
                          sessionId: controller.session.id.val,
                        ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
