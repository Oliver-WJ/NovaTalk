import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/pages/chat/role_profile/role_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:novatalk/app/pages/call/phone_btn.dart';
import 'package:novatalk/app/pages/call/phone_ctr.dart';
import 'package:novatalk/app/pages/call/phone_title.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../../generated/assets.dart';
import '../../../generated/locales.g.dart';
import '../../configs/constans.dart';
import '../../entities/role_entity.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> with RouteAware {
  late final ctr = Get.find<PhoneCtr>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: buildDefaultBg(
          child: Stack(
            children: [
              Positioned.fill(
                child: (ctr.guideVideo?.gifUrl ?? ctr.role.avatar).iv(),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withOpacity(0.6)),
              ),
              // Positioned.fill(
              //   child: Container(
              //     decoration: const BoxDecoration(
              //       gradient: LinearGradient(
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //         colors: [
              //           Color(0xCC000000),
              //           Color(0x001A1A1A),
              //           Color(0x001A1A1A),
              //           Color(0x801A1A1A),
              //           Color(0xCC1A1A1A),
              //         ],
              //         stops: [0.1, 0.27, 0.43, 0.55, 0.99],
              //       ),
              //     ),
              //   ),
              // ),
              SafeArea(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildBackIcon().marginOnly(left: 12.w),
                        ex,
                        Obx(
                          () => ctr.showFormattedDuration.value
                              ? Container(
                                  margin: EdgeInsets.only(right: 12.w),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4.w,
                                    horizontal: 12.w,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 7.w,
                                        height: 7.w,
                                        margin: EdgeInsets.only(right: 6.w),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xffB0ECFD),
                                        ),
                                      ),
                                      _buildTimer(),
                                    ],
                                  ),
                                )
                              : sh,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.w),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2.w,
                                ),
                              ),
                              child: SizedBox.square(
                                dimension: 88.r,
                                child: ClipOval(child: ctr.role.avatar.iv()),
                              ),
                            ),
                            16.verticalSpace,
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: Get.width/2,
                              ),
                              child: ctr.role.name.tv(
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 24.sp,
                                  color: Colors.white,
                                  fontWeight:  FontWeight.w500,
                                ),
                              ),
                            ),
                            12.verticalSpace,
                            SizedBox(
                                width: 28.w,
                                child: buildAgeWidget(ctr.role.age))
                          ],
                        ),
                      ),
                    ),
                    Obx(() => _buildLoading()),
                    Obx(() {
                      ctr.callState.value;
                      return _buildAnswering();
                    }),
                    SizedBox(height: 30.w),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _buildButtons(),
                      ).paddingSymmetric(horizontal: 20.w),
                    ),
                    20.verticalSpace
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    if (ctr.callState.value == CallState.calling ||
        ctr.callState.value == CallState.answering ||
        ctr.callState.value == CallState.listening) {
      return LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.white,
        size: 40.w,
      );
    }
    if (ctr.callState.value == CallState.micOff) {
      return GestureDetector(
        onTap: () => ctr.onTapMic(true),
        child: Column(
          children: [
            Assets.imagesPhPhoneMic.iv(
              width: 42.w,
              height: 42.w,
              color: Colors.white,
            ),
            Text(
              LocaleKeys.pressConti.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildTimer() {
    if (ctr.showFormattedDuration.value) {
      return Text(
        ctr.formattedDuration(ctr.callDuration.value),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    }
    return Container();
  }

  Widget _buildAnswering() {
    final text = ctr.callStateDescription(ctr.callState.value);
    if (text.isEmpty) {
      return Container();
    }

    return SizedBox(
      width: Get.width - 60,
      child: Center(
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          child: AnimatedTextKit(
            key: ValueKey(ctr.callState.value),
            totalRepeatCount: 1,
            animatedTexts: [
              TypewriterAnimatedText(
                text,
                speed: const Duration(milliseconds: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons() {
    final asColor = Color(0xff78D5FA);
    List<Widget> buttons = [
      PhoneBtn(
        icon: Assets.imagesPhPhoneHangup.iv(width: 28.w),
        title: '',
        color: hangupColor,
        onTap: ctr.onTapHangup,
      ),
    ];

    if (ctr.callState.value == CallState.incoming) {
      buttons.add(
        PhoneBtn(
          icon: Assets.imagesPhPhoneAnswer.iv(width: 28.w),
          title: '',
          color: answerColor,
          iconColor: Colors.white,
          animationColor: Colors.transparent,
          onTap: ctr.onTapAccept,
        ),
      );
    }

    if (ctr.callState.value == CallState.listening) {
      buttons.add(
        PhoneBtn(
          icon: Assets.imagesPhPhoneMic2.iv(width: 28.w,color: Colors.black),
          title: '',
          color: asColor,
          iconColor: Colors.white,
          animationColor: asColor,
          onTap: () => ctr.onTapMic(false),
        ),
      );
    }

    if (ctr.callState.value == CallState.answering ||
        ctr.callState.value == CallState.micOff ||
        ctr.callState.value == CallState.answered) {
      buttons.add(
        PhoneBtn(
          icon: ctr.callState.value == CallState.micOff
              ? Assets.imagesPhPhoneMic2.iv(width: 28.w,color: Colors.white)
              : Assets.imagesPhPhoneMic.iv(width: 28.w),
          title: '',
          color: Colors.black.withValues(alpha: 0.5),
          iconColor: Colors.white,
          onTap: () => ctr.onTapMic(true),
        ),
      );
    }

    return buttons;
  }
}

Widget topRoleInfoView(RoleRecords role) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () => Get.back(),
        child: buildBackIcon(),
      ).marginOnly(left: 16.w),
      8.horizontalSpace,
      ClipOval(
        child: role.avatar.iv(width: 36.w, height: 36.w),
      ),
      8.horizontalSpace,
      role.name.tv(
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      6.horizontalSpace,
      SizedBox(width: 27.w, height: 16.h, child: buildAgeWidget(5)),
      // PhoneTitle(role: role)
    ],
  ).paddingOnly(bottom: 4.h);
}

const hangupColor = Color(0xffE2266C);
const answerColor = Color(0xffFBF05D);
