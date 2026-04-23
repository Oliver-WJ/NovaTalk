import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/utils/common_utils.dart';
import 'app/configs/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'app/utils/storage_util.dart';
import 'app/widgets/common_widget.dart';
import 'generated/locales.g.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

const designSize = Size(375, 812);

Future<void> main() async {
  await init();
  runApp(
    ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: Theme1.lightTheme,
          locale: Locale('en', 'US'),
          translationsKeys: AppTranslation.translations,
          builder: FlutterSmartDialog.init(
            loadingBuilder: (msg) => const SLoading(),
          ),
        );
      },
    ),
  );
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    PaintingBinding.instance.imageCache.maximumSizeBytes = 400 << 20;
    await GetStorage.init(StorageUtils.storeTag);
  } catch (e) {
    goPrint("app error $e");
  }
}
