import 'package:flutter/material.dart';

import '../../entities/lang.dart';

class AzListContactModel {
  final String section;
  final List<String> names;
  final List<Lang>? langList; // 添加 language 属性来保存语言数据

  AzListContactModel({
    required this.section,
    required this.names,
    this.langList,
  });
}

class AzListCursorInfoModel {
  final String title;
  final Offset offset;

  AzListCursorInfoModel({
    required this.title,
    required this.offset,
  });
}
