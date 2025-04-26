import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get prayer-specific color based on prayer name
    Color getPrayerColor() {
      final prayerName = widget.prayerItemModel.enName;
      if (prayerName.contains('Fajr')) {
        return isDarkMode ? Colors.lightBlue.shade300 : Colors.lightBlue;
      } else if (prayerName.contains('Dhuhr')) {
        return isDarkMode ? Colors.amber.shade300 : Colors.amber;
      } else if (prayerName.contains('Asr')) {
        return isDarkMode ? Colors.orange.shade300 : Colors.orange;
      } else if (prayerName.contains('Maghrib')) {
        return isDarkMode ? Colors.deepOrange.shade300 : Colors.deepOrange;
      } else if (prayerName.contains('Isha')) {
        return isDarkMode ? Colors.indigo.shade300 : Colors.indigo;
      } else {
        return theme.colorScheme.primary;
      }
    }

    final prayerColor = getPrayerColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        height: 72,
        width: double.infinity,
        decoration: BoxDecoration(
          color:
              widget.isNextPrayer
                  ? prayerColor.withAlpha(isDarkMode ? 60 : 30)
                  : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow:
              widget.isNextPrayer
                  ? [
                    BoxShadow(
                      blurRadius: 12,
                      spreadRadius: 1,
                      color: prayerColor.withAlpha(isDarkMode ? 60 : 40),
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
          border: Border.all(
            color:
                widget.isNextPrayer
                    ? prayerColor
                    : theme.dividerTheme.color ?? Colors.transparent,
            width: widget.isNextPrayer ? 2 : 1,
          ),
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
              const SizedBox(width: 16),
              // Prayer icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: prayerColor.withAlpha(isDarkMode ? 40 : 20),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getPrayerIcon(), color: prayerColor, size: 20),
              ),
              const SizedBox(width: 16),
              // Prayer name and time
              PrayerTimesItemTitle(
                prayerItemModel: widget.prayerItemModel,
                isNextPrayer: widget.isNextPrayer,
              ),
              PrayerTimesItemTrailing(
                prayerItemModel: widget.prayerItemModel,
                isNextPrayer: widget.isNextPrayer,
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPrayerIcon() {
    final prayerName = widget.prayerItemModel.enName;
    if (prayerName.contains('Fajr')) {
      return Icons.wb_twilight;
    } else if (prayerName.contains('Dhuhr')) {
      return Icons.wb_sunny;
    } else if (prayerName.contains('Asr')) {
      return Icons.sunny_snowing;
    } else if (prayerName.contains('Maghrib')) {
      return Icons.nightlight_round;
    } else if (prayerName.contains('Isha')) {
      return Icons.nights_stay;
    } else {
      return Icons.access_time;
    }
  }
}
