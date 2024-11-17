import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/widgets/big_text.dart';
import 'package:get/get.dart';

void showCustomerSnackBar(String mess, {bool isError = true,
String title = "Error"}) {
  Get.snackbar(title, mess, titleText: BigText(text: title, color: Colors.white),
  messageText: Text(mess, style: const TextStyle(
    color: Colors.white,
  ),
  ),
      colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
    backgroundColor: isError ? Colors.red : AppColors.mainColor,
  );
}