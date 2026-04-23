import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:novatalk/app/configs/app_theme.dart';
import 'package:novatalk/app/entities/role_entity.dart';
import 'package:novatalk/app/utils/api_svc.dart';
import 'package:novatalk/app/utils/app_user.dart';
import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:vibration/vibration.dart';

import '../../../generated/locales.g.dart';
import '../../configs/constans.dart';
import '../../entities/character_video_chat.dart';
import '../../entities/msg_answer.dart';
import '../../routes/app_pages.dart';
import '../../utils/audio_player_util.dart';
import '../../utils/common_utils.dart';
import '../../utils/download_util.dart';
import '../../utils/log/log_event.dart';

class PhoneCtr extends GetxController {
  bool _hasVideoPlayer = false;
  bool _showVideo = false;

  late String sessionId;
  late RoleRecords role;
  late CharacterVideoChat? guideVideo;
  late CharacterVideoChat? phoneVideo;

  final Rx<CallState> callState = CallState.calling.obs;
  final RxInt callDuration = 0.obs;
  final RxString lastWords = ''.obs;
  final RxBool showFormattedDuration = false.obs;
  var answerText = '';
  MsgAnswer? messageReplyRsp;

  Timer? _callTimer;
  bool _isVibrating = false;
  Timer? _durationTimer;

  final SpeechToText _speech = SpeechToText();
  bool _hasSpeech = false;

  String? errorText;

  bool get _isVip => AppUser.inst.isVip.value;

  @override
  void onInit() {
    super.onInit();

    _getArgs();
    _initSpeech();
  }

  @override
  void onClose() {
    _releaseResources();
    super.onClose();
  }

  void _getArgs() {
    final args = Get.arguments;
    _showVideo = args['showVideo'] ?? false;
    sessionId = args['sessionId'].toString();
    role = args['role'];
    callState.value = args['callState'];

    phoneVideo = role.characterVideoChat?.firstWhereOrNull((e) => e.tag != 'guide');
    var url = phoneVideo?.url;
    if (url != null && url.isNotEmpty && _showVideo) {
      _hasVideoPlayer = true;
    }

    guideVideo = role.characterVideoChat?.firstWhereOrNull((e) => e.tag == 'guide');

    _handleCallState(callState.value);
  }

  void _handleCallState(CallState state) {
    if (state == CallState.calling) {
      Future.delayed(const Duration(milliseconds: 1000), onTapCall);
    } else if (state == CallState.incoming) {
      _startCallTimer();
    }
  }

  String formattedDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  String callStateDescription(CallState callState) {
    switch (callState) {
      case CallState.calling:
      case CallState.listening:
        return LocaleKeys.listening.tr;
      case CallState.answering:
        return LocaleKeys.waitResponse.tr;
      case CallState.answered:
        return answerText;
      default:
        return '';
    }
  }

  void onTapCall() async {
    await _initSpeech();
    if (_hasSpeech) {
      await _deductGems();
      HapticFeedback.selectionClick();
      _startCall();
    }
  }

  void onTapAccept() {
    _stopVibration();
    if (!_isVip) {
      logEvent('acceptcall');
      pushVip(VipFrom.acceptcall);
      return;
    }
    onTapCall();
  }

  Future<bool> _checkMicrophonePermission() async {
    try {
      // 由于权限已经在 AppRouter 中请求过了，这里主要做最终确认
      var micStatus = await Permission.microphone.status;
      var speechStatus = await Permission.speech.status;

      // 如果权限已经授予，直接返回
      if (micStatus.isGranted && speechStatus.isGranted) {
        return true;
      }
      // 如果权限仍然没有授予，显示提示并引导用户到设置
      _showPermissionDialog();
      return false;
    } catch (e) {
      try {
        bool hasPermission = await _speech.hasPermission;
        if (!hasPermission) {
          _showPermissionDialog();
        }
        return hasPermission;
      } catch (e2) {
        _showPermissionDialog();
        return false;
      }
    }
  }

  void _showPermissionDialog() {
    Theme1Dialog.showBottomTwoBtn(
      title: LocaleKeys.firstEnableMic.trParams({
        "permission": LocaleKeys.micPhone.tr,
      }),
      confirmText: LocaleKeys.prefs.tr,
      onConfirm: () {
        openAppSettings();
      },
    );
  }

  void _startCall() {
    _callTimer?.cancel();
    _startDurationTimer();
    _startListening();
  }

  void onTapHangup() {
    _stopVibration();
    Get.back();
  }

  void onTapMic(bool isOn) {
    if (callState.value == CallState.answering) return;

    HapticFeedback.selectionClick();
    if (isOn) {
      _startListening();
    } else {
      callState.value = CallState.micOff;
      _stopListening();
    }
  }

  void _releaseResources() {
    _speech
        .stop()
        .then((_) {
          _speech
              .cancel()
              .then((_) {
                _callTimer?.cancel();
                _callTimer = null;
                _durationTimer?.cancel();
                _durationTimer = null;
                AudioPlayerUtil.instance.stopAll();
                Vibration.cancel();
              })
              .catchError((error) {});
        })
        .catchError((error) {
          goPrint('speech error: $error');
        });
    AudioPlayerUtil.instance.stopAll();
    Vibration.cancel();
  }

  void _startCallTimer() {
    _isVibrating = true;
    _callTimer = Timer(const Duration(seconds: 15), _onCallTimeout);

    _startVibration();
  }

  void _stopVibration() {
    _isVibrating = false;
  }

  Future<void> _startVibration() async {
    for (int i = 0; i < 20; i++) {
      // 20 * 500ms = 10s
      if (!_isVibrating) break;
      Vibration.vibrate(duration: 500);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void _onCallTimeout() {
    _stopVibration();
    if (callState.value == CallState.incoming && Get.currentRoute == Routes.CALL) {
      onTapHangup();
    }
  }

  void _startDurationTimer() {
    showFormattedDuration.value = true;
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callDuration.value++;
      // Check if a minute has passed
      if (callDuration.value % 60 == 0) {
        _deductGems();
      }
    });
  }

  Future<void> _deductGems() async {
    if (AppUser.inst.isBalanceEnough(ConsumeFrom.call)) {
      AppUser.inst.consume(ConsumeFrom.call);
    } else {
      SmartDialog.showToast(LocaleKeys.notEnough2.tr);
      Future.delayed(const Duration(milliseconds: 1000));
      onTapHangup();
    }
  }

  Future<void> _initSpeech() async {
    if (_hasSpeech) return;
    var micStatus = await Permission.microphone.request();
    var speechStatus = await Permission.speech.request();
    var isGranted = micStatus.isGranted && speechStatus.isGranted;
    if (!isGranted) {
      _showPermissionDialog();
      return;
    }
    try {
      _hasSpeech = await _speech.initialize(
        onStatus: (status) {
          goPrint("onStatus =$status");
        },
        onError: (error) {
          goPrint("onError =$error");
          errorText = error.errorMsg;
          if (error.errorMsg.contains('error_language_not_supported') ||
              error.errorMsg.contains('error_permission') ||
              error.errorMsg.contains('error_language_unavailable')) {
            SmartDialog.showToast(
              LocaleKeys.notSupportedSpeechTips.tr,
              displayTime: 5.seconds,
            );
            Get.back();
          } else {
            SmartDialog.showToast(
              LocaleKeys.notSupportedSpeechTips.tr,
              displayTime: 5.seconds,
            );
          }
        },
      );
    } catch (e) {
      _hasSpeech = false;
      SmartDialog.showToast(LocaleKeys.notSupportedSpeechTips.tr);
    }
  }

  void _startListening() async {
    if (errorText?.isNotEmpty == true) {
      SmartDialog.showToast(LocaleKeys.notSupportedSpeechTips.tr);
      return;
    }
    if (isClosed) {
      return;
    }

    if (!_hasSpeech) {
      SmartDialog.showToast(LocaleKeys.notSupportedSpeechTips.tr);
      onTapHangup();
      return;
    }

    callState.value = CallState.listening;
    answerText = '';
    lastWords.value = '';
    _listen();
  }

  void _stopListening() {
    _speech.stop();
  }

  Future<void> _listen() async {
    _speech.listen(
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      onResult: _onSpeechResult,
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    goPrint('result: ${result.recognizedWords}');
    if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
      lastWords.value = result.recognizedWords;
      if (callState.value == CallState.listening || callState.value == CallState.micOff) {
        _requestAnswer();
      }
    }
  }

  Future<void> _requestAnswer() async {
    callState.value = CallState.answering;

    _stopListening();

    try {
      final msg = await _sendMessage();
      if (msg != null) {
        messageReplyRsp = msg;
        _playResponseAudio(msg);
      } else {
        SmartDialog.showToast(LocaleKeys.occurredTips.tr);
        _restartRecording();
      }
    } catch (e) {
      SmartDialog.showToast(LocaleKeys.occurredTips.tr);
    }
  }

  Future<MsgAnswer?> _sendMessage() async {
    final roleId = role.id;
    if (roleId == null) {
      SmartDialog.showToast(LocaleKeys.occurredTips.tr);
      return null;
    }

    var userId = AppUser.inst.user?.id;
    if (userId == null) {
      SmartDialog.showToast(LocaleKeys.occurredTips.tr);
      return null;
    }

    return await ApiSvc.sendVoiceChatMsg(
      userId: userId,
      nickName: AppUser.inst.user?.nickname ?? '',
      message: lastWords.value,
      roleId: roleId,
    );
  }

  void _restartRecording() {
    _startListening();
  }

  void _playResponseAudio(MsgAnswer msg) async {
    final url = msg.answer?.voiceUrl;
    if (url == null || url.isEmpty) {
      _playAudioFallback();
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    final file = await _downloadFileWithRetry(url, 5);
    if (file != null && file.path.isNotEmpty) {
      _playAudioFile(file.path, msg);
    } else {
      _playAudioFallback();
    }
  }

  void _playAudioFallback() {
    answerText = messageReplyRsp?.answer?.content ?? '';
    Future.delayed(const Duration(seconds: 1), _restartRecording);
  }

  Future<File?> _downloadFileWithRetry(String url, int retries) async {
    File? file;
    for (int attempt = 1; attempt <= retries; attempt++) {
      try {
        file = await _downloadFile(url);
        if (file != null && file.path.isNotEmpty) {
          return file;
        }
      } catch (e) {
        SmartDialog.showToast(LocaleKeys.occurredTips.tr);
      }
    }
    return null;
  }

  Future<File?> _downloadFile(String url) async {
    final path = await DownloadUtil.download(url);
    if (path == null || path.isEmpty) {
      return null;
    }
    return File(path);
  }

  void _playAudioFile(String path, MsgAnswer msg) async {
    final id = messageReplyRsp?.msgId;
    if (id != null) {
      answerText = messageReplyRsp?.answer?.content ?? '';

      callState.value = CallState.answered;

      await AudioPlayerUtil.instance.play(
        id,
        DeviceFileSource(path),
        stopAction: _stopPlayAnimation,
      );
    }
  }

  void _stopPlayAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      _startListening();
    });
  }
}
