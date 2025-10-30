import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget optimized for ADHD therapeutic applications
/// Implements therapeutic minimalism with calming design elements
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final AppBarVariant variant;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.variant = AppBarVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color effectiveBackgroundColor;
    Color effectiveForegroundColor;

    switch (variant) {
      case AppBarVariant.primary:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
      case AppBarVariant.transparent:
        effectiveBackgroundColor = backgroundColor ?? Colors.transparent;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
      case AppBarVariant.therapeutic:
        effectiveBackgroundColor =
            backgroundColor ?? colorScheme.primary.withAlpha(13);
        effectiveForegroundColor = foregroundColor ?? colorScheme.primary;
        break;
    }

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: effectiveForegroundColor,
          letterSpacing: 0,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: variant == AppBarVariant.transparent ? 0 : elevation,
      shadowColor: theme.shadowColor.withAlpha(51),
      leading: _buildLeading(context, effectiveForegroundColor),
      actions: _buildActions(context, effectiveForegroundColor),
      shape: variant == AppBarVariant.transparent
          ? null
          : const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
            ),
    );
  }

  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: foregroundColor,
          size: 20,
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Kembali',
        splashRadius: 20,
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context, Color foregroundColor) {
    if (actions == null) return null;

    return actions!.map((action) {
      if (action is IconButton) {
        return IconButton(
          icon: action.icon,
          onPressed: action.onPressed,
          color: foregroundColor,
          tooltip: action.tooltip,
          splashRadius: 20,
        );
      }
      return action;
    }).toList();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar variants for different therapeutic contexts
enum AppBarVariant {
  /// Standard app bar with surface background
  primary,

  /// Transparent app bar for overlay contexts
  transparent,

  /// Therapeutic variant with calming primary color tint
  therapeutic,
}
