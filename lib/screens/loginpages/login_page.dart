import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/resourese/firebaseauth_service.dart';
import 'package:l1_213544z_yongle_project/screens/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controllers for e-mail and password textfields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool signUp = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFfed8c3),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
          shrinkWrap: true,
          reverse: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 535,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFffffff),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(signUp)
                            Text(
                              "Sign Up",
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4f4f4f),
                              ),
                            ),
                             if(!signUp)
                            Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4f4f4f),
                              ),
                            ),
                            
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Color(0xFF8d8d8d),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      prefixIcon:
                                          const Icon(Icons.mail_outline),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Password",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Color(0xFF8d8d8d),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      prefixIcon:
                                          const Icon(Icons.lock_outline),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //Sign in/Sign up button
                                  RaisedButton(
                                    onPressed: () async {
                                      if (signUp) {
                                        var newuser =
                                            await FirebaseAuthService().signUp(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                        );
                                        if (newuser != null) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()));
                                        }
                                      } else {
                                        var reguser =
                                            await FirebaseAuthService().signIn(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                        );
                                        if (reguser != null) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()));
                                        }
                                      }
                                    },
                                    child: signUp
                                        ? Text("Sign Up")
                                        : Text("Sign In"),
                                  ),
                                  //SignUp / Sign in toggler
                                  OutlineButton(
                                    onPressed: () {
                                      setState(() {
                                        signUp = !signUp;
                                      });
                                    },
                                    child: signUp
                                        ? Text("Have an account?Sign in")
                                        : Text("Create an account"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -253),
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/project-45295.appspot.com/o/plants2.png?alt=media&token=68fd32ac-cddf-48ea-b8fa-e16ab86fa583',
                        scale: 1.5,
                        width: double.infinity,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
