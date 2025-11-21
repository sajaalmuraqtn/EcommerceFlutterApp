import 'package:electrical_store_mobile_app/helpers/constants.dart';
import 'package:flutter/material.dart';

class Colordot extends StatelessWidget {

final Color fillColor;
final bool isSelected;

  const Colordot({super.key, required this.fillColor, this.isSelected=false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2.5),
      padding: EdgeInsets.all(3.0),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color:  isSelected? fillColor:Colors.transparent),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:fillColor,
        ),
      ),
    );
  }
}
