import 'package:crmcc/form_submission_status.dart';

class LoginState {
  final String username;
  final String password;
  final FormSubmissionStatus formStatus;

  LoginState({
    this.username = '',
    this.password = '',
    this.formStatus = const IntialFormStatus(),
  });

  LoginState copyWith({
    required String username,
    required String password,
    required FormSubmissionStatus formStatus,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
