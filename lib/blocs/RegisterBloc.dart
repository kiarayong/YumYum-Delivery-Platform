

import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/resourese/auth_methods.dart';

class RegisterPageBloc with ChangeNotifier {

  AuthMethods mAuthMethods = AuthMethods();

  bool isRegisterPressed = false;

  String validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter valid email';
    }
    return null;
  } 

  String validatePassword(String password) {
    if (password.isEmpty && password.length<6) {
      return 'Password should atleast contain 6 character';
    }
    return null;
  } 

  String validatePhone(String phone) {
    if (phone.isEmpty && phone.length < 8) {
      return 'Invalid PhoneNo';
    }
    return null;
  } 

  Future<void> validateFormAndRegister(GlobalKey<FormState> formKey, String userName, String password, String phone) async {
      isRegisterPressed = true;
      notifyListeners();
      if(formKey.currentState.validate()){
          await mAuthMethods.handleSignUp(phone, userName, password);
          isRegisterPressed = false;
          notifyListeners();
      }
  }
}