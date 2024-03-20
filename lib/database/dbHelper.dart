import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:jwt_app/models/favsProducts.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

class DbHelper {
  static Future<Database> database() async {
    // sqflite_ffi.databaseFactory = sqflite_ffi.databaseFactoryFfi;
    return openDatabase(
      join(await getDatabasesPath(), 'products.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE products(_id TEXT PRIMARY KEY, name TEXT, owner TEXT, rate TEXT, image TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<FavProducts> insertProduct(Map<String, dynamic> product) async {
    final Database db = await database();
    final query = await db.insert(
      'products',
      product,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (query != 0) {
      return FavProducts(
        id: product['id'],
        name: product['name'],
        image: product['image'],
        owner: product['owner'],
        rating: product['rate'],
      );
    } else {
      throw Exception('Failed to insert product');
    }
  }

  static Future<List<Map<String, dynamic>>> products() async {
    final Database db = await database();
    final List<Map<String, dynamic>> queryResult = await db.query('products');
    return queryResult;
    // final query = await db.query('products');
    // return query;
  }

  static Future<String> productToJson() async {
    final List<Map<String, dynamic>> productsList = await products();
    return jsonEncode(productsList);
  }

  static Future<void> deleteFavs(String id) async {
    final db = await database();
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteProduct() async {
    final db = await database();
    await db.delete(
      'products',
    );
  }

  static Future close() async {
    final Database db = await database();
    db.close();
  }
}
