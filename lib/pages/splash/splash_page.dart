import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_app/routes/route_helper.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';

import '../../controllers/popular_product_coontroller.dart';
import '../../controllers/recommended_product_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  Future<void> _loadResource() async {
      await Get.find<PopularProductController>().getPopularProductList();
      await Get.find<RecommendedProductController>().getRecommendedProductList();
  }
  @override
  void initState() {
    // TODO: implement initState
    _loadResource();
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3))..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    Timer(
        Duration(seconds: 3), // Dấu ngoặc cho Duration phải được đóng
            () =>
            Get.offNamed(
                RouteHelper.getInitial()) // Hàm callback phải đúng cú pháp
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(scale: animation,
          child: Center(child: Image.asset("assets/image/logo part 1.png", width: Dimension.height50*5,))),
          Center(child: Image.asset("assets/image/logo part 2.png", width: Dimension.height50*5,))
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dừng và huỷ AnimationController
    controller.dispose();
    super.dispose();
  }
}
