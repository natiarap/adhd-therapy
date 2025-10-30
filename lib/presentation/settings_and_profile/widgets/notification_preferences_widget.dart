import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  final Map<String, dynamic> notificationSettings;
  final Function(String, bool) onToggleNotification;
  final Function(String, TimeOfDay) onTimeChanged;

  const NotificationPreferencesWidget({
    super.key,
    required this.notificationSettings,
    required this.onToggleNotification,
    required this.onTimeChanged,
  });

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferensi Notifikasi',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          _buildNotificationItem(
            context,
            'Pengingat Obat',
            'Dapatkan notifikasi untuk jadwal minum obat',
            'medication_liquid',
            AppTheme.primaryLight,
            'medication',
            showTimePicker: true,
          ),
          SizedBox(height: 2.h),
          _buildNotificationItem(
            context,
            'Sesi Terapi',
            'Pengingat untuk sesi latihan dan terapi harian',
            'psychology',
            AppTheme.secondaryLight,
            'therapy',
            showTimePicker: true,
          ),
          SizedBox(height: 2.h),
          _buildNotificationItem(
            context,
            'Pencapaian',
            'Rayakan pencapaian dan milestone Anda',
            'emoji_events',
            AppTheme.accentLight,
            'achievements',
          ),
          SizedBox(height: 2.h),
          _buildNotificationItem(
            context,
            'Laporan Mingguan',
            'Ringkasan progress dan analisis mingguan',
            'assessment',
            AppTheme.warningLight,
            'weekly_reports',
          ),
          SizedBox(height: 2.h),
          _buildNotificationItem(
            context,
            'Tips Harian',
            'Tips dan motivasi untuk mengelola ADHD',
            'lightbulb',
            AppTheme.successLight,
            'daily_tips',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    Color iconColor,
    String settingKey, {
    bool showTimePicker = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = widget.notificationSettings[settingKey] as bool? ?? false;
    final timeKey = '${settingKey}_time';
    final notificationTime =
        widget.notificationSettings[timeKey] as TimeOfDay? ??
            const TimeOfDay(hour: 9, minute: 0);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: iconColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: (value) {
                  widget.onToggleNotification(settingKey, value);
                },
                activeThumbColor: colorScheme.primary,
                inactiveThumbColor:
                    colorScheme.onSurface.withValues(alpha: 0.3),
                inactiveTrackColor:
                    colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ],
          ),
          if (showTimePicker && isEnabled) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: colorScheme.primary,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Waktu Pengingat:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () =>
                        _selectTime(context, settingKey, notificationTime),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${notificationTime.hour.toString().padLeft(2, '0')}:${notificationTime.minute.toString().padLeft(2, '0')}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectTime(
      BuildContext context, String settingKey, TimeOfDay currentTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
              dayPeriodTextColor: Theme.of(context).colorScheme.onSurface,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialTextColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentTime) {
      widget.onTimeChanged(settingKey, picked);
    }
  }
}


