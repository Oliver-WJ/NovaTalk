import 'dart:ui';

import 'package:novatalk/app/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:novatalk/app/configs/app_theme.dart';

import '../../../widgets/gradient_text.dart';

class MsgInputButtons extends StatelessWidget {
  const MsgInputButtons({super.key, required this.tags, required this.onTap});

  final List<dynamic> tags;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final item = tags[index];
                  return GestureDetector(
                    onTap: () => onTap(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        height: 26,
                        decoration:  BoxDecoration(
                          color: Color(0xff212121).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border:  Border.all(
                            color: Color(0xffFBF05D).withOpacity(0.25),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Image.asset(item['icon'], width: 16, height: 16),
                            // const SizedBox(width: 1.5),
                            "${item['name']}".tv(style: tTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemCount: tags.length,
              ),
            ),
          ),

          SizedBox(width: 8),
        ],
      ),
    );
  }
}
