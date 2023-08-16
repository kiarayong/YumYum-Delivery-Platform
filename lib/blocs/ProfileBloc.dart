// profile_bloc.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    BuildContext context,
    Function clearTextFields, // Accept the callback function
  ) async {
    try {
      User user = _auth.currentUser;
      if (user != null) {
        AuthCredential credentials = EmailAuthProvider.credential(
          email: user.email,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credentials);
        await user.updatePassword(newPassword);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Password changed successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    clearTextFields(); // Call the callback function
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to change password. ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}