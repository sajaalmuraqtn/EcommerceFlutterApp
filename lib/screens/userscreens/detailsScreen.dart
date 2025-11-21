import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:electrical_store_mobile_app/logic/models/product.dart';
import 'package:electrical_store_mobile_app/widgets/details/detailsBody.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {

    final Product product;

  const DetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: DetailsAppBar(context),
      body: Detailsbody(product:product,),
    );
  }

  AppBar DetailsAppBar(BuildContext context) {
    return   AppBar(
      elevation: 0,
      backgroundColor: kBackgroundColor,
      leading: IconButton(
        padding: EdgeInsets.only(right: kDefaultPadding),
        onPressed: ( ){
        Navigator.pop(context);
      },
       icon: Icon(Icons.arrow_back,color: kPrimaryColor,)),
       title: Text("رجوع",style: Theme.of(context).textTheme.bodyLarge,),
    );
  }
}