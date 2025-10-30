import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../../widgets/custom_icon_widget.dart';

class SocialLoginWidget extends StatelessWidget {
  final Function(String provider) onSocialLogin;
  final bool isLoading;

  const SocialLoginWidget({
    super.key,
    required this.onSocialLogin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Divider with text
        Container(
          margin: EdgeInsets.symmetric(vertical: 3.h),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'atau masuk dengan',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),

        // Social Login Buttons
        Row(
          children: [
            // Google Login Button
            Expanded(
              child: _buildSocialButton(
                context: context,
                provider: 'Google',
                iconName: 'g_translate',
                backgroundColor: colorScheme.surface,
                borderColor: colorScheme.outline.withValues(alpha: 0.3),
                textColor: colorScheme.onSurface,
                onTap: () => onSocialLogin('google'),
              ),
            ),

            SizedBox(width: 3.w),

            // Apple Login Button
            Expanded(
              child: _buildSocialButton(
                context: context,
                provider: 'Apple',
                iconName: 'apple',
                backgroundColor: colorScheme.onSurface,
                borderColor: colorScheme.onSurface,
                textColor: colorScheme.surface,
                onTap: () => onSocialLogin('apple'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String provider,
    required String iconName,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 6.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: textColor,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              provider,
              style: theme.textTheme.titleSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

