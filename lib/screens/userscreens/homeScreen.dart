import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:electrical_store_mobile_app/helpers/database_helper.dart';
import 'package:electrical_store_mobile_app/logic/controller/product_controller.dart';
import 'package:electrical_store_mobile_app/logic/models/product.dart';
import 'package:electrical_store_mobile_app/screens/auth/loginscreen.dart';
import 'package:electrical_store_mobile_app/screens/user/profilescreen.dart';
import 'package:electrical_store_mobile_app/screens/userscreens/detailsScreen.dart';
import 'package:electrical_store_mobile_app/screens/userscreens/liked_products_screen.dart';
import 'package:electrical_store_mobile_app/widgets/homeWidgets/productCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductController productController = ProductController();
  List<Product> products = [];
  bool isLoggedIn = false;
  int? user_id;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initializeApp();
    });
  }

  // ----------- INITIALIZE APP ----------
  Future<void> _initializeApp() async {
    await checkLoginStatus();
    await _loadProducts();
  }

  // ----------- CHECK LOGIN STATUS ----------
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
      user_id = prefs.getInt("user_id");
    });
  }

  // ----------- LOAD PRODUCTS ----------
  Future<void> _loadProducts() async {
    setState(() => _loading = true);

    if (isLoggedIn && user_id != null) {
      products = await productController.readAllProducts(userId: user_id);
    } else {
      products = await productController.readAllProducts();
    }

    setState(() => _loading = false);
  }

  // ----------- LIKE HANDLER (بدون إعادة تحميل من DB) ----------
Future<void> handleLike(Product p) async {
  if (user_id == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("يجب تسجيل الدخول لإضافة إعجاب")),
    );
    return;
  }

  await productController.toggleLike(user_id!, p);

  setState(() {
    p.isLiked = !p.isLiked; // تحديث مباشر بدون إعادة تحميل DB
  });
}


  @override
  Widget build(BuildContext context) {
    int likedCount = products.where((p) => p.isLiked).length;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          isLoggedIn
              ? "تصفح المنتجات المتنوعة"
              : "مرحباً بكم في متجرنا الإلكتروني",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!isLoggedIn)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                ).then((_) => _initializeApp());
              },
              icon: Icon(Icons.login, color: Colors.white),
            ),
          if (isLoggedIn) ...[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              },
              icon: Icon(Icons.person, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LikedProductsScreen()),
                );
              },
              icon: Stack(
                children: [
                  Icon(Icons.favorite, color: Colors.white),
                  if (likedCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          likedCount.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: kDefaultPadding / 2),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 70),
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),

                  // ----------- LOADING ----------
                  if (_loading)
                    Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    )
                  // ----------- NO PRODUCTS ----------
                  else if (products.isEmpty)
                    Center(child: Text("لا توجد منتجات"))
                  // ----------- PRODUCTS LIST ----------
                  else
                    ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final p = products[index];
                        return ProductCard(
                          itemIndex: index,
                          product: p,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(product: p),
                              ),
                            ).then((_) => _loadProducts());
                          },
                          onLikeChanged: () => handleLike(p),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
