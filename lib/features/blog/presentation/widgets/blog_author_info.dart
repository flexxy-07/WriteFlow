import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BlogAuthorInfo extends StatelessWidget {
  final String? authorName;
  final double avatarRadius;
  final double fontSize;
  final bool showFullInfo;
  final Widget? metadata; // For additional info like date and reading time

  const BlogAuthorInfo({
    super.key,
    required this.authorName,
    this.avatarRadius = 16,
    this.fontSize = 13,
    this.showFullInfo = false,
    this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = authorName ?? 'Anonymous';
    final initial = displayName[0].toUpperCase();

    return Row(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: AppPallete.borderColor,
          child: Text(
            initial,
            style: TextStyle(
              fontSize: avatarRadius * 0.875, // Proportional font size
              fontWeight: FontWeight.bold,
              color: AppPallete.whiteColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (showFullInfo && metadata != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: fontSize + 3,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.whiteColor,
                  ),
                ),
                const SizedBox(height: 4),
                metadata!,
              ],
            ),
          )
        else
          Expanded(
            child: Text(
              displayName,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: AppPallete.whiteColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
