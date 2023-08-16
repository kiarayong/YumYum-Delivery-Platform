import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:l1_213544z_yongle_project/blocs/RegisterBloc.dart';
import 'package:l1_213544z_yongle_project/resourese/auth_methods.dart';
import 'package:l1_213544z_yongle_project/screens/homepage.dart';
import 'package:l1_213544z_yongle_project/screens/loginpages/login.dart';
import 'package:l1_213544z_yongle_project/utils/universal_variables.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterPageBloc(),
      child: RegisterPageContent(),
    );
  }
}

class RegisterPageContent extends StatefulWidget {
  @override
  _RegisterPageContentState createState() => _RegisterPageContentState();
}

class _RegisterPageContentState extends State<RegisterPageContent> {
  AuthMethods _authMethods = AuthMethods(); // Initialize AuthMethods here

  RegisterPageBloc registerPageBloc;
  TextEditingController textNameController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();
  TextEditingController textPhoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    registerPageBloc = Provider.of<RegisterPageBloc>(context);
    return Scaffold(
      body: Container(
        color: UniversalVariables.whiteColor,
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
          child: Form(
            key: _formKey,
            child: buildForm(),
          ),
        ),
      ),
    );
  }

  buildForm() {
    return Column(
      children: [
        SizedBox(height: 20.0),
        FlutterLogo(size: 200.0,),
        SizedBox(height: 20.0),
        TextFormField(
          validator: (email) {
            return registerPageBloc.validateEmail(email);
          },
          controller: textNameController,
          decoration: InputDecoration(
            hintText: "Email",
          ),
        ),
        TextFormField(
          maxLength: 8,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          validator: (phone) {
            return registerPageBloc.validatePhone(phone);
          },
          controller: textPhoneController,
          decoration: InputDecoration(
            hintText: "PhoneNo",
          ),
        ),
        TextFormField(
          validator: (password) {
            return registerPageBloc.validatePassword(password);
          },
          controller: textPasswordController,
          decoration: InputDecoration(
            hintText: "Password",
          ),
        ),
        SizedBox(height: 20.0),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(UniversalVariables.orangeColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              // Start the registration process
              auth.User user = await _authMethods.handleSignUp(
                textPhoneController.text,
                textNameController.text,
                textPasswordController.text,
              );

              if (user != null) {
                // User registration successful
                gotoHomePage();
              } else {
                // User registration failed
                print('User registration failed');
              }
            }
          },
          child: Text(
            "Register",
            style: TextStyle(color: UniversalVariables.whiteColor,),
          ),
        ),
        registerPageBloc.isRegisterPressed
            ? Center(child: CircularProgressIndicator())
            : Container(),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(UniversalVariables.orangeColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          onPressed: () async {
            gotoLoginPage();
          },
          child: Text(
            "Login",
            style: TextStyle(color: UniversalVariables.whiteColor,),
          ),
        )
      ],
    );
  }

  gotoLoginPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  gotoHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
