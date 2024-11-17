import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/widgets/app_icon.dart';
import 'package:food_app/widgets/big_text.dart';

class AccountWidget extends StatelessWidget {
  AppIcon appIcon;
  BigText bigText;

  AccountWidget({super.key, required this.appIcon, required this.bigText});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: Dimension.width20,
          top: Dimension.height10, bottom: Dimension.height10),


      child: ClipRect(
        child: Row(
          children: [
            appIcon,
            SizedBox(width: Dimension.width20,),
            bigText
          ],
        ),
      ),
    );
  }
}