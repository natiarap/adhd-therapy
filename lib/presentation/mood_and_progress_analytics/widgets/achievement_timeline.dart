import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementTimeline extends StatelessWidget {
  const AchievementTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Pencapaian Terapi',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showAllAchievements(context),
                child: Text(
                  'Lihat Semua',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ..._getAchievements().map((achievement) => _buildAchievementItem(
                context,
                achievement,
              )),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
      BuildContext context, Map<String, dynamic> achievement) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleted = achievement['completed'] as bool;

    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : colorScheme.outline.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : colorScheme.outline.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Center(
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    : null,
              ),
              if (achievement != _getAchievements().last)
                Container(
                  width: 2,
                  height: 6.h,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
            ],
          ),
          SizedBox(width: 4.w),
          // Achievement content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement['title'] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? colorScheme.onSurface
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    if (isCompleted)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '+${achievement['points']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  achievement['description'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      achievement['date'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    if (!isCompleted) ...[
                      SizedBox(width: 3.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${achievement['progress']}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAchievements() {
    return [
      {
        'title': 'Konsistensi 7 Hari',
        'description':
            'Berhasil mencatat mood dan gejala selama 7 hari berturut-turut',
        'date': '15 Sep 2025',
        'completed': true,
        'points': 50,
        'progress': 100,
      },
      {
        'title': 'Peningkatan Fokus',
        'description':
            'Mencapai skor fokus rata-rata di atas 4.0 selama seminggu',
        'date': '12 Sep 2025',
        'completed': true,
        'points': 75,
        'progress': 100,
      },
      {
        'title': 'Master Latihan',
        'description': 'Menyelesaikan 20 sesi latihan fokus dengan skor tinggi',
        'date': 'Target: 25 Sep 2025',
        'completed': false,
        'points': 100,
        'progress': 65,
      },
      {
        'title': 'Stabilitas Mood',
        'description': 'Mempertahankan mood stabil (3-5) selama 14 hari',
        'date': 'Target: 30 Sep 2025',
        'completed': false,
        'points': 80,
        'progress': 42,
      },
    ];
  }

  void _showAllAchievements(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAllAchievementsSheet(context),
    );
  }

  Widget _buildAllAchievementsSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Semua Pencapaian',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: _getAllAchievements()
                    .map((achievement) =>
                        _buildAchievementItem(context, achievement))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAllAchievements() {
    return [
      ..._getAchievements(),
      {
        'title': 'Pemula Terapi',
        'description': 'Menyelesaikan sesi terapi pertama',
        'date': '1 Sep 2025',
        'completed': true,
        'points': 25,
        'progress': 100,
      },
      {
        'title': 'Eksplorasi Fitur',
        'description': 'Menggunakan semua fitur aplikasi minimal sekali',
        'date': '5 Sep 2025',
        'completed': true,
        'points': 30,
        'progress': 100,
      },
      {
        'title': 'Kepatuhan Obat',
        'description': 'Mencapai tingkat kepatuhan obat 95% selama sebulan',
        'date': 'Target: 1 Okt 2025',
        'completed': false,
        'points': 120,
        'progress': 78,
      },
    ];
  }
}

