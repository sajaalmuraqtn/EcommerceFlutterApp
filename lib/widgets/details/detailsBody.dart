import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:electrical_store_mobile_app/logic/models/product.dart';
import 'package:electrical_store_mobile_app/widgets/details/colorDot.dart';
import 'package:electrical_store_mobile_app/widgets/details/productImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Detailsbody extends StatelessWidget {
  final Product product;
  const Detailsbody({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding*1.5),
          decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Center(child:ProductImage(size: size, image:product.image) ,)  ,
              Padding(
                padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Colordot(fillColor: kTextLightColor, isSelected: true),
                    Colordot(fillColor: Colors.blueAccent, isSelected: false),
                    Colordot(
                      fillColor: CupertinoColors.destructiveRed,
                      isSelected: false,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: kDefaultPadding/2,
                ),
                child: Text(
                  product.title ,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ), 

              Text('السعر ${ product.price }\$ ',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w600,
                color: kSecondaryColor
              ),
              
              ),

              SizedBox(height: kDefaultPadding),

            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: kDefaultPadding/2),
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding*1.5,vertical: kDefaultPadding/2),
          child: Text(product.description,
          style: TextStyle(
                fontSize: 19.0,
                 color: Colors.white
              ),
          ),
        )
      ],
    );
  }
}
