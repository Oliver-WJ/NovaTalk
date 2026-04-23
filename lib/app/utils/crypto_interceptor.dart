import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../configs/app_config.dart';
import 'common_utils.dart';
import 'cryptography.dart';

class CryptoInterceptor extends Interceptor {
  void _log(dynamic content) {
    goPrint(content);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // 1. 加密 URL（路径和查询参数）
      final encryptedUrl = Cryptology.encryptUrl(
        originalUrl: options.uri.toString(),
        prefix: AppConfig.prefix,
      );
      final newUri = Uri.parse(encryptedUrl);
      options.path = newUri.path;
      // 2. 加密请求体参数（data）

      if (options.contentType == 'multipart/form-data') {
      } else {
        options.data = Cryptology.encryptParams(options.data);
      }
      options.queryParameters={};
      super.onRequest(options, handler);
    } catch (e) {
      // 加密失败时抛出错误
      handler.reject(
        DioException(
          requestOptions: options,
          message: "onRequest Error: $e",
        ),
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      final decryptedData = Cryptology.decryptAES(response.data); // 实际需替换为对称解密
      final jsonData = await compute(json.decode, decryptedData);
      response.data = jsonData;

      super.onResponse(response, handler);
    } catch (e, stackTrace) {

      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: e,
          message: "onResponse error: $e",
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 打印原始错误响应数据
    _log("onError: ${err.response?.data}");
    super.onError(err, handler);
  }
}
