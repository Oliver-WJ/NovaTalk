import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/widgets/keep_alive_wrapper.dart';
import 'package:novatalk/app/widgets/overall_build_widget.dart';

import '../../../generated/assets.dart';
import '../../../generated/locales.g.dart';
import '../../utils/time_util.dart';
import '../../widgets/common_widget.dart';
import '../home/home_view.dart';
import 'chat_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';

class ChatView extends GetBuildView<ChatController> {
  const ChatView({super.key});

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      body: buildDefaultBg(
        child: SafeArea(
          child: DefaultTabController(
            length: 2,
            animationDuration: const Duration(milliseconds: 50),
            child: Column(
              children: [
                // buildHomeAppBar(
                //   titleIcon: Assets.imagesIgChat,
                //   actions: [buildGemWidget().marginOnly(right:  16.w)],
                // ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
                  width: Get.width,
                  child: buildHomeTitleTabBar(
                    isScrollable: false,
                    tabAlignment: null,
                    tabs: [
                      Tab(text: LocaleKeys.contactedBefore.tr),
                      Tab(text: LocaleKeys.favorites.tr),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      KeepAliveWrapper(
                        child: SessionListView(
                          controller: controller.sessionListController,
                        ),
                      ),
                      KeepAliveWrapper(
                        child: SessionListView(
                          controller: controller.likedSessionListController,
                        ),
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
}

class SessionListView extends StatefulWidget {
  final SessionListController controller;

  const SessionListView({super.key, required this.controller});

  @override
  State<SessionListView> createState() => _SessionListViewState();
}

class _SessionListViewState extends State<SessionListView> {
  late final ctr = widget.controller;

  @override
  void initState() {
    super.initState();
    ctr.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      onRefresh: ctr.onRefresh,
      childBuilder: (context, physics) {
        return Obx(() {
          if (ctr.pageData.isEmpty) {
            return Center(child: buildEmpty());
          }
          return ListView.separated(
            physics: physics,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 22.h),
            separatorBuilder: (_, index) {
              return const SizedBox(height: 20);
            },
            itemBuilder: (_, index) {
              final item = ctr.pageData[index];
              return InkWell(
                onTap: () => ctr.onItemTap(item),
                child: Container(
                  height: 68.h,
                  child: Row(
                    children: [
                      Stack(
                        alignment: AlignmentGeometry.bottomRight,
                        children: [
                          ClipOval(
                            child: item.avatar.iv(width: 68.w, height: 68.w),
                          ),
                          if (ctr.isLiked) buildLikeThemeBtn(),
                        ],
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tTheme.titleMedium!.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: 36.h),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.lastMessage ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      12.horizontalSpace,
                      if (item.updateTime != null)
                        Text(
                          TimeUtil.formatToday(item.updateTime!),
                          style: tTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
            itemCount: ctr.pageData.length,
          );
        });
      },
    );
  }
}

Widget buildLikeThemeBtn({
  EdgeInsetsGeometry? padding,
  double? radius,
  Widget? contentWidget,
  BoxShape shape = BoxShape.rectangle,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12.r),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Container(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: shape == BoxShape.circle
              ? null
              : BorderRadius.circular(radius ?? 12.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 1.w,
          ),
          color: Colors.black.withValues(alpha: 0.4),
        ),
        child: contentWidget ?? Assets.imagesPhLike.iv(width: 12.w),
      ),
    ),
  );
}
