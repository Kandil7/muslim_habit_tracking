import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// An animated card widget for the dashboard
class AnimatedDashboardCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final bool isReorderable;
  final VoidCallback? onReorder;
  final VoidCallback? onVisibilityToggle;
  final bool isVisible;

  const AnimatedDashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16.0),
    this.isReorderable = false,
    this.onReorder,
    this.onVisibilityToggle,
    this.isVisible = true,
  });

  @override
  State<AnimatedDashboardCard> createState() => _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<AnimatedDashboardCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });

    if (isHovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: Card(
          elevation: _isHovering ? 4 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: _isHovering 
                ? BorderSide(
                    color: widget.iconColor ?? AppColors.primary,
                    width: 1,
                  )
                : BorderSide.none,
          ),
          color: widget.backgroundColor ?? (isDarkMode 
              ? AppColors.surfaceDark 
              : AppColors.surfaceLight),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: widget.padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            widget.icon,
                            color: widget.iconColor ?? AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.title,
                            style: AppTextStyles.headingSmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (widget.isReorderable && widget.onReorder != null)
                            IconButton(
                              icon: const Icon(Icons.drag_handle),
                              onPressed: widget.onReorder,
                              tooltip: 'Reorder',
                              iconSize: 20,
                              color: AppColors.textSecondary,
                            ),
                          if (widget.onVisibilityToggle != null)
                            IconButton(
                              icon: Icon(
                                widget.isVisible 
                                    ? Icons.visibility 
                                    : Icons.visibility_off,
                              ),
                              onPressed: widget.onVisibilityToggle,
                              tooltip: widget.isVisible 
                                  ? 'Hide card' 
                                  : 'Show card',
                              iconSize: 20,
                              color: AppColors.textSecondary,
                            ),
                          if (widget.onTap != null)
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  widget.child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
