import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:electrical_store_mobile_app/logic/controller/product_controller.dart';
import 'package:electrical_store_mobile_app/logic/models/product.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController title;
  late TextEditingController subTitle;
  late TextEditingController description;
  late TextEditingController image;
  late TextEditingController price;

  final ProductController controller = ProductController();
  final _formKey = GlobalKey<FormState>();

  final List<String> categories = [
    "الإلكترونيات والأجهزة",
    "الأزياء والملابس",
    "المنزل والمطبخ",
    "الجمال والعناية الشخصية",
    "الكتب والوسائط",
  ];

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.product.title);
    subTitle = TextEditingController(text: widget.product.subTitle);
    description = TextEditingController(text: widget.product.description);
    image = TextEditingController(text: widget.product.image);
    price = TextEditingController(text: widget.product.price.toString());

    selectedCategory = widget.product.category;
  }

  void update() async {
    if (!_formKey.currentState!.validate()) return;

    Product updated = Product(
      id: widget.product.id,
      title: title.text,
      subTitle: subTitle.text,
      description: description.text,
      price: int.parse(price.text),
      image: image.text,
      category: selectedCategory!,
    );

    await controller.updateProduct(updated);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم التعديل على المنتج بنجاح"),backgroundColor: Colors.green),
      );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل المنتج", style: TextStyle(color: kBackgroundColor)),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
               ClipRRect(
                 borderRadius: const BorderRadius.vertical(
                   top: Radius.circular(12),
                   bottom: Radius.circular(12),
                 ),
                 child: widget.product.image.contains('assets/')? Image.asset(widget.product.image ,height: 250,):Image.network(widget.product.image, fit: BoxFit.cover,width: 30),
               ),
             const  SizedBox(height: 50,),
              // العنوان
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: "العنوان"),
                validator: (value) =>
                    value == null || value.isEmpty ? "الرجاء إدخال العنوان" : null,
              ),
            const  SizedBox(height: 10,),

              TextFormField(
                controller: subTitle,
                decoration: const InputDecoration(labelText: "العنوان الفرعي"),
                validator: (value) =>
                    value == null || value.isEmpty ? "الرجاء إدخال العنوان الفرعي" : null,
              ),
             const  SizedBox(height: 10,),

              TextFormField(
                controller: description,
                decoration: const InputDecoration(labelText: "الوصف"),
                validator: (value) =>
                    value == null || value.isEmpty ? "الرجاء إدخال الوصف" : null,
              ),
             const  SizedBox(height: 10,),

              // رابط الصورة
              TextFormField(
                controller: image,
                decoration: const InputDecoration(labelText: "رابط الصورة"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "الرجاء إدخال رابط الصورة";
                  if (!Uri.tryParse(value)!.isAbsolute && !value.contains('assets/')) {
                    return "رابط الصورة غير صالح";
                  }
                  return null;
                },
              ),
                const  SizedBox(height: 10,),

              // السعر
              TextFormField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "السعر"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "الرجاء إدخال السعر";
                  if (int.tryParse(value) == null) return "السعر يجب أن يكون رقم صحيح";
                  return null;
                },
              ),
                const  SizedBox(height: 10,),

              // التصنيف
              DropdownButtonFormField(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: "التصنيف"),
                items: categories.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c));
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value),
                validator: (value) =>
                    value == null ? "الرجاء اختيار تصنيف" : null,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: update,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "تحديث",
                  style: TextStyle(color: kBackgroundColor, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
