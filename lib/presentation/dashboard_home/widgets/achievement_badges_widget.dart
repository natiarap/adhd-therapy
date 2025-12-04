import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgesWidget extends StatefulWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementBadgesWidget({
    super.key,
    required this.achievements,
  });

  @override
  State<AchievementBadgesWidget> createState() =>
      _AchievementBadgesWidgetState();
}

class _AchievementBadgesWidgetState extends State<AchievementBadgesWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = widget.achievements.map((achievement) {
      return AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
    }).toList();

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    // Start animations with staggered delay
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.achievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              children: [
                const CustomIconWidget(
                  iconName: 'emoji_events',
                  color: AppTheme.accentLight,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Pencapaian Terbaru',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 30.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: widget.achievements.length,
              itemBuilder: (context, index) {
                final achievement = widget.achievements[index];
                return AnimatedBuilder(
                  animation: _scaleAnimations[index],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: _buildAchievementCard(context, achievement, index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
      BuildContext context, Map<String, dynamic> achievement, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isNewAchievement = achievement['isNew'] as bool? ?? false;

    return Container(
      width: 40.w,
      margin: EdgeInsets.only(right: 3.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isNewAchievement
              ? [
                  AppTheme.accentLight.withValues(alpha: 0.1),
                  AppTheme.accentLight.withValues(alpha: 0.1),
                ]
              : [
                  colorScheme.surface,
                  colorScheme.surface.withValues(alpha: 0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNewAchievement
              ? AppTheme.accentLight.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.2),
          width: isNewAchievement ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isNewAchievement
                ? AppTheme.accentLight.withValues(alpha: 0.2)
                : theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: isNewAchievement ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isNewAchievement) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'BARU!',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                ),
              ),
            ),
            SizedBox(height: 1.h),
          ],
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: _getBadgeColor(achievement['category'] as String)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomIconWidget(
              iconName: achievement['icon'] as String,
              color: _getBadgeColor(achievement['category'] as String),
              size: 28,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            achievement['title'] as String,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Text(
            achievement['description'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: _getBadgeColor(achievement['category'] as String)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              achievement['earnedDate'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getBadgeColor(achievement['category'] as String),
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor(String category) {
    switch (category.toLowerCase()) {
      case 'focus':
        return AppTheme.primaryLight;
      case 'mood':
        return AppTheme.accentLight;
      case 'medication':
        return AppTheme.warningLight;
      case 'exercise':
        return AppTheme.secondaryLight;
      case 'streak':
        return AppTheme.successLight;
      default:
        return AppTheme.primaryLight;
    }
  }
}

