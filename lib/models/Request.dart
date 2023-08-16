import 'package:l1_213544z_yongle_project/models/Food.dart';
class Request {
  String address;
  List<Map<String, dynamic>> foodList; // Update the type to List<Map<String, dynamic>>
  String name;
  String uid;
  String status;
  String total;

  Request({
    this.address,
    this.foodList,
    this.name,
    this.uid,
    this.status,
    this.total,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'foodList': foodList,
      'name': name,
      'uid': uid,
      'status': status,
      'total': total,
    };
  }

  Request.fromMap(Map<dynamic, dynamic> mapData) {
    address = mapData['address'];
    foodList = List<Map<String, dynamic>>.from(mapData['foodList']); // Update this line
    name = mapData['name'];
    uid = mapData["uid"];
    status = mapData["status"];
    total = mapData["total"];
  }
  void addCartItems(List<Food> cartItems) {
    foodList = cartItems.map((food) => food.toMap()).toList();
}
}