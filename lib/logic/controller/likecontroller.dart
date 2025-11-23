import 'package:electrical_store_mobile_app/helpers/database_helper.dart';
import 'package:electrical_store_mobile_app/logic/models/product.dart';
import 'package:sqflite/sqflite.dart';
 
class LikeController {

  // ----------- GET LIKED PRODUCTS ------------
 static Future<List<Product>> getLikedProducts(String userId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery("""
      SELECT p.*, 1 AS isLiked
      FROM products p
      INNER JOIN likes l
        ON p.id = l.productId
      WHERE l.userId = ?
    """, [userId]);

    return result.map((e) => Product.fromMap(e)).toList();
  }
 static Future<void> toggleLike(String userId, Product product) async {
    final db = await DatabaseHelper.instance.database;

  final check = await db.query(
    "likes",
    where: "userId = ? AND productId = ?",
    whereArgs: [userId, product.id],
  );

  if (check.isEmpty) {
    await db.insert("likes", {"userId": userId, "productId": product.id});
    product.isLiked = true;
  } else {
    await db.delete("likes",
        where: "userId = ? AND productId = ?",
        whereArgs: [userId, product.id]);
    product.isLiked = false;
  }
}

}
