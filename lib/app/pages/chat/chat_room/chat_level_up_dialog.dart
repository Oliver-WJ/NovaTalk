import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/assets.dart';
import '../../../widgets/common_widget.dart';

class ChatLevelUpDialog extends StatefulWidget {
  const ChatLevelUpDialog({super.key, required this.rewards});

  final int rewards;

  @override
  State<ChatLevelUpDialog> createState() => _ChatLevelUpDialogState();
}

class _ChatLevelUpDialogState extends State<ChatLevelUpDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // 初始化 AnimationController
    _controller = AnimationController(vsync: this);

    // 监听动画状态
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 动画完成时的处理逻辑
        SmartDialog.dismiss();
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      // 显示动画
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return sh;
    // return Center(
    //   child: Lottie.asset(
    //     Assets.animePlayG,
    //     controller: _controller,
    //     onLoaded: (composition) {
    //       // 设置动画时长
    //       _controller.duration = composition.duration;
    //     },
    //   ),
    // );
  }
}
