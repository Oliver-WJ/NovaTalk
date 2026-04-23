import 'dart:io';

import 'package:flutter/widgets.dart';

/// 入口方法
void main() {
  for (String folder in [
    // 指定文件夹路径（你的开发机上的绝对路径）
    '/Users/anytalk/Documents/work/AnyTalk/lib/app/entities',
    '/Users/anytalk/Documents/work/AnyTalk/lib/generated/json',
  ]) {
    // 调用替换方法
    replaceField(folder);
  }

  for (String folder in [
    '/Users/anytalk/Documents/work/AnyTalk/lib/app/deploy',
  ]) {
    // 调用替换方法
    for (int i = 0; i <= 4; i++) {
      replacePath(folder);
    }
  }
}

void replaceField(String folderPath) {
  // 替换规则
  final Map<String, String> replacementMap = {
    "acptwg": "total",
    "afszle": "recharge_status",
    "aggclh": "thumbnail_url",
    "ahswqi": "completed",
    "alibmz": "video_message",
    "aqnyom": "cid",
    "avygwz": "style_path",
    "ayfuvp": "retain_text",
    "ayzuvt": "create_time",
    "bafaot": "chat_model",
    "bgwgjc": "translate_answer",
    "bhfncp": "chat",
    "bhiumz": "message",
    "bnhhqt": "generate_image",
    "boumgn": "character_images",
    "bzcrwt": "product_id",
    "bztqwx": "planned_msg_id",
    "caxmhg": "value",
    "caxpzb": "visibility",
    "ccdztr": "report_type",
    "cfvfgh": "profile_change",
    "cgyqcz": "user_id",
    "cjkqld": "type",
    "cluuci": "template_id",
    "codufw": "amount",
    "cppguf": "pages",
    "cqflvo": "lock_level_media",
    "ctywnr": "reward_gems",
    "cyvjxn": "current_value",
    "dapmaz": "nick_name",
    "dblknw": "style",
    "dcnhea": "photo_message",
    "dfeanq": "prompt_description",
    "dgpvix": "generated_images",
    "dhgqal": "scene_change",
    "dhuqop": "chat_video_price",
    "dikskv": "price",
    "dphipm": "create_img",
    "dpixee": "free_overrun",
    "dsmlwn": "ctype",
    "dzudmm": "conv_id",
    "ebvtqe": "source",
    "ejzepw": "profile_id",
    "eonauj": "prompt_name",
    "eqsvud": "describe_img",
    "ezyeuz": "update_time",
    "fklbqc": "nsfw",
    "fwnfym": "is_claimed",
    "fyvtlp": "email",
    "gbdkrl": "gen_photo_tags",
    "gidbev": "hide_character",
    "giecya": "next_msgs",
    "gjhthv": "chat_image_price",
    "glmjqt": "undress_count",
    "glvuwp": "imgs",
    "gomswx": "translate_question",
    "gqegie": "gen_video",
    "gvopnl": "id",
    "hbivcf": "receipt",
    "hlnuiz": "text_message",
    "howjba": "height",
    "hqxjvw": "subscription",
    "hufqqp": "call_ai_characters",
    "hyuvsc": "token",
    "iazfrb": "image_path",
    "ihxpzs": "conversation_id",
    "ilsvgt": "task_description",
    "itpeiv": "last_message",
    "jgwzzw": "order_type",
    "jhigpi": "engine",
    "jhjynm": "session_count",
    "jrvwto": "target_language",
    "jvycdg": "modify_time",
    "jwgogc": "app_user_chat_level",
    "kbylgv": "audit_time",
    "kgzgtk": "gems",
    "krydbo": "visual",
    "kyjplv": "size",
    "kyvpao": "generate_video",
    "lehzos": "device_id",
    "lghlhj": "cname",
    "lmuhfj": "voice_duration",
    "lnxhor": "subscription_end",
    "lossxn": "gen_photo",
    "lqoyln": "nickname",
    "lzffko": "gender",
    "mauxph": "media_text",
    "mcdded": "activate",
    "mcguud": "age_min",
    "mdzrfn": "task_id",
    "mhnryf": "password",
    "mszrkv": "uid",
    "nfbczo": "url",
    "nlptjb": "trigger_genimg",
    "ntunof": "vip",
    "ochkda": "age",
    "odgubj": "style_type",
    "oiywgb": "current",
    "ojrnnc": "order_no",
    "olrapr": "lora_strength",
    "opoayg": "deserved_gems",
    "oquhod": "change_clothing",
    "orktsf": "results",
    "otvvvk": "task_name",
    "owbehl": "name",
    "patlws": "currency_symbol",
    "pipnwp": "new_user",
    "plgbpf": "title",
    "pmhcpn": "dynamic_encry_time",
    "qdhual": "lock_level",
    "qefhnj": "audit_status",
    "qgszqb": "characterId",
    "qjluxz": "free_message",
    "qjuvio": "character_name",
    "qprizn": "video_chat",
    "qrpdtl": "greetings",
    "qwggzm": "gtype",
    "qwrehy": "sign",
    "qzntlk": "about_me",
    "qzytfj": "time_need",
    "rdzfsp": "task_type",
    "rewnao": "idfa",
    "rgfezr": "enable_auto_translate",
    "rhikmc": "page",
    "rpjogb": "age_max",
    "rtapln": "model_id",
    "runesd": "audio_message",
    "rvnyoq": "source_language",
    "rxmtro": "render_style",
    "ryzkfw": "character_video_chat",
    "rzzowb": "creation_id",
    "sbpznr": "character_id",
    "sczrbl": "order_num",
    "seqzgz": "original_transaction_id",
    "slepwt": "pay",
    "sltzds": "msg_id",
    "sqvisf": "question",
    "svfofe": "greetings_voice",
    "swyowa": "taskId",
    "sycdnf": "upgrade",
    "tggeyf": "fileMd5",
    "tgvaxn": "dynamic_encry_status",
    "thxczo": "tags",
    "tvvwul": "signature",
    "ubgqqw": "adid",
    "ucnddq": "shelving",
    "udslyd": "price",
    "ufampc": "style_id",
    "uhxyfg": "reward",
    "untwgf": "prompt",
    "urntju": "key",
    "usergc": "likes",
    "vbewcg": "approved_character_id",
    "vgiefy": "video_unlock",
    "vkalre": "answer",
    "vowirg": "gname",
    "vpjbhp": "more_details",
    "vrjhvc": "platform",
    "vtyqus": "scene",
    "vvsfdz": "estimated_time",
    "vwekui": "currency_code",
    "vxjoas": "records",
    "vzdodm": "level",
    "wcqhbw": "rewards",
    "wfsqmx": "voice_url",
    "wtrxui": "unlock_card_num",
    "wuicwn": "lora_path",
    "wwgode": "transaction_id",
    "xablal": "result_path",
    "xbizbm": "gen_img_id",
    "xhdlux": "card_num",
    "xhhvsv": "create_video",
    "xnpocb": "media",
    "xomvws": "chat_audio_price",
    "xrmbbt": "voice_id",
    "ybndoo": "target_value",
    "ybsgyd": "avatar",
    "ydihlu": "duration",
    "yedbbg": "choose_env",
    "yepkvm": "safety_level",
    "yffewq": "visual_style",
    "yghpfa": "auto_translate",
    "yphuyb": "ids",
    "zcjvux": "generated_status",
    "zgrvjs": "reply_suggestions_enabled",
    "zihdgv": "is_completed",
    "zjdbmp": "lora_model",
    "zkoojf": "source_message_id",
  };

  // 获取文件夹
  final Directory directory = Directory(folderPath);
  if (!directory.existsSync()) {
    debugPrint('文件夹不存在: $folderPath');
    return;
  }
  final List<FileSystemEntity> files = directory.listSync();

  for (final FileSystemEntity entity in files) {
    if (entity is File) {
      String fileContent = entity.readAsStringSync();

      // 使用简单的字符串替换来避免正则表达式格式化问题
      String replacedContent = fileContent;

      // 遍历所有需要替换的值
      for (final entry in replacementMap.entries) {
        final String oldKey = entry.key;
        final String newValue = entry.value;

        replacedContent = replacedContent.replaceAll(
          '"$newValue"',
          '"$oldKey"',
        );
        // 替换 JSON 对象中的键名: "key": value
        replacedContent = replacedContent.replaceAll(
          '"$newValue":',
          '"$oldKey":',
        );

        // 替换 JSON 访问: json['key'] 和 json["key"]
        replacedContent = replacedContent.replaceAll(
          "json['$newValue']",
          "json['$oldKey']",
        );
        replacedContent = replacedContent.replaceAll(
          'json["$newValue"]',
          'json["$oldKey"]',
        );

        // 替换 Map 字面量中的键名: 'key': value 和 "key": value
        replacedContent = replacedContent.replaceAll(
          "'$newValue':",
          "'$oldKey':",
        );
        replacedContent = replacedContent.replaceAll(
          '"$newValue":',
          '"$oldKey":',
        );
      }

      entity.writeAsStringSync(replacedContent);
      debugPrint('文件已成功替换: ${entity.path}');
    }
  }
}

void replacePath(String folderPath) {
  // 替换规则
  final Map<String, String> replacementMap = {
    "abtlvw": "history",
    "aeqlkj": "translate",
    "aeuyiq": "register",
    "amrtlx": "aiChatConversation",
    "bvgapj": "price",
    "bxrfyi": "getUndressWith",
    "byvxwy": "getClothingConf",
    "ccivys": "setChatBackground",
    "cejluy": "getChatLevel",
    "coprhk": "getGenerateImageResult",
    "dkwgzg": "randomName",
    "dmibym": "daily-quests",
    "dpcwqt": "creationCharacter",
    "drxgcs": "claim",
    "drzvcm": "save",
    "ecqzmo": "aiPhoto",
    "ehvxxo": "voices",
    "emfhaw": "user",
    "esdfor": "aiWrite",
    "euexje": "subscriptionTransactions",
    "fcsurw": "getAll",
    "fmjppk": "undressResult",
    "fssvhy": "message",
    "geyhub": "creationMoreDetails",
    "gfnnvm": "switch",
    "gpxnto": "userProfile",
    "gqqvwj": "completed",
    "grpjkq": "getUndressWithResult",
    "gyojqs": "appUser",
    "hjdvac": "delete",
    "hpawwb": "getByRole",
    "irimec": "getUndressResult",
    "itxups": "saveMessage",
    "iunosi": "create",
    "jmitcr": "consumption",
    "kgcxap": "chatSwitch",
    "kjccxq": "gift",
    "krzfyw": "getGiftConf",
    "laomvn": "undressOutcome",
    "lrdnsr": "creationStyleOptions",
    "ltotew": "editMsg",
    "mhjyci": "upinfo",
    "mjtrzc": "progress",
    "mvoyqy": "api",
    "nmlgjl": "info",
    "npiovs": "undress",
    "npqrqb": "system",
    "ntljag": "unlockDynamicVideo",
    "nujdmk": "getGenImg",
    "osktkx": "safety-level",
    "oxtjlp": "getRecommendRole",
    "pmdlzw": "platformConfig",
    "qswmak": "appUserReport",
    "qyyovj": "config",
    "rayucu": "clothes",
    "rcwihm": "unlock",
    "rrylgo": "deleteMessage",
    "senapf": "generateImage",
    "skpycm": "subscription",
    "slioji": "lang",
    "sppkdb": "characterProfile",
    "staqzx": "assets",
    "styixb": "getUndressWithVideoResult",
    "tdqztd": "getGenerateImagePrice",
    "tqlzuc": "characters",
    "tztaeu": "selectGenImg",
    "uimqvj": "chatLevelConf",
    "upqrrk": "rechargeOrders",
    "uptths": "roleplay",
    "uryqll": "randomOne",
    "usqvqr": "pay",
    "vclnmb": "onboarding",
    "vradcm": "emotionRetain",
    "wedely": "giveVip",
    "werbrc": "gems",
    "wgxzqj": "insert",
    "wytagr": "saveFirebaseToken",
    "xhjazt": "replySuggestions",
    "xnnobj": "verify",
    "xnnroy": "noDressHis",
    "xvtkth": "google",
    "yiffqn": "gen",
    "yiovaq": "getUndressWithVideo",
    "ykehxo": "noDress",
    "ynpaqc": "characterMedia",
    "yrwaxg": "isNaked",
    "ztgytu": "getStyleConfig",
    "zudinp": "conversation",
  };

  // 获取文件夹
  final Directory directory = Directory(folderPath);
  if (!directory.existsSync()) {
    print('文件夹不存在: $folderPath');
    return;
  }
  final List<FileSystemEntity> files = directory.listSync();
  for (final FileSystemEntity entity in files) {
    if (entity is File) {
      String fileContent = entity.readAsStringSync();

      // 使用正则替换内容
      final regex = RegExp('["\'](.*?)["\']');
      final String replacedContent = regex.allMatches(fileContent).fold(
        fileContent,
        (String content, Match match) {
          final String matchString = match.group(1)!;
          replacementMap.forEach((key, value) {
            RegExp regex = RegExp('\\b${RegExp.escape(value)}\\b');
            if (matchString.contains("/$value/")) {
              content = content.replaceAll(
                matchString,
                matchString.replaceFirst("/$value/", "/$key/"),
              );
            } else if (regex.hasMatch(matchString)) {
              content = content.replaceAll(
                matchString,
                matchString.replaceFirst(value, key),
              );
            }
          });
          return content;
        },
      );
      entity.writeAsStringSync(replacedContent);
      print('文件已成功替换: ${entity.path}');
    }
  }
}
