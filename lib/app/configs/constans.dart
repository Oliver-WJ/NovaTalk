import 'package:novatalk/app/entities/sku.dart';
import 'package:novatalk/generated/locales.g.dart';
import 'package:get/get.dart';

enum VipFrom {
  locktext,
  lockpic,
  lockvideo,
  lockaudio,
  send,
  homevip,
  mevip,
  chatvip,
  launch,
  relaunch,
  viprole,
  call,
  acceptcall,
  creimg,
  crevideo,
  undrphoto,
  postpic,
  postvideo,
  undrchar,
  videochat,
  trans,
  dailyrd,
  scenario,
  ldailyrd
}

enum ConsumeFrom {
  home,
  chat,
  send,
  profile,
  text,
  audio,
  call,
  unlcokText,
  undr,
  creaimg,
  creavideo,
  album,
  gift_toy,
  gift_clo,
  aiphoto,
  img2v,
  mask,
}

extension GlobFromExt on ConsumeFrom {
  int get gems {
    switch (this) {
      case ConsumeFrom.text:
        return 2;
      case ConsumeFrom.audio:
        return 4;
      case ConsumeFrom.call:
        return 10;
      case ConsumeFrom.creaimg:
        return 8;
      case ConsumeFrom.creavideo:
        return 10;
      case ConsumeFrom.unlcokText:
        return 4;
      case ConsumeFrom.undr:
        return 100;
      default:
        return 0;
    }
  }
}

enum MsgSource {
  audio('AUDIO'),
  clothe('CLOTHE'),
  gift('GIFT'),
  waitAnswer('waitAnswer'),
  sendText('sendText'),
  scenario('scenario'),
  tips('tips'),
  video('VIDEO'),
  welcome('welcome'),
  intro('intro'),
  photo('PHOTO'),
  error('error'),
  text('TEXT_GEN'),
  maskTips('maskTips');

  final String value;

  const MsgSource(this.value);

  static final Map<String, MsgSource> _map = {for (var e in MsgSource.values) e.value: e};

  static MsgSource? fromSource(String? source) => _map[source];
}

enum LockLevel {
  normal("NORMAL"),
  private("PRIVATE");

  final String value;

  const LockLevel(this.value);
}

enum FollowEvent { follow, unfollow }

enum ChatMode {
  short("short"),
  long("long");

  final String val;

  const ChatMode(this.val);
}

enum CallState { calling, incoming, listening, answering, answered, micOff }

enum LoadingState { idle, loading, success, empty, error }

enum SkuTag {
  greatest(1, LocaleKeys.greatest),
  topPopular(2, LocaleKeys.topChoice),
  discount(3, "");

  final int value;
  final String show;

  const SkuTag(this.value, this.show);

  static SkuTag? getSkuTagByValue(int? value) {
    return SkuTag.values.firstWhereOrNull((element) => element.value == value);
  }
}
enum AdType { open, interstitial, rewarded, native }
enum PlacementType { homelist }

