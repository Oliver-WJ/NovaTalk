import 'package:novatalk/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_theme.dart';

import 'package:novatalk/app/entities/role_entity.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../../../generated/assets.dart';

class RoleProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RoleProfileAppBar({
    super.key,
    required this.role,
    required this.opacity,
    this.onClearHistory,
    this.onReport,
    this.onDelete,
  });

  final RoleRecords role;
  final double opacity;
  final Function? onClearHistory;
  final Function? onReport;
  final Function? onDelete;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: buildBackIcon(),
      ),
      actions: [buildMoreMenu(), 16.horizontalSpace],
    );
  }

  Widget buildMoreMenu() {
    void tapMenu(Function? onTap){
      Navigator.of(Get.context!).pop();
      onTap?.call();
    }
    return CustomPopup(
      showArrow: false,
      rootNavigator: true,
      contentPadding:  EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.symmetric(
          vertical: 4.h
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 25.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TapBox(
                    onTap: ()=>tapMenu(onClearHistory),
                    padding: EdgeInsets.all(5.r),
                    child: LocaleKeys.cleHistory.tv(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  TapBox(
                    onTap: ()=>tapMenu(onReport),
                    padding: EdgeInsets.all(5.r),
                    child: LocaleKeys.report.tv(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(
              width: 150.w,
              child: Divider(
                height: 10.h,
                thickness: 4.h,
                color: Color(0xffFAFAFA),
              ),
            ),
            TapBox(
              onTap: ()=>tapMenu(onDelete),
              padding: EdgeInsets.all(5.r),
              child: LocaleKeys.remChat.tv(
                style: TextStyle(
                  color: Color(0xffE2266C),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            4.verticalSpace
          ],
        ),
      ),
      child: Assets.imagesPhMore.iv(width: 24.w),
    );

  }
}
