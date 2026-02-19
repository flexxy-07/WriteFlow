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
      print('🔐 [DataSource] Starting signup for email: $email');
      print('🔐 [DataSource] User name: $name');
      
       final response = await supabaseClient.auth.signUp(
         email: email,
         password: password,
         data: {
          'name' : name
         }
       );
       
       print('🔐 [DataSource] Signup response received');
       print('🔐 [DataSource] Response user: ${response.user}');
       print('🔐 [DataSource] User ID: ${response.user?.id}');
       print('🔐 [DataSource] User email: ${response.user?.email}');
       
       if(response.user == null){
        print('❌ [DataSource] ERROR: User is null after signup');
        throw ServerException('User is null');
       }
       print('✅ [DataSource] User created successfully with ID: ${response.user!.id}');
       return UserModel.fromJson(response.user!.toJson()).copyWith(email: response.user!.email).copyWith(
        name: (await supabaseClient.from('profiles').select('name').eq('id', response.user!.id).single())['name'] ?? '',)
    }on AuthApiException catch(e){
      print('❌ [DataSource] AuthApiException caught: ${e.message}');
      print('❌ [DataSource] Status Code: ${e.statusCode}');
      print('❌ [DataSource] Code: ${e.code}');
      
      // Check if it's a rate limit error but user was still created
      if(e.statusCode == '429' || e.code == 'over_email_send_rate_limit'){
        print('⚠️ [DataSource] Email rate limit exceeded - User may still be created in database');
      }
      
      throw ServerException('${e.message} (Status: ${e.statusCode})');
    }catch(e){
      print('❌ [DataSource] Exception caught: $e');
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
