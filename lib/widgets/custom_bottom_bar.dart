import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar optimized for ADHD therapeutic applications
/// Implements contextual navigation that adapts based on user focus state
class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isVisible;
  final BottomBarVariant variant;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isVisible = true,
    this.variant = BottomBarVariant.standard,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  // Hardcoded navigation items for therapeutic ADHD application
  final List<BottomBarItem> _items = [
    const BottomBarItem(
      icon: Icons.home_rounded,
      activeIcon: Icons.home_rounded,
      label: 'Beranda',
      route: '/dashboard-home',
    ),
    const BottomBarItem(
      icon: Icons.psychology_outlined,
      activeIcon: Icons.psychology_rounded,
      label: 'Latihan',
      route: '/focus-training-games',
    ),
    const BottomBarItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics_rounded,
      label: 'Progress',
      route: '/mood-and-progress-analytics',
    ),
    const BottomBarItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
      route: '/settings-and-profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _opacityAnimation.value) * 100),
            child: _buildBottomBar(context, theme, colorScheme),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    switch (widget.variant) {
      case BottomBarVariant.standard:
        return _buildStandardBottomBar(context, theme, colorScheme);
      case BottomBarVariant.floating:
        return _buildFloatingBottomBar(context, theme, colorScheme);
      case BottomBarVariant.therapeutic:
        return _buildTherapeuticBottomBar(context, theme, colorScheme);
    }
  }

  Widget _buildStandardBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return _buildBottomBarItem(
                context,
                item,
                isSelected,
                index,
                colorScheme,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withAlpha(38),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == widget.currentIndex;

            return _buildBottomBarItem(
              context,
              item,
              isSelected,
              index,
              colorScheme,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTherapeuticBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface.withAlpha(242),
            colorScheme.surface,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(26),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return _buildTherapeuticBottomBarItem(
                context,
                item,
                isSelected,
                index,
                colorScheme,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarItem(
    BuildContext context,
    BottomBarItem item,
    bool isSelected,
    int index,
    ColorScheme colorScheme,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(context, index, item.route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? item.activeIcon : item.icon,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(153),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withAlpha(153),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTherapeuticBottomBarItem(
    BuildContext context,
    BottomBarItem item,
    bool isSelected,
    int index,
    ColorScheme colorScheme,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(context, index, item.route),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withAlpha(26)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withAlpha(38)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withAlpha(153),
                  size: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: GoogleFonts.nunitoSans(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withAlpha(153),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, int index, String route) {
    if (index != widget.currentIndex) {
      widget.onTap(index);
      Navigator.pushNamed(context, route);
    }
  }
}

/// Bottom bar variants for different therapeutic contexts
enum BottomBarVariant {
  /// Standard bottom navigation bar
  standard,

  /// Floating bottom navigation bar with rounded corners
  floating,

  /// Therapeutic variant with enhanced visual feedback
  therapeutic,
}

/// Bottom bar item model
class BottomBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
