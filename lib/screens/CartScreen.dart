import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDataScreen extends StatefulWidget {
  @override
  _CartDataScreenState createState() => _CartDataScreenState();
}

class _CartDataScreenState extends State<CartDataScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    try {
      // Get the path to the database
      String databasePath = await getDatabasesPath();
      String path = join(databasePath, "cart.db");

      // Open the database
      Database database = await openDatabase(path);

      // Fetch data from the database
      List<Map<String, dynamic>> results = await database.query("cartTable");

      // Update the state with the fetched data
      setState(() {
        cartItems = results;
      });

      // Close the database
      await database.close();
    } catch (e) {
      print("Error fetching data from the database: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Data"),
      ),
      body:ListView.builder(
  itemCount: cartItems.length,
  itemBuilder: (context, index) {
    String id = cartItems[index]["id"];
    String name = cartItems[index]["name"];
    double price = double.parse(cartItems[index]["price"]); // Convert to double
    String category = cartItems[index]["category"];
    String description = cartItems[index]["description"];

    return ListTile(
      title: Text(name),
      subtitle: Text("Price: $price, Category: $category, Description: $description"),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          // Implement delete functionality here if needed
        },
      ),
    );
  },
));}}
  

