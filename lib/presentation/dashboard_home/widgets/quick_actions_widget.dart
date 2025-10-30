import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onStartFocusGame;
  final VoidCallback onLogMood;
  final VoidCallback onBreathingExercise;
  final VoidCallback onViewGoals;

  const QuickActionsWidget({
    super.key,
    required this.onStartFocusGame,
    required this.onLogMood,
    required this.onBreathingExercise,
    required this.onViewGoals,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Aksi Cepat',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  context,
                  'Permainan Fokus',
                  'games',
                  colorScheme.primary,
                  onStartFocusGame,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionButton(
                  context,
                  'Catat Mood',
                  'mood',
                  AppTheme.accentLight,
                  onLogMood,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  context,
                  'Latihan Napas',
                  'air',
                  AppTheme.secondaryLight,
                  onBreathingExercise,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionButton(
                  context,
                  'Lihat Tujuan',
                  'flag',
                  AppTheme.successLight,
                  onViewGoals,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 28,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

