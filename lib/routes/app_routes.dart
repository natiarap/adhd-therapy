import 'package:flutter/material.dart';
import '../presentation/mood_and_progress_analytics/mood_and_progress_analytics.dart';
import '../presentation/focus_training_games/focus_training_games.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/settings_and_profile/settings_and_profile.dart';
import '../presentation/dashboard_home/dashboard_home.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String moodAndProgressAnalytics = '/mood-and-progress-analytics';
  static const String focusTrainingGames = '/focus-training-games';
  static const String login = '/login-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String settingsAndProfile = '/settings-and-profile';
  static const String dashboardHome = '/dashboard-home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    moodAndProgressAnalytics: (context) => const MoodAndProgressAnalytics(),
    focusTrainingGames: (context) => const FocusTrainingGames(),
    login: (context) => const LoginScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    settingsAndProfile: (context) => const SettingsAndProfile(),
    dashboardHome: (context) => const DashboardHome(),
    // TODO: Add your other routes here
  };
}
