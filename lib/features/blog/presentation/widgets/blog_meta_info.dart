import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BlogMetaInfo extends StatelessWidget {
  final String date;
  final int readingTime;
  final double fontSize;
  final bool showIcon;

  const BlogMetaInfo({
    super.key,
    required this.date,
    required this.readingTime,
    this.fontSize = 13,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          date,
          style: TextStyle(
            fontSize: fontSize,
            color: AppPallete.greyColor.withOpacity(0.8),
          ),
        ),
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            color: AppPallete.greyColor,
            shape: BoxShape.circle,
          ),
        ),
        if (showIcon)
          Icon(
            Icons.access_time_rounded,
            size: 14,
            color: AppPallete.greyColor.withOpacity(0.8),
          ),
        if (showIcon) const SizedBox(width: 4),
        Text(
          '$readingTime min read',
          style: TextStyle(
            fontSize: fontSize,
            color: AppPallete.greyColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
