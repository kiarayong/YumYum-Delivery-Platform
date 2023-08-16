import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/resourese/auth_methods.dart';

class LoginPageBloc with ChangeNotifier {
  AuthMethods mAuthMethods = AuthMethods();
  bool isLoginPressed = false;

String validateEmail(String email) {
  if (email.isEmpty || !EmailValidator.validate(email)) {
    return 'Please enter a valid email';
  }
  return null;
}


  String validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter a password';
    } else if (password.length < 6) {
      return 'Password should be at least 6 characters';
    }
    return null;
  }

 Future<String> validateFormAndLogin(GlobalKey<FormState> formKey, String userName, String password) async {
    if (formKey.currentState.validate()) {
      try {
        isLoginPressed = true;
        notifyListeners();
        
        // Attempt to authenticate the user
        final result = await mAuthMethods.handleSignInEmail(userName, password);

        isLoginPressed = false;
        notifyListeners();

        if (result != null) {
          // Authentication successful, return null
          return null;
        } else {
          // Authentication failed, return an error message
          return 'User not found or invalid credentials';
        }
      } catch (error) {
        print('Error during login: $error');
        return 'An error occurred during login';
      }
    }
    return null; // Return null when form validation fails
  }
}


