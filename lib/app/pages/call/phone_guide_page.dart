import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:novatalk/app/pages/call/phone_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/entities/role_entity.dart';
import 'package:novatalk/app/pages/call/phone_btn.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../../../generated/assets.dart';
import '../../../generated/locales.g.dart';
import '../../configs/app_theme.dart';
import '../../configs/constans.dart';
import '../../utils/common_utils.dart';
import '../../utils/log/log_event.dart';

class PhoneGuidePage extends StatefulWidget {
  const PhoneGuidePage({super.key});

  @override
  State<PhoneGuidePage> createState() => _PhoneGuidePageState();
}

class _PhoneGuidePageState extends State<PhoneGuidePage>
    with RouteAware, WidgetsBindingObserver {
  late RoleRecords role;

  late VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _isPlayed = false;
  StreamSubscription? _phoneStateSub;

  @override
  void initState() {
    super.initState();
    var args = Get.arguments;
    role = args['role'];

    WidgetsBinding.instance.addObserver(this);

    _initVideoPlay();
  }

  void _initVideoPlay() async {
    final guide = role.characterVideoChat?.firstWhereOrNull(
      (e) => e.tag == 'guide',
    );
    var url = guide?.url;

    _controller = VideoPlayerController.networkUrl(Uri.parse(url ?? ''));

    _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
      _controller?.addListener(_videoListener);
      handlePhoneCall();

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          _controller?.play();
          setState(() {});
        }
      });
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //  路由订阅
    // NavObs.instance.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    /// 取消路由订阅
    // NavObs.instance.routeObserver.unsubscribe(this);

    WidgetsBinding.instance.removeObserver(this);

    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _phoneStateSub?.cancel();
    _phoneStateSub = null;
    super.dispose();
  }

  @override
  void didPushNext() {
    // 页面被其他页面覆盖时调用
    _controller?.pause();
  }

  @override
  void didPopNext() {
    // 页面从其他页面回到前台时调用
    _controller?.play();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller?.pause();
      setState(() {});
    }
    if (state == AppLifecycleState.resumed) {
      _controller?.play();
      setState(() {});
    }
  }

  void _videoListener() {
    if (_controller == null) return;
    if (_controller!.value.isPlaying) {
      setState(() {});
    }

    final position = _controller!.value.position;
    final duration = _controller!.value.duration;
    final timeRemaining = duration - position;

    if (timeRemaining <= const Duration(milliseconds: 500)) {
      _isPlayed = true;
      _controller?.pause();
      setState(() {});
    }
  }

  //监听权限
  Future<bool?> requestPermission() async {
    var status = await Permission.phone.request();

    switch (status) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.granted:
        return true;
      default:
        return true;
    }
  }

  //处理来电话播放器停止播放的操作
  void handlePhoneCall() async {
    if (_phoneStateSub != null) {
      return;
    }
    bool havePermission = true;
    if (Platform.isAndroid) {
      havePermission = await requestPermission() ?? true;
    }
    // if (havePermission) {
    //   _phoneStateSub = PhoneState.stream.listen((event) {
    //     _controller?.pause();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildDefaultBg(
        child: Stack(
          children: [
            Positioned.fill(child: role.avatar.iv()),
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller?.value.size.width,
                        height: _controller?.value.size.height,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  );
                } else {
                  // 在加载时显示进度指示器
                  return Center(
                    child: CircularProgressIndicator(color: cTheme.primary),
                  );
                }
              },
            ),
            IgnorePointer(
              child: Container(
                height: Get.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() {
              final vip = AppUser.inst.isVip.value;
              if (_isPlayed) {
                if (vip) {
                  return _buildButtons();
                }
                return _buildVipVideoView();
              }
              return _buildWaitingView();
            }),

            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.w),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(bottom: false, child: topRoleInfoView(role)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    List<Widget> buttons = [
      PhoneBtn(
        icon: Assets.imagesPhPhoneHangup.iv(width: 28.w),
        title: '',
        color:hangupColor,
        onTap: () => Get.back(),
      ),
      PhoneBtn(
        icon: Assets.imagesPhPhoneAnswer.iv(width: 28.w),
        title: '',
        color: answerColor,
        iconColor: Colors.white,
        animationColor: Colors.transparent,
        onTap: () {
          if (AppUser.inst.balance.value < ConsumeFrom.call.gems) {
            pushGem(ConsumeFrom.call);
            return;
          }
          offPhone(role: role, showVideo: true);
        },
      ),
    ];

    return Column(
      children: [
        Expanded(child: Container()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: buttons,
        ),
        SizedBox(height: 60.w),
      ],
    );
  }

  Widget _buildVipVideoView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: buildTheme1SheetRootWidget(
        onClose:  () {
          Get.back();
        },
        showClose: true,
        bgColor: Colors.black.withValues(alpha: 0.75),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: Get.width,
            height: 209.h,
            child: Stack(
              children: [
                Assets.imagesBgkStar.iv(),
                Positioned.fill(
                  left: 20.w,
                  right: 20.w,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          20.verticalSpace,
                          Text(
                            LocaleKeys.claim.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10.w),
                          SizedBox(
                            width: 190.w,
                            child: Text(
                              LocaleKeys.interactiveAI.tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.7
                              ),
                            ),
                          ),
                          ex,
                          buildTheme3Btn(
                            bold: true,
                            alignment: Alignment.center,
                            onTap: () {
                              pushVip(VipFrom.call);
                              logEvent('c_unlock_videocall');
                            },
                            title: LocaleKeys.proceed.tr,
                          ),
                        ],
                      ),
                      Positioned(
                        right: -35.w,
                        child: Assets.imagesPhGem3.iv(width: 170.w),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaitingView() {
    // if (_controller?.value.isPlaying ?? false) {
    //   return SafeArea(
    //     child: Column(
    //       children: [
    //         Text(
    //           role.name ?? '',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontSize: 23.sp,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //         SizedBox(height: 16.w),
    //         Text(
    //           LocaleKeys.wantsYouVde.tr,
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontSize: 14.sp,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //         Expanded(child: Container()),
    //         PhoneBtn(
    //           icon: Assets.imagesIcPhoneAh.iv(width: 40.w),
    //           title: '',
    //           color: const Color(0xFFFA5151),
    //           onTap: () => Get.back(),
    //         ),
    //         SizedBox(height: 60.w),
    //       ],
    //     ),
    //   );
    // }
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: Container()),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.w),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
                decoration: BoxDecoration(color: Color(0x26000000)),
                child: Text(
                  LocaleKeys.wantsYouVde.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          25.verticalSpace,
          PhoneBtn(
            icon: Assets.imagesPhPhoneHangup.iv(width: 28.w),
            title: '',
            color: const Color(0xffE2266C),
            onTap: () => Get.back(),
          ),
          SizedBox(height: 60.w),
        ],
      ),
    );
  }
}
