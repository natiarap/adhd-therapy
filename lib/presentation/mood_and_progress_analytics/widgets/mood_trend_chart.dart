import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MoodTrendChart extends StatefulWidget {
  final String selectedPeriod;

  const MoodTrendChart({
    super.key,
    required this.selectedPeriod,
  });

  @override
  State<MoodTrendChart> createState() => _MoodTrendChartState();
}

class _MoodTrendChartState extends State<MoodTrendChart> {
  int? touchedIndex;

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
            color: theme.shadowColor.withOpacity(0.08), // ✅ GUNAKAN .withOpacity()
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
                iconName: 'mood',
                color: colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Tren Mood',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1), // ✅
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getPeriodLabel(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 30.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: colorScheme.outline.withOpacity(0.1), // ✅
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text( // ✅ GANTI SIDE TITLE WIDGET DENGAN TEXT LANGSUNG
                          _getBottomTitle(value.toInt()),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6), // ✅
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text( // ✅ GANTI SIDE TITLE WIDGET DENGAN TEXT LANGSUNG
                          _getMoodLabel(value.toInt()),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6), // ✅
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2), // ✅
                  ),
                ),
                minX: 0,
                maxX: _getMaxX(),
                minY: 1,
                maxY: 5,
                lineBarsData: [
                  LineChartBarData(
                    spots: _getMoodData(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.7), // ✅
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.primary.withOpacity(0.2), // ✅
                          colorScheme.primary.withOpacity(0.05), // ✅
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
  enabled: true,
  touchTooltipData: LineTouchTooltipData(
    fitInsideHorizontally: true,
    fitInsideVertically: true,
    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
      return touchedBarSpots.map((barSpot) {
        return LineTooltipItem(
          '${_getMoodLabel(barSpot.y.toInt())}\n${_getBottomTitle(barSpot.x.toInt())}',
          theme.textTheme.bodySmall!.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList();
    },
  ),
),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          _buildMoodLegend(context),
        ],
      ),
    );
  }

  Widget _buildMoodLegend(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final moods = [
      {'label': 'Sangat Baik', 'color': const Color(0xFF6A994E)},
      {'label': 'Baik', 'color': const Color(0xFF5A9B7C)},
      {'label': 'Netral', 'color': const Color(0xFFE9C46A)},
      {'label': 'Buruk', 'color': const Color(0xFFF4A261)},
      {'label': 'Sangat Buruk', 'color': const Color(0xFFE76F51)},
    ];

    return Wrap(
      spacing: 3.w,
      runSpacing: 1.h,
      children: moods.map((mood) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: mood['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 1.w),
            Text(
              mood['label'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7), // ✅
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _getPeriodLabel() {
    switch (widget.selectedPeriod) {
      case 'week':
        return '7 Hari Terakhir';
      case 'month':
        return '30 Hari Terakhir';
      case 'quarter':
        return '3 Bulan Terakhir';
      default:
        return '7 Hari Terakhir';
    }
  }

  double _getMaxX() {
    switch (widget.selectedPeriod) {
      case 'week':
        return 6;
      case 'month':
        return 29;
      case 'quarter':
        return 11;
      default:
        return 6;
    }
  }

  String _getBottomTitle(int value) {
    switch (widget.selectedPeriod) {
      case 'week':
        const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
        return value < days.length ? days[value] : '';
      case 'month':
        return value % 5 == 0 ? '${value + 1}' : '';
      case 'quarter':
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
        ];
        return value < months.length ? months[value] : '';
      default:
        return '';
    }
  }

  String _getMoodLabel(int value) {
    switch (value) {
      case 1:
        return 'Sangat Buruk';
      case 2:
        return 'Buruk';
      case 3:
        return 'Netral';
      case 4:
        return 'Baik';
      case 5:
        return 'Sangat Baik';
      default:
        return '';
    }
  }

  List<FlSpot> _getMoodData() {
    switch (widget.selectedPeriod) {
      case 'week':
        return const [
          FlSpot(0, 3.2),
          FlSpot(1, 3.8),
          FlSpot(2, 4.1),
          FlSpot(3, 3.5),
          FlSpot(4, 4.3),
          FlSpot(5, 4.0),
          FlSpot(6, 4.2),
        ];
      case 'month':
        return List.generate(30, (index) {
          return FlSpot(
              index.toDouble(), 2.5 + (index % 7) * 0.4 + (index % 3) * 0.3);
        });
      case 'quarter':
        return const [
          FlSpot(0, 3.1),
          FlSpot(1, 3.4),
          FlSpot(2, 3.8),
          FlSpot(3, 3.6),
          FlSpot(4, 4.0),
          FlSpot(5, 4.2),
          FlSpot(6, 4.1),
          FlSpot(7, 4.3),
          FlSpot(8, 4.0),
          FlSpot(9, 4.2),
          FlSpot(10, 4.4),
          FlSpot(11, 4.1),
        ];
      default:
        return const [FlSpot(0, 3.0)];
    }
  }
}

// ❌ HAPUS EKSTENSI INI
// extension on Color {
//   withValues({required double alpha}) {}
// }