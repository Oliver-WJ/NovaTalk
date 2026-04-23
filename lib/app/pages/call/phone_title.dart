import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:novatalk/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novatalk/app/entities/role_entity.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../configs/app_theme.dart';
import '../chat/role_profile/role_profile_view.dart';

class PhoneTitle extends StatelessWidget {
  const PhoneTitle({super.key, required this.role});

  final RoleRecords role;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration:  BoxDecoration(
              borderRadius:  BorderRadius.circular(20.r),
              border:  Border.all(
                color: cTheme.primary,
                width: 2.w,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: role.avatar.iv(
                width: 80.w,
                height: 80.h,
              ),
            ),
          ),
          5.verticalSpace,
          Row(
            crossAxisAlignment:  CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Get.width/2.2
                ),
                child: Text(
                  role.name ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (role.age != null)
                buildAgeWidget(role.age).marginOnly(left: 4.w),
            ],
          ),
        ],
      ),
    );
  }
}

