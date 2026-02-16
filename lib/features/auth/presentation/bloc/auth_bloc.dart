import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;

  AuthBloc({required UserSignUp userSignUp})
    : _userSignUp = userSignUp,
      super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async{
      print('🔵 [AuthBloc] AuthSignUp event received');
      print('🔵 [AuthBloc] Email: ${event.email}, Name: ${event.name}');
      
      final res =  await _userSignUp(
        UserSignUpParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      print('🔵 [AuthBloc] UseCase returned result');
      res.fold(
        (failure) {
          print('❌ [AuthBloc] Failure: ${failure.message}');
          emit(AuthFailure(message: failure.message));
        }, 
        (user) {
          print('✅ [AuthBloc] Success! User ID: ${user.id}');
          emit(AuthSuccess(user: user));
        }
      );
    });
  }
}
