import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:electrical_store_mobile_app/logic/controller/product_controller.dart';
import 'package:electrical_store_mobile_app/widgets/homeWidgets/productCard.dart';
import 'package:electrical_store_mobile_app/logic/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedProductsScreen extends StatefulWidget {
  const LikedProductsScreen({super.key});

  @override
  State<LikedProductsScreen> createState() => _LikedProductsScreenState();
}

class _LikedProductsScreenState extends State<LikedProductsScreen> {
  final ProductController productController = ProductController();
  List<Product> products = [];
  bool isLoading = true;
  int? user_id;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt("user_id");
    await loadLiked();
  }

  Future<void> loadLiked() async {
    if (user_id == null) return;
    setState(() => isLoading = true);
    products = await productController.getLikedProducts(user_id!);
    setState(() => isLoading = false);
  }

  Future<void> handleLike(Product p) async {
    if (user_id == null) return;
    await productController.toggleLike(user_id!, p);
    await loadLiked(); // إعادة تحميل القائمة بعد Like/Unlike
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المنتجات المعجب بها", style: TextStyle(color: kBackgroundColor)),
        backgroundColor: kPrimaryColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : products.isEmpty
              ? Center(child: Text("لا توجد منتجات معجب بها"))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return ProductCard(
                      itemIndex: index,
                      product: p,
                      onPressed: () {},
                      onLikeChanged: () => handleLike(p),
                    );
                  },
                ),
    );
  }
}

 