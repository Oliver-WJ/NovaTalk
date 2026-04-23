import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/assets.dart';

class AzListItemView extends StatelessWidget {
  const AzListItemView({
    super.key,
    required this.name,
    this.isShowSeparator = false,
    this.onTap,
    this.isChoosed = false,
  });

  final String name;

  final bool isShowSeparator;
  final bool isChoosed;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          border: isShowSeparator
              ? Border(bottom: BorderSide(color: Colors.grey[300]!, width: 0.5))
              : null,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isChoosed) Assets.imagesPhCheck2.iv(width: 20.w)
            // else
            //   Assets.imagesIgCheck2Un.iv(width: 20.w),
          ],
        ),
      ),
    );
  }
}
