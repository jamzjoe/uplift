import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthScreen { login, register }

class AuthCubit extends Cubit<AuthScreen> {
  AuthCubit() : super(AuthScreen.login);

  void switchToLogin() {
    emit(AuthScreen.login);
  }

  void switchToRegister() {
    emit(AuthScreen.register);
  }
}
