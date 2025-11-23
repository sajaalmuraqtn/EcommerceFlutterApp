import 'package:flutter/material.dart';
import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:electrical_store_mobile_app/logic/controller/product_controller.dart';
import 'package:electrical_store_mobile_app/logic/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProductCard extends StatefulWidget {
  final int itemIndex;
  final Product product;
  final Function() onPressed;
  final Future<void> Function() onLikeChanged; // 🔥 إخطار parent

  const ProductCard({
    super.key,
    required this.itemIndex,
    required this.product,
    required this.onPressed,
    required this.onLikeChanged,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.7,
      upperBound: 1.0,
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void onLikePressed() async {
    // Animation
    _controller.forward().then((value) => _controller.reverse());

    // Toggle like locally
    setState(() {
      widget.product.isLiked = !widget.product.isLiked;
    });

    // إخطار الـ parent لإعادة تحميل البيانات في حال الحاجة
    await widget.onLikeChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: widget.onPressed,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 10),
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
              ],
            ),
            child: Row(
              children: [
                // Image
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: widget.product.image.contains('assets/')?  Image.asset(widget.product.image, fit: BoxFit.cover):CachedNetworkImage(imageUrl: widget.product.image,fit:  BoxFit.cover)   ,
                  ),
                ),

                // Info
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.product.title,
                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                        const SizedBox(height: 15),
                        Text(widget.product.subTitle),
                        Text(widget.product.category,style:TextStyle(color: kSecondaryColor) ,),
                        Text("السعر: ${widget.product.price}\$",
                            style: const TextStyle(color: kPrimaryColor)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ❤️ Like Button
        Positioned(
          top: 10,
          right: 25,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTap: onLikePressed,
              child: Icon(
                widget.product.isLiked ? Icons.favorite : Icons.favorite_border,
                color: widget.product.isLiked ? Colors.red : Colors.grey,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
