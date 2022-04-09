import 'package:crmcc/model/user_data_model.dart';
import 'package:crmcc/screen/clockpage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:dio/dio.dart';
import 'package:crmcc/constants/dio_intrepters.dart';
import 'package:crmcc/data/clock_data.dart';
import 'package:crmcc/data/login_data.dart';
import 'package:crmcc/model/clock_data_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:sizer/sizer.dart';

// stf
// stl

var token;
var userID;
bool falseUserOrPass = false;
var email;
var name;
UserLogin? data;
var errorText = '';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  void validate() {
    if (formkey.currentState!.validate()) {
      print("Validated");
    } else {
      print("Not Validated");
    }
  }

  String? validateEmail(value) {
    if (value.isEmpty) {
      return "Required";
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return "Please enter a valid email address";
    } else {
      return null;
    }
  }

  String? validatePass(value) {
    if (value.isEmpty) {
      return "Required";
    } else if (value.length < 8) {
      return "Should be at least 8 characters";
    } else if (value.length > 15) {
      return "Should not be more than 15 characters";
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 130),
                child: Image.asset(
                  'assets/MVp.png',
                  width: 200,
                  height: 200,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  autocorrect: false,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: validateEmail,
                  controller: emailController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_rounded,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: validatePass,
                  controller: pwdController,
                  obscureText: !_passwordVisible,
                ),
              ),
              //Text("The email or "),
              Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                    left: 20.0,
                    bottom: 20.0,
                    right: 20.0,
                  ),
                  child: buttonLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton.icon(
                          icon: Icon(Icons.login),
                          label: Text("Login"),
                          onPressed: () => buttonPressed())),
            ],
          ),
        ),
      ),
    );
  }

  removeErrorText() {
    setState(() {
      errorText = '';
    });
  }

  bool buttonLoading = false;

  Future<void> buttonPressed() async {
    setState(() {
      buttonLoading = true;
    });
    if (!formkey.currentState!.validate()) {
      return;
    }
    try {
      data = (await AuthData().login(emailController.text, pwdController.text));
      if (data!.user != null) {
        AppInterceptor.token = data!.token.toString();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ClockScreen(),
          ),
        );
      } else {
        print('failed');
      }
    } catch (e) {
      setState(() {
        falseUserOrPass = true;
        errorText = e.toString();

        if (errorText.indexOf("400") != -1)
          errorText = 'INVALID USER OR PASS, PLEASE TRY AGAIN!!';
        else if (errorText.indexOf("500") != -1)
          errorText = 'SERVER ERROR! PLEASE TRY AGAIN';
      });
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    setState(() {
      buttonLoading = false;
    });
  }

  MultiValidator(List<TextFieldValidator> list) {}
}
