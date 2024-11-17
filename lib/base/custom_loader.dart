import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/auth_controller.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    print("CustomLoader " + Get.find<AuthController>().isLoading.toString());
    return Center(
      child: Container(
        height: Dimension.height100,
        width: Dimension.width100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimension.height20*5/2),
          color:AppColors.mainColor,

        ),
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: Colors.white,

        )
      ),
    );
  }
}
