import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:l1_213544z_yongle_project/models/User.dart';

class AuthMethods {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static final DatabaseReference _userReference = _database.reference().child("Users");

Future<auth.User> getCurrentUser() async {
  try {
    auth.User currentUser = _auth.currentUser;
    if (currentUser != null) {
      // User is authenticated
      print("User is authenticated: ${currentUser.uid}");
    } else {
      // User is not authenticated or null
      print("User is not authenticated or null.");
    }
    return currentUser;
  } catch (e) {
    print("Error getting current user: $e");
    return null;
  }
}



  Stream<auth.User> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  Future<auth.User> handleSignInEmail(String email, String password) async {
    final auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final auth.User user = userCredential.user;

    assert(user != null);
    assert(await user.getIdToken() != null);
    final auth.User currentUser = _auth.currentUser;
    
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded: $user');

    return user;
  }

  Future<auth.User> handleSignUp(String phone, String email, String password) async {
  try {
    final auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final auth.User user = userCredential.user;

    assert(user != null);
    assert(await user.getIdToken() != null);
    
    // Add user data to the database
    await addDataToDb(user, email, phone, password);
    
    return user;
  } catch (e) {
    print('Error during registration: $e');
    return null;
  }
}


  Future<void> addDataToDb(auth.User currentUser, String username, String phone, String password) async {
    User user = User(
      uid: currentUser.uid,
      email: currentUser.email,
      phone: phone,
      password: password,
    );

    _userReference.child(currentUser.uid).set(user.toMap(user));
  }
  

  Future<void> logout() async {
    await _auth.signOut();
    
  }
}
