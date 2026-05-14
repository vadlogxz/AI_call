import 'package:elia/core/theme/app_colors.dart';
import 'package:elia/core/theme/app_radius.dart';
import 'package:elia/core/theme/app_spacing.dart';
import 'package:elia/core/theme/app_text_styles.dart';
import 'package:elia/shared/widgets/app_icon.dart';
import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  const StatisticCard({
    super.key,
    required this.title,
    required this.value,
    required this.accentText,
    required this.accentTextColor,
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.iconColor,
  });

  final String title;
  final int value;
  final String accentText;
  final Color accentTextColor;
  final String iconPath;
  final Color iconBackgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: -4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: AppIcon(path: iconPath, size: 20, color: iconColor),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(title, style: AppTextStyles.label),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            accentText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: accentTextColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
