part of 'blog_bloc.dart';
@immutable
sealed class BlogEvent {}

final class UploadBlogEvent extends BlogEvent {
  final String title;
  final String content;
  final File image;
  final String posterId;
  final List<String> topics;

  UploadBlogEvent({
    required this.title,
    required this.content,
    required this.posterId,
    required this.image,
    required this.topics,
  });
}

final class BlogFetchAllBlogs extends BlogEvent {}

final class DeleteBlogEvent extends BlogEvent {
  final String blogId;
  final String userId;

  DeleteBlogEvent({
    required this.blogId,
    required this.userId,
  });
}
