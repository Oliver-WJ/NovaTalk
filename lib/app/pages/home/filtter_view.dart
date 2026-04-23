import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../../generated/assets.dart';
import '../../../generated/locales.g.dart';
import '../../entities/role_tags_entity.dart';
import '../../widgets/gradient_bound_painter.dart';
import 'home_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final ctr = Get.find<RolesController>();

  late RoleTagsEntity selectedType = ctr.roleTags.first;
  late final selectTags = ctr.selectTags.value.obs;

  @override
  Widget build(BuildContext context) {
    final tags = selectedType.tags;

    bool containsAll = false;
    if (tags != null && tags.isNotEmpty) {
      containsAll = selectTags.containsAll(tags);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TapBox(
              onTap: () {
                Get.back();
              },
              child: buildBackIcon(color: Color(0xff1C1A1D)),
            ),
            16.horizontalSpace,
            LocaleKeys.pickTags.tv(
              style: tTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Color(0xff434343),
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
        18.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 40.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(left: -12.w, height: 35.h, child: _buildType()),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (containsAll) {
                  selectTags.removeAll(tags ?? []);
                } else {
                  selectTags.addAll(tags ?? []);
                }
                setState(() {});
              },
              child: Text(
                containsAll
                    ? LocaleKeys.deselectAllItems.tr
                    : LocaleKeys.selectAllItems.tr,
                style: tTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ).marginOnly(top: 16, bottom: 12),
            ),
          ],
        ),
        12.verticalSpace,
        Expanded(
          child: Column(
            children: [
              Expanded(child: _buildTags()),
              28.verticalSpace,
              buildTheme3Btn(
                alignment: Alignment.center,
                onTap: () {
                  Get.dismissBottomSheet();
                  ctr.filterEvent.value = Set<RoleTagsTagList>.from(
                    selectTags,
                  );
                  ctr.filterEvent.refresh();
                  ctr.selectTags.value = selectTags.value;
                },
                title: LocaleKeys.confirmSel.tr,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    ).marginSymmetric(horizontal: 16.w, vertical: 20.h);
  }

  Widget _buildTags() {
    final tags = selectedType.tags;
    if (tags == null || tags.isEmpty) {
      return const SizedBox();
    }

    return GridView.builder(
      itemCount: tags.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.8,
        mainAxisSpacing: 12.w,
        crossAxisSpacing: 12.h,
      ),
      itemBuilder: (context, index) {
        final e = tags[index];
        var isSelected = selectTags.contains(e);
        return InkWell(
          onTap: () {
            if (selectTags.contains(e)) {
              selectTags.remove(e);
            } else {
              selectTags.add(e);
            }
            setState(() {});
          },
          child: _buildItem(isSelected, e),
        );
      },
    );
  }

  Widget _buildItem(bool isSelected, RoleTagsTagList e) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(19.r)),
            border: Border.all(
              color: isSelected ? cTheme.scrim : Color(0xffEFEFEF),
              width: 1.w,
            ),
          ),
          child: Text(
            e.name ?? "",
            textAlign: TextAlign.center,
            maxLines:  1,
            overflow: TextOverflow.ellipsis,
            style: tTheme.titleSmall!.copyWith(
              color: isSelected ? Colors.black : Color(0xff595959),
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            top: 0,
            right: 0,
            child: Assets.imagesPhCheck.iv(
              width: 16.w,
            )
          )
      ],
    );
  }

  Widget _buildType() {
    var tags = ctr.roleTags;
    List<RoleTagsEntity> result = (tags.length > 2)
        ? tags.take(2).toList()
        : tags;

    RoleTagsEntity type1 = result[0];

    RoleTagsEntity? type2;
    if (result.length > 1) {
      type2 = result[1];
    }

    return DefaultTabController(
      length: result.length,
      child: buildHomeTitleTabBar(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        labelPadding: EdgeInsets.only(right: 22.w),
        onTap: (index) {
          selectedType = result[index];
          setState(() {});
        },
        tabs: [
          Tab(child: _buildTypeItem(type1)),
          if (type2 != null) Tab(child: _buildTypeItem(type2)),
        ],
      ),
    );
  }

  Widget _buildTypeItem(RoleTagsEntity type) {
    return Container(
      decoration: BoxDecoration(),
      child: Center(child: Text(type.labelType ?? '')),
    );
  }
}
