import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/accessibility_settings_widget.dart';
import './widgets/data_management_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/profile_header_card.dart';
import './widgets/settings_section_card.dart';

class SettingsAndProfile extends StatefulWidget {
  const SettingsAndProfile({super.key});

  @override
  State<SettingsAndProfile> createState() => _SettingsAndProfileState();
}

class _SettingsAndProfileState extends State<SettingsAndProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Mock user profile data
  final Map<String, dynamic> _userProfile = {
    'name': 'Sarah Wijaya',
    'email': 'sarah.wijaya@email.com',
    'avatar':
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face',
    'therapyDuration': '3 bulan 2 minggu',
    'completedSessions': 47,
    'streakDays': 12,
    'currentLevel': 8,
    'joinDate': '2023-10-15',
    'emergencyContact': '+62 812-3456-7890',
    'therapistName': 'Dr. Amanda Putri',
    'therapistContact': '+62 811-2345-6789',
  };

  // Mock notification settings
  final Map<String, dynamic> _notificationSettings = {
    'medication': true,
    'medication_time': const TimeOfDay(hour: 8, minute: 0),
    'therapy': true,
    'therapy_time': const TimeOfDay(hour: 19, minute: 0),
    'achievements': true,
    'weekly_reports': false,
    'daily_tips': true,
  };

  // Mock accessibility settings
  final Map<String, dynamic> _accessibilitySettings = {
    'reduced_motion': false,
    'high_contrast': false,
    'font_size': 1.0,
    'simplified_interface': false,
    'focus_duration': 25.0,
    'voice_guidance': true,
  };

  final List<CustomTab> _tabs = [
    const CustomTab(
      text: 'Profil',
      icon: Icons.person_outline,
    ),
    const CustomTab(
      text: 'Pengaturan',
      icon: Icons.settings_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: _currentTabIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const CustomAppBar(
        title: 'Profil & Pengaturan',
        variant: AppBarVariant.primary,
      ),
      body: Column(
        children: [
          CustomTabBar(
            tabs: _tabs,
            currentIndex: _currentTabIndex,
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
              _tabController.animateTo(index);
            },
            variant: TabBarVariant.therapeutic,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(),
                _buildSettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          ProfileHeaderCard(userProfile: _userProfile),
          _buildPersonalInformationSection(),
          _buildTherapyInformationSection(),
          _buildEmergencyContactsSection(),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          NotificationPreferencesWidget(
            notificationSettings: _notificationSettings,
            onToggleNotification: _handleNotificationToggle,
            onTimeChanged: _handleTimeChanged,
          ),
          AccessibilitySettingsWidget(
            accessibilitySettings: _accessibilitySettings,
            onSettingChanged: _handleAccessibilitySettingChanged,
          ),
          _buildPrivacyControlsSection(),
          _buildTherapyCustomizationSection(),
          DataManagementWidget(
            userData: _userProfile,
            onDataImported: _handleDataImported,
          ),
          _buildSupportSection(),
          _buildAppInfoSection(),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildPersonalInformationSection() {
    return SettingsSectionCard(
      title: 'Informasi Pribadi',
      initiallyExpanded: false,
      items: [
        SettingsItem(
          title: 'Edit Profil',
          subtitle: 'Ubah nama, foto, dan informasi dasar',
          iconName: 'edit',
          iconColor: AppTheme.primaryLight,
          onTap: _showEditProfileDialog,
        ),
        SettingsItem(
          title: 'Ubah Email',
          subtitle: _userProfile['email'],
          iconName: 'email',
          iconColor: AppTheme.secondaryLight,
          onTap: _showChangeEmailDialog,
        ),
        SettingsItem(
          title: 'Ubah Password',
          subtitle: 'Perbarui kata sandi akun Anda',
          iconName: 'lock',
          iconColor: AppTheme.accentLight,
          onTap: _showChangePasswordDialog,
        ),
      ],
    );
  }

  Widget _buildTherapyInformationSection() {
    return SettingsSectionCard(
      title: 'Informasi Terapi',
      initiallyExpanded: false,
      items: [
        SettingsItem(
          title: 'Terapis',
          subtitle: _userProfile['therapistName'],
          iconName: 'psychology',
          iconColor: AppTheme.primaryLight,
          onTap: _showTherapistInfo,
        ),
        SettingsItem(
          title: 'Riwayat Sesi',
          subtitle: '${_userProfile['completedSessions']} sesi selesai',
          iconName: 'history',
          iconColor: AppTheme.secondaryLight,
          onTap: () => _navigateToRoute('/mood-and-progress-analytics'),
        ),
        SettingsItem(
          title: 'Sertifikat Pencapaian',
          subtitle: 'Lihat pencapaian dan sertifikat Anda',
          iconName: 'emoji_events',
          iconColor: AppTheme.accentLight,
          onTap: _showAchievements,
        ),
      ],
    );
  }

  Widget _buildEmergencyContactsSection() {
    return SettingsSectionCard(
      title: 'Kontak Darurat',
      initiallyExpanded: false,
      items: [
        SettingsItem(
          title: 'Kontak Darurat',
          subtitle: _userProfile['emergencyContact'],
          iconName: 'emergency',
          iconColor: AppTheme.errorLight,
          onTap: _showEmergencyContactDialog,
        ),
        SettingsItem(
          title: 'Hotline Krisis',
          subtitle: 'Akses bantuan profesional 24/7',
          iconName: 'support_agent',
          iconColor: AppTheme.warningLight,
          onTap: _showCrisisSupport,
        ),
      ],
    );
  }

  Widget _buildPrivacyControlsSection() {
    return SettingsSectionCard(
      title: 'Kontrol Privasi',
      initiallyExpanded: false,
      items: [
        SettingsItem(
          title: 'Autentikasi Biometrik',
          subtitle: 'Gunakan sidik jari atau Face ID',
          iconName: 'fingerprint',
          iconColor: AppTheme.primaryLight,
          trailing: Switch(
            value: true,
            onChanged: (value) {},
          ),
        ),
        SettingsItem(
          title: 'Timeout Sesi',
          subtitle: 'Keluar otomatis setelah 15 menit',
          iconName: 'timer',
          iconColor: AppTheme.secondaryLight,
          onTap: _showSessionTimeoutDialog,
        ),
        SettingsItem(
          title: 'Berbagi Data',
          subtitle: 'Kelola izin berbagi dengan terapis',
          iconName: 'share',
          iconColor: AppTheme.accentLight,
          onTap: _showDataSharingSettings,
        ),
      ],
    );
  }

  Widget _buildTherapyCustomizationSection() {
    return SettingsSectionCard(
      title: 'Kustomisasi Terapi',
      initiallyExpanded: false,
      items: [
        SettingsItem(
          title: 'Tingkat Kesulitan',
          subtitle: 'Sesuaikan level latihan',
          iconName: 'tune',
          iconColor: AppTheme.primaryLight,
          onTap: _showDifficultySettings,
        ),
        SettingsItem(
          title: 'Jenis Permainan',
          subtitle: 'Pilih permainan fokus favorit',
          iconName: 'games',
          iconColor: AppTheme.secondaryLight,
          onTap: () => _navigateToRoute('/focus-training-games'),
        ),
        SettingsItem(
          title: 'Frekuensi Tracking',
          subtitle: 'Atur seberapa sering mencatat mood',
          iconName: 'schedule',
          iconColor: AppTheme.accentLight,
          onTap: _showTrackingFrequencyDialog,
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return SettingsSectionCard(
      title: 'Bantuan & Dukungan',
      initiallyExpanded: false,
      items: [
        SettingsItem(
          title: 'Pusat Bantuan',
          subtitle: 'FAQ dan panduan penggunaan',
          iconName: 'help',
          iconColor: AppTheme.primaryLight,
          onTap: _showHelpCenter,
        ),
        SettingsItem(
          title: 'Hubungi Dukungan',
          subtitle: 'Chat dengan tim support',
          iconName: 'support',
          iconColor: AppTheme.secondaryLight,
          onTap: _showContactSupport,
        ),
        SettingsItem(
          title: 'Berikan Feedback',
          subtitle: 'Bantu kami meningkatkan aplikasi',
          iconName: 'feedback',
          iconColor: AppTheme.accentLight,
          onTap: _showFeedbackDialog,
        ),
      ],
    );
  }

  Widget _buildAppInfoSection() {
    return SettingsSectionCard(
      title: 'Informasi Aplikasi',
      initiallyExpanded: false,
      items: [
        SettingsItem(
          title: 'Versi Aplikasi',
          subtitle: '1.0.0 (Build 100)',
          iconName: 'info',
          iconColor: AppTheme.primaryLight,
        ),
        SettingsItem(
          title: 'Syarat & Ketentuan',
          subtitle: 'Baca syarat penggunaan aplikasi',
          iconName: 'description',
          iconColor: AppTheme.secondaryLight,
          onTap: _showTermsAndConditions,
        ),
        SettingsItem(
          title: 'Kebijakan Privasi',
          subtitle: 'Pelajari bagaimana data Anda dilindungi',
          iconName: 'privacy_tip',
          iconColor: AppTheme.accentLight,
          onTap: _showPrivacyPolicy,
        ),
        SettingsItem(
          title: 'Keluar',
          subtitle: 'Keluar dari akun Anda',
          iconName: 'logout',
          iconColor: AppTheme.errorLight,
          onTap: _showLogoutDialog,
        ),
      ],
    );
  }

  void _handleNotificationToggle(String key, bool value) {
    setState(() {
      _notificationSettings[key] = value;
    });
  }

  void _handleTimeChanged(String key, TimeOfDay time) {
    setState(() {
      _notificationSettings['${key}_time'] = time;
    });
  }

  void _handleAccessibilitySettingChanged(String key, dynamic value) {
    setState(() {
      _accessibilitySettings[key] = value;
    });
  }

  void _handleDataImported(Map<String, dynamic> importedData) {
    setState(() {
      if (importedData.containsKey('user_profile')) {
        _userProfile
            .addAll(importedData['user_profile'] as Map<String, dynamic>);
      }
    });
  }

  void _navigateToRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil'),
        content: const Text('Fitur edit profil akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Email'),
        content: const Text('Fitur ubah email akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Password'),
        content: const Text('Fitur ubah password akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showTherapistInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi Terapis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${_userProfile['therapistName']}'),
            SizedBox(height: 1.h),
            Text('Kontak: ${_userProfile['therapistContact']}'),
            SizedBox(height: 1.h),
            const Text('Spesialisasi: ADHD Therapy, CBT'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showAchievements() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pencapaian'),
        content:
            const Text('Fitur sertifikat pencapaian akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kontak Darurat'),
        content: const Text('Fitur edit kontak darurat akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showCrisisSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dukungan Krisis'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hotline Kesehatan Mental 24/7:'),
            Text('📞 119 ext 8'),
            SizedBox(height: 8),
            Text('Yayasan Pulih:'),
            Text('📞 021-788-42580'),
            SizedBox(height: 8),
            Text('Jika dalam keadaan darurat, segera hubungi 112'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showSessionTimeoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Timeout Sesi'),
        content: const Text('Fitur pengaturan timeout akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showDataSharingSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan Berbagi Data'),
        content:
            const Text('Fitur pengaturan berbagi data akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showDifficultySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tingkat Kesulitan'),
        content: const Text(
            'Fitur pengaturan tingkat kesulitan akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showTrackingFrequencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Frekuensi Tracking'),
        content: const Text(
            'Fitur pengaturan frekuensi tracking akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pusat Bantuan'),
        content: const Text('Fitur pusat bantuan akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showContactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hubungi Dukungan'),
        content: const Text('Fitur chat support akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berikan Feedback'),
        content: const Text('Fitur feedback akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Syarat & Ketentuan'),
        content: const Text('Fitur syarat & ketentuan akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kebijakan Privasi'),
        content: const Text('Fitur kebijakan privasi akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
