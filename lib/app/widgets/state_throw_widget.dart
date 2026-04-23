import 'package:flutter/widgets.dart';

class StateThrowWidget extends StatefulWidget {
  final Widget? child;
  final Function? onInitState;
  final Function? onDispose;
  final Function? onReady;

  const StateThrowWidget(
      {super.key, this.child, this.onInitState, this.onDispose, this.onReady});

  @override
  State<StateThrowWidget> createState() => _StateThrowWidgetState();
}

class _StateThrowWidgetState extends State<StateThrowWidget> {
  @override
  void initState() {
    widget.onInitState?.call();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onReady?.call();
    });
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }
}
