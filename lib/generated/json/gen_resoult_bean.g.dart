import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/gen_resoult_bean.dart';

GenResultBean $GenResultBeanFromJson(Map<String, dynamic> json) {
  final GenResultBean genResultBean = GenResultBean();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    genResultBean.id = id;
  }
  final int? creationId = jsonConvert.convert<int>(json['creationId']);
  if (creationId != null) {
    genResultBean.creationId = creationId;
  }
  final int? age = jsonConvert.convert<int>(json['age']);
  if (age != null) {
    genResultBean.age = age;
  }
  final String? height = jsonConvert.convert<String>(json['height']);
  if (height != null) {
    genResultBean.height = height;
  }
  final String? gender = jsonConvert.convert<String>(json['gender']);
  if (gender != null) {
    genResultBean.gender = gender;
  }
  final int? styleId = jsonConvert.convert<int>(json['styleId']);
  if (styleId != null) {
    genResultBean.styleId = styleId;
  }
  final bool? nsfw = jsonConvert.convert<bool>(json['nsfw']);
  if (nsfw != null) {
    genResultBean.nsfw = nsfw;
  }
  final List<GenResoultMoreDetails>? moreDetails = (json['moreDetails'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<GenResoultMoreDetails>(e) as GenResoultMoreDetails)
      .toList();
  if (moreDetails != null) {
    genResultBean.moreDetails = moreDetails;
  }
  final String? describeImg = jsonConvert.convert<String>(json['describeImg']);
  if (describeImg != null) {
    genResultBean.describeImg = describeImg;
  }
  final String? prompt = jsonConvert.convert<String>(json['prompt']);
  if (prompt != null) {
    genResultBean.prompt = prompt;
  }
  final String? imgs = jsonConvert.convert<String>(json['imgs']);
  if (imgs != null) {
    genResultBean.imgs = imgs;
  }
  final String? platform = jsonConvert.convert<String>(json['platform']);
  if (platform != null) {
    genResultBean.platform = platform;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    genResultBean.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    genResultBean.updateTime = updateTime;
  }
  final bool? del = jsonConvert.convert<bool>(json['del']);
  if (del != null) {
    genResultBean.del = del;
  }
  return genResultBean;
}

Map<String, dynamic> $GenResultBeanToJson(GenResultBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['creationId'] = entity.creationId;
  data['age'] = entity.age;
  data['height'] = entity.height;
  data['gender'] = entity.gender;
  data['styleId'] = entity.styleId;
  data['nsfw'] = entity.nsfw;
  data['moreDetails'] = entity.moreDetails?.map((v) => v.toJson()).toList();
  data['describeImg'] = entity.describeImg;
  data['prompt'] = entity.prompt;
  data['imgs'] = entity.imgs;
  data['platform'] = entity.platform;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['del'] = entity.del;
  return data;
}

extension GenResultBeanExtension on GenResultBean {
  GenResultBean copyWith({
    int? id,
    int? creationId,
    int? age,
    String? height,
    String? gender,
    int? styleId,
    bool? nsfw,
    List<GenResoultMoreDetails>? moreDetails,
    String? describeImg,
    String? prompt,
    String? imgs,
    String? platform,
    String? createTime,
    String? updateTime,
    bool? del,
  }) {
    return GenResultBean()
      ..id = id ?? this.id
      ..creationId = creationId ?? this.creationId
      ..age = age ?? this.age
      ..height = height ?? this.height
      ..gender = gender ?? this.gender
      ..styleId = styleId ?? this.styleId
      ..nsfw = nsfw ?? this.nsfw
      ..moreDetails = moreDetails ?? this.moreDetails
      ..describeImg = describeImg ?? this.describeImg
      ..prompt = prompt ?? this.prompt
      ..imgs = imgs ?? this.imgs
      ..platform = platform ?? this.platform
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..del = del ?? this.del;
  }
}

GenResoultMoreDetails $GenResoultMoreDetailsFromJson(
    Map<String, dynamic> json) {
  final GenResoultMoreDetails genResoultMoreDetails = GenResoultMoreDetails();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    genResoultMoreDetails.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    genResoultMoreDetails.name = name;
  }
  final List<GenResoultMoreDetailsTags>? tags = (json['tags'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<GenResoultMoreDetailsTags>(
          e) as GenResoultMoreDetailsTags)
      .toList();
  if (tags != null) {
    genResoultMoreDetails.tags = tags;
  }
  final bool? required = jsonConvert.convert<bool>(json['required']);
  if (required != null) {
    genResoultMoreDetails.required = required;
  }
  final String? defaultValue = jsonConvert.convert<String>(
      json['defaultValue']);
  if (defaultValue != null) {
    genResoultMoreDetails.defaultValue = defaultValue;
  }
  final int? orderNum = jsonConvert.convert<int>(json['orderNum']);
  if (orderNum != null) {
    genResoultMoreDetails.orderNum = orderNum;
  }
  final String? platform = jsonConvert.convert<String>(json['platform']);
  if (platform != null) {
    genResoultMoreDetails.platform = platform;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    genResoultMoreDetails.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    genResoultMoreDetails.updateTime = updateTime;
  }
  final bool? del = jsonConvert.convert<bool>(json['del']);
  if (del != null) {
    genResoultMoreDetails.del = del;
  }
  return genResoultMoreDetails;
}

Map<String, dynamic> $GenResoultMoreDetailsToJson(
    GenResoultMoreDetails entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['tags'] = entity.tags?.map((v) => v.toJson()).toList();
  data['required'] = entity.required;
  data['defaultValue'] = entity.defaultValue;
  data['orderNum'] = entity.orderNum;
  data['platform'] = entity.platform;
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['del'] = entity.del;
  return data;
}

extension GenResoultMoreDetailsExtension on GenResoultMoreDetails {
  GenResoultMoreDetails copyWith({
    int? id,
    String? name,
    List<GenResoultMoreDetailsTags>? tags,
    bool? required,
    String? defaultValue,
    int? orderNum,
    String? platform,
    String? createTime,
    String? updateTime,
    bool? del,
  }) {
    return GenResoultMoreDetails()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..tags = tags ?? this.tags
      ..required = required ?? this.required
      ..defaultValue = defaultValue ?? this.defaultValue
      ..orderNum = orderNum ?? this.orderNum
      ..platform = platform ?? this.platform
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..del = del ?? this.del;
  }
}

GenResoultMoreDetailsTags $GenResoultMoreDetailsTagsFromJson(
    Map<String, dynamic> json) {
  final GenResoultMoreDetailsTags genResoultMoreDetailsTags = GenResoultMoreDetailsTags();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    genResoultMoreDetailsTags.id = id;
  }
  final String? label = jsonConvert.convert<String>(json['label']);
  if (label != null) {
    genResoultMoreDetailsTags.label = label;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    genResoultMoreDetailsTags.value = value;
  }
  return genResoultMoreDetailsTags;
}

Map<String, dynamic> $GenResoultMoreDetailsTagsToJson(
    GenResoultMoreDetailsTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['label'] = entity.label;
  data['value'] = entity.value;
  return data;
}

extension GenResoultMoreDetailsTagsExtension on GenResoultMoreDetailsTags {
  GenResoultMoreDetailsTags copyWith({
    String? id,
    String? label,
    String? value,
  }) {
    return GenResoultMoreDetailsTags()
      ..id = id ?? this.id
      ..label = label ?? this.label
      ..value = value ?? this.value;
  }
}