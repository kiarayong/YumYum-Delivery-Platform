import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  DocumentReference reference;

  String description;
  String discount;
  String image;
  String menuId;
  String name;
  String price;
  String foodRating;
  String keys;
  int quantity;

  Food({
    this.description,
    this.discount,
    this.image,
    this.menuId,
    this.name,
    this.price,
    this.foodRating,
    this.keys,
    this.quantity,
  });

  Food.fromMap(Map<String, dynamic> mapData) {
    this.description = mapData['description'];
    this.discount = mapData['discount'];
    this.image = mapData['image'];
    this.menuId = mapData['menuId'];
    this.name = mapData['name'];
    this.price = mapData['price'];
    this.foodRating = mapData['foodRating'];
    this.keys = mapData['keys'];
    this.quantity = mapData['quantity'] ?? 1;
    
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'discount': discount,
      'image': image,
      'menuId': menuId,
      'name': name,
      'price': price,
      'foodRating': foodRating,
      'keys': keys,
      'quantity': quantity,
    };
  }

Future<void> updateRating(double newRating) async {
  try {
    if (reference == null) {
      // If the reference is null, fetch the document's reference from Firestore
      final collection = FirebaseFirestore.instance.collection('Foods');
      reference = collection.doc(keys);
    }

    // Check if the document exists before updating the food rating
    final snapshot = await reference.get();
    if (snapshot.exists) {
      // Update the food rating in Firestore
      await reference.update({'foodRating': newRating.toString()});
      print('Rating updated successfully.');
    } else {
      // Document does not exist, handle this scenario according to your app logic
      print('Document not found, cannot update rating. Document ID: $keys');
    }
  } catch (e) {
    print('Error updating food rating: $e');
  }
}
static Future<String> getFoodRatingFromFirestore(String documentId) async {
    try {
      DocumentSnapshot foodSnapshot =
          await FirebaseFirestore.instance.collection('Foods').doc(documentId).get();

      if (foodSnapshot.exists) {
        return foodSnapshot.data()['foodRating'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching foodRating: $e');
      return null;
    }
  }
Food copyWith({String keys}) {
    return Food(
      // Copy all other properties and update the keys value
      keys: keys ?? this.keys,
      name: this.name,
      price: this.price,
      menuId: this.menuId,
      image: this.image,
      discount: this.discount,
      description: this.description,
    );
  }

Food.fromSnapshot(DocumentSnapshot snapshot) {
  // Initialize other fields from snapshot data
  description = snapshot['description'];
  discount = snapshot['discount'];
  image = snapshot['image'];
  menuId = snapshot['menuId'];
  name = snapshot['name'];
  price = snapshot['price'];
  foodRating = snapshot['foodRating'] ?? '0'; // Set default value to '0' if foodRating is null
  keys = snapshot.id;

  // Set the reference to the Firestore document
  reference = snapshot.reference;
}


}
