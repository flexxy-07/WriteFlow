import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements UseCase<void, DeleteBlogParams> {
  final BlogRepository blogRepository;
  DeleteBlog(this.blogRepository);

  @override
  Future<Either<Failure, void>> call(DeleteBlogParams params) async {
    return await blogRepository.deleteBlog(
      blogId: params.blogId,
      userId: params.userId,
    );
  }
}

class DeleteBlogParams {
  final String blogId;
  final String userId;

  DeleteBlogParams({
    required this.blogId,
    required this.userId,
  });
}
