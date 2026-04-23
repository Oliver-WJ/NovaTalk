import 'package:novatalk/app/utils/api_svc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../../entities/gen_photo_result_bean.dart';

class CreationsController extends GetxController {
  List<GenPhotoResultBean> creations = [];

  @override
  void onInit() {
    super.onInit();
    SmartDialog.showLoading(clickMaskDismiss: true);
    ApiSvc.getCreations().then((v){
      SmartDialog.dismiss();
      creations = v;
      update();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
