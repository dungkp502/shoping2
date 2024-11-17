import 'package:flutter/material.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/widgets/big_text.dart';
import 'package:food_app/widgets/small_text.dart';
import 'package:get/get.dart';

import '../../controllers/popular_product_coontroller.dart';
import '../../controllers/recommended_product_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimension.dart';
import 'food_page_body.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainState();
}

class _MainState extends State<MainFoodPage> {
  Future<void> _loadResource() async {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  Widget build(BuildContext context) {
    // kiem tra ty le man hinh
    // print("height: "+ MediaQuery.of(context).size.height.toString());
    // print("width: "+ MediaQuery.of(context).size.width.toString());
    return RefreshIndicator(onRefresh: _loadResource, child: Column(
      children: [
        // hiển thị header
        Container(
          child: Container(
            margin: EdgeInsets.only(top: Dimension.height45, bottom: Dimension.height15),
            padding: EdgeInsets.only(left: Dimension.width20, right: Dimension.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    BigText(text: "Shoppe_food", color: AppColors.mainColor),
                    Row(
                      children: [
                        SmallText(text: "Dũng_Nhi_Hường", color: Colors.black45,),
                        Icon(Icons.arrow_drop_down_rounded)
                      ],
                    )
                  ],
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getCartPage()); // Điều hướng đến trang giỏ hàng
                    },
                    child: Container(
                      width: Dimension.height45,
                      height: Dimension.height45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimension.radius15),
                        color: AppColors.mainColor,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: Dimension.icon24,
                        ),
                      ),
                      // child: Stack(
                      //   children: [
                      //     Center(
                      //       child: Icon(
                      //         Icons.shopping_cart_outlined,
                      //         color: Colors.white,
                      //         size: Dimension.icon24,
                      //       ),
                      //     ),
                      //     // Hiển thị hình tròn nếu có sản phẩm trong giỏ hàng
                      //     Get.find<PopularProductController>().totalItems >= 1
                      //         ? Positioned(
                      //       right: -2,
                      //       top: -2,
                      //       child: Container(
                      //         width: 20, // Kích thước hình tròn
                      //         height: 20, // Kích thước hình tròn
                      //         decoration: BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           // color: AppColors.mainBlackColor,
                      //         ),
                      //         child: Center(
                      //           child: BigText(
                      //             text: Get.find<PopularProductController>()
                      //                 .totalItems
                      //                 .toString(),
                      //             size: 12,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //       ),
                      //     )
                      //         : Container(),
                      //   ],
                      // ),
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
        // hiển thị body
        Expanded(child: SingleChildScrollView(
          child: FoodPageBody(),
        ))
      ],
    ));
  }
}
