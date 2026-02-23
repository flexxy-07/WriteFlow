import 'package:blog_app/core/common/utils/blog_utils.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_author_info.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_meta_info.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_topic_chip.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    final readingTime = calculateReadingTime(blog.content);
    final formattedDate = formatDateBlog(blog.updatedAt);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppPallete.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppPallete.borderColor,
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog Image
              if (blog.imageUrl.isNotEmpty)
                Stack(
                  children: [
                    Image.network(
                      blog.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: AppPallete.borderColor,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 50,
                              color: AppPallete.greyColor,
                            ),
                          ),
                        );
                      },
                    ),
                    // Gradient overlay at bottom for better text readability
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppPallete.backgroundColor.withOpacity(0.9),
                              AppPallete.backgroundColor.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Topics
                    if (blog.topics.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: blog.topics
                              .map((topic) => BlogTopicChip(topic: topic))
                              .toList(),
                        ),
                      ),

                    // Title
                    Text(
                      blog.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.whiteColor,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Content Excerpt
                    Text(
                      blog.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppPallete.greyColor.withOpacity(0.8),
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 16),

                    // Bottom Meta Information
                    Row(
                      children: [
                        Expanded(
                          child: BlogAuthorInfo(
                            authorName: blog.posterName,
                          ),
                        ),
                        // Separator Dot
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            color: AppPallete.greyColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        BlogMetaInfo(
                          date: formattedDate,
                          readingTime: readingTime,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
