import 'package:flutter/material.dart';
import '/core/utils/colors.dart';

import '../../../data/models/prayer_item_model.dart';
import 'prayer_times_item_title.dart';
import 'prayer_times_item_trailing.dart';

class PrayerTimesItem extends StatefulWidget {
  const PrayerTimesItem({
    super.key,
    required this.prayerItemModel,
    required this.isNextPrayer,
  });
  final PrayerItemModel prayerItemModel;
  final bool isNextPrayer;

  @override
  State<PrayerTimesItem> createState() => _PrayerTimesItemState();
}

class _PrayerTimesItemState extends State<PrayerTimesItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isNextPrayer) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PrayerTimesItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isNextPrayer != oldWidget.isNextPrayer) {
      if (widget.isNextPrayer) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      height: 64,
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.isNextPrayer ? AppColors.primaryColor2 : null,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: widget.isNextPrayer ? 8 : 0,
            spreadRadius: widget.isNextPrayer ? 2 : 0,
            color:
                widget.isNextPrayer
                    ? AppColors.primaryColor2
                    : Colors.teal.shade100,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isNextPrayer ? _scaleAnimation.value : 1.0,
            child: Opacity(
              opacity: widget.isNextPrayer ? _opacityAnimation.value : 1.0,
              child: child,
            ),
          );
        },
        child: Row(
          children: [
            const SizedBox(width: 12),
            PrayerTimesItemTitle(
              prayerItemModel: widget.prayerItemModel,
              isNextPrayer: widget.isNextPrayer,
            ),
            PrayerTimesItemTrailing(
              prayerItemModel: widget.prayerItemModel,
              isNextPrayer: widget.isNextPrayer,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
