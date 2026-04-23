import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart' ;

import '../configs/app_config.dart';
import 'common_utils.dart';

class Cryptology {
  Cryptology._();


  /// 加密（输出 Hex）
  static String encryptAES(String content) {
    goPrint('---origin---: $content');
    if (content.isEmpty) return content;
    try {
      final encrypter = Encrypter(AES(AppConfig.cryptology_key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(content, iv: AppConfig.cryptology_iv);
      var h= hex.encode(encrypted.bytes); // 输出十六进制
      decryptAES(h);
      return h;
    } catch (e) {
      throw Exception("AES encrypt error: $e");
    }
  }

  /// 解密（输入 Hex）
  static String decryptAES(String encryptedHex) {
    goPrint('Needs decrypt: $encryptedHex');
    if (encryptedHex.isEmpty) return encryptedHex;
    try {
      final encrypter = Encrypter(AES(AppConfig.cryptology_key, mode: AESMode.cbc));

      // hex.decode() → List<int> → 转为 Uint8List
      final bytes = Uint8List.fromList(hex.decode(encryptedHex));

      final decrypted = encrypter.decrypt(Encrypted(bytes), iv: AppConfig.cryptology_iv);
      goPrint('---decrypted---: $decrypted');
      return decrypted;
    } catch (e) {
      goPrint('---AES decrypt Error:---: $e');
      throw Exception("AES decrypt error: $e");
    }
  }

  // 其他方法（encryptParams、encryptUrl 等保持不变，复用之前的逻辑）
  static dynamic encryptParams(dynamic params) {
    if (params == null) return null;
    if (params is String) {
      return encryptAES(params);
    } else if (params is Map) {
      var jsonString = json.encode(params);
      return encryptAES(jsonString);
    } else if (params is List) {
      var jsonString = json.encode(params);
      return encryptAES(jsonString);
    } else {
      return params;
    }
  }

  static String encryptUrl({
    required String originalUrl,
    String prefix = '',
  }) {
    final uri = Uri.parse(originalUrl);
    // 1. 构建原始路径 + 查询参数的完整路径用于加密
    final originalPathWithQuery =
        '${uri.path}${uri.query.isNotEmpty ? '?${uri.query}' : ''}';

    // 2. 加密整个路径（包括查询参数）
    final encryptedPathContent = originalPathWithQuery.isNotEmpty
        ? encryptAES(originalPathWithQuery)
        : '';

    // 3. 构建新 URL (域名 + /prefix/加密内容)
    final newUri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: '/$prefix/$encryptedPathContent',
    );

    return newUri.toString();
  }
}
