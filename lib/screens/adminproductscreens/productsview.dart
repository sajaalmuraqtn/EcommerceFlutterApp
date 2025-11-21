import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:electrical_store_mobile_app/screens/adminproductscreens/addproductscreen.dart';
import 'package:electrical_store_mobile_app/screens/adminproductscreens/updateproductscreen.dart';
import 'package:electrical_store_mobile_app/screens/user/profilescreen.dart';
import 'package:flutter/material.dart';
import '../../logic/models/product.dart';
import '../../logic/controller/product_controller.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final ProductController _controller = ProductController();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
   }

  Future<void> _loadProducts() async {
    final data = await _controller.readAllProducts();
    setState(() {
      _products = data.cast<Product>();
      _isLoading = false;
    });
  }

  Future<void> _deleteProduct(int id) async {
    await _controller.deleteProduct(id);
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة تحكم المنتجات",style: TextStyle(color: kBackgroundColor),),        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>   ProfileScreen()),
              );
            },
            icon: Icon(Icons.person_rounded),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? const Center(child: Text("لا توجد منتجات"))
          : Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) =>
                        _buildProductCard(_products[index]),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
          if (result == true) _loadProducts();
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(Product p) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: p.image.contains('assets/')? Image.asset(p.image, fit: BoxFit.cover):Image.network(p.image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  p.subTitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                Text(p.category,style:TextStyle(color: kSecondaryColor) ,),

                const SizedBox(height: 8),
                Text(
                  "${p.price} \$",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: kPrimaryColor),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProductScreen(product: p),
                          ),
                        );
                        if (result == true) _loadProducts();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("تأكيد الحذف"),
                            content: Text("هل تريد حذف المنتج \"${p.title}\"؟"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text("لا"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text("نعم"),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) await _deleteProduct(p.id!);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
