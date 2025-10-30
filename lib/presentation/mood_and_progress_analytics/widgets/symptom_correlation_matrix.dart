import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SymptomCorrelationMatrix extends StatelessWidget {
  const SymptomCorrelationMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final symptoms = ['Fokus', 'Hiperaktif', 'Impulsif', 'Mood', 'Tidur'];
    final correlationData = _getCorrelationData();

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
                iconName: 'grid_view',
                color: colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Korelasi Gejala',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showCorrelationInfo(context),
                child: CustomIconWidget(
                  iconName: 'info_outline',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                // Header row
                Row(
                  children: [
                    SizedBox(width: 20.w), // Space for row labels
                    ...symptoms.map((symptom) => SizedBox(
                          width: 15.w,
                          child: Text(
                            symptom,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.8),
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 1.h),
                // Matrix rows
                ...symptoms.asMap().entries.map((entry) {
                  final rowIndex = entry.key;
                  final symptom = entry.value;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          child: Text(
                            symptom,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        ...symptoms.asMap().entries.map((colEntry) {
                          final colIndex = colEntry.key;
                          final correlation =
                              correlationData[rowIndex][colIndex];

                          return Container(
                            width: 15.w,
                            height: 8.w,
                            margin: EdgeInsets.only(right: 1.w),
                            decoration: BoxDecoration(
                              color: _getCorrelationColor(
                                  correlation, colorScheme),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                correlation.toStringAsFixed(1),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _getTextColor(correlation),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          _buildCorrelationLegend(context),
        ],
      ),
    );
  }

  Widget _buildCorrelationLegend(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Text(
          'Korelasi: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _buildLegendItem(context, 'Lemah', const Color(0xFFE3F2FD)),
              SizedBox(width: 2.w),
              _buildLegendItem(context, 'Sedang', const Color(0xFF90CAF9)),
              SizedBox(width: 2.w),
              _buildLegendItem(context, 'Kuat', const Color(0xFF1976D2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  List<List<double>> _getCorrelationData() {
    return [
      [1.0, 0.3, 0.5, 0.7, 0.4], // Fokus
      [0.3, 1.0, 0.8, 0.2, 0.6], // Hiperaktif
      [0.5, 0.8, 1.0, 0.4, 0.3], // Impulsif
      [0.7, 0.2, 0.4, 1.0, 0.5], // Mood
      [0.4, 0.6, 0.3, 0.5, 1.0], // Tidur
    ];
  }

  Color _getCorrelationColor(double correlation, ColorScheme colorScheme) {
    if (correlation >= 0.7) {
      return const Color(0xFF1976D2);
    } else if (correlation >= 0.4) {
      return const Color(0xFF90CAF9);
    } else {
      return const Color(0xFFE3F2FD);
    }
  }

  Color _getTextColor(double correlation) {
    if (correlation >= 0.7) {
      return Colors.white;
    } else {
      return const Color(0xFF1976D2);
    }
  }

  void _showCorrelationInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          title: Text(
            'Tentang Korelasi Gejala',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Matriks ini menunjukkan hubungan antara berbagai gejala ADHD. Nilai yang lebih tinggi menunjukkan korelasi yang lebih kuat.\n\n'
            '• 0.0-0.3: Korelasi lemah\n'
            '• 0.4-0.6: Korelasi sedang\n'
            '• 0.7-1.0: Korelasi kuat',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Mengerti',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}


