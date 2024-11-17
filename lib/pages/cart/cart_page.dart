import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/base/no_data_page.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/location_controller.dart';
import 'package:food_app/controllers/popular_product_coontroller.dart';
import 'package:food_app/controllers/auth_controller.dart';
import 'package:food_app/controllers/recommended_product_controller.dart';
import 'package:food_app/pages/home/main_food_page.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/widgets/app_icon.dart';
import 'package:food_app/widgets/big_text.dart';
import 'package:food_app/widgets/small_text.dart';
import 'package:get/get.dart';

import '../../routes/route_helper.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: Dimension.height20*3,
              right: Dimension.width20,
              left: Dimension.width20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: () {
                      Get.toNamed(RouteHelper.getInitial());
                    },
                      child: AppIcon(iconData: Icons.arrow_back_ios,
                      color: Colors.white,
                        colorBackGroundColor: AppColors.mainColor,
                        iconSize: Dimension.icon24,
                      ),
                    ),
                    SizedBox(width: Dimension.width100,),
                    GestureDetector(onTap:() {
                      Get.toNamed(RouteHelper.getInitial());

                    },
                      child: AppIcon(iconData: Icons.home_outlined,
                        color: Colors.white,
                        colorBackGroundColor: AppColors.mainColor,
                        iconSize: Dimension.icon24,
                      ),
                    ),
                    AppIcon(iconData: Icons.shopping_cart_outlined,
                      color: Colors.white,
                      colorBackGroundColor: AppColors.mainColor,
                      iconSize: Dimension.icon24,
                    ),
                  ],
          )),
          GetBuilder<CartController>(builder: (_cartController) {
            return _cartController.getItems.length>0?Positioned(
              top: Dimension.height20*5,
              left: Dimension.width20,
              right: Dimension.width20,
              bottom: 0,
              child: Container(
                margin: EdgeInsets.only(top: Dimension.width15),
                // color: Colors.red,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: GetBuilder<CartController>(builder: (controller) {
                    var cartList = controller.getItems;
                    // print(cartList);
                    return ListView.builder(
                        itemCount: cartList.length,
                        itemBuilder: (_, index) {
                          return Container(
                            width: double.maxFinite,
                            height: Dimension.height100,
                            child: Row(
                              children: [
                                GestureDetector(onTap: () {
                                  var popularIndex = Get.find<PopularProductController>()
                                      .popularProductList
                                      .indexOf(cartList[index].productsModel!);
                                  // print("ID  " +popularIndex.toString());
                                  if (popularIndex>=0) {
                                    Get.toNamed(RouteHelper.getPopularFood(popularIndex, "cart-page"));
                                  } else {
                                    var recommendedIndex = Get.find<RecommendedProductController>()
                                        .recommendedProductList
                                        .indexOf(cartList[index].productsModel!);
                                    if(recommendedIndex<0) {
                                      Get.snackbar("Lịch sử sản phẩm", "Không tìm thấy sản phẩm",
                                          backgroundColor: AppColors.mainColor,
                                          colorText: Colors.white);
                                    } else {
                                      Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex, "cart-page"));
                                    }
                                  }
                                },
                                  child: Container(
                                    width: Dimension.height20*5,
                                    height: Dimension.height20*5,
                                    margin: EdgeInsets.only(bottom: Dimension.height10),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                AppConstants.BASE_URL+AppConstants.UPLOAD+controller.getItems[index].img!
                                            )),
                                        borderRadius: BorderRadius.circular(Dimension.radius20),
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                SizedBox(width: Dimension.width10,),
                                Expanded(
                                    child: Container(
                                      height: Dimension.height100,
                                      // color: Colors.blue,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          BigText(text: controller.getItems[index].name!, color: Colors.black54,),
                                          SmallText(text: ""),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              BigText(text: controller.getItems[index].price.toString(), color: Colors.redAccent,),
                                              Container(
                                                padding: EdgeInsets.only(top: Dimension.height5, bottom: Dimension.height5, left: Dimension.height5, right: Dimension.height5),
                                                // margin: EdgeInsets.only(left: Dimension.height10),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(Dimension.height20),
                                                    color: Colors.white
                                                ),
                                                child: Row(
                                                  children: [
                                                    // -
                                                    GestureDetector(onTap: () {
                                                      // popularProduct.setQuantity(false);
                                                      controller.addItem(cartList[index].productsModel!, -1);
                                                    },
                                                        child: Icon(Icons.remove, color: AppColors.signColor,)),
                                                    SizedBox(width: Dimension.width10/2,),
                                                    BigText(text: cartList[index].quantity.toString()),
                                                    SizedBox(width: Dimension.width10/2,),
                                                    // +
                                                    GestureDetector(onTap: () {
                                                      // popularProduct.setQuantity(true);
                                                      controller.addItem(cartList[index].productsModel!, 1);

                                                    },
                                                        child: Icon(Icons.add, color: AppColors.signColor,))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          );

                        });
                  }),
                ),
              ),
            ):NoDataPage(text: "Cart trống");
          })
        ],
      ),
      bottomNavigationBar: GetBuilder<CartController>(builder: (cartController) {
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
          child: cartController.getItems.length>0?Row(
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
                      SizedBox(width: Dimension.width10/2,),
                      BigText(text: "\$  ${cartController.totalAmount.toString()}"),
                      SizedBox(width: Dimension.width10/2,),
                      // +
                    ]
                ),
              ),
              GestureDetector(
                onTap: () {
                  if(Get.find<AuthController>().userIsLoggedIn()) {
                    print("Login ???");
                    if (Get.find<LocationController>().addressList.isEmpty) {
                      Get.toNamed(RouteHelper.getAddressPage());
                    }
                    // } else {
                    //   Get.offNamed(RouteHelper.getInitial());
                    // }
                    // cartController.getCartHistory();
                  } else {
                    Get.toNamed(RouteHelper.getSignInPage());
                  }

                },
                child: Container(
                    padding: EdgeInsets.only(top: Dimension.height20, bottom: Dimension.height20, left: Dimension.width20, right: Dimension.width20),
                    margin: EdgeInsets.only(right: Dimension.height20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimension.radius20),
                        color: AppColors.mainColor
                    ),

                    child: BigText(text: "Check out", color: Colors.white, textOverflow: TextOverflow.clip,)

                ),
              )
            ],
          ):Container(),
        );
      },),
    );
  }
}
