import 'package:novatalk/app/configs/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/entities/role_entity.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/locales.g.dart';
import '../../../configs/constans.dart';
import '../../../utils/app_user.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/log/log_event.dart';

class ChatMsgFloatItems extends StatelessWidget {
  const ChatMsgFloatItems({
    super.key,
    required this.role,
    required this.sessionId,
  });

  final RoleRecords role;
  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (role.videoChat == true) _buildVideoItem(),
        // if (role.videoGen == true) _buildItem('🔥', LocaleKeys.gen_video.tr, _onTapCreateVideo),
        // if (role.photoGen == true) _buildItem('🌶', LocaleKeys.gen_picture.tr, _onTapCreateImage),
      ],
    );
  }

  void _onTapPhoneVideo() {
    logEvent('c_videocall');

    if (!AppUser.inst.isVip.value) {
      pushVip(VipFrom.call);
      return;
    }

    if (!AppUser.inst.isBalanceEnough(ConsumeFrom.call)) {
      pushGem(ConsumeFrom.call);
      return;
    }
    pushPhone(sessionId: sessionId.toInt, role: role, showVideo: true);
  }

  void _onTapCreateImage() {
    // logEvent('c_createimg');
    // RouterUtil.pushCreate(role: role, type: CreateType.photo);
  }

  void _onTapCreateVideo() {
    // logEvent('c_createvideo');
    // RouterUtil.pushCreate(role: role, type: CreateType.video);
  }

  Widget _buildVideoItem() {
    final guide = role.characterVideoChat?.firstWhereOrNull(
      (e) => e.tag == 'guide',
    );
    final url = guide?.gifUrl ?? role.avatar;

    return GestureDetector(
      onTap: _onTapPhoneVideo,
      child: Stack(
        children: [
          ClipOval(
            child: url.iv(width: 72.w, height: 72.w),
          ),
          Positioned(
            top: 1.w,
            right: 1.w,
            child: Assets.imagesPhVideoMachine.iv(width: 24.w),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String icon, String name, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFD9DBFF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: LayoutBuilder(
          builder: (BuildContext _, BoxConstraints bc) {
            // 创建一个 TextPainter 来计算文本的宽度
            TextPainter textPainter = TextPainter(
              text: TextSpan(
                text: '🔥  $name',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              textDirection: TextDirection.ltr,
            );
            textPainter.layout();
            // 获取文本宽度
            double textWidth = textPainter.width;
            final width = textWidth + 20.w;

            return Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(width: 4.w),
                    Text(
                      icon,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
