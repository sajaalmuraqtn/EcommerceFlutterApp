import '../../helpers/database_helper.dart';
import '../models/product.dart';

class ProductController {
  final dbHelper = DatabaseHelper.instance;

  Future<int> createProduct(Product product) async {
    final db = await dbHelper.database;
    return await db.insert('products', product.toMap());
  }

  Future<int> updateProduct(Product product) async {
    final db = await dbHelper.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await dbHelper.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // --------------------- SUPER FAST PRODUCTS + LIKES ----------------------
  Future<List<Product>> readAllProducts({int? userId}) async {
    final db = await dbHelper.database;

    final result = await db.rawQuery("""
      SELECT 
        p.*, 
        CASE 
          WHEN l.productId IS NOT NULL THEN 1 
          ELSE 0 
        END as isLiked
      FROM products p
      LEFT JOIN likes l
        ON p.id = l.productId AND l.userId = ?
    """, [userId]);

    return result.map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Product>> getLikedProducts(int userId) async {
    final db = await dbHelper.database;

    final result = await db.rawQuery("""
      SELECT p.*, 1 as isLiked
      FROM products p
      INNER JOIN likes l
        ON p.id = l.productId
      WHERE l.userId = ?
    """, [userId]);

    return result.map((e) => Product.fromMap(e)).toList();
  }

  Future<void> toggleLike(int userId, Product product) async {
    final db = await dbHelper.database;

    final check = await db.query(
      "likes",
      where: "userId = ? AND productId = ?",
      whereArgs: [userId, product.id],
    );

    if (check.isEmpty) {
      await db.insert("likes", {"userId": userId, "productId": product.id});
      product.isLiked = true;
    } else {
      await db.delete(
        "likes",
        where: "userId = ? AND productId = ?",
        whereArgs: [userId, product.id],
      );
      product.isLiked = false;
    }
  }
}
