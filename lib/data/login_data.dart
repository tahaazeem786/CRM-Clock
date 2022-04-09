import 'package:crmcc/constants/dio_intrepters.dart';
import 'package:crmcc/model/user_data_model.dart';

class AuthData {
  Future<UserLogin> login(String email, String password) async {
    return UserLogin.fromJson((await api().post(
      "login",
      data: {
        'email': email,
        'password': password,
      },
    ))
        .data);
  }
}
