import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/utils/blog_utils.dart';
import 'package:blog_app/core/common/utils/show_snackbar.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_author_info.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_meta_info.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_topic_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogViewerPage extends StatefulWidget {
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(blog: blog),
      );

  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  void _showDeleteConfirmation(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Blog'),
        content: const Text('Are you sure you want to delete this blog? This action cannot be undone.'),
        backgroundColor: AppPallete.backgroundColor,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BlogBloc>().add(
                    DeleteBlogEvent(
                      blogId: widget.blog.id,
                      userId: userId,
                    ),
                  );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppPallete.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppUserCubit>().state;
    String? currentUserId;
    
    if (currentUser is AppUserLoggedIn) {
      currentUserId = currentUser.user.id;
    }
    
    final isOwner = currentUserId != null && currentUserId == widget.blog.posterId;

    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogFailure) {
          showSnackBar(context, state.message);
        } else if (state is BlogDeleteSuccess) {
          showSnackBar(context, 'Blog deleted successfully');
          Navigator.pop(context);
          // Refresh blog list
          context.read<BlogBloc>().add(BlogFetchAllBlogs());
        }
      },
      builder: (context, state) {
        if (state is BlogLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            actions: [
              if (isOwner)
                IconButton(
                  onPressed: () => _showDeleteConfirmation(context, currentUserId!),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete Blog',
                ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border_outlined),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                if (widget.blog.imageUrl.isNotEmpty)
                  Image.network(
                    widget.blog.imageUrl,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        color: AppPallete.borderColor,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 60,
                            color: AppPallete.greyColor,
                          ),
                        ),
                      );
                    },
                  ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Topics
                      if (widget.blog.topics.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.blog.topics
                                .map((topic) => BlogTopicChip(
                                      topic: topic,
                                      fontSize: 13,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),

                      // Title
                      Text(
                        widget.blog.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.whiteColor,
                          height: 1.3,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Author and Meta Information
                      BlogAuthorInfo(
                        authorName: widget.blog.posterName,
                        avatarRadius: 24,
                        showFullInfo: true,
                        metadata: BlogMetaInfo(
                          date: formatDateBlog(widget.blog.updatedAt),
                          readingTime: calculateReadingTime(widget.blog.content),
                        ),
                      ),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Container(
                          height: 1,
                          color: AppPallete.borderColor.withOpacity(0.5),
                        ),
                      ),

                      // Content
                      Text(
                        widget.blog.content,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.8,
                          color: AppPallete.whiteColor,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
