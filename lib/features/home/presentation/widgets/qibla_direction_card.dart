import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'animated_dashboard_card.dart';

/// Card widget for Qibla direction
class QiblaDirectionCard extends StatefulWidget {
  final VoidCallback? onReorder;
  final VoidCallback? onVisibilityToggle;
  final bool isVisible;
  final bool isReorderable;

  const QiblaDirectionCard({
    super.key,
    this.onReorder,
    this.onVisibilityToggle,
    this.isVisible = true,
    this.isReorderable = false,
  });

  @override
  State<QiblaDirectionCard> createState() => _QiblaDirectionCardState();
}

class _QiblaDirectionCardState extends State<QiblaDirectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  // Mock qibla direction (in a real app, this would come from a compass sensor)
  final double _qiblaDirection = 137.0; // Example direction in degrees
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0,
      end: _qiblaDirection * (math.pi / 180), // Convert to radians
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDashboardCard(
      title: 'Qibla Direction',
      icon: Icons.explore,
      iconColor: AppColors.primary,
      isReorderable: widget.isReorderable,
      onReorder: widget.onReorder,
      onVisibilityToggle: widget.onVisibilityToggle,
      isVisible: widget.isVisible,
      onTap: () {
        // Navigate to Qibla direction page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Qibla Direction feature coming soon!'),
          ),
        );
      },
      child: Column(
        children: [
          const Text(
            'Tap the compass to find the Qibla direction',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Compass background
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha:0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  // Cardinal directions
                  Positioned(
                    top: 10,
                    child: Text(
                      'N',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Text(
                      'S',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: Text(
                      'E',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    child: Text(
                      'W',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Animated needle
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value,
                        child: child,
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Kaaba icon at the end of the needle
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 60,
                          color: AppColors.primary,
                        ),
                        const Icon(
                          Icons.arrow_downward,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Qibla is $_qiblaDirection° from North',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Based on your current location',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
