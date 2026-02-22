import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(password: password, email: email);
    if(response.user == null){
      throw ServerException('User is null');
    }
    return UserModel(
      id: response.user!.id,
      email: response.user!.email ?? '',
      name: response.user!.userMetadata?['name'] ?? '',
    );
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
       final response = await supabaseClient.auth.signUp(
         email: email,
         password: password,
         data: {
          'name' : name
         }
       );
       
       if(response.user == null){
        
        throw ServerException('User is null');
       }
      
       return UserModel(
         id: response.user!.id,
         email: response.user!.email ?? '',
         name: response.user!.userMetadata?['name'] ?? '',
       );
    }catch(e){
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if(currentUserSession != null){
        return UserModel(
          id: currentUserSession!.user.id,
          email: currentUserSession!.user.email ?? '',
          name: currentUserSession!.user.userMetadata?['name'] ?? '',
        );
      }
      
      return null;
    }catch(e){
      throw ServerException(e.toString());
    }
    
  }
  
  
}
