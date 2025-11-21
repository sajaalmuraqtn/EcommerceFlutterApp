// import 'package:electrical_store_mobile_app/helpers/constants.dart';
// import 'package:electrical_store_mobile_app/helpers/database_helper.dart';
// import 'package:electrical_store_mobile_app/logic/models/product.dart';
// import 'package:electrical_store_mobile_app/screens/detailsScreen.dart';
// import 'package:electrical_store_mobile_app/widgets/homeWidgets/productCard.dart';
// import 'package:flutter/material.dart';

// class HomeBody extends StatefulWidget {
//   const HomeBody({super.key});

//   @override
//   State<HomeBody> createState() => _HomeBodyState();
// }

// class _HomeBodyState extends State<HomeBody> {
//   List<Product> products = [];

// @override
// void initState() {
//   super.initState();
//   loadProducts();
// }

// void loadProducts() async {
//   products = await DatabaseHelper.instance.readAllProducts();
//   setState(() {});
// }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       bottom: false,

//        child: Column(
//         children: [
//           SizedBox(height: kDefaultPadding / 2),
//           Expanded(
//             child: Stack(
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(top: 70.0),
//                   decoration: BoxDecoration(
//                     color: kBackgroundColor,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                   ),
//                 ),
//                 ListView.builder(
//                   itemCount: products.length,
//                   itemBuilder: (context, index) => ProductCard(
//                     itemIndex: index,
//                     product: products[index],
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DetailsScreen(product: products[index],),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
