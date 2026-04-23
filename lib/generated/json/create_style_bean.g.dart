import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/create_style_bean.dart';

CreateStyleBean $CreateStyleBeanFromJson(Map<String, dynamic> json) {
  final CreateStyleBean createStyleBean = CreateStyleBean();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    createStyleBean.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    createStyleBean.name = name;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    createStyleBean.remark = remark;
  }
  final String? cover = jsonConvert.convert<String>(json['cover']);
  if (cover != null) {
    createStyleBean.cover = cover;
  }
  final int? styleType = jsonConvert.convert<int>(json['style_type']);
  if (styleType != null) {
    createStyleBean.styleType = styleType;
  }
  final String? modelName = jsonConvert.convert<String>(json['model_name']);
  if (modelName != null) {
    createStyleBean.modelName = modelName;
  }
  final String? loraModel = jsonConvert.convert<String>(json['lora_model']);
  if (loraModel != null) {
    createStyleBean.loraModel = loraModel;
  }
  final int? loraStrength = jsonConvert.convert<int>(json['lora_strength']);
  if (loraStrength != null) {
    createStyleBean.loraStrength = loraStrength;
  }
  final String? loraPath = jsonConvert.convert<String>(json['lora_path']);
  if (loraPath != null) {
    createStyleBean.loraPath = loraPath;
  }
  final int? orderNum = jsonConvert.convert<int>(json['order_num']);
  if (orderNum != null) {
    createStyleBean.orderNum = orderNum;
  }
  final String? platform = jsonConvert.convert<String>(json['platform']);
  if (platform != null) {
    createStyleBean.platform = platform;
  }
  final String? createTime = jsonConvert.convert<String>(json['create_time']);
  if (createTime != null) {
    createStyleBean.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['update_time']);
  if (updateTime != null) {
    createStyleBean.updateTime = updateTime;
  }
  final bool? del = jsonConvert.convert<bool>(json['del']);
  if (del != null) {
    createStyleBean.del = del;
  }
  return createStyleBean;
}

Map<String, dynamic> $CreateStyleBeanToJson(CreateStyleBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['remark'] = entity.remark;
  data['cover'] = entity.cover;
  data['style_type'] = entity.styleType;
  data['model_name'] = entity.modelName;
  data['lora_model'] = entity.loraModel;
  data['lora_strength'] = entity.loraStrength;
  data['lora_path'] = entity.loraPath;
  data['order_num'] = entity.orderNum;
  data['platform'] = entity.platform;
  data['create_time'] = entity.createTime;
  data['update_time'] = entity.updateTime;
  data['del'] = entity.del;
  return data;
}

extension CreateStyleBeanExtension on CreateStyleBean {
  CreateStyleBean copyWith({
    int? id,
    String? name,
    String? remark,
    String? cover,
    int? styleType,
    String? modelName,
    String? loraModel,
    int? loraStrength,
    String? loraPath,
    int? orderNum,
    String? platform,
    String? createTime,
    String? updateTime,
    bool? del,
  }) {
    return CreateStyleBean()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..remark = remark ?? this.remark
      ..cover = cover ?? this.cover
      ..styleType = styleType ?? this.styleType
      ..modelName = modelName ?? this.modelName
      ..loraModel = loraModel ?? this.loraModel
      ..loraStrength = loraStrength ?? this.loraStrength
      ..loraPath = loraPath ?? this.loraPath
      ..orderNum = orderNum ?? this.orderNum
      ..platform = platform ?? this.platform
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..del = del ?? this.del;
  }
}