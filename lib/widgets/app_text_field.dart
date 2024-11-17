import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimension.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  bool isObscure;

  AppTextField({super.key,required this.textEditingController, required this.hintText, required this.icon, this.isObscure = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimension.width20, right: Dimension.width20, top: Dimension.height20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimension.radius15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 7,
            blurRadius: 10,
            offset: Offset(1, 10),
          ),
        ],
      ),
      child: TextField(
          obscureText: isObscure? true: false,
          controller: textEditingController,
          decoration: InputDecoration(
            // labelText: "Email",
            hintText: hintText,
            prefixIcon: Icon(icon, color: AppColors.yellowColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(Dimension.radius15)
            ),

            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(Dimension.radius15)
            ),

            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(Dimension.radius15)
            ),
          )
      ),
    );
  }
}
