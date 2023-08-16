// profile.dart
import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/blocs/ProfileBloc.dart';


class ProfilePage extends StatelessWidget {
  final ProfileBloc _profileBloc = ProfileBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ProfileForm(profileBloc: _profileBloc),
    );
  }
}

class ProfileForm extends StatefulWidget {
  final ProfileBloc profileBloc;

  ProfileForm({ this.profileBloc});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  


  // Add this function to clear the text fields
  void clearTextFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _currentPasswordController,
            decoration: InputDecoration(labelText: 'Current Password'),
            obscureText: true,
          ),
          TextFormField(
            controller: _newPasswordController,
            decoration: InputDecoration(labelText: 'New Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => widget.profileBloc.changePassword(
              _currentPasswordController.text,
              _newPasswordController.text,
              context,
              clearTextFields, // Pass the callback function
            ),
            child: Text('Change Password'),
          ),
        ],
      ),
    );
  }
}