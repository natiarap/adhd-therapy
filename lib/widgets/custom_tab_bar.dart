import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Tab Bar widget optimized for ADHD therapeutic applications
/// Implements therapeutic minimalism with gentle visual feedback
class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<CustomTab> tabs;
  final int currentIndex;
  final Function(int) onTap;
  final TabBarVariant variant;
  final bool isScrollable;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.variant = TabBarVariant.standard,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.currentIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _tabController.animateTo(widget.currentIndex);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      widget.onTap(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.variant) {
      case TabBarVariant.standard:
        return _buildStandardTabBar(context, theme, colorScheme);
      case TabBarVariant.therapeutic:
        return _buildTherapeuticTabBar(context, theme, colorScheme);
      case TabBarVariant.pills:
        return _buildPillsTabBar(context, theme, colorScheme);
      case TabBarVariant.underlined:
        return _buildUnderlinedTabBar(context, theme, colorScheme);
    }
  }

  Widget _buildStandardTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        indicatorColor: widget.indicatorColor ?? colorScheme.primary,
        indicatorWeight: 2.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: widget.labelColor ?? colorScheme.primary,
        unselectedLabelColor:
            widget.unselectedLabelColor ?? colorScheme.onSurface.withAlpha(153),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        tabs: widget.tabs.map((tab) => _buildTab(tab, false)).toList(),
      ),
    );
  }

  Widget _buildTherapeuticTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: widget.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == widget.currentIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withAlpha(26)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: colorScheme.primary.withAlpha(51))
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: 18,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface.withAlpha(153),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        tab.text,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface.withAlpha(153),
                          letterSpacing: 0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPillsTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = index == widget.currentIndex;

            return Padding(
              padding: EdgeInsets.only(
                  right: index < widget.tabs.length - 1 ? 12 : 0),
              child: GestureDetector(
                onTap: () => widget.onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorScheme.primary : colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withAlpha(77),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withAlpha(51),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tab.icon != null) ...[
                        Icon(
                          tab.icon,
                          size: 16,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface.withAlpha(179),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        tab.text,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface.withAlpha(179),
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUnderlinedTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withAlpha(51),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        indicatorColor: widget.indicatorColor ?? colorScheme.primary,
        indicatorWeight: 3.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: widget.labelColor ?? colorScheme.primary,
        unselectedLabelColor:
            widget.unselectedLabelColor ?? colorScheme.onSurface.withAlpha(153),
        labelStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: widget.tabs.map((tab) => _buildTab(tab, true)).toList(),
      ),
    );
  }

  Widget _buildTab(CustomTab tab, bool isUnderlined) {
    return Tab(
      height: isUnderlined ? 48 : 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tab.icon != null) ...[
            Icon(tab.icon, size: 18),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              tab.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (tab.badge != null) ...[
            const SizedBox(width: 6),
            tab.badge!,
          ],
        ],
      ),
    );
  }
}

/// Tab bar variants for different therapeutic contexts
enum TabBarVariant {
  /// Standard Material Design tab bar
  standard,

  /// Therapeutic variant with enhanced visual feedback
  therapeutic,

  /// Pill-shaped tabs for modern appearance
  pills,

  /// Underlined tabs with minimal design
  underlined,
}

/// Custom tab model for therapeutic applications
class CustomTab {
  final String text;
  final IconData? icon;
  final Widget? badge;
  final String? route;

  const CustomTab({
    required this.text,
    this.icon,
    this.badge,
    this.route,
  });
}
