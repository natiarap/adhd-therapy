import 'package:adhd_therapy/presentation/focus_training_games/widgets/game_detail_overlay.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/game_card.dart';
import './widgets/game_category_tabs.dart';
// ignore: duplicate_import
import './widgets/game_detail_overlay.dart';
import './widgets/progress_header.dart';

class FocusTrainingGames extends StatefulWidget {
  const FocusTrainingGames({super.key});

  @override
  State<FocusTrainingGames> createState() => _FocusTrainingGamesState();
}

class _FocusTrainingGamesState extends State<FocusTrainingGames>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;
  Map<String, dynamic>? _selectedGame;
  bool _showGameDetail = false;

  // Mock data for games
  final List<List<Map<String, dynamic>>> _gamesByCategory = [
    // Attention Games
    [
      {
        "id": 1,
        "title": "Sustained Attention Response Task",
        "category": "Perhatian",
        "thumbnail":
            "https://images.pexels.com/photos/5428836/pexels-photo-5428836.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 15,
        "difficulty": 2,
        "isCompleted": true,
        "personalBest": "85%",
        "instructions":
            "Tekan tombol ketika melihat huruf yang BUKAN huruf X. Latihan ini membantu meningkatkan kemampuan mempertahankan perhatian dalam jangka waktu yang lama.",
        "benefits":
            "Meningkatkan kemampuan fokus berkelanjutan, mengurangi impulsivitas, dan memperkuat kontrol inhibisi yang penting untuk penderita ADHD."
      },
      {
        "id": 2,
        "title": "Visual Attention Trainer",
        "category": "Perhatian",
        "thumbnail":
            "https://images.pexels.com/photos/8923962/pexels-photo-8923962.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 10,
        "difficulty": 1,
        "isCompleted": false,
        "personalBest": "",
        "instructions":
            "Temukan objek target di antara objek pengecoh dalam waktu yang ditentukan. Fokuskan perhatian visual Anda untuk menyelesaikan setiap level.",
        "benefits":
            "Memperkuat kemampuan perhatian selektif, meningkatkan kecepatan pemrosesan visual, dan mengurangi distractibility."
      },
      {
        "id": 3,
        "title": "Dual N-Back Challenge",
        "category": "Perhatian",
        "thumbnail":
            "https://images.pexels.com/photos/5428832/pexels-photo-5428832.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 20,
        "difficulty": 3,
        "isCompleted": true,
        "personalBest": "Level 4",
        "instructions":
            "Ingat posisi dan suara dari N langkah sebelumnya. Latihan ini menggabungkan memori kerja dengan perhatian terbagi untuk hasil maksimal.",
        "benefits":
            "Meningkatkan memori kerja, memperkuat kemampuan multitasking, dan mengembangkan kontrol eksekutif yang lebih baik."
      },
      {
        "id": 4,
        "title": "Focus Flow State",
        "category": "Perhatian",
        "thumbnail":
            "https://images.pexels.com/photos/6963098/pexels-photo-6963098.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 12,
        "difficulty": 2,
        "isCompleted": false,
        "personalBest": "",
        "instructions":
            "Ikuti pola gerakan yang berubah secara dinamis sambil mempertahankan fokus pada target utama. Latihan ini mengembangkan flow state yang optimal.",
        "benefits":
            "Mengembangkan kemampuan memasuki flow state, meningkatkan konsentrasi mendalam, dan mengurangi kecemasan saat fokus."
      }
    ],
    // Memory Games
    [
      {
        "id": 5,
        "title": "Working Memory Builder",
        "category": "Memori",
        "thumbnail":
            "https://images.pexels.com/photos/8923965/pexels-photo-8923965.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 18,
        "difficulty": 2,
        "isCompleted": true,
        "personalBest": "92%",
        "instructions":
            "Ingat urutan angka yang ditampilkan secara terbalik. Mulai dari 3 digit dan tingkatkan sesuai kemampuan Anda.",
        "benefits":
            "Memperkuat memori kerja, meningkatkan kemampuan manipulasi mental, dan mendukung fungsi eksekutif yang lebih baik."
      },
      {
        "id": 6,
        "title": "Pattern Memory Matrix",
        "category": "Memori",
        "thumbnail":
            "https://images.pexels.com/photos/5428840/pexels-photo-5428840.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 14,
        "difficulty": 1,
        "isCompleted": false,
        "personalBest": "",
        "instructions":
            "Hafalkan pola yang muncul dalam grid, kemudian reproduksi pola tersebut setelah grid kosong ditampilkan.",
        "benefits":
            "Mengembangkan memori spasial, meningkatkan kemampuan visualisasi, dan memperkuat koneksi neural untuk pembelajaran."
      },
      {
        "id": 7,
        "title": "Sequential Memory Challenge",
        "category": "Memori",
        "thumbnail":
            "https://images.pexels.com/photos/6963100/pexels-photo-6963100.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 16,
        "difficulty": 3,
        "isCompleted": true,
        "personalBest": "Level 8",
        "instructions":
            "Ikuti urutan warna dan suara yang semakin kompleks. Setiap level menambah satu elemen baru dalam sekuens.",
        "benefits":
            "Meningkatkan memori sekuensial, memperkuat kemampuan mengikuti instruksi multi-langkah, dan mengembangkan organisasi mental."
      },
      {
        "id": 8,
        "title": "Spatial Memory Navigator",
        "category": "Memori",
        "thumbnail":
            "https://images.pexels.com/photos/8923968/pexels-photo-8923968.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 22,
        "difficulty": 2,
        "isCompleted": false,
        "personalBest": "",
        "instructions":
            "Navigasi melalui maze virtual sambil mengingat lokasi objek penting. Gunakan memori spasial untuk mencapai tujuan.",
        "benefits":
            "Mengembangkan memori spasial, meningkatkan orientasi ruang, dan memperkuat kemampuan navigasi mental."
      }
    ],
    // Processing Speed Games
    [
      {
        "id": 9,
        "title": "Rapid Decision Maker",
        "category": "Kecepatan",
        "thumbnail":
            "https://images.pexels.com/photos/5428844/pexels-photo-5428844.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 8,
        "difficulty": 1,
        "isCompleted": true,
        "personalBest": "1.2 detik",
        "instructions":
            "Buat keputusan cepat berdasarkan stimulus visual yang muncul. Kecepatan dan akurasi sama pentingnya dalam latihan ini.",
        "benefits":
            "Meningkatkan kecepatan pemrosesan kognitif, mengurangi waktu reaksi, dan memperkuat pengambilan keputusan cepat."
      },
      {
        "id": 10,
        "title": "Symbol Speed Match",
        "category": "Kecepatan",
        "thumbnail":
            "https://images.pexels.com/photos/6963102/pexels-photo-6963102.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 12,
        "difficulty": 2,
        "isCompleted": false,
        "personalBest": "",
        "instructions":
            "Cocokkan simbol dengan pasangannya secepat mungkin. Latihan ini mengembangkan kecepatan pemrosesan visual dan motorik.",
        "benefits":
            "Meningkatkan koordinasi mata-tangan, mempercepat pemrosesan informasi visual, dan mengembangkan respons motorik yang efisien."
      },
      {
        "id": 11,
        "title": "Cognitive Speed Test",
        "category": "Kecepatan",
        "thumbnail":
            "https://images.pexels.com/photos/8923970/pexels-photo-8923970.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 15,
        "difficulty": 3,
        "isCompleted": true,
        "personalBest": "95 WPM",
        "instructions":
            "Selesaikan serangkaian tugas kognitif dalam batas waktu yang ketat. Kombinasi kecepatan dan akurasi menentukan skor akhir.",
        "benefits":
            "Mengoptimalkan efisiensi kognitif, meningkatkan kemampuan multitasking, dan memperkuat fungsi eksekutif under pressure."
      },
      {
        "id": 12,
        "title": "Reaction Time Optimizer",
        "category": "Kecepatan",
        "thumbnail":
            "https://images.pexels.com/photos/5428848/pexels-photo-5428848.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 10,
        "difficulty": 1,
        "isCompleted": false,
        "personalBest": "",
        "instructions":
            "Respons secepat mungkin terhadap stimulus yang muncul secara acak. Latihan ini mengasah refleks dan kecepatan reaksi.",
        "benefits":
            "Mempercepat waktu reaksi, meningkatkan kewaspadaan, dan mengoptimalkan koneksi saraf-otot untuk respons cepat."
      }
    ],
    // Flexibility Games
    [
      {
        "id": 13,
        "title": "Task Switching Master",
        "category": "Fleksibilitas",
        "thumbnail":
            "https://images.pexels.com/photos/6963104/pexels-photo-6963104.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 20,
        "difficulty": 2,
        "isCompleted": true,
        "personalBest": "88%",
        "instructions":
            "Beralih antara tugas yang berbeda berdasarkan petunjuk yang berubah. Latihan ini mengembangkan fleksibilitas kognitif.",
        "benefits":
            "Meningkatkan kemampuan task switching, mengurangi cognitive rigidity, dan memperkuat adaptabilitas mental."
      },
      {
        "id": 14,
        "title": "Cognitive Flexibility Trainer",
        "category": "Fleksibilitas",
        "thumbnail":
            "https://images.pexels.com/photos/8923972/pexels-photo-8923972.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 16,
        "difficulty": 3,
        "isCompleted": false,
        "personalBest": "",
        "instructions":
            "Adaptasi strategi Anda berdasarkan aturan yang berubah secara dinamis. Fleksibilitas mental adalah kunci sukses.",
        "benefits":
            "Mengembangkan fleksibilitas kognitif, meningkatkan kemampuan adaptasi, dan memperkuat problem-solving yang kreatif."
      },
      {
        "id": 15,
        "title": "Rule Reversal Challenge",
        "category": "Fleksibilitas",
        "thumbnail":
            "https://images.pexels.com/photos/5428850/pexels-photo-5428850.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 18,
        "difficulty": 2,
        "isCompleted": true,
        "personalBest": "Level 6",
        "instructions":
            "Ikuti aturan yang berubah secara tiba-tiba dan adaptasi respons Anda dengan cepat. Latihan ini menguji fleksibilitas mental.",
        "benefits":
            "Memperkuat kemampuan beradaptasi dengan perubahan, mengurangi perseverative errors, dan meningkatkan kontrol inhibisi."
      },
      {
        "id": 16,
        "title": "Mental Set Shifting",
        "category": "Fleksibilitas",
        "thumbnail":
            "https://images.pexels.com/photos/6963106/pexels-photo-6963106.jpeg?auto=compress&cs=tinysrgb&w=800",
        "duration": 14,
        "difficulty": 1,
        "isCompleted": false,
        "personalBest": "",
        "instructions":
            "Pindah antara set mental yang berbeda berdasarkan konteks yang berubah. Latihan ini mengembangkan fleksibilitas berpikir.",
        "benefits":
            "Meningkatkan kemampuan shifting attention, mengembangkan perspektif multiple, dan memperkuat adaptabilitas kognitif."
      }
    ]
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Latihan Fokus',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 5.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/settings-and-profile'),
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 5.w,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Progress Header
                ProgressHeader(
                  dailyStreak: 7,
                  totalFocusMinutes: 245,
                ),
                // Category Tabs
                GameCategoryTabs(
                  selectedIndex: _selectedCategoryIndex,
                  onTabSelected: (index) {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                ),
                // Games Grid
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 1.w,
                        mainAxisSpacing: 1.w,
                      ),
                      itemCount:
                          _gamesByCategory[_selectedCategoryIndex].length,
                      itemBuilder: (context, index) {
                        final game =
                            _gamesByCategory[_selectedCategoryIndex][index];
                        return GameCard(
                          game: game,
                          onTap: () => _showGameDetails(game),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Game Detail Overlay
            if (_showGameDetail && _selectedGame != null)
              GameDetailOverlay(
                game: _selectedGame!,
                onStartGame: _startGame,
                onClose: _closeGameDetails,
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 8.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(
                  icon: 'home',
                  label: 'Beranda',
                  isSelected: false,
                  onTap: () => Navigator.pushNamed(context, '/dashboard-home'),
                ),
                _buildBottomNavItem(
                  icon: 'psychology',
                  label: 'Latihan',
                  isSelected: true,
                  onTap: () {},
                ),
                _buildBottomNavItem(
                  icon: 'analytics',
                  label: 'Progress',
                  isSelected: false,
                  onTap: () => Navigator.pushNamed(
                      context, '/mood-and-progress-analytics'),
                ),
                _buildBottomNavItem(
                  icon: 'person',
                  label: 'Profil',
                  isSelected: false,
                  onTap: () =>
                      Navigator.pushNamed(context, '/settings-and-profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 6.w,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _showGameDetails(Map<String, dynamic> game) {
    setState(() {
      _selectedGame = game;
      _showGameDetail = true;
    });
  }

  void _closeGameDetails() {
    setState(() {
      _showGameDetail = false;
      _selectedGame = null;
    });
  }

  void _startGame() {
    _closeGameDetails();
    // Show game starting message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Memulai ${_selectedGame!['title']}...',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

