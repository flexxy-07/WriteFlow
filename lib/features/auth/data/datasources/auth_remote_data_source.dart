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
    return UserModel.fromJson(response.user!.toJson()).copyWith(email: response.user!.email).copyWith(
      name: (await supabaseClient.from('profiles').select('name').eq('id', response.user!.id).single())['name'] ?? '',
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
      
       return UserModel.fromJson(response.user!.toJson()).copyWith(email: response.user!.email).copyWith(
        name: (await supabaseClient.from('profiles').select('name').eq('id', response.user!.id).single())['name'] ?? '',);
    }catch(e){
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if(currentUserSession != null){
        final userData = await supabaseClient.from('profiles').select('id, name').eq('id', currentUserSession!.user.id);

        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email
        ); 
      }
      
      return null;
    }catch(e){
      throw ServerException(e.toString());
    }
    
  }
  
  
}
