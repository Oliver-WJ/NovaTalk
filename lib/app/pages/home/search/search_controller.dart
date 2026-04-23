import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/pages/home/home_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:novatalk/app/widgets/common_widget.dart';

import '../../../utils/common_utils.dart';

class SearchController extends GetxController {
  //TODO: Implement SearchController

  final count = 0.obs;

  var searchController = TextEditingController();

  var roleContentController = PageLoadRoleController();

  final IntervalDo intervalDo = IntervalDo();

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      String value = searchController.value.text.trim();
      if (value.isEmpty) return;
      intervalDo.drop(
        fun: () {
          onSubmitted(searchController.value.text);
        },
        milliseconds: 700,
      );
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();
    intervalDo.cancel();
    roleContentController.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> onSubmitted(String value) async {
    if (value.isVoid) return;
    SmartDialog.showLoading();
    roleContentController.name = value;
    roleContentController.tagIds=[];
    await roleContentController.onRefresh();
    SmartDialog.dismiss();
  }
}
