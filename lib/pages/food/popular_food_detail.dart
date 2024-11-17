import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:food_app/cart/cart_page.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/popular_product_coontroller.dart';
import 'package:food_app/routes/route_helper.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/widgets/column_detail.dart';
import 'package:food_app/widgets/extend_text.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text.dart';
import '../../widgets/small_text.dart';

class PopularFoodDetail extends StatelessWidget {
  final int idPage;
  final String page;
  const PopularFoodDetail({super.key, required this.idPage, required this.page});

  @override
  Widget build(BuildContext context) {
    var product = Get.find<PopularProductController>().popularProductList[idPage!];
    Get.find<PopularProductController>().initProduct(product, Get.find<CartController>());
    // print("Dung loi dm");
    // print("trang hien tai: " + idPage.toString());
    // print("name${product.name}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // hinh anh chinh
          Positioned(
            left: 0,
            right: 0,
              child: Container(
                width: double.maxFinite,
                height: Dimension.popularViewImage,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                      image: NetworkImage(
                        AppConstants.BASE_URL+AppConstants.UPLOAD+product.img!
                      ),)
                ),

          )),
          // hàng icon
          Positioned(
            top: Dimension.height45,
            left: Dimension.width20,
            right: Dimension.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                       if (page == "cart-page") {
                         Get.toNamed(RouteHelper.getCartPage());
                       } else {
                         Get.toNamed(RouteHelper.getInitial());
                       }
                      },
                      child: AppIcon(iconData: Icons.arrow_back_ios)),

                  GetBuilder<PopularProductController>(
                    builder: (controller) {
                      return Stack(
                        children: [
                          GestureDetector(onTap: () {
                            Get.toNamed(RouteHelper.getCartPage());
                          },
                              child: AppIcon(iconData: Icons.shopping_cart_outlined)),
                          Get.find<PopularProductController>().totalItems >= 1
                              ? Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(onTap: () {
                              Get.toNamed(RouteHelper.getCartPage());

                            },
                              child: AppIcon(
                                iconData: Icons.circle,
                                size: 20,
                                color: Colors.transparent,
                                colorBackGroundColor: AppColors.mainColor,
                              ),
                            ),
                          )
                              : Container(),
                          Get.find<PopularProductController>().totalItems >= 1
                              ? Positioned(
                            right: 3,
                            top: 3,
                            child: BigText(
                              text: Get.find<PopularProductController>()
                                  .totalItems
                                  .toString(),
                              size: 12, color: Colors.white,
                            ),
                          )
                              : Container(), // Sửa lỗi thiếu Container ở đây
                        ],
                      );
                    },
                  )


                ],
            ),

          ),
          // thông tin
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: Dimension.popularViewImage-20,
              child: Container(
                padding: EdgeInsets.only(left: Dimension.height20, right: Dimension.height20, top: Dimension.height20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimension.height20),
                    topLeft: Radius.circular(Dimension.height20),
                  ),
                  color: Colors.white,

                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ColumnDetail(textName: product.name!,),
                     SizedBox(height: Dimension.height20,),
                     BigText(text: "Introduce"),
                    SizedBox(height: Dimension.height20,),
                    Expanded(child: SingleChildScrollView(
                      child: ExtendText(text: product.description!),
                    ))
                  ],
                ),
          ))

        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (popularProduct) {
        return  Container(
          height: Dimension.height120,
          padding: EdgeInsets.only(top: Dimension.height30, bottom: Dimension.height20),
          decoration: BoxDecoration(
              color: AppColors.buttonBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimension.height20*2),
                topRight: Radius.circular(Dimension.height20*2),
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: Dimension.height20, bottom: Dimension.height20, left: Dimension.width20, right: Dimension.width20),
                margin: EdgeInsets.only(left: Dimension.height20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimension.height20),
                    color: Colors.white
                ),
                child: Row(
                  children: [
                    // -
                    GestureDetector(onTap: () {
                      popularProduct.setQuantity(false);
                    },
                        child: Icon(Icons.remove, color: AppColors.signColor,)),
                    SizedBox(width: Dimension.width10/2,),
                    BigText(text: popularProduct.inCartItems.toString()),
                    SizedBox(width: Dimension.width10/2,),
                    // +
                    GestureDetector(onTap: () {
                      popularProduct.setQuantity(true);
                    },
                        child: Icon(Icons.add, color: AppColors.signColor,))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: Dimension.height20, bottom: Dimension.height20, left: Dimension.width20, right: Dimension.width20),
                margin: EdgeInsets.only(right: Dimension.height20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimension.radius20),
                    color: AppColors.mainColor
                ),

                child: GestureDetector(onTap: () {
                  popularProduct.addItem(product);
                },
                    child: BigText(text: "\$${product.price!} | Add to cart", color: Colors.white, textOverflow: TextOverflow.clip,)),
              )
            ],
          ),
        );
      },),
    );
  }
}
