import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/pages/chat/chat_room/chat_room_controller.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../../../../generated/assets.dart';
import '../../../../../generated/locales.g.dart';
import '../../../../configs/app_theme.dart';
import '../../../../configs/constans.dart';
import '../../../../entities/msg_res.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/log/log_event.dart';
import '../../../vip/vip_view.dart';
import 'msg_text_item.dart';

class MsgVideoItem extends StatelessWidget {
  const MsgVideoItem({super.key, required this.msg, required this.ctr});

  final Msg msg;
  final ChatRoomController ctr;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MsgTextItem(msg: msg, ctr: ctr),
          const SizedBox(height: 8),
          _buildImageWidget(),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    var imageUrl = msg.thumbLink ?? '';
    var isLockImage = msg.mediaLock == LockLevel.private.value;
    var imageWidth = 230 / 1.4;
    var imageHeight = 312 / 1.4;

    var videoUrl = msg.videoUrl ?? '';

    var imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: imageUrl.iv(width: imageWidth, height: imageHeight),
    );

   return Obx(
      () {
        var isHide = !AppUser.inst.isVip.value && isLockImage;
        return isHide
            ? GestureDetector(
          onTap: _onTapUnlock,
          child: Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                imageWidget,
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    blendMode: BlendMode.src,
                    child: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 2.h),
                  decoration:  BoxDecoration(
                    borderRadius:  BorderRadius.circular(16),
                    color: Colors.black.withOpacity(0.16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.imagesPhAdPlay.iv(
                        width: 16.w,
                        color: cTheme.scrim,
                      ),
                      4.horizontalSpace,
                      Text(
                        LocaleKeys.topVideo.tr,
                        style: TextStyle(
                          color: cTheme.scrim,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    right: 8.w,
                    bottom: 8.h,
                    child: Assets.imagesPhVideoPlay.iv(width: 36.w))
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     buildPlayBtn(),
                //     const SizedBox(height: 15),
                //     buildTheme3Btn(
                //         title: LocaleKeys.unlockNow,
                //         vertical: 7.h,
                //         horizontal: 11.w
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        )
            : GestureDetector(
          onTap: () {
            Get.toNamed(Routes.VIDEO_REVIEW, arguments: videoUrl);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              imageWidget,
              buildPlayBtn(),
            ],
          ),
        );
      }
    );
  }

  Container buildPlayBtn() {
    return Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A1A1A).withValues(alpha: 0.9),
              ),
              child: Center(child: Icon(Icons.play_arrow,color: Colors.white,)),
            );
  }

  void _onTapUnlock() async {
    logEvent('c_news_lockvideo');
    final isVip = AppUser.inst.isVip.value;
    if (!isVip) {
      pushVip(VipFrom.lockpic);
    }
  }
}
