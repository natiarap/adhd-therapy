import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_timeline.dart';
import './widgets/analytics_summary_card.dart';
import './widgets/mood_trend_chart.dart';
import './widgets/progress_report_card.dart';
import './widgets/symptom_correlation_matrix.dart';
import './widgets/time_period_selector.dart';

class MoodAndProgressAnalytics extends StatefulWidget {
  const MoodAndProgressAnalytics({super.key});

  @override
  State<MoodAndProgressAnalytics> createState() =>
      _MoodAndProgressAnalyticsState();
}

class _MoodAndProgressAnalyticsState extends State<MoodAndProgressAnalytics>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'week';
  final ScrollController _scrollController = ScrollController();
  // ignore: unused_field
  bool _isRefreshing = false;

  // Mock data for analytics
  final List<Map<String, dynamic>> _summaryData = [
    {
      'title': 'Skor Mood Rata-rata',
      'value': '4.2',
      'subtitle': 'Dari 5.0 skala',
      'icon': Icons.mood,
      'iconColor': const Color(0xFF5A9B7C),
      'trend': '+12%',
      'isPositiveTrend': true,
    },
    {
      'title': 'Peningkatan Gejala',
      'value': '23%',
      'subtitle': 'Minggu ini',
      'icon': Icons.trending_up,
      'iconColor': const Color(0xFF2E7D8F),
      'trend': '+8%',
      'isPositiveTrend': true,
    },
    {
      'title': 'Kepatuhan Obat',
      'value': '95%',
      'subtitle': 'Target tercapai',
      'icon': Icons.medication,
      'iconColor': const Color(0xFFF4A261),
      'trend': '+5%',
      'isPositiveTrend': true,
    },
    {
      'title': 'Progress Latihan',
      'value': '87%',
      'subtitle': 'Sesi selesai',
      'icon': Icons.psychology,
      'iconColor': const Color(0xFFE9C46A),
      'trend': '+15%',
      'isPositiveTrend': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
      body: SafeArea(
        child: Column(
          children: [
            _buildStickyHeader(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: colorScheme.primary,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          _buildSummaryCards(),
                          SizedBox(height: 3.h),
                          MoodTrendChart(selectedPeriod: _selectedPeriod),
                          SizedBox(height: 3.h),
                          const SymptomCorrelationMatrix(),
                          SizedBox(height: 3.h),
                          const ProgressReportCard(),
                          SizedBox(height: 3.h),
                          const AchievementTimeline(),
                          SizedBox(
                              height: 10.h), // Bottom padding for navigation
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildStickyHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_back_ios',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Analitik & Progress',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showFilterOptions(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'filter_list',
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: () => _showExportOptions(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'file_download',
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildTabBar(context),
          SizedBox(height: 1.h),
          TimePeriodSelector(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) {
              setState(() {
                _selectedPeriod = period;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Kemajuan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 3.w,
            runSpacing: 2.h,
            children: _summaryData.map((data) {
              return AnalyticsSummaryCard(
                title: data['title'],
                value: data['value'],
                subtitle: data['subtitle'],
                icon: data['icon'],
                iconColor: data['iconColor'],
                trend: data['trend'],
                isPositiveTrend: data['isPositiveTrend'],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                  context, 'home', 'Beranda', '/dashboard-home', false),
              _buildNavItem(context, 'psychology', 'Latihan',
                  '/focus-training-games', false),
              _buildNavItem(context, 'analytics', 'Progress',
                  '/mood-and-progress-analytics', true),
              _buildNavItem(
                  context, 'person', 'Profil', '/settings-and-profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String iconName, String label,
      String route, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    // ignore: unused_local_variable
    final colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton(
      onPressed: () => _showQuickActions(context),
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      child: const CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil diperbarui'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterSheet(context),
    );
  }

  Widget _buildFilterSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Data',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildFilterOption(context, 'Semua Gejala', true),
          _buildFilterOption(context, 'Fokus', false),
          _buildFilterOption(context, 'Hiperaktif', false),
          _buildFilterOption(context, 'Impulsif', false),
          _buildFilterOption(context, 'Mood', false),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Terapkan Filter'),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildFilterOption(
      BuildContext context, String title, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {},
            activeColor: colorScheme.primary,
          ),
          SizedBox(width: 2.w),
          Text(
            title,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildExportSheet(context),
    );
  }

  Widget _buildExportSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ekspor Data',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildExportOption(context, 'PDF Report', 'picture_as_pdf',
              () => _exportPDF(context)),
          _buildExportOption(
              context, 'CSV Data', 'table_chart', () => _exportCSV(context)),
          _buildExportOption(
              context, 'Gambar Chart', 'image', () => _exportImage(context)),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildExportOption(
      BuildContext context, String title, String iconName, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildQuickActionsSheet(context),
    );
  }

  Widget _buildQuickActionsSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aksi Cepat',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildQuickAction(
              context, 'Catat Mood', 'mood', () => _logMood(context)),
          _buildQuickAction(context, 'Mulai Latihan', 'psychology',
              () => _startTraining(context)),
          _buildQuickAction(context, 'Reminder Obat', 'medication',
              () => _setMedicationReminder(context)),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
      BuildContext context, String title, String iconName, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportPDF(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan PDF berhasil diekspor'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _exportCSV(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data CSV berhasil diekspor'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _exportImage(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gambar chart berhasil disimpan'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _logMood(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur catat mood akan segera tersedia'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startTraining(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/focus-training-games');
  }

  void _setMedicationReminder(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengingat obat berhasil diatur'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

