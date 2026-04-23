import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/und_style_bean.dart';

UndStyleBean $UndStyleBeanFromJson(Map<String, dynamic> json) {
  final UndStyleBean undStyleBean = UndStyleBean();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    undStyleBean.name = name;
  }
  final String? style = jsonConvert.convert<String>(json['style']);
  if (style != null) {
    undStyleBean.style = style;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    undStyleBean.url = url;
  }
  final String? icon = jsonConvert.convert<String>(json['icon']);
  if (icon != null) {
    undStyleBean.icon = icon;
  }
  final String? price = jsonConvert.convert<String>(json['price']);
  if (price != null) {
    undStyleBean.price = price;
  }
  return undStyleBean;
}

Map<String, dynamic> $UndStyleBeanToJson(UndStyleBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['style'] = entity.style;
  data['url'] = entity.url;
  data['icon'] = entity.icon;
  data['price'] = entity.price;
  return data;
}

extension UndStyleBeanExtension on UndStyleBean {
  UndStyleBean copyWith({
    String? name,
    String? style,
    String? url,
    String? icon,
    String? price,
  }) {
    return UndStyleBean()
      ..name = name ?? this.name
      ..style = style ?? this.style
      ..url = url ?? this.url
      ..icon = icon ?? this.icon
      ..price = price ?? this.price;
  }
}