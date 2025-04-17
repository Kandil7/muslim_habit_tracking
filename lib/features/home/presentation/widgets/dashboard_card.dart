import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// A reusable card widget for the dashboard
class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: iconColor ?? AppColors.primary),
                      const SizedBox(width: 8),
                      Text(title, style: AppTextStyles.headingSmall),
                    ],
                  ),
                  if (onTap != null)
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
