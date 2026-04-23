import 'dart:convert';

class MsgAnswer {
  final String? convId;
  final String? msgId;
  final Answer? answer;

  MsgAnswer({
    this.convId,
    this.msgId,
    this.answer,
  });

  factory MsgAnswer.fromRawJson(String str) => MsgAnswer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MsgAnswer.fromJson(Map<String, dynamic> json) => MsgAnswer(
        convId: json['conv_ident'],
        msgId: json['msg_identifier'],
        answer: json['answer'] == null ? null : Answer.fromJson(json['answer']),
      );

  Map<String, dynamic> toJson() => {
        'conv_ident': convId,
        'msg_identifier': msgId,
        'answer': answer?.toJson(),
      };
}

class Answer {
  final String? content;
  final String? src;
  final String? lockLvl;
  final String? lockMed;
  final String? voiceUrl;
  final int? voiceDur;
  final String? resUrl;
  final int? dur;
  final String? thumbUrl;

  Answer({
    this.content,
    this.src,
    this.lockLvl,
    this.lockMed,
    this.voiceUrl,
    this.voiceDur,
    this.resUrl,
    this.dur,
    this.thumbUrl,
  });

  factory Answer.fromRawJson(String str) => Answer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        content: json['content'],
        src: json['src_plat'],
        lockLvl: json['lock_lvl'],
        lockMed: json['lock_lvl_media'],
        voiceUrl: json['voice_link'],
        voiceDur: json['voice_dur'],
        resUrl: json['web_link'],
        dur: json['dur'],
        thumbUrl: json['thumb_link'],
      );

  Map<String, dynamic> toJson() => {
        'content': content,
        'src_plat': src,
        'lock_lvl': lockLvl,
        'lock_lvl_media': lockMed,
        'voice_link': voiceUrl,
        'voice_dur': voiceDur,
        'web_link': resUrl,
        'dur': dur,
        'thumb_link': thumbUrl,
      };
}
