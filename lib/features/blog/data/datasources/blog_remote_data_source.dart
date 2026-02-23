import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
  Future<void> deleteBlog({
    required String blogId,
    required String userId,
  });
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select();
      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from('blogs_images').upload(blog.id, image);
      return supabaseClient.storage.from('blogs_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles(name)');
      return blogs
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog['profiles']['name']),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlog({
    required String blogId,
    required String userId,
  }) async {
    try {
      // First verify the user owns this blog
      final blog = await supabaseClient
          .from('blogs')
          .select('poster_id')
          .eq('id', blogId)
          .single();

      if (blog['poster_id'] != userId) {
        throw ServerException('You do not have permission to delete this blog');
      }

      // Delete the blog image from storage
      await supabaseClient.storage.from('blogs_images').remove([blogId]);

      // Delete the blog from database
      await supabaseClient.from('blogs').delete().eq('id', blogId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
