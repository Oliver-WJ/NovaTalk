import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/pages/chat/chat_room/chat_room_controller.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/locales.g.dart';
import '../../../configs/constans.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_user.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/storage_util.dart';
import '../../undr/ctls/undress_page_controller.dart';
import 'msg_input_buttons.dart';

class MsgInput extends StatefulWidget {
  const MsgInput({super.key, required this.ctr, required this.inputTags});

  final ChatRoomController ctr;
  final List<dynamic> inputTags;

  @override
  State<MsgInput> createState() => _MsgInputState();
}

class _MsgInputState extends State<MsgInput> {
  late TextEditingController textEditingController;
  bool isSend = false;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.addListener(_onInputChange);
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.removeListener(_onInputChange);
    focusNode.dispose();
  }

  void firstClickChatInputBox() async {
    focusNode.unfocus();
    StorageUtils.firstClickChatInputBox = false;
    setState(() {}); // 更新UI，移除覆盖层

    /// TODO mask dialog
    // await AppDialog.alert(
    //   message: LocaleKeys.create_mask_profile_description.tr,
    //   cancelText: LocaleKeys.cancelAct.tr,
    //   confirmText: LocaleKeys.confirmSel.tr,
    //   clickMaskDismiss: false,
    //   onConfirm: () {
    //     AppDialog.dismiss();
    //     RouterUtil.pushMask();
    //   },
    // );
  }

  void _onInputChange() async {
    if (textEditingController.text.length > 500) {
      // SmartDialog.showToast(LocaleKeys.max_input_length.tr, displayType: SmartToastType.onlyRefresh);
      // 截断文本到500字符
      textEditingController.text = textEditingController.text.substring(0, 500);
      // 将光标移到文本末尾
      textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length),
      );
    }
    isSend = textEditingController.text.isNotEmpty;
    setState(() {});
  }

  // 0  tease, 1 undress, 2 gift, 3 mask, 100 screen, 101 sortlong
  void onTapTag(int index) {
    final item = widget.inputTags[index];
    final id = item['id'];

    if (id == 0) {
      List<String> list = item['list'];
      if (list.isNotEmpty) {
        textEditingController.text = list[randomNumber(max: list.length)];
      }
      onSend();
    } else if (id == 1) {
      final ctr = widget.ctr;
      Get.toNamed(
        Routes.UND,
        arguments: UndressPageArgs(
          characterId: ctr.role.id,
          coverUrl: StorageUtils.chatBgImagePath.isVoid
              ? ctr.session.avatar
              : StorageUtils.chatBgImagePath,
        ),
      );
    } else if (id == 2) {
      showGift();
    } else if (id == 3) {
      toMaskPage();
    } else {}
  }

  void showGift() {}

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withOpacity(0.25),
          child: Column(
            children: [
             Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MsgInputButtons(
                            tags: widget.ctr.inputTags.toList(),
                            onTap: onTapTag,
                          ),
                        ),
                        TapBox(
                          onTap: () {
                            showEditContentSheet(
                              defTxt: widget.ctr.session.scene,
                              title: LocaleKeys.edScenario.tr,
                              defHits:  LocaleKeys.scenarioHits.tr,
                              onConfirmDismiss: false,
                              onConfirm: (txt) async {
                                if (!AppUser.inst.isVip.value) {
                                  pushVip(VipFrom.scenario);
                                  return;
                                }
                                var result =
                                    await Theme1Dialog.showBottomTwoBtn(
                                      content: LocaleKeys.newScenarioHits.tr,
                                      onConfirm: () {
                                        widget.ctr.editScenario(txt);
                                        Get.closeDialog();
                                        Get.closeBottomSheet();
                                      },
                                    );
                              },
                            );
                          },
                          child: Assets.imagesPhMsgFr.iv(width: 35.w),
                        ),
                        12.horizontalSpace,
                        TapBox(
                          onTap: () {
                            showReplyModeDialog();
                          },
                          child: Assets.imagesPhMsgMod.iv(width: 35.w),
                        ),
                        16.horizontalSpace,
                      ],
                    ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                child: Stack(
                  children: [
                    SafeArea(
                      top: false,
                      left: false,
                      right: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(16.r),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 1,
                                        sigmaY: 1,
                                      ),
                                      child: Container(
                                        padding: EdgeInsetsEx.atWill(
                                          vertical: 2.5.h,
                                          left: 12.w,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(16.r),
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.5,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            _buildSpecialButton(),
                                            Flexible(child: _buildTextField()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SendButton(onTap: onSend, canSend: isSend),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 第一次使用时的覆盖层
                    if (StorageUtils.firstClickChatInputBox)
                      Positioned.fill(
                        child: GestureDetector(onTap: firstClickChatInputBox),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      textInputAction: TextInputAction.send,
      onEditingComplete: onSend,
      minLines: 1,
      maxLines: 3,
      maxLength: 500,
      style: const TextStyle(
        height: 1,
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: textEditingController,
      enableInteractiveSelection: true,
      // 确保文本选择功能启用
      dragStartBehavior: DragStartBehavior.down,
      // 优化拖拽行为
      decoration: InputDecoration(
        hintText: LocaleKeys.writeMsg.tr,
        hintStyle: tTheme.bodyLarge!.copyWith(
          color: Colors.white.withOpacity(0.5),
          fontWeight: FontWeight.w400,
        ),
        fillColor: Colors.transparent,
        border: InputBorder.none,
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.only(
          left: 5,
          top: 6,
          right: 5,
          bottom: 6,
        ),
        counterText: '',
      ),
      autofocus: false,
      focusNode: focusNode,
      // onTap: () {
      //   var onlyOneMaskTips = StorageUtils.onlyOneMaskTips;
      //   if (!onlyOneMaskTips) {
      //     focusNode.unfocus();
      //     StorageUtils.onlyOneMaskTips = true;
      //     Theme1Dialog.showBottomTwoBtn(
      //       content: LocaleKeys.crMaskTips.tr,
      //       onConfirm: () {
      //         Get.closeDialog();
      //         toMaskPage();
      //       },
      //     );
      //   }
      // },
    );
  }

  void toMaskPage() {
    // Get.toNamed(
    //   Routes.MASK_PAGE,
    //   arguments: MaskArgs(
    //     maskId: widget.ctr.session.profileId.val,
    //     conversionId: widget.ctr.session.id.val,
    //   ),
    // );
  }

  void onSend() async {
    // widget.ctr.showUndTips();
    // return;
    String content = textEditingController.text.trim();
    if (content.isNotEmpty) {
      focusNode.unfocus();
      widget.ctr.sendMsg(content);
      textEditingController.clear();
    } else {
      SmartDialog.showToast(LocaleKeys.emptyMsg.tr, debounce: true);
      textEditingController.clear();
      return;
    }
  }

  Widget _buildSpecialButton() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);

        final text = textEditingController.text;
        final selection = textEditingController.selection;

        // Insert "**" at the current cursor position
        final newText = text.replaceRange(selection.start, selection.end, '**');

        // Update the text and set the cursor between the two asterisks
        textEditingController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.fromPosition(
            TextPosition(offset: selection.start + 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: 20,
        height: 32,
        child: Center(
          child: Text(
            '*',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showReplyModeDialog() async {
    final mode = widget.ctr.chatMode;
    Widget buildItem({
      required String title,
      bool isSelected = true,
      Function? onTap,
    }) {
      return TapBox(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              height: 55.h,
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.all(Radius.circular(28.r)),
                border: Border.all(
                  color: isSelected ? cTheme.scrim : Color(0xffEFEFEF),
                  width: 1.w,
                ),
              ),
              child: Text(
                title.tr,
                style: tTheme.titleMedium!.copyWith(color: Colors.black),
              ),
            ),
            if (isSelected)
              Positioned(
                right: 0,
                child: Assets.imagesPhCheck2.iv(width: 18.w),
              ),
          ],
        ),
      );
    }

    Future<void> setChatModeAndDismissDialog() async {
      await widget.ctr.setChatMode();
      Get.closeBottomSheet();
    }

    await Get.bottomSheet(
      buildTheme2SheetRootWidget(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              LocaleKeys.replyMode.tv(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              18.verticalSpace,
              Obx(
                () => buildItem(
                  title: LocaleKeys.short,
                  onTap: () {
                    mode.value = ChatMode.short.val;
                    setChatModeAndDismissDialog();
                  },
                  isSelected: mode.value == ChatMode.short.val,
                ),
              ),
              12.verticalSpace,
              Obx(
                () => buildItem(
                  title: LocaleKeys.long,
                  onTap: () {
                    mode.value = ChatMode.long.val;
                    setChatModeAndDismissDialog();
                  },
                  isSelected: mode.value == ChatMode.long.val,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w),
        ),
      ),
      isScrollControlled: true,
    );

    // await showTheme1Sheet(
    //   title: LocaleKeys.responseStyle.tr,
    //   showCancel: false,
    //   child:
    //   SafeArea(
    //     child: Column(
    //       children: [
    //         Obx(
    //           () => buildItem(
    //             title: LocaleKeys.short,
    //             icon: Assets.imagesIgChatSwitchMod,
    //             onTap: () {
    //               mode.value = ChatMode.short.val;
    //               setChatModeAndDismissDialog();
    //             },
    //             isSelected: mode.value == ChatMode.short.val,
    //           ),
    //         ),
    //         12.verticalSpace,
    //         Obx(
    //           () => buildItem(
    //             title: LocaleKeys.long,
    //             icon: Assets.imagesIgChatSwitchMod,
    //             onTap: () {
    //               mode.value = ChatMode.long.val;
    //               setChatModeAndDismissDialog();
    //             },
    //             isSelected: mode.value == ChatMode.long.val,
    //           ),
    //         ),
    //       ],
    //     ).paddingSymmetric(horizontal: 20.w),
    //   ),
    // );
  }
}

class SendButton extends StatelessWidget {
  const SendButton({super.key, required this.onTap, required this.canSend});

  final VoidCallback onTap;
  final bool canSend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: canSend
          ? Assets.imagesPhMsgSend.iv(width: 54.w)
          : Assets.imagesPhMsgSend2.iv(width: 54.w),
    );
  }
}
