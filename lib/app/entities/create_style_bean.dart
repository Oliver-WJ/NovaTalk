import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/create_style_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/create_style_bean.g.dart';

@JsonSerializable()
class CreateStyleBean {
  int? id;
  String? name;
  String? remark;
  String? cover;
  @JSONField(name: 'style_type')
  int? styleType;
  @JSONField(name: 'model_name')
  String? modelName;
  @JSONField(name: 'lora_model')
  String? loraModel;
  @JSONField(name: 'lora_strength')
  int? loraStrength;
  @JSONField(name: 'lora_path')
  String? loraPath;
  @JSONField(name: 'order_num')
  int? orderNum;
  String? platform;
  @JSONField(name: 'create_time')
  String? createTime;
  @JSONField(name: 'update_time')
  String? updateTime;
  bool? del;

  CreateStyleBean();

  factory CreateStyleBean.fromJson(Map<String, dynamic> json) =>
      $CreateStyleBeanFromJson(json);

  Map<String, dynamic> toJson() => $CreateStyleBeanToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateStyleBean &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
