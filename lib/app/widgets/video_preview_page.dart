import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

extension IntExt on int {
  String formatTimeMMSS() {
    int minutes = this ~/ 60;
    int seconds = this % 60;
    String mm = minutes.toString().padLeft(2, '0');
    String ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}

class VideoPreviewPage extends StatefulWidget {
  const VideoPreviewPage({super.key});

  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> with WidgetsBindingObserver {
  late VideoPlayerController _controller;

  bool _progressShow = true;
  Timer? _timer;
  bool _isError = false;
  bool _isInit = false;
  bool _isPlaying = true;
  StreamSubscription? _phoneStateSub;

  late String url;

  // //监听权限
  // Future<bool?> _requestPermission() async {
  //   var status = await Permission.phone.request();

  //   switch (status) {
  //     case PermissionStatus.denied:
  //     case PermissionStatus.restricted:
  //     case PermissionStatus.limited:
  //     case PermissionStatus.permanentlyDenied:
  //       return false;
  //     case PermissionStatus.granted:
  //       return true;
  //     default:
  //       return true;
  //   }
  // }

  //处理来电话播放器停止播放的操作
  // void _handlePhoneCall() async {
  //   if (_phoneStateSub != null) {
  //     return;
  //   }
  //   bool havePermission = true;
  //   if (Platform.isAndroid) {
  //     havePermission = await _requestPermission() ?? true;
  //   }
  //   if (havePermission) {
  //     _phoneStateSub = PhoneState.stream.listen((event) {
  //       if (_isPlaying) {
  //         _isPlaying = false;
  //         _controller.pause();
  //         setState(() {});
  //       }
  //     });
  //   }
  // }

  void _playProgressAutoHide() {
    _timer?.cancel();
    if (_progressShow) {
      _timer = Timer(const Duration(seconds: 3), () {
        if (_progressShow) {
          setState(() {
            _progressShow = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    url = Get.arguments;

    if (url.startsWith('http://') || url.startsWith('https://')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    } else {
      _controller = VideoPlayerController.file(File(url));
    }

    _controller.addListener(() {
      var isPlaying = _controller.value.isPlaying;
      var position = _controller.value.position;
      var duration = _controller.value.duration;
      if (!isPlaying && position == duration) {
        _controller.seekTo(const Duration());
        _isPlaying = false;
      } else {
        // _handlePhoneCall();
      }

      setState(() {});
    });
    _controller.setLooping(false);
    _controller
        .initialize()
        .then((_) {
          _isInit = true;
          if (mounted) {
            _isPlaying = true;
            _controller.play();
            setState(() {});
          }
        })
        .catchError((e) {
          _isError = true;
          if (mounted) {
            setState(() {});
          }
        });
    _playProgressAutoHide();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 添加 inactive 状态判断避免来电等状态
    if ((AppLifecycleState.paused == state || AppLifecycleState.inactive == state) &&
        _isPlaying) {
      _isPlaying = false;
      _controller.pause();
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _timer?.cancel();
    _phoneStateSub?.cancel();
    _phoneStateSub = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: _isError
                ? const Icon(Icons.error, color: Colors.white)
                : _isInit
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _progressShow = !_progressShow;
                        _playProgressAutoHide();
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const CupertinoActivityIndicator(radius: 16.0, color: Colors.white),
          ),
          Visibility(
            visible: _isInit && !_isPlaying,
            child: GestureDetector(
              onTap: () {
                _isPlaying = true;
                _controller.play();
              },
              child: Center(child: Icon(Icons.play_arrow)),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 75,
            child: Visibility(
              visible: _isInit && _progressShow,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_isPlaying) {
                        _isPlaying = false;
                        _controller.pause();
                      } else {
                        _isPlaying = true;
                        _controller.play();
                      }
                    },
                    child: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    _controller.value.position.inSeconds.formatTimeMMSS(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 2,
                      child: VideoProgressIndicator(
                        _controller,
                        colors: const VideoProgressColors(
                          playedColor: Colors.white,
                          backgroundColor: Color(0x4d000000),
                        ),
                        padding: EdgeInsets.zero,
                        allowScrubbing: false,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _controller.value.duration.inSeconds.formatTimeMMSS(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
