import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrical_store_mobile_app/logic/controller/likecontroller.dart';
import 'package:electrical_store_mobile_app/logic/models/auth/user_session.dart';
import 'package:electrical_store_mobile_app/logic/models/product.dart';

class FirebaseProductService {
  final collection = FirebaseFirestore.instance.collection("products");
     Future<List<Product>> fetchProducts() async {
    final snapshot = await collection.get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
  Future<void> addProduct(Map<String, dynamic> p) async {
    await collection.doc(p["id"]).set(p);
  }

  Future<void> updateProduct(Map<String, dynamic> p) async {
    await collection.doc(p["id"]).update(p);
  }

  Future<void> deleteProduct(String id) async {
    await collection.doc(id).delete();
  }
  
 static  Future<void> syncLikesToFirestore() async {
  final userId =await UserSession.getUserId();
  if (userId == null) return;

  final likedIds = await LikeController.getLikedProducts(userId);

  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  for (var productId in likedIds) {
    final docRef = firestore.collection('likes').doc('${userId}_$productId');
    batch.set(docRef, {
      'userId': userId,
      'productId': productId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  try {
    await batch.commit();
    print("All likes synced to Firestore!");
  } catch (e) {
    print("Error syncing likes: $e");
  }
}
}
