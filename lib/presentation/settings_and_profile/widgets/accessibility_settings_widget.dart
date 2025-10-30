import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccessibilitySettingsWidget extends StatefulWidget {
  final Map<String, dynamic> accessibilitySettings;
  final Function(String, dynamic) onSettingChanged;

  const AccessibilitySettingsWidget({
    super.key,
    required this.accessibilitySettings,
    required this.onSettingChanged,
  });

  @override
  State<AccessibilitySettingsWidget> createState() =>
      _AccessibilitySettingsWidgetState();
}

class _AccessibilitySettingsWidgetState
    extends State<AccessibilitySettingsWidget> {
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
            'Pengaturan Aksesibilitas',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Sesuaikan aplikasi untuk kebutuhan ADHD Anda',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 3.h),
          _buildToggleItem(
            context,
            'Kurangi Animasi',
            'Mengurangi gerakan dan transisi untuk fokus yang lebih baik',
            'motion_photos_off',
            AppTheme.primaryLight,
            'reduced_motion',
          ),
          SizedBox(height: 2.h),
          _buildToggleItem(
            context,
            'Mode Kontras Tinggi',
            'Meningkatkan kontras untuk kemudahan membaca',
            'contrast',
            AppTheme.secondaryLight,
            'high_contrast',
          ),
          SizedBox(height: 2.h),
          _buildSliderItem(
            context,
            'Ukuran Font',
            'Sesuaikan ukuran teks untuk kenyamanan membaca',
            'text_fields',
            AppTheme.accentLight,
            'font_size',
            0.8,
            1.4,
          ),
          SizedBox(height: 2.h),
          _buildToggleItem(
            context,
            'Interface Sederhana',
            'Menyederhanakan tampilan untuk mengurangi distraksi',
            'view_compact',
            AppTheme.warningLight,
            'simplified_interface',
          ),
          SizedBox(height: 2.h),
          _buildSliderItem(
            context,
            'Durasi Fokus',
            'Atur durasi sesi fokus sesuai kemampuan Anda',
            'timer',
            AppTheme.successLight,
            'focus_duration',
            5.0,
            60.0,
            isMinutes: true,
          ),
          SizedBox(height: 2.h),
          _buildToggleItem(
            context,
            'Suara Panduan',
            'Aktifkan panduan suara untuk instruksi latihan',
            'record_voice_over',
            AppTheme.primaryLight,
            'voice_guidance',
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    Color iconColor,
    String settingKey,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled =
        widget.accessibilitySettings[settingKey] as bool? ?? false;

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
      child: Row(
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
              widget.onSettingChanged(settingKey, value);
            },
            activeThumbColor: colorScheme.primary,
            inactiveThumbColor: colorScheme.onSurface.withValues(alpha: 0.3),
            inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderItem(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    Color iconColor,
    String settingKey,
    double min,
    double max, {
    bool isMinutes = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentValue =
        widget.accessibilitySettings[settingKey] as double? ?? (min + max) / 2;

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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isMinutes
                                ? '${currentValue.round()} menit'
                                : '${(currentValue * 100).round()}%',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: iconColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
            ],
          ),
          SizedBox(height: 2.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: iconColor,
              thumbColor: iconColor,
              overlayColor: iconColor.withValues(alpha: 0.2),
              inactiveTrackColor: iconColor.withValues(alpha: 0.3),
              trackHeight: 4.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            ),
            child: Slider(
              value: currentValue,
              min: min,
              max: max,
              divisions: isMinutes ? ((max - min) / 5).round() : 20,
              onChanged: (value) {
                widget.onSettingChanged(settingKey, value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

