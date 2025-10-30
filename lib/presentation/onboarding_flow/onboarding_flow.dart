import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/celebration_animation_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/setup_card_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _parallaxController;
  int _currentPage = 0;
  bool _showCelebration = false;

  // Setup selections
  String? _selectedAgeGroup;
  final List<String> _selectedSymptoms = [];
  final List<String> _selectedGoals = [];

  // Mock data for onboarding pages
  final List<Map<String, dynamic>> _onboardingPages = [
    {
      "title": "Selamat Datang di Terapi ADHD",
      "description":
          "Aplikasi terpercaya untuk membantu mengelola gejala ADHD dan meningkatkan kualitas hidup Anda setiap hari.",
      "imageUrl":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "title": "Lacak Gejala & Suasana Hati",
      "description":
          "Pantau perkembangan harian Anda dengan mudah. Catat suasana hati dan tingkat perhatian untuk terapi yang lebih efektif.",
      "imageUrl":
          "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "title": "Latihan Fokus & Permainan",
      "description":
          "Tingkatkan konsentrasi dengan permainan terapi yang menyenangkan dan latihan fokus yang telah terbukti efektif.",
      "imageUrl":
          "https://images.unsplash.com/photo-1606092195730-5d7b9af1efc5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "title": "Pengingat Obat & Rutinitas",
      "description":
          "Jangan pernah lupa minum obat lagi. Atur pengingat cerdas dan bangun rutinitas harian yang mendukung kesehatan Anda.",
      "imageUrl":
          "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  // Setup options
  final List<Map<String, dynamic>> _ageGroups = [
    {
      "id": "child",
      "title": "Anak (6-12 tahun)",
      "description":
          "Program terapi khusus untuk anak-anak dengan pendekatan yang menyenangkan",
      "icon": Icons.child_care,
    },
    {
      "id": "teen",
      "title": "Remaja (13-17 tahun)",
      "description":
          "Terapi yang disesuaikan dengan kebutuhan dan tantangan remaja",
      "icon": Icons.school,
    },
    {
      "id": "adult",
      "title": "Dewasa (18+ tahun)",
      "description":
          "Program komprehensif untuk mengelola ADHD di kehidupan dewasa",
      "icon": Icons.work,
    },
  ];

  final List<Map<String, dynamic>> _symptoms = [
    {
      "id": "attention",
      "title": "Kesulitan Fokus",
      "description": "Sulit berkonsentrasi pada tugas atau aktivitas",
      "icon": Icons.psychology,
    },
    {
      "id": "hyperactivity",
      "title": "Hiperaktivitas",
      "description": "Merasa gelisah dan sulit untuk diam",
      "icon": Icons.mood,
    },
    {
      "id": "impulsivity",
      "title": "Impulsivitas",
      "description": "Bertindak tanpa berpikir terlebih dahulu",
      "icon": Icons.help_outline,
    },
    {
      "id": "organization",
      "title": "Masalah Organisasi",
      "description": "Kesulitan mengatur waktu dan tugas",
      "icon": Icons.schedule,
    },
  ];

  final List<Map<String, dynamic>> _goals = [
    {
      "id": "focus",
      "title": "Meningkatkan Fokus",
      "description": "Latihan untuk memperpanjang rentang perhatian",
      "icon": Icons.center_focus_strong,
    },
    {
      "id": "medication",
      "title": "Manajemen Obat",
      "description": "Pengingat dan pelacakan konsumsi obat",
      "icon": Icons.medication,
    },
    {
      "id": "routine",
      "title": "Membangun Rutinitas",
      "description": "Menciptakan kebiasaan harian yang sehat",
      "icon": Icons.fitness_center,
    },
    {
      "id": "mindfulness",
      "title": "Mindfulness & Relaksasi",
      "description": "Teknik meditasi dan pernapasan untuk ketenangan",
      "icon": Icons.self_improvement,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _parallaxController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _parallaxController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showSetupScreen();
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/dashboard-home');
  }

  void _showSetupScreen() {
    setState(() {
      _currentPage = _onboardingPages.length;
    });
  }

  void _completeSetup() {
    if (_selectedAgeGroup != null &&
        _selectedSymptoms.isNotEmpty &&
        _selectedGoals.isNotEmpty) {
      setState(() {
        _showCelebration = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mohon lengkapi semua pilihan untuk melanjutkan',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _onCelebrationComplete() {
    Navigator.pushReplacementNamed(context, '/dashboard-home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: Stack(
        children: [
          // Main Content
          _showCelebration
              ? CelebrationAnimationWidget(
                  onComplete: _onCelebrationComplete,
                )
              : _currentPage < _onboardingPages.length
                  ? _buildOnboardingContent()
                  : _buildSetupContent(),

          // Skip Button (only for onboarding pages)
          if (_currentPage < _onboardingPages.length && !_showCelebration)
            Positioned(
              top: 6.h,
              right: 6.w,
              child: SafeArea(
                child: TextButton(
                  onPressed: _skipOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  ),
                  child: Text(
                    'Lewati',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOnboardingContent() {
    return Column(
      children: [
        // Progress Indicator
        SafeArea(
          child: ProgressIndicatorWidget(
            currentPage: _currentPage,
            totalPages: _onboardingPages.length,
          ),
        ),

        // Page View
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardingPages.length,
            itemBuilder: (context, index) {
              final page = _onboardingPages[index];
              return OnboardingPageWidget(
                title: page["title"] as String,
                description: page["description"] as String,
                imageUrl: page["imageUrl"] as String,
                isLastPage: index == _onboardingPages.length - 1,
                onNext: _nextPage,
                onGetStarted: _showSetupScreen,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSetupContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentPage = _onboardingPages.length - 1;
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Pengaturan Awal',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 12.w),
              ],
            ),

            SizedBox(height: 3.h),

            // Age Group Selection
            _buildSectionTitle('Pilih Kelompok Usia'),
            SizedBox(height: 2.h),
            ..._ageGroups.map((group) => SetupCardWidget(
                  title: group["title"] as String,
                  description: group["description"] as String,
                  icon: group["icon"] as IconData,
                  isSelected: _selectedAgeGroup == group["id"],
                  onTap: () {
                    setState(() {
                      _selectedAgeGroup = group["id"] as String;
                    });
                  },
                )),

            SizedBox(height: 4.h),

            // Symptoms Selection
            _buildSectionTitle('Gejala Utama (Pilih yang sesuai)'),
            SizedBox(height: 2.h),
            ..._symptoms.map((symptom) => SetupCardWidget(
                  title: symptom["title"] as String,
                  description: symptom["description"] as String,
                  icon: symptom["icon"] as IconData,
                  isSelected: _selectedSymptoms.contains(symptom["id"]),
                  onTap: () {
                    setState(() {
                      if (_selectedSymptoms.contains(symptom["id"])) {
                        _selectedSymptoms.remove(symptom["id"]);
                      } else {
                        _selectedSymptoms.add(symptom["id"] as String);
                      }
                    });
                  },
                )),

            SizedBox(height: 4.h),

            // Goals Selection
            _buildSectionTitle('Tujuan Terapi (Pilih yang diinginkan)'),
            SizedBox(height: 2.h),
            ..._goals.map((goal) => SetupCardWidget(
                  title: goal["title"] as String,
                  description: goal["description"] as String,
                  icon: goal["icon"] as IconData,
                  isSelected: _selectedGoals.contains(goal["id"]),
                  onTap: () {
                    setState(() {
                      if (_selectedGoals.contains(goal["id"])) {
                        _selectedGoals.remove(goal["id"]);
                      } else {
                        _selectedGoals.add(goal["id"] as String);
                      }
                    });
                  },
                )),

            SizedBox(height: 6.h),

            // Complete Setup Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: ElevatedButton(
                onPressed: _completeSetup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Selesaikan Pengaturan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
