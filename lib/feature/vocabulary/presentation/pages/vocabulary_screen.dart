import 'package:elia/core/assets/app_assets.dart';
import 'package:elia/core/theme/app_colors.dart';
import 'package:elia/core/theme/app_radius.dart';
import 'package:elia/core/theme/app_spacing.dart';
import 'package:elia/core/theme/app_text_styles.dart';
import 'package:elia/feature/vocabulary/presentation/widgets/statistic_card.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vocabulary', style: AppTextStyles.heading2),
                  SizedBox(height: AppSpacing.xs),
                  Text('Your personal word list', style: AppTextStyles.body),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: ShadInput(
                      controller: searchController,
                      placeholder: Text(
                        'Search words, translations, examples...',
                      ),
                      leading: Icon(Icons.search, size: 20),
                      decoration: ShadDecoration(
                        border: ShadBorder.all(
                          radius: BorderRadius.all(Radius.circular(AppRadius.sm))
                        ),
                        focusedBorder: ShadBorder.all(
                          color: ShadTheme.of(context).colorScheme.primary,
                          radius: BorderRadius.all(Radius.circular(AppRadius.sm)))
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: StatisticCard(
                      title: 'Total Words',
                      value: 0,
                      accentText: '+0 this week',
                      accentTextColor: AppColors.primaryGlow,
                      iconPath: AppAssets.notebookIcon,
                      iconBackgroundColor: AppColors.tintPrimary,
                      iconColor: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: StatisticCard(
                      title: 'To Review',
                      value: 0,
                      accentText: 'Due today',
                      accentTextColor: AppColors.warning,
                      iconPath: AppAssets.notebookIcon,
                      iconBackgroundColor: AppColors.tintWarning,
                      iconColor: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: StatisticCard(
                      title: 'Learned',
                      value: 10540,
                      accentText: '0% of all words',
                      accentTextColor: AppColors.success,
                      iconPath: AppAssets.notebookIcon,
                      iconBackgroundColor: AppColors.tintSuccess,
                      iconColor: AppColors.success,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
