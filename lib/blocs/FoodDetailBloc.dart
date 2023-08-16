import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/models/Food.dart';
import 'package:l1_213544z_yongle_project/resourese/auth_methods.dart';
import 'package:l1_213544z_yongle_project/resourese/sql.dart';
import 'package:l1_213544z_yongle_project/resourese/firebase_helper.dart';

class FoodDetailPageBloc with ChangeNotifier {
  AuthMethods mAuthMethods = AuthMethods();
  FirebaseHelper mFirebaseHelper = FirebaseHelper();

  List<Food> foodList = [];

  var random = new Random();
  double _rating;

  // no of items add to list
  int mItemCount = 1;

  BuildContext context;

  // Constructor to initialize the rating value and scaffoldKey
  GlobalKey<ScaffoldState> scaffoldKey;

  FoodDetailPageBloc({this.scaffoldKey}) {
    _rating = 0.0;
  }

addToCart(Food food) async {
  DatabaseSql databaseSql = DatabaseSql();
  await databaseSql.openDatabaseSql();
  String uuid = Uuid().v4();
  Food foodWithUuid = food.copyWith(keys: uuid);
  await databaseSql.insertData(foodWithUuid, mItemCount); // Pass the mItemCount as the second argument
  await databaseSql.getData();
  final snackBar = SnackBar(
    content: Text('Food Added To Cart'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  mItemCount = 1;
  if (scaffoldKey != null) {
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
  notifyListeners();
}


  getPopularFoodList() {
    // setted 06 id category as popular.
    mFirebaseHelper.fetchSpecifiedFoods("06").then((List<Food> list) {
      foodList = list;
      notifyListeners();
    });
  }

  void increamentItems() {
    mItemCount++;
    notifyListeners();
  }

  void decreamentItems() {
    mItemCount--;
    notifyListeners();
  }

  // Add a method to update the rating value
  void updateRating(String newRating) {
    _rating = double.parse(newRating);
    notifyListeners();
  }

  // Getter to access the rating value
  double get rating => _rating;

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
}
