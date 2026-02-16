import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, User>> logInWithEmailAndPassword({required String email, required String password}) {
    // TODO: implement logInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({required String name, required String email, required String password}) async {
   try {
     print('📚 [Repository] signUpWithEmailAndPassword called');
     print('📚 [Repository] Email: $email, Name: $name');
     
     final user = await remoteDataSource.signUpWithEmailPassword(name: name, email: email, password: password);
     
     print('📚 [Repository] Signup succeeded, User ID: $user');
     return right(user);
   }on ServerException catch(e){
    print('❌ [Repository] ServerException caught: ${e.message}');
    return left(Failure(e.message));
   }catch(e){
    print('❌ [Repository] Unexpected exception: $e');
    return left(Failure(e.toString()));
   }
  }

}