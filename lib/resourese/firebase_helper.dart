import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:l1_213544z_yongle_project/models/Food.dart';
import 'package:l1_213544z_yongle_project/models/Request.dart';
import 'package:l1_213544z_yongle_project/resourese/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  // Firebase Database, will use to get reference.
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('Orders');

  static final DatabaseReference _ordersReference =
      _database.reference().child("Orders");

  String getCurrentUserUid() {
    User user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : null;
  }

  // fetch all foods list from food reference
  Future<List<Food>> fetchAllFood() async {
    List<Food> foodList = <Food>[];

    try {
      QuerySnapshot snapshot = await _firestore.collection('Foods').get();
      foodList.clear();

      snapshot.docs.forEach((doc) {
        Food food = Food(
          description: doc['description'],
          discount: doc['discount'],
          image: doc['image'],
          menuId: doc['menuId'],
          name: doc['name'],
          price: doc['price'],
          foodRating: doc['foodRating'],
          keys: doc.id,
        );
        foodList.add(food);
      });

      return foodList;
    } catch (e) {
      print("Error fetching foods: $e");
      return [];
    }
  }

  // fetch food list with query string
  Future<List<Food>> fetchSpecifiedFoods(String queryStr) async {
    List<Food> foodList = <Food>[];

    QuerySnapshot snapshot = await _firestore
        .collection('Foods')
        .where('menuId', isEqualTo: queryStr)
        .get();

    snapshot.docs.forEach((doc) {
      Food food = Food(
        description: doc['description'],
        discount: doc['discount'],
        image: doc['image'],
        menuId: doc['menuId'],
        name: doc['name'],
        price: doc['price'],
        foodRating: doc['foodRating'],
        keys: doc.id,
      );
      foodList.add(food);
    });
    return foodList;
  }

  Future<bool> placeOrder(Request request) async {
    await _ordersReference.child(request.uid).push().set(request.toMap());
    return true;
  }




Future<List<Request>> fetchOrders(User user) async {
    List<Request> orders = [];
    CollectionReference ordersCollection = FirebaseFirestore.instance.collection('Orders');

    try {
      // Query the orders collection for orders with the current user's UID
      QuerySnapshot querySnapshot = await ordersCollection.where('uid', isEqualTo: user.uid).get();

      // Convert the query result to a list of Request objects
      orders = querySnapshot.docs.map((doc) => Request.fromMap(doc.data())).toList();

      return orders;
    } catch (e) {
      print("Error fetching orders from Firestore: $e");
      throw e;
    }
  }
//   Future<void> addOrder(String totalPrice, List<Map<String, dynamic>> orderedFoodList, String name, String address) async {
//   try {
//     // Get user details
//     User user = await AuthMethods().getCurrentUser();
//     String uidtxt = user.uid;
//     String statustxt = "0";
//     String totaltxt = totalPrice; // Use the totalPrice string directly

//     Request request = Request(
//       address: address,
//       name: name,
//       uid: uidtxt,
//       status: statustxt,
//       total: totaltxt,
//       foodList: orderedFoodList,
//     );
//      print("Request Data: ${request.toMap()}");

//     print("Order adding!");
//     // Use push to generate a unique ID for the new order
//     await _ordersReference.push().set(request.toMap());
//     // var newOrderRef = _ordersReference.push();
    
//     // // Set the data for the unique ID
//     // await newOrderRef.set(request.toMap());
//     print("Order added successfully!");
//   } catch (e) {
//     print("Error adding order: $e");
//   }


// }

// Future<void> addOrder(String totalPrice, List<Map<String, dynamic>> foodList, String name, String address) async {
//     try {
//       // Access the Firestore instance and specify the 'orders' collection
//       CollectionReference ordersCollection = FirebaseFirestore.instance.collection('Orders');

//       await ordersCollection.add({
//         'total': totalPrice,
//         'name': name,
//         'address': address,
//         'foodList': foodList,
//         // Add other fields as needed (e.g., uid, status, timestamp, etc.)
//       });

//       print("Order added successfully!");
//     } catch (e) {
//       print("Error adding order: $e");
//     }
//   }
// }

Future<void> addOrder(String totalPrice, List<Map<String, dynamic>> foodList, String name, String address) async {
  try {
    // Get user details
    User user = await AuthMethods().getCurrentUser();
    String uidtxt = user.uid;
    String statustxt = "0";
    String totaltxt = totalPrice; // Use the totalPrice string directly

     await ordersCollection.add({
        'total': totaltxt,
        'name': name,
        'uid':uidtxt,
        'address': address,
        'status': statustxt, // Set the initial status of the order, you can change this as needed
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for sorting orders
        'foodList': foodList,
      });

    print("Order added successfully!");
  } catch (e) {
    print("Error adding order: $e");
  }
}



// Future<void> addOrder(String totalPrice, List<Food> orderedFoodList, String name, String address) async {
//   try {
//     // Get user details
//     User user = await AuthMethods().getCurrentUser();
//     if (user == null) {
//       print("User is not authenticated.");
//       return;
//     }
    
//     String uidtxt = user.uid;
//     String statustxt = "0";
//     String totaltxt = totalPrice; // Use the totalPrice string directly

//     // Create a model of the list of ordered foods
//     Map<String, dynamic> aux = {};
//     orderedFoodList.forEach((food) {
//       aux[food.keys] = {
//         'description': food.description,
//         'discount': food.discount,
//         'image': food.image,
//         'menuId': food.menuId,
//         'name': food.name,
//         'price': food.price,
//         'foodRating': food.foodRating,
//       };
//     });

//     Request request = Request(
//       address: address,
//       name: name,
//       uid: uidtxt,
//       status: statustxt,
//       total: totaltxt,
//       foodList: aux,
//     );

//     print("Order adding!");
//     // Add order to the database
//     await _firestore.collection('Orders').add(request.toMap());
//     print("Order added successfully!");
    
//     // Delete cart data 
//     DatabaseSql databaseSql = DatabaseSql();
//     await databaseSql.openDatabaseSql();
//     await databaseSql.deleteAllData();
//     print("Cart data deleted successfully!");
//   } catch (e) {
//     print("Error adding order: $e");
//   }
// }





//   Request request = new Request(
//     address:address,
//     name:name,
//     uid:uidtxt,
//     status:statustxt,
//     total:totaltxt,
//     foodList:aux
//   );

//   // add order to database
//   await _ordersReference.child(request.uid).push().set(request.toMap(request)).then((value) async {
//     // delete cart data
//     DatabaseSql databaseSql = DatabaseSql();
//     await databaseSql.openDatabaseSql();
//     await databaseSql.deleteAllData();
//   });
// }
}