import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:novatalk/generated/locales.g.dart';

class DownloadUtil {
  static Future<String?> download(
    String url, {
    String folderName = 'voices',
    String ext = '.mp3',
  }) async {
    try {
      // 获取文档目录
      Directory docDir = await getApplicationDocumentsDirectory();
      String folderPath = path.join(docDir.path, folderName);

      // 创建文件夹（如果不存在）
      Directory folder = Directory(folderPath);
      if (!folder.existsSync()) {
        await folder.create(recursive: true);
      }

      // 生成文件路径
      String originalFileName = generateFileNameFromUrl(url);
      String savePath = path.join(folderPath, originalFileName);

      // 获取文件的扩展名
      String fileExtension = path.extension(originalFileName).toLowerCase();

      // 检查文件是否已存在（包括扩展名）
      String fileNameWithoutExtension = path.basenameWithoutExtension(
        originalFileName,
      );
      String targetFilePath = path.join(
        folderPath,
        '$fileNameWithoutExtension$fileExtension',
      );

      // 规范化路径，确保分隔符一致
      targetFilePath = path.normalize(targetFilePath);

      // 检查文件是否存在
      bool fileExists = await File(targetFilePath).exists();
      if (fileExists) {
        return targetFilePath;
      } else {}

      // 文件不存在，执行下载
      Dio dio = Dio();
      if (File(savePath).existsSync()) {
        return savePath;
      }

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // log.d('下载进度：${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      // 重命名文件扩展名为指定格式
      File downloadedFile = File(savePath);
      if (downloadedFile.existsSync()) {
        File newFile = await downloadedFile.rename(targetFilePath);
        return newFile.path;
      }

      return savePath;
    } catch (e) {
      SmartDialog.showNotify(
        msg: LocaleKeys.voiceDownloadFailed.tr,
        notifyType: NotifyType.error,
      );
      return null;
    }
  }

  static String generateFileNameFromUrl(String url) {
    // 对 URL 进行哈希处理，生成一个唯一的文件名
    var bytes = utf8.encode(url); // 将 URL 编码为字节
    var hash = sha256.convert(bytes); // 使用 SHA-256 哈希算法生成哈希值

    // 生成文件名：使用哈希值的前几位加上原文件名
    String fileName = Uri.parse(url).pathSegments.last;
    String hashedFileName = hash.toString().substring(0, 16); // 获取哈希值的前 16 个字符
    return '$hashedFileName-$fileName';
  }

  static Future<String?> downloadVideo(
    String url, {
    String folderName = 'videos',
  }) async {
    try {
      // 获取文档目录
      Directory docDir = await getApplicationDocumentsDirectory();
      String folderPath = path.join(docDir.path, folderName);

      // 创建文件夹（如果不存在）
      Directory folder = Directory(folderPath);
      if (!folder.existsSync()) {
        await folder.create(recursive: true);
      }

      // 从URL中获取原始文件名
      String fileName = Uri.parse(url).pathSegments.last;
      String savePath = path.join(folderPath, fileName);

      // 规范化路径
      savePath = path.normalize(savePath);

      // 检查文件是否已存在
      if (await File(savePath).exists()) {
        return savePath;
      }

      // 下载文件
      Dio dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // log.d('下载进度：${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      return savePath;
    } catch (e) {
      SmartDialog.showNotify(
        msg: LocaleKeys.voiceDownloadFailed.tr,
        notifyType: NotifyType.error,
      );
      return null;
    }
  }
}
