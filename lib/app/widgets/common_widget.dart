import 'dart:async';
import 'dart:ui';

import 'package:novatalk/app/utils/storage_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/configs/constans.dart';
import 'package:novatalk/app/pages/vip/vip_view.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/widgets/blur_background.dart';
import 'package:hive/hive.dart';

import '../../generated/assets.dart';
import '../../generated/locales.g.dart';
import '../pages/setting/setting_view.dart';
import '../utils/common_utils.dart';
import 'gradient_bound_painter.dart';
import 'msg_gift_loading.dart';

Widget get ex => const Spacer();

Widget get sh => const SizedBox.shrink();

extension Common on Comparable? {
  bool containsIgnoreCase(String other) {
    return val.toLowerCase().contains(other.toLowerCase());
  }

  String get val => this == null ? "" : toString();

  bool get isVoid => val.isEmpty;

  int get toInt => int.tryParse(val) ?? 0;

  Color hex([double alpha = 1]) {
    var hexStr = val.toUpperCase().replaceAll("#", "");
    int hex = int.parse(hexStr, radix: 16);
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    return Color.fromRGBO(
      (hex & 0xFF0000) >> 16,
      (hex & 0x00FF00) >> 8,
      (hex & 0x0000FF) >> 0,
      alpha,
    );
  }

  String get removeZeroWidthChars {
    // 零宽空格的Unicode码点：U+200B
    return val.replaceAll(RegExp('[\u200B]'), '');
  }

  Text tv({
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      val.tr,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  Widget iv({
    double? width,
    double? height,
    Color? color,
    BoxFit? fit = BoxFit.cover,
    BlendMode? colorBlendMode,
  }) {
    if (val.isURL) {
      return CachedNetworkImage(
        imageUrl: val,
        width: width,
        height: height,
        fit: fit,
        color: color,
        placeholder: (context, url) => Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 30.w, maxHeight: 30.w),
            child: CircularProgressIndicator(strokeWidth: 2.w),
          ),
        ),
      );
    }
    return Image.asset(
      val,
      width: width,
      height: height,
      color: color,
      fit: fit,
      colorBlendMode: colorBlendMode,
    );
  }
}

int _lastClickTime = 0;

class TapBox extends GestureDetector {
  TapBox({
    super.key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    int canClickDelay = 450,
    Function? onTap,
  }) : super(
         behavior: HitTestBehavior.translucent,
         onTap: onTap == null
             ? null
             : () {
                 var now = DateTime.now().millisecondsSinceEpoch;
                 if (now - _lastClickTime < canClickDelay) return;
                 _lastClickTime = now;
                 onTap.call();
               },
         child: padding != null
             ? Padding(padding: padding, child: child)
             : child,
       );
}

extension GetWidget on GetInterface {
  void dismissDialog() {
    if (Get.isDialogOpen ?? false) Get.back();
  }

  void dismissBottomSheet() {
    if (Get.isBottomSheetOpen ?? false) Get.back();
  }

  Future<void> popTo(
    String routeName, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) async {
    bool exists = false;

    Get.until((route) {
      exists = route.settings.name == routeName;
      return exists;
    });
    if (!exists) {
      Get.toNamed(
        routeName,
        arguments: arguments,
        id: id,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
      );
    }
  }
}

class SLoading extends StatelessWidget {
  const SLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      ),
    );
  }
}

extension GetWindow on GetInterface {
  void closeBottomSheet<T>({T? result}) {
    if (isBottomSheetOpen == true) {
      Get.back(result: result);
    }
  }

  void closeDialog() {
    if (isDialogOpen == true) {
      Get.back();
    }
  }
}

/// 构建富文本
List<InlineSpan> buildTextSpans({
  required String origin,
  required List<String> targets,
  TextStyle? style,
  required InlineSpan Function(String target, TextStyle? style, int index)
  buildTargetTextSpan,
}) {
  final spans = <InlineSpan>[];
  int lastIndex = 0;

  for (int i = 0; i < targets.length; i++) {
    final start = origin.indexOf(targets[i]);
    if (start == -1) continue; // 不存在就跳过
    if (start > lastIndex) {
      spans.add(
        TextSpan(text: origin.substring(lastIndex, start), style: style),
      );
    }
    spans.add(buildTargetTextSpan(targets[i], style, i));
    lastIndex = start + targets[i].length;
  }

  if (lastIndex < origin.length) {
    spans.add(TextSpan(text: origin.substring(lastIndex), style: style));
  }

  return spans;
}

void dismissAndShowMsg(String message) {
  SmartDialog.dismiss();
  SmartDialog.showToast(message);
}

Future showClothesLoading() {
  return SmartDialog.show(
    clickMaskDismiss: false,
    alignment: Alignment.bottomCenter,
    keepSingle: true,
    tag: "clothesLoading",
    builder: (BuildContext context) {
      return SizedBox(height: Get.height / 2.6, child: const MsgGiftLoading());
    },
  );
}

Future hiddenClothesLoading() {
  return SmartDialog.dismiss(tag: "clothesLoading");
}

Future<void> showEditContentSheet({
  String? defTxt,
  String? defHits,
  FocusNode? focusNode,
  FutureOr Function(String? txt)? onConfirm,
  bool onConfirmDismiss = true,
  String? title,
}) async {
  final TextEditingController textEditingController = TextEditingController(
    text: defTxt,
  );
  await Get.bottomSheet(
    buildTheme2SheetRootWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          20.verticalSpace,
          Row(
            children: [
              Text(
                title.val,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // 8.horizontalSpace,
              // Text("5 stars/edit",
              //     style: TextStyle(
              //         color: Color(0xFF808080),
              //         fontSize: 11.sp,
              //         fontWeight: FontWeight.w500)),
            ],
          ).marginOnly(bottom: 5.h),
          Container(
            padding: EdgeInsets.only(bottom: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Color(0xffFBF05D), width: 1.w),
              gradient: LinearGradient(
                colors: [Color(0xffFFFBD8), Colors.white, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: TextField(
              controller: textEditingController,
              cursorColor: Theme1.cursorColor,
              minLines: 2,
              maxLines: 6,
              maxLength: 500,
              focusNode: focusNode,
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                hintText: defHits,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          10.verticalSpace,
          buildTheme2BottomBtn(
            done: () async {
              if (onConfirmDismiss) {
                Get.closeBottomSheet();
              }
              await onConfirm?.call(textEditingController.text);
            },
          ),
        ],
      ).marginSymmetric(horizontal: 16.w),
    ),
  );
  Future.delayed(Duration(milliseconds: 300), textEditingController.dispose);
}

Widget buildTheme2BottomBtn({
  Function? done,
  Function? cancel,
  String? doneTitle,
}) {
  return SafeArea(
    child: Row(
      children: [
        buildTheme3Btn(
          title: LocaleKeys.cancel.tr,
          onTap: cancel ?? Get.closeBottomSheet,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: Color(0xff1C1A1D), width: 1),
          ),
        ),
        11.horizontalSpace,
        Expanded(
          flex: 2,
          child: buildTheme3Btn(
            alignment: Alignment.center,
            title: doneTitle ?? LocaleKeys.done.tr,
            onTap: done,
          ),
        ),
      ],
    ),
  );
}

Future<void> showHelpUs() {
  if ((Get.isDialogOpen ?? false) || (Get.isBottomSheetOpen ?? false)) {
    return Future.value();
  }
  final contents = [
    (
      Assets.imagesPhStarLike,
      Assets.imagesPhStarLike2,
      LocaleKeys.notSatisfied,
    ),
    (Assets.imagesPhStarLike, Assets.imagesPhStarLike2, LocaleKeys.could),
    (Assets.imagesPhStarLike, Assets.imagesPhStarLike2, LocaleKeys.lovingIt),
  ];
  (String, String, String)? selectedItem;

  return Get.bottomSheet(
    isScrollControlled: false,
    SizedBox(
      height: Get.height / 2.5,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          buildTheme1SheetRootWidget(
            child: StatefulBuilder(
              builder: (context, setState) => ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.imagesBgkHelpUs),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      24.verticalSpace,
                      Text(
                        LocaleKeys.helpUs.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      28.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: contents.map((v) {
                          final current = contents.indexOf(v);
                          int selectedIndex = -1;
                          if (selectedItem != null) {
                            selectedIndex = contents.indexOf(selectedItem!);
                          }
                          return TapBox(
                            onTap: () {
                              setState(() {
                                selectedItem = v;
                              });
                            },
                            child: (selectedIndex >= current ? v.$2 : v.$1)
                                .iv(width: 64.w)
                                .marginSymmetric(horizontal: 2.w),
                          );
                        }).toList(),
                      ),
                      24.verticalSpace,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (selectedItem?.$3.tr).tv(
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: 0.75),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          8.verticalSpace,
                          buildTheme3Btn(
                            bold:   true,
                            title:
                                (selectedItem != null &&
                                    contents.indexOf(selectedItem!) != 2)
                                ? LocaleKeys.submitFb
                                : LocaleKeys.submit,
                            isValid: selectedItem != null,
                            alignment: Alignment.center,
                            onTap: () {
                              if (selectedItem == null) return;
                              if (contents.indexOf(selectedItem!) != 2) {
                                toEmail();
                              } else {
                                openStoreReview();
                              }
                            },
                          ),
                        ],
                      ),
                      20.verticalSpace,
                    ],
                  ).paddingSymmetric(horizontal: 20.w),
                ),
              ),
            ),
          ),
          Positioned(
            right: 32.w,
            top: 18.h,
            child: Assets.imagesPhHelpUs.iv(width: 90.w),
          ),
        ],
      ),
    ),
  );
}

Widget buildProcessView() {
  return Positioned.fill(
    child: AbsorbPointer(
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 24.h,horizontal: 40.w),
              decoration: BoxDecoration(color: '#222222'.hex(0.6)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.genHits.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ).marginSymmetric(horizontal: 16.w),
                  30.verticalSpace,
                  CircularProgressIndicator(strokeWidth: 4.r, color: cTheme.primary),
                  20.verticalSpace,
                  Text(
                    LocaleKeys.aiCre.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
