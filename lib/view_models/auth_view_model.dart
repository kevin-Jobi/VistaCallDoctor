import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';

class AuthViewModel {
  final AuthBloc authBloc;

  AuthViewModel(this.authBloc);

  void checkAuthState() {
    authBloc.add(AppStarted());
  }

  void signInWithGoogle() {
    authBloc.add(SignInWithGoogle());
  }

  void logout() {
    authBloc.add(SignOut());
  }
}
