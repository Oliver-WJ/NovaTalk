import 'dart:io';

import 'package:novatalk/app/configs/app_config.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/entities/und_style_bean.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/widgets/release_text_edit_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../../generated/locales.g.dart';
import '../../routes/app_pages.dart';
import '../../widgets/common_widget.dart';
import 'ctls/undress_page_controller.dart';

TextStyle undrDescribeTextStyle() => TextStyle(
  fontSize: 12.sp,
  color: Color(0xff181818).withValues(alpha: 0.5),
  fontWeight: FontWeight.w500,
);

TextStyle undrTitleTextStyle() => TextStyle(
  fontSize: 14.sp,
  fontWeight: FontWeight.w700,
  color: cTheme.primary,
);

class UndressPage extends StatelessWidget {
  final String? tag;

  UndressPage({super.key, this.tag});

  late final UndressPageController controller = Get.find<UndressPageController>(
    tag: tag,
  );

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        controller.args.isHomeReuse
            ? sh
            : AppBar(
                leading: Center(
                  child: SizedBox(
                    width: 42.w,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: buildBackIcon(color: Colors.black),
                    ),
                  ),
                ),
                centerTitle: true,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                title: Text(
                  LocaleKeys.dress.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
        Expanded(
          child: Obx(
            () => Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.undressAnother.value) 100.verticalSpace,
                        // if (!controller.showStyle.value &&
                        //     !controller.undressAnother.value)
                        //   Center(
                        //     child: Text(
                        //       LocaleKeys.dre.tr,
                        //       textAlign: TextAlign.center,
                        //       style: undrTitleTextStyle(),
                        //     ),
                        //   ),
                        14.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: AspectRatio(
                            aspectRatio: 0.77,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: SizedBox(
                                width: Get.width,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned.fill(child: buildImage()),
                                    Positioned(
                                      right: 10.w,
                                      top: 10.h,
                                      child: Obx(
                                        () =>
                                            controller.showStyle.value ||
                                                controller.undressAnother.value
                                            ? TapBox(
                                                onTap: () {
                                                  controller.resetState();
                                                },
                                                child: buildCloseIcon(),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).marginSymmetric(horizontal: 18.w),
                        ),
                        5.verticalSpaceFromWidth,
                        if (controller.showStyle.value) undressTemplate(),
                        if (!controller.showStyle.value &&
                            !controller.undressAnother.value)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 18.h),
                            decoration: BoxDecoration(
                              color: Color(0xffFAFAFA),
                              borderRadius: BorderRadius.all(
                                Radius.circular(21.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 26.w),
                              child: DefaultTextStyle(
                                style: undrDescribeTextStyle(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    12.verticalSpace,
                                    Text(LocaleKeys.aHits1.tr),
                                    6.verticalSpaceFromWidth,
                                    Text(LocaleKeys.abHits2.tr),
                                    6.verticalSpaceFromWidth,
                                    Text(LocaleKeys.uHits3.tr),
                                    6.verticalSpaceFromWidth,
                                    Text(LocaleKeys.uHits4.tr),
                                    14.verticalSpaceFromWidth,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        150.verticalSpace,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: controller.showStyle.value
                      ? Container(
                          color: cTheme.surface,
                          padding: EdgeInsets.only(top: 16.h, bottom: 30.h),
                          child: buildUndrBtn(
                            vertical: 2.h,
                            titleWidget: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LocaleKeys.generate.tv(
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Obx(
                                  () => Text.rich(
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff1C1A1D),
                                    ),
                                    TextSpan(
                                      text: '${LocaleKeys.credits.tr}: ',
                                      children: [
                                        TextSpan(
                                          text: '${AppUser.inst.createImg}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${LocaleKeys.photos.tr.toLowerCase()}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            title: LocaleKeys.generate.tr,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              controller.undressCharacter();
                            },
                          ).marginSymmetric(horizontal: 12.w),
                        )
                      : Obx(() {
                          Widget widget;
                          if (controller.undressAnother.value) {
                            widget = buildUndrBtn(
                              onTap: controller.selectImage,
                              title: LocaleKeys.create.tr,
                            );
                          } else {
                            widget = Row(
                              spacing: 11.w,
                              children: [
                                Expanded(
                                  child: buildUndrBtn(
                                    tb1: !controller.args.isHomeReuse,
                                    bold:  controller.args.isHomeReuse,
                                    onTap: () => controller.selectImage(),
                                    title: LocaleKeys.uploadImage.tr,
                                  ),
                                ),
                                if (!controller.args.isHomeReuse)
                                  Expanded(
                                    child: Obx(
                                      () => buildUndrBtn(
                                        title: controller.finishGenerate.value
                                            ? LocaleKeys.viewCha.tr
                                            : LocaleKeys.uRole.tr,
                                        onTap: () =>
                                            controller.undressCharacter(),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }
                          return Container(
                            color: cTheme.surface,
                            child: widget.paddingOnly(
                              left: 12.w,
                              right: 12.w,
                              bottom: !controller.args.isHomeReuse
                                  ? ScreenUtil().bottomBarHeight + 30.h
                                  : 10.h,
                            ),
                          );
                        }),
                ),
                if (controller.undressing.value) buildProcessView(),
              ],
            ),
          ),
        ),
      ],
    );
    return ReleaseTextEditFocus(child: controller.args.isHomeReuse ? body : buildDefaultBg(child: body));
  }

  Widget buildImage() {
    final uri = controller.userSelectedImage.value.isVoid
        ? AppConfig.undressBeforeImage
        : controller.userSelectedImage.value!;

    if (uri.isURL) {
      return TapBox(
        onTap: () {
          var url = controller.userSelectedImage.value;
          if (url.isVoid) return;
          Get.toNamed(Routes.IMAGEP_REVIEW, arguments: url);
        },
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator(color: cTheme.primary)),
          imageUrl: controller.userSelectedImage.value.isVoid
              ? AppConfig.undressBeforeImage
              : controller.userSelectedImage.value!,
        ),
      );
    }
    return Image.file(File(uri), fit: BoxFit.cover);
  }

  //模版
  Widget undressTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${LocaleKeys.artStyle.tr}:",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        4.verticalSpace,
        Obx(
          () => SizedBox(
            height: 96.h,
            child: ListView.separated(
              itemCount: controller.templateConfigList.length,
              shrinkWrap: true,

              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 0),
              separatorBuilder: (context, index) => 8.horizontalSpace,
              itemBuilder: (context, index) {
                return Obx(() {
                  UndStyleBean data = controller.templateConfigList[index];
                  bool isSelected =
                      controller.undressSelectedIndex.value == index;
                  return TapBox(
                    onTap: () {
                      controller.selectUndressMode(index);
                    },
                    child: Container(
                      width: 90.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12.r)),
                        border: Border.all(
                          color: isSelected ? cTheme.scrim : Color(0xffFAFAFA),
                          width: 1.r,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            child: CachedNetworkImage(
                              width: 22.w,
                              imageUrl: data.icon ?? '',
                              color: Colors.black,
                              errorWidget: (context, url, error) {
                                return buildLoadingWidget();
                              },
                              placeholder: (context, url) {
                                return buildLoadingWidget();
                              },
                            ),
                          ),
                          5.verticalSpace,
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 50.w),
                            child: Text(
                              data.name ?? '',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Color(0xff434343),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ),
        24.verticalSpace,
        Text(
          "${LocaleKeys.cusPrompt.tr}:",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        5.verticalSpace,
        Builder(
          builder: (context) {
            final border = OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.12),
              ),
            );
            return InkWell(
              onTap: () {
                showCustomPromptDialog(context);
              },
              child: TextField(
                enabled: false,
                cursorColor: Theme1.cursorColor,
                controller: controller.customPromptController,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 13.h,
                    horizontal: 16.w,
                  ),
                  hintText: LocaleKeys.promptHits2.tr,
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: .normal,
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                  filled: true,
                  fillColor: Color(0x1AFFFFFF),
                  border: border,
                  disabledBorder: border,
                  enabledBorder: border,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> showCustomPromptDialog(BuildContext context) async {
    String? oldValue = controller.customPromptController.text;
    await showEditContentSheet(
      defTxt: oldValue.val,
      title: "${LocaleKeys.cusPrompt.tr}:",
      defHits: LocaleKeys.promptHits2.tr,
      onConfirm: (v) {
        controller.customPromptController.text = v.val;
        controller.setCustomPrompt();
      },
    );
  }
}

Widget buildUndrBtn({
  EdgeInsetsGeometry? margin,
  String? title,
  bool tb1 = false,
  bool bold = false,
  double? vertical,
  Widget? titleWidget,
  onTap,
}) {
  return buildTheme3Btn(
    alignment: Alignment.center,
    onTap: onTap,
    title: title,
    vertical: vertical ?? 10.h,
    decoration: tb1
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              width: 1,
              color: Color(0xff1C1A1D).withValues(alpha: 0.5),
            ),
          )
        : null,
    titleWidget:
        titleWidget ??
        title.tv(
          style: bold
              ? TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                )
              : TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
        ),
  );
}

Widget buildLoadingWidget() {
  return Container(
    color: const Color(0x33906BF7),
    child: const Center(child: Icon(Icons.image, color: Color(0x80808080))),
  );
}
