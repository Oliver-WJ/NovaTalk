import 'dart:async';
import 'package:flutter/material.dart';

/// A controller to operate the Countdown widget: start, pause, reset.
class CountdownController {
  _CountdownState? _state;

  /// Start or resume the countdown.
  void start() => _state?._start();

  /// Pause the countdown.
  void pause() => _state?._pause();

  /// Reset to [duration] (if provided) or to the original duration.
  void reset([Duration? duration]) => _state?._reset(duration);

  /// Current remaining duration. Null if not attached yet.
  Duration? get remaining => _state?._remaining;

  bool get isRunning => _state?._isRunning ?? false;

  @visibleForTesting
  void _bind(_CountdownState state) => _state = state;

  @visibleForTesting
  void _unbind() => _state = null;
}

/// Countdown widget which "throws out" (exposes) the child building logic
/// using a builder: Widget Function(BuildContext, Duration remaining).
class Countdown extends StatefulWidget {
  /// Total countdown duration to start from.
  final Duration duration;

  /// The tick frequency (default 1s).
  final Duration tick;

  /// Builder called every tick with the remaining time.
  final Widget Function(BuildContext context, Duration remaining) builder;

  /// Called when countdown reaches zero.
  final VoidCallback? onFinished;

  /// Whether to start automatically on widget mount.
  final bool autoStart;

  /// Optional controller to manipulate countdown externally.
  final CountdownController? controller;

  const Countdown({
    super.key,
    required this.duration,
    required this.builder,
    this.tick = const Duration(seconds: 1),
    this.onFinished,
    this.autoStart = true,
    this.controller,
  }) : assert(duration >= Duration.zero);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? _timer;
  late Duration _initialDuration;
  Duration? _remaining;
  late DateTime _endTime;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _initialDuration = widget.duration;
    _remaining = _initialDuration;
    widget.controller?._bind(this);
    if (widget.autoStart && _initialDuration > Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  @override
  void didUpdateWidget(covariant Countdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent changed the duration explicitly, update initial and remaining.
    if (widget.duration != oldWidget.duration) {
      _initialDuration = widget.duration;
      if (!_isRunning) _remaining = _initialDuration;
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._unbind();
      widget.controller?._bind(this);
    }
  }

  void _start() {
    if (_isRunning) return;
    _isRunning = true;
    final remain = _remaining ?? Duration.zero;
    _endTime = DateTime.now().add(remain);

    // Use periodic timer but compute remaining using DateTime to avoid drift.
    _timer = Timer.periodic(widget.tick, (_) => _tick());
    // Immediately tick so UI updates without waiting for the first tick.
    _tick();
  }

  void _pause() {
    if (!_isRunning) return;
    _timer?.cancel();
    _timer = null;
    // compute remaining accurately
    _remaining = _endTime.difference(DateTime.now());
    if (_remaining!.isNegative) _remaining = Duration.zero;
    _isRunning = false;
    setState(() {});
  }

  void _reset(Duration? duration) {
    _timer?.cancel();
    _isRunning = false;
    _initialDuration = duration ?? widget.duration;
    _remaining = _initialDuration;
    setState(() {});
    if (widget.autoStart && _initialDuration > Duration.zero) {
      _start();
    }
  }

  void _tick() {
    final now = DateTime.now();
    final remaining = _endTime.difference(now);
    final newRemaining = remaining.isNegative ? Duration.zero : remaining;

    // Update only when changed to avoid redundant rebuilds.
    if (_remaining == null || newRemaining != _remaining) {
      _remaining = newRemaining;
      setState(() {});
    }

    if (newRemaining == Duration.zero) {
      _timer?.cancel();
      _timer = null;
      _isRunning = false;
      widget.onFinished?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller?._unbind();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _remaining ?? Duration.zero;
    return widget.builder(context, remaining);
  }
}

/// ---------------------- Usage example ----------------------
///
/// Countdown(
///   duration: Duration(minutes: 2),
///   controller: myController, // optional
///   builder: (context, remaining) {
///     final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
///     final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
///     return Text('$minutes:$seconds', style: TextStyle(fontSize: 28));
///   },
///   onFinished: () => print('done'),
/// )
///
/// To control externally:
/// final controller = CountdownController();
/// controller.start();
/// controller.pause();
/// controller.reset(Duration(seconds: 30));
