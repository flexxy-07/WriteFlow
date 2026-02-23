import 'package:blog_app/core/common/utils/show_snackbar.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_control_footer.dart';
import 'package:blog_app/features/blog/presentation/widgets/horizontal_blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ViewMode { vertical, horizontal }

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  bool _isSortedAscending = true;
  ViewMode _viewMode = ViewMode.vertical;

  @override
  void initState() {
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
    super.initState();
  }

  List<Blog> _getSortedBlogs(List<Blog> blogs) {
    final sortedBlogs = List<Blog>.from(blogs);
    sortedBlogs.sort((a, b) {
      return _isSortedAscending
          ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
          : b.title.toLowerCase().compareTo(a.title.toLowerCase());
    });
    return sortedBlogs;
  }

  void _toggleSort() {
    setState(() {
      _isSortedAscending = !_isSortedAscending;
    });
  }

  void _toggleViewMode() {
    setState(() {
      _viewMode = _viewMode == ViewMode.vertical
          ? ViewMode.horizontal
          : ViewMode.vertical;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.edit_note_rounded,
              size: 28,
              color: AppPallete.whiteColor,
            ),
            const SizedBox(width: 12),
            const Text('WriteFlow'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocConsumer<BlogBloc, BlogState>(
            listener: (context, state) {
              if (state is BlogFailure) {
                showSnackBar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is BlogLoading) {
                return const Loader();
              }
              if (state is BlogDisplaySuccess) {
                final sortedBlogs = _getSortedBlogs(state.blogs);

                if (_viewMode == ViewMode.vertical) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: sortedBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = sortedBlogs[index];
                      return BlogCard(
                        blog: blog,
                        color: AppPallete.gradient1,
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: sortedBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = sortedBlogs[index];
                      return HorizontalBlogCard(blog: blog);
                    },
                  );
                }
              }
              return const SizedBox();
            },
          ),
          BlogControlFooter(
            isSortedAscending: _isSortedAscending,
            viewMode: _viewMode,
            onSortToggle: _toggleSort,
            onViewModeToggle: _toggleViewMode,
          ),
        ],
      ),
    );
  }
}
