import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/models/Food.dart';
import 'package:l1_213544z_yongle_project/models/Request.dart';
import 'package:l1_213544z_yongle_project/resourese/sql.dart';
import 'package:l1_213544z_yongle_project/resourese/firebase_helper.dart';
import 'package:l1_213544z_yongle_project/screens/homepage.dart';

class CartPageBloc with ChangeNotifier {
  List<Food> foodList = [];
  double totalPrice = 0;

  FirebaseHelper mFirebaseHelper = FirebaseHelper();
  DatabaseSql databaseSql;

  BuildContext context;
  void setBuildContext(BuildContext context) {
    this.context = context;
  }

  int get totalQuantity {
    int quantity = 0;
    for (var food in foodList) {
      quantity += food.quantity;
    }
    return quantity;
  }

 getDatabaseValue() async {
  databaseSql = DatabaseSql();
  await databaseSql.openDatabaseSql();
  cartItems = await databaseSql.getData();

  // Calculate the total price
  totalPrice = 0;
  for (var food in cartItems) {
    double foodItemPrice = double.parse(food.price) * food.quantity;
    totalPrice += foodItemPrice;
  }
  

  notifyListeners();
}



  List<Food> cartItems = [];

void loadCartItems() async {
  try {
    databaseSql = DatabaseSql();
    await databaseSql.openDatabaseSql();
    cartItems = await databaseSql.getData();

    // Add debug statement to check cart items
    print('Loaded Cart Items: $cartItems');

    // Calculate the total price
    totalPrice = 0;
    for (var food in cartItems) {
      double foodItemPrice = double.parse(food.price) * food.quantity;
      totalPrice += foodItemPrice;
    }

    notifyListeners();
  } catch (e) {
    print('Error loading cart items: $e');
  }
}
// orderPlaceToFirebase method
  orderPlaceToFirebase(String name, String address) async {
    print("orderPlaceToFirebase called");
    print("Total Price: ${totalPrice.toStringAsFixed(2)}");
    print("Cart Items: $cartItems");

    // Create a new Request object with the order details
    Request newOrder = Request(
      address: address,
      foodList: cartItems.map((food) => food.toMap()).toList(),
      name: name,
      uid: mFirebaseHelper.getCurrentUserUid(),
      status: "0", // Assuming "0" means the order is placed
      total: totalPrice.toStringAsFixed(2),
    );

    try {
      // Save the order to Firestore
      await mFirebaseHelper.addOrder(
  totalPrice.toStringAsFixed(2),
  cartItems.map((food) => food.toMap()).toList(),
  name,
  address,
);

      // Clear the cart items from the local database
      await databaseSql.deleteAllData();

      print("Order added successfully");
      notifyListeners();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
      );
    } catch (e) {
      print("Error adding order: $e");
    }
  }


//   // orderPlaceToFirebase method
//  orderPlaceToFirebase(String name, String address) async {
//   print("orderPlaceToFirebase called");
//   print("Total Price: ${totalPrice.toStringAsFixed(2)}");
//   print("Cart Items: $cartItems");
//   List<Map<String, dynamic>> cartItemMaps = cartItems.map((food) => food.toMap()).toList();
  

//   await mFirebaseHelper.addOrder(
//       totalPrice.toStringAsFixed(2), cartItemMaps, name, address); // Pass the list of maps
//   {
//     print("addOrder method completed successfully");
//     notifyListeners();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => HomePage(),
//       ),
//     );
//   }
// }

}
