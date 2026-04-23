import 'package:novatalk/app/configs/app_config.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/utils/api_svc.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/utils/common_utils.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../../generated/assets.dart';
import '../../../generated/locales.g.dart';
import '../../entities/lang.dart';
import 'a_z_list_cursor.dart';
import 'a_z_list_index_bar.dart';
import 'a_z_list_item_view.dart';
import 'a_z_list_model.dart';

class ChooseLangPage extends StatefulWidget {
  const ChooseLangPage({super.key});

  @override
  State<ChooseLangPage> createState() => _ChooseLangPageState();
}

class _ChooseLangPageState extends State<ChooseLangPage> {
  List<AzListContactModel> contactList = [];

  List<String> get symbols => contactList.map((e) => e.section).toList();

  final indexBarContainerKey = GlobalKey();

  bool isShowListMode = true;

  ValueNotifier<AzListCursorInfoModel?> cursorInfo = ValueNotifier(null);

  double indexBarWidth = 20;

  ScrollController scrollController = ScrollController();

  late SliverObserverController observerController;

  Map<int, BuildContext> sliverContextMap = {};

  var choosedName = ''.obs;
  Lang? selectedLang; // 保存选中的语言对象

  final loader = Loader();

  // 注释掉原有的 generateContactData 方法
  // void generateContactData() {
  //   final a = const Utf8Codec().encode("A").first;
  //   final z = const Utf8Codec().encode("Z").first;
  //   int pointer = a;
  //   while (pointer >= a && pointer <= z) {
  //     final character = const Utf8Codec().decode(Uint8List.fromList([pointer]));
  //     contactList.add(
  //       AzListContactModel(
  //         section: character,
  //         names: List.generate(Random().nextInt(8), (index) {
  //           return '$character-$index';
  //         }),
  //       ),
  //     );
  //     pointer++;
  //   }
  // }

  // 新的 generateContactData 方法，使用 loadAppLangs 获取数据
  Future<void> generateContactData() async {
    try {
      loader.loading();
      if (mounted) {
        setState(() {});
      }
      SmartDialog.showLoading();
      final appLangs = await AppConfig.supportLang.future.timeout(10.seconds);
      SmartDialog.dismiss();

      _buildContactListFromData(appLangs);
      loader.success();
    } catch (e) {
      loader.error();
    }
  }

  // 从数据构建联系人列表的辅助方法
  void _buildContactListFromData(Map<String, dynamic> appLangs) {
    contactList.clear();

    // 遍历每个字母分组
    appLangs.forEach((key, value) {
      if (value is List) {
        List<String> names = [];
        List<Lang> langs = [];

        // 将每个语言项转换为 Lang 对象
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            final lang = Lang.fromJson(item);
            if (lang.label != null) {
              names.add(lang.label!);
              langs.add(lang);
            }
          }
        }

        if (names.isNotEmpty) {
          contactList.add(
            AzListContactModel(section: key, names: names, langList: langs),
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    observerController = SliverObserverController(controller: scrollController);

    _loadLanguageData();
  }

  Future<void> _loadLanguageData() async {
    await generateContactData();

    // 设置默认选中的语言
    _setDefaultSelectedLanguage();

    if (mounted) {
      setState(() {});
    }
  }

  /// 设置默认选中的语言
  Future<void> _setDefaultSelectedLanguage() async {
    try {
      // 使用 UserHelper 的 matchUserLang 方法获取匹配的语言
      final matchedLang = await AppUser.inst.matchUserLang();

      if (matchedLang.label != null) {
        choosedName.value = matchedLang.label!;
        selectedLang = matchedLang;
      }
    } catch (e) {
      goPrint('language error: $e');
    }
  }

  /// 保存按钮点击处理
  void _onSaveButtonTapped() async {
    if (selectedLang != null) {
      SmartDialog.showLoading();

      final isOK = await ApiSvc.updateEventParams(lang: selectedLang?.value);
      if (isOK) {
        AppUser.inst.targetLanguage.value = selectedLang!;
        AppUser.inst.refreshUser();
      }

      SmartDialog.dismiss();

      // 返回上一页
      Get.back(result: selectedLang);
    } else {
      // 可以显示提示信息
      SmartDialog.showToast(LocaleKeys.chooseLang.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildDefaultBg(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: buildBackIcon(color: Colors.black),
          ),
          title: Text(
            LocaleKeys.languageHits.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: cTheme.primary,
                borderRadius: BorderRadius.circular(16.w),
                gradient: LinearGradient(
                  colors: [
                    Color(0xffFBF69A).withValues(alpha: 0.35),
                    Color(0xffF6E961).withValues(alpha: 0.35),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  Assets.imagesPhDing.iv(width: 28.w),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: buildTextSpans(
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            origin: LocaleKeys.langAI.tr,
                            targets: ["@s"],
                            buildTargetTextSpan:
                                (String target, TextStyle? style, int index) {
                                  return TextSpan(
                                    text:
                                        AppUser.inst.targetLanguage.value.label,
                                    style: style?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                          ),
                        ),
                      ),
                      4.verticalSpace,
                      LocaleKeys.saveConfirm.tv(
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!loader.isSuccess)
              SizedBox.shrink()
            else
              Expanded(
                child: Stack(
                  children: [
                    SliverViewObserver(
                      controller: observerController,
                      sliverContexts: () {
                        return sliverContextMap.values.toList();
                      },
                      child: CustomScrollView(
                        key: ValueKey(isShowListMode),
                        controller: scrollController,
                        slivers: [
                          ...contactList.mapIndexed((i, e) {
                            return _buildSliver(index: i, model: e);
                          }),
                          SliverToBoxAdapter(child: Container(height: 140)),
                        ],
                      ),
                    ),
                    _buildCursor(),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: _buildIndexBar(),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildSaveButton(),
                    ),
                  ],
                ).paddingOnly(top: 16.h),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ).copyWith(top: 16, bottom: bottom > 0 ? bottom : 16),
      color: cTheme.surface,
      child: buildTheme3Btn(
        alignment: Alignment.center,
        title: LocaleKeys.save,
        onTap: _onSaveButtonTapped,
      ),
    );
  }

  // SliverToBoxAdapter _buildHeader() {
  //   return SliverToBoxAdapter(
  //     child: Container(
  //       padding: EdgeInsets.all(16),
  //       margin: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         gradient: LinearGradient(
  //           begin: Alignment(-0.8, -0.6), // 约等于 111deg
  //           end: Alignment(0.8, 0.6),
  //           stops: [0.0306, 0.5406, 0.9865],
  //           colors: [
  //             Color(0xFFEAEDFF), // #EAEDFF
  //             Color(0xFFF1E9FF), // #F1E9FF
  //             Color(0xFFF7EAFF), // #F7EAFF
  //           ],
  //         ),
  //       ),
  //       child: Column(
  //         spacing: 8,
  //         crossAxisAlignment: CrossAxisAlignment.start, // align-items: flex-start
  //         children: [
  //           Obx(() {
  //             final language = UserHelper().sessionLang.value;
  //             final name = language?.label ?? 'English';
  //             return RichText(
  //               text: TextSpan(
  //                 children: [
  //                   TextSpan(
  //                     text: LocaleKeys.ai_language_is.tr,
  //                     style: ITStyle.textStyle(14, FontWeight.w500, Colors.black),
  //                   ),
  //                   TextSpan(
  //                     text: ' $name',
  //                     style: ITStyle.textStyle(14, FontWeight.w600, IColor.brand),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }),
  //           Text(
  //             LocaleKeys.save.tr,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCursor() {
    return ValueListenableBuilder<AzListCursorInfoModel?>(
      valueListenable: cursorInfo,
      builder:
          (BuildContext context, AzListCursorInfoModel? value, Widget? child) {
            Widget resultWidget = Container();
            double top = 0;
            double right = indexBarWidth + 8;
            if (value == null) {
              resultWidget = const SizedBox.shrink();
            } else {
              double titleSize = 80;
              top = value.offset.dy - titleSize * 0.5;
              resultWidget = AzListCursor(size: titleSize, title: value.title);
            }
            resultWidget = Positioned(
              top: top,
              right: right,
              child: resultWidget,
            );
            return resultWidget;
          },
    );
  }

  Widget _buildIndexBar() {
    return Container(
      key: indexBarContainerKey,
      width: indexBarWidth,
      alignment: Alignment.center,
      child: AzListIndexBar(
        parentKey: indexBarContainerKey,
        symbols: symbols,
        onSelectionUpdate: (index, cursorOffset) {
          cursorInfo.value = AzListCursorInfoModel(
            title: symbols[index],
            offset: cursorOffset,
          );
          final sliverContext = sliverContextMap[index];
          if (sliverContext == null) return;
          observerController.jumpTo(index: 0, sliverContext: sliverContext);
        },
        onSelectionEnd: () {
          cursorInfo.value = null;
        },
      ),
    );
  }

  Widget _buildSliver({required int index, required AzListContactModel model}) {
    final names = model.names;
    if (names.isEmpty) return const SliverToBoxAdapter();
    Widget resultWidget = SliverList(
      delegate: SliverChildBuilderDelegate((context, itemIndex) {
        if (sliverContextMap[index] == null) {
          sliverContextMap[index] = context;
        }
        return Obx(
          () => Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Color(0xffFAFAFA),
              borderRadius: itemIndex == 0
                  ? BorderRadius.vertical(top: Radius.circular(12.r))
                  : itemIndex == names.length - 1
                  ? BorderRadius.vertical(bottom: Radius.circular(12.r))
                  : null,
            ),
            child: AzListItemView(
              name: names[itemIndex],
              isChoosed: names[itemIndex] == choosedName.value,
              onTap: () {
                choosedName.value = names[itemIndex];
                // 保存选中的语言对象
                if (model.langList != null &&
                    itemIndex < model.langList!.length) {
                  selectedLang = model.langList![itemIndex];
                }
              },
            ),
          ),
        );
      }, childCount: names.length),
    );
    resultWidget = SliverStickyHeader(
      header: Container(
        height: 40.h,
        color: Colors.white,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          model.section,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      sliver: resultWidget,
    );
    return resultWidget;
  }
}
