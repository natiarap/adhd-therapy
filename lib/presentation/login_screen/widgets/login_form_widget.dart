import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final bool isLoading;

  const LoginFormWidget({
    super.key,
    required this.onLogin,
    this.isLoading = false,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _isPasswordValid = password.length >= 6;
    });
  }

  bool get _isFormValid => _isEmailValid && _isPasswordValid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !widget.isLoading,
                  decoration: InputDecoration(
                    hintText: 'Masukkan email Anda',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'email',
                        color: _isEmailValid
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                    ),
                    suffixIcon: _emailController.text.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName:
                                  _isEmailValid ? 'check_circle' : 'error',
                              color: _isEmailValid
                                  ? AppTheme.successLight
                                  : AppTheme.errorLight,
                              size: 20,
                            ),
                          )
                        : null,
                    errorText:
                        _emailController.text.isNotEmpty && !_isEmailValid
                            ? 'Format email tidak valid'
                            : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!_isEmailValid) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),

          // Password Field
          Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kata Sandi',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  enabled: !widget.isLoading,
                  decoration: InputDecoration(
                    hintText: 'Masukkan kata sandi Anda',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'lock',
                        color: _isPasswordValid
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: _isPasswordVisible
                              ? 'visibility'
                              : 'visibility_off',
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 20,
                        ),
                      ),
                    ),
                    errorText:
                        _passwordController.text.isNotEmpty && !_isPasswordValid
                            ? 'Kata sandi minimal 6 karakter'
                            : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi tidak boleh kosong';
                    }
                    if (!_isPasswordValid) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (_isFormValid) {
                      widget.onLogin(
                          _emailController.text, _passwordController.text);
                    }
                  },
                ),
              ],
            ),
          ),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      // Navigate to forgot password screen
                      Navigator.pushNamed(context, '/forgot-password');
                    },
              child: Text(
                'Lupa Kata Sandi?',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Login Button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: _isFormValid && !widget.isLoading
                  ? () => widget.onLogin(
                      _emailController.text, _passwordController.text)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.12),
                foregroundColor: _isFormValid
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withValues(alpha: 0.38),
                elevation: _isFormValid ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Masuk',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

