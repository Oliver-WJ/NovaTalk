import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/prompt_bean.dart';

PromptBean $PromptBeanFromJson(Map<String, dynamic> json) {
  final PromptBean promptBean = PromptBean();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    promptBean.id = id;
  }
  final String? titleEn = jsonConvert.convert<String>(json['title_en']);
  if (titleEn != null) {
    promptBean.titleEn = titleEn;
  }
  final String? titleCn = jsonConvert.convert<String>(json['title_cn']);
  if (titleCn != null) {
    promptBean.titleCn = titleCn;
  }
  final String? category = jsonConvert.convert<String>(json['category']);
  if (category != null) {
    promptBean.category = category;
  }
  final String? prompt = jsonConvert.convert<String>(json['prompt']);
  if (prompt != null) {
    promptBean.prompt = prompt;
  }
  return promptBean;
}

Map<String, dynamic> $PromptBeanToJson(PromptBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['title_en'] = entity.titleEn;
  data['title_cn'] = entity.titleCn;
  data['category'] = entity.category;
  data['prompt'] = entity.prompt;
  return data;
}

extension PromptBeanExtension on PromptBean {
  PromptBean copyWith({
    int? id,
    String? titleEn,
    String? titleCn,
    String? category,
    String? prompt,
  }) {
    return PromptBean()
      ..id = id ?? this.id
      ..titleEn = titleEn ?? this.titleEn
      ..titleCn = titleCn ?? this.titleCn
      ..category = category ?? this.category
      ..prompt = prompt ?? this.prompt;
  }
}