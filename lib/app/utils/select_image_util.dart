import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:novatalk/generated/locales.g.dart';

import '../widgets/common_widget.dart';

class SelectImageUtil {
  static Future<String?> selectImage({
    double? width,
    double? height,
    double? ratioX,
    double? ratioY,
    bool noticePermissions = true,
    ImageSource source = ImageSource.gallery,
    bool crop = true,
    bool base64Img = false,
  }) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image;
    String? path;
    try {
      image = await imagePicker.pickImage(source: source);
    } catch (e) {
      image = null;
      path = '';
    }
    if (image == null) {
      return path;
    }
    if (crop == false) {
      return image.path;
    }
    if (base64Img) {
      Uint8List? originalImage = await imageToJpeg(image.path);
      if (originalImage == null) {
        return null;
      }
      return base64Encode(originalImage);
    }
    return Future.delayed(const Duration(milliseconds: 200), () async {
      return await cropImage(
        image: image!.path,
        width: width,
        height: height,
        ratioX: ratioX,
        ratioY: ratioY,
      );
    });
  }

  ///裁切图片
  ///[image] 图片路径或文件
  ///[width] 宽度
  ///[height] 高度
  ///[aspectRatio] 比例
  ///[androidUiSettings]UI 参数
  ///[iOSUiSettings] ios的ui 参数
  static Future<String?> cropImage({
    required image,
    double? width,
    double? height,
    double? ratioX,
    double? ratioY,
    androidUiSettings,
    iOSUiSettings,
  }) async {
    String imagePth = "";
    if (image is String) {
      imagePth = image;
    } else if (image is File) {
      imagePth = image.path;
    } else {
      throw (LocaleKeys.pathIncorrect.tr);
    }
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePth,
      maxWidth: width?.toInt(),
      maxHeight: height?.toInt(),
      aspectRatio: CropAspectRatio(
        ratioX: ratioX ?? 1.0,
        ratioY: ratioY ?? 1.0,
      ),
      uiSettings: [
        androidUiSettings ??
            AndroidUiSettings(
              toolbarTitle: LocaleKeys.crop.tr,
              toolbarColor: '#5DC0C1'.hex(),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              hideBottomControls: false,
              showCropGrid: false,
              activeControlsWidgetColor: '#5DC0C1'.hex(),
              lockAspectRatio: true,
            ),
        iOSUiSettings ??
            IOSUiSettings(
              title: LocaleKeys.crop.tr,
              doneButtonTitle: LocaleKeys.done.tr,
              cancelButtonTitle: LocaleKeys.cancel.tr,
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
              rotateClockwiseButtonHidden: true,
            ),
      ],
    );
    if (croppedFile != null) {
      return croppedFile.path;
    }
    return null;
  }

  // 图片转成jpegr然后再转换成base64
  static Future<Uint8List?> imageToJpeg(String imagePath) async {
    SmartDialog.showLoading();
    final File imageFile = File(imagePath);
    final Uint8List imageBytes = await imageFile.readAsBytes();
    if (imageBytes.length / 1024 > (1024 * 4)) {
      SmartDialog.showToast('smaller sized');
      return null;
    }
    // 将图片转换为Image对象
    final img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      SmartDialog.showToast(LocaleKeys.laterTry.tr);
      return null;
    }
    if (image.width < 512 || image.height < 512) {
      SmartDialog.showToast('larger sized');
      return null;
    }
    // 初始质量设为最高
    int quality = 100;
    // compute：在隔离的 isolate 中执行耗时的操作，从而避免阻塞主线程。
    Uint8List jpegBytes = await compute(encodeJpg, [image, quality]);
    // 计算图片大小
    final double sizeInKB = jpegBytes.length / 1024;
    if (sizeInKB > (1024 * 4)) {
      SmartDialog.showToast('smaller sized');
      return null;
    }
    if (sizeInKB > 500) {
      await Future.doWhile(() async {
        // 使用当前质量压缩图片
        jpegBytes = await compute(encodeJpg, [image, quality]);
        // 减少质量
        quality -= 1;
        return jpegBytes.length > 600 * 1024 && quality > 0;
      });
    }
    SmartDialog.dismiss();
    return jpegBytes;
  }

  static Uint8List encodeJpg(List<dynamic> args) {
    img.Image image = args[0];
    int quality = args[1];
    return img.encodeJpg(image, quality: quality);
  }
}
