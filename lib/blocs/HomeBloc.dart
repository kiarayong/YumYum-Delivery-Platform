
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/models/Food.dart';
import 'package:l1_213544z_yongle_project/resourese/auth_methods.dart';
import 'package:l1_213544z_yongle_project/resourese/firebase_helper.dart';

class HomePageBloc with ChangeNotifier {

  FirebaseHelper mFirebaseHelper = FirebaseHelper();
  AuthMethods mAuthMethods = AuthMethods();

  List<Food> foodList = [];
  List<Food> popularFoodList = [];
  List<Food> bannerFoodList = [];
  

  User mFirebaseUser;

  getCurrentUser() {
    mAuthMethods.getCurrentUser().then((User currentUser)  {
      mFirebaseUser = currentUser;
      notifyListeners();
    });
  }


  Future<List<Food>> fetchPopularFoods() async {
    try {
      return await mFirebaseHelper.fetchSpecifiedFoods("05");
    } catch (e) {
      print("Error fetching popular foods: $e");
      return [];
    }
  }

  getRecommendedFoodList() {
    // Fetch foods with menuId 05, 03, and 07


    mFirebaseHelper.fetchSpecifiedFoods("03").then((List<Food> foods) {
      foodList.addAll(foods);
      notifyListeners();
    });

  }
  

}