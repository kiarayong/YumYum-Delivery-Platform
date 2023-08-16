import 'dart:async';
import 'package:l1_213544z_yongle_project/models/Food.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSql {

  Database database;
  int count;

  Future<void> openDatabaseSql() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'carts.db');

    // open the database
    database = await openDatabase(path, version: 1,
 onCreate: (Database db, int version) async {
  // When creating the db, create the table
  await db.execute(
    "CREATE TABLE cartsTable(keys TEXT PRIMARY KEY, name TEXT, price TEXT, menuId TEXT, image TEXT, discount TEXT, description TEXT, quantity INTEGER)",
  );
},


    );
  }

Future<bool> insertData(Food food, int quantity) async {
  await database.transaction((txn) async {
    int id1 = await txn.rawInsert(
        'INSERT INTO cartsTable(keys, name, price, menuId, image, discount, description, quantity) VALUES("${food.keys}","${food.name}","${food.price}","${food.menuId}","${food.image}","${food.discount}","${food.description}", $quantity)');
    print('inserted1: $id1');
  });
  return true;
}




  Future<int> countData() async {
    count = Sqflite
        .firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM cartsTable'));
    assert(count == 2);
    return count;
  }

  Future<bool> deleteData(String id) async {
    count = await database
        .rawDelete('DELETE FROM cartsTable WHERE keys = ?', [id]);
    print(id);
    return true;
  }


  Future<bool> deleteAllData() async {
    count = await database
        .rawDelete('DELETE FROM cartsTable ');
    return true;
  }


  Future<List<Food>> getData() async {
    List<Food> foodList=[];
    List<Map> list = await database.rawQuery('SELECT * FROM cartsTable');
    // convert to list food
    list.forEach((map) {
      foodList.add(Food.fromMap(map));
    });
    return foodList;
  }

}