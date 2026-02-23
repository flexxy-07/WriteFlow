import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BlogTopicChip extends StatelessWidget {
  final String topic;
  final double fontSize;
  final EdgeInsets padding;

  const BlogTopicChip({
    super.key,
    required this.topic,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppPallete.borderColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppPallete.borderColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        topic,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: AppPallete.whiteColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
