import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final Size  size;
  final String image;
  const ProductImage({super.key, required this.size, required this.image});

  @override
  Widget build(BuildContext context) {
    return   Container(
              margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
              height: size.width*0.8,
              child: Stack(
                children: [
                  Container(
                    height: size.width*0.7,
                    width:size.width*0.7 ,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                  ),
                  Image(
                    image: AssetImage(image),
                    height:size.width*0.75 ,
                    width:size.width*0.75 ,
                    fit: BoxFit.cover,
                     
                  
                  )
                ],
              ),

             );
  }
}