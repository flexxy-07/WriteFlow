import 'package:blog_app/core/common/utils/blog_utils.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_author_info.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_meta_info.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_topic_chip.dart';
import 'package:flutter/material.dart';

class HorizontalBlogCard extends StatelessWidget {
  final Blog blog;

  const HorizontalBlogCard({
    super.key,
    required this.blog,
  });

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
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppPallete.borderColor,
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog Image
              if (blog.imageUrl.isNotEmpty)
                Container(
                  width: 140,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppPallete.borderColor.withOpacity(0.3),
                  ),
                  child: Image.network(
                    blog.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppPallete.borderColor,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: AppPallete.greyColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Topics
                          if (blog.topics.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: blog.topics
                                    .take(2)
                                    .map(
                                      (topic) => BlogTopicChip(
                                        topic: topic,
                                        fontSize: 11,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),

                          // Title
                          Text(
                            blog.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppPallete.whiteColor,
                              height: 1.3,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Content Preview
                          Text(
                            blog.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppPallete.greyColor.withOpacity(0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Author and Meta Info
                      Row(
                        children: [
                          Expanded(
                            child: BlogAuthorInfo(
                              authorName: blog.posterName,
                              avatarRadius: 12,
                              fontSize: 11,
                            ),
                          ),
                          BlogMetaInfo(
                            date: formattedDate,
                            readingTime: readingTime,
                            fontSize: 11,
                            showIcon: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
