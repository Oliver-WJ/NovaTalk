import 'package:flutter/material.dart';

class ReleaseTextEditFocus extends StatelessWidget {
  final Widget child;

  const ReleaseTextEditFocus({super.key, required this.child});

  static void releaseFocus(BuildContext ctx) {
    FocusScopeNode currentFocus = FocusScope.of(ctx);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      /// 取消焦点，相当于关闭键盘
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => releaseFocus(context),
      child: child,
    );
  }
}
