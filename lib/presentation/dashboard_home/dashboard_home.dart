import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/achievement_badges_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/medication_reminder_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_progress_widget.dart';
import './widgets/todays_focus_card_widget.dart';
import './widgets/upcoming_appointments_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int _currentBottomBarIndex = 0;

  // Mock data for dashboard
  final String _userName = "Sarah Putri";
  final String _currentMood = "Baik";
  final double _attentionLevel = 0.75;
  final String _nextDoseTime = "14:30";
  final String _medicationName = "Methylphenidate 10mg";
  final int _streakCount = 7;
  final double _weeklyCompletion = 0.68;

  final List<Map<String, dynamic>> _progressData = [
    {
      "title": "Sesi Fokus",
      "value": "12/15",
      "icon": "psychology",
      "color": AppTheme.primaryLight,
    },
    {
      "title": "Latihan Napas",
      "value": "8/10",
      "icon": "air",
      "color": AppTheme.secondaryLight,
    },
    {
      "title": "Catat Mood",
      "value": "6/7",
      "icon": "mood",
      "color": AppTheme.accentLight,
    },
  ];

  final Map<String, dynamic> _nextAppointment = {
    "therapistName": "Dr. Maya Sari, M.Psi",
    "sessionType": "Terapi Kognitif Perilaku",
    "dateTime": "Kamis, 23 Sep 2025 - 10:00",
    "duration": "60",
    "status": "Terkonfirmasi",
  };

  final List<Map<String, dynamic>> _achievements = [
    {
      "title": "Fokus Master",
      "description": "Menyelesaikan 10 sesi fokus berturut-turut",
      "icon": "psychology",
      "category": "focus",
      "earnedDate": "22 Sep 2025",
      "isNew": true,
    },
    {
      "title": "Mood Tracker",
      "description": "Mencatat mood selama 30 hari",
      "icon": "mood",
      "category": "mood",
      "earnedDate": "20 Sep 2025",
      "isNew": false,
    },
    {
      "title": "Konsisten Obat",
      "description": "Minum obat tepat waktu 14 hari",
      "icon": "medication",
      "category": "medication",
      "earnedDate": "18 Sep 2025",
      "isNew": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GreetingHeaderWidget(
                      userName: _userName,
                      currentMood: _currentMood,
                      onMoodTap: _handleMoodTap,
                    ),
                    SizedBox(height: 1.h),
                    TodaysFocusCardWidget(
                      attentionLevel: _attentionLevel,
                      onMoodCheckIn: _handleMoodCheckIn,
                    ),
                    MedicationReminderCardWidget(
                      nextDoseTime: _nextDoseTime,
                      medicationName: _medicationName,
                      streakCount: _streakCount,
                      onMarkTaken: _handleMarkMedicationTaken,
                    ),
                    RecentProgressWidget(
                      weeklyCompletion: _weeklyCompletion,
                      progressData: _progressData,
                    ),
                    QuickActionsWidget(
                      onStartFocusGame: _handleStartFocusGame,
                      onLogMood: _handleLogMood,
                      onBreathingExercise: _handleBreathingExercise,
                      onViewGoals: _handleViewGoals,
                    ),
                    UpcomingAppointmentsWidget(
                      nextAppointment: _nextAppointment,
                      onJoinSession: _handleJoinSession,
                    ),
                    AchievementBadgesWidget(
                      achievements: _achievements,
                    ),
                    SizedBox(height: 4.h), // Bottom padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleStartTherapySession,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const CustomIconWidget(
          iconName: 'play_arrow',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Mulai Sesi',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomBarIndex,
        onTap: _handleBottomBarTap,
        variant: BottomBarVariant.therapeutic,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate refresh with gentle haptic feedback
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        // Update data here in real implementation
      });
    }
  }

  void _handleMoodTap() {
    _showMoodSelector();
  }

  void _handleMoodCheckIn() {
    Navigator.pushNamed(context, '/mood-and-progress-analytics');
  }

  void _handleMarkMedicationTaken() {
    _showMedicationConfirmation();
  }

  void _handleStartFocusGame() {
    Navigator.pushNamed(context, '/focus-training-games');
  }

  void _handleLogMood() {
    Navigator.pushNamed(context, '/mood-and-progress-analytics');
  }

  void _handleBreathingExercise() {
    _showBreathingExerciseDialog();
  }

  void _handleViewGoals() {
    Navigator.pushNamed(context, '/settings-and-profile');
  }

  void _handleJoinSession() {
    _showJoinSessionDialog();
  }

  void _handleStartTherapySession() {
    Navigator.pushNamed(context, '/focus-training-games');
  }

  void _handleBottomBarTap(int index) {
    setState(() {
      _currentBottomBarIndex = index;
    });
  }

  void _showMoodSelector() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.6.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Bagaimana perasaan Anda hari ini?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Wrap(
                spacing: 3.w,
                runSpacing: 2.h,
                children: [
                  'Sangat Baik',
                  'Baik',
                  'Netral',
                  'Buruk',
                  'Sangat Buruk'
                ].map((mood) => _buildMoodChip(mood)).toList(),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoodChip(String mood) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = mood == _currentMood;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Update mood in real implementation
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          mood,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  void _showMedicationConfirmation() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const CustomIconWidget(
                iconName: 'medication',
                color: AppTheme.successLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Konfirmasi Obat',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda sudah minum $_medicationName pada $_nextDoseTime?',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Belum',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessSnackBar('Obat berhasil ditandai sudah diminum!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successLight,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sudah Minum'),
            ),
          ],
        );
      },
    );
  }

  void _showBreathingExerciseDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const CustomIconWidget(
                iconName: 'air',
                color: AppTheme.secondaryLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Latihan Pernapasan',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih durasi latihan pernapasan:',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDurationButton('2 menit'),
                  _buildDurationButton('5 menit'),
                  _buildDurationButton('10 menit'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDurationButton(String duration) {
    final theme = Theme.of(context);
    // ignore: unused_local_variable
    final colorScheme = theme.colorScheme;

    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        _showSuccessSnackBar('Memulai latihan pernapasan $duration');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.secondaryLight.withValues(alpha: 0.1),
        foregroundColor: AppTheme.secondaryLight,
        elevation: 0,
      ),
      child: Text(duration),
    );
  }

  void _showJoinSessionDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'video_call',
                color: colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Bergabung Sesi',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Anda akan bergabung dengan sesi terapi bersama ${_nextAppointment['therapistName']}. Pastikan koneksi internet stabil.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessSnackBar('Menghubungkan ke sesi terapi...');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Bergabung'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }
}
