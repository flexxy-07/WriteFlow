import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';

class BlogControlFooter extends StatelessWidget {
  final bool isSortedAscending;
  final ViewMode viewMode;
  final VoidCallback onSortToggle;
  final VoidCallback onViewModeToggle;

  const BlogControlFooter({
    super.key,
    required this.isSortedAscending,
    required this.viewMode,
    required this.onSortToggle,
    required this.onViewModeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // View Mode Toggle (moved to left)
                _buildViewModeToggle(),

                // Divider
                Container(
                  width: 1,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppPallete.whiteColor.withOpacity(0),
                        AppPallete.whiteColor.withOpacity(0.3),
                        AppPallete.whiteColor.withOpacity(0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Sort Toggle (moved to right)
                _buildSortToggle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortToggle() {
    return InkWell(
      onTap: onSortToggle,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppPallete.whiteColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppPallete.whiteColor.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.filter_list_rounded,
          color: const Color(0xFF00D9FF),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildViewModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppPallete.whiteColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppPallete.whiteColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButtonSmooth(
            icon: Icons.view_agenda_outlined,
            name: 'List',
            isSelected: viewMode == ViewMode.vertical,
            onTap: viewMode == ViewMode.horizontal ? onViewModeToggle : null,
          ),
          const SizedBox(width: 12),
          _buildToggleButtonSmooth(
            icon: Icons.view_carousel_outlined,
            name: 'Grid',
            isSelected: viewMode == ViewMode.horizontal,
            onTap: viewMode == ViewMode.vertical ? onViewModeToggle : null,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtonSmooth({
    required IconData icon,
    required String name,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00D9FF)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00D9FF).withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF1F2937)
                  : AppPallete.whiteColor.withOpacity(0.5),
              size: 18,
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isSelected
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(width: 0),
              secondChild: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  name,
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
