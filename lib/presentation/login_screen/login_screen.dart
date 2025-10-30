import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/sign_up_prompt_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'admin@adhdtherapy.com': 'admin123',
    'user@adhdtherapy.com': 'user123',
    'therapist@adhdtherapy.com': 'therapist123',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 6.h),

                      // App Logo and Branding
                      const AppLogoWidget(),

                      // Welcome Text
                      Container(
                        margin: EdgeInsets.only(bottom: 4.h),
                        child: Column(
                          children: [
                            Text(
                              'Selamat Datang Kembali',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Masuk untuk melanjutkan perjalanan terapi Anda',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Error Message
                      _errorMessage != null
                          ? Container(
                              margin: EdgeInsets.only(bottom: 2.h),
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.errorLight.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.errorLight
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const CustomIconWidget(
                                    iconName: 'error_outline',
                                    color: AppTheme.errorLight,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: AppTheme.errorLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),

                      // Login Form
                      LoginFormWidget(
                        onLogin: _handleLogin,
                        isLoading: _isLoading,
                      ),

                      // Social Login Options
                      SocialLoginWidget(
                        onSocialLogin: _handleSocialLogin,
                        isLoading: _isLoading,
                      ),

                      //Expanded(child: Container()), 
                      SizedBox(height: 6.h),
                      // Sign Up Prompt
                      const SignUpPromptWidget(),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    if (_mockCredentials.containsKey(email) &&
        _mockCredentials[email] == password) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard-home');
      }
    } else {
      // Error - show friendly message
      setState(() {
        _errorMessage = 'Email atau kata sandi tidak valid. Silakan coba lagi.';
      });

      // Error haptic feedback
      HapticFeedback.vibrate();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate social login process
    await Future.delayed(const Duration(seconds: 3));

    // For demo purposes, always succeed with social login
    HapticFeedback.lightImpact();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/dashboard-home');
    }

    setState(() {
      _isLoading = false;
    });
  }
}


