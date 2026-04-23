import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<Tab> tabs;
  final TabBarIndicatorSize? indicatorSize;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final Decoration? indicator;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.indicatorSize,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.indicator,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  late final tabController = DefaultTabController.of(context);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerHeight: 0,
      controller: tabController,
      indicatorSize: widget.indicatorSize,
      labelStyle: widget.labelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      indicator: widget.indicator,
      tabs: widget.tabs
          .asMap()
          .entries
          .map(
            (entry) => AnimatedBuilder(
          animation: tabController.animation!,
          builder: (ctx, snapshot) {
            final forward = tabController.offset > 0;
            final backward = tabController.offset < 0;
            int fromIndex;
            int toIndex;
            double progress;
            // Tab
            if (tabController.indexIsChanging) {
              fromIndex = tabController.previousIndex;
              toIndex = tabController.index;
              progress =
                  (tabController.animation!.value - fromIndex).abs() /
                      (toIndex - fromIndex).abs();
            } else {
              // Scroll
              fromIndex = tabController.index;
              toIndex = forward
                  ? fromIndex + 1
                  : backward
                  ? fromIndex - 1
                  : fromIndex;
              progress = (tabController.animation!.value - fromIndex).abs();
            }
            var alpha = entry.key == fromIndex
                ? 1 - progress
                : entry.key == toIndex
                ? progress
                : 0.0;
            return buildTab(entry.value.text ?? '', alpha);
          },
        ),
      )
          .toList(),
    );
  }

  AnimatedScale buildTab(String tabName, double alpha) {
    return AnimatedScale(
      scale: 1 + double.parse((alpha * 0.2).toStringAsFixed(2)),
      duration: const Duration(milliseconds: 100),
      child: AnimatedDefaultTextStyle(
        style:
        (alpha >= 0.5 ? widget.labelStyle : widget.unselectedLabelStyle) ??
            TextStyle(),
        duration: const Duration(milliseconds: 100),
        child: Text(tabName),
      ),
    );
  }
}
