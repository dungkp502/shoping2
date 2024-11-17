import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:food_app/cart/cart_page.dart';
import 'package:food_app/controllers/popular_product_coontroller.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/recommended_product_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/extend_text.dart';

class RecommendedFoodDetail extends StatelessWidget {
  final int idPage;
  final String page;
  const RecommendedFoodDetail({super.key, required this.idPage, required this.page});

  @override
  Widget build(BuildContext context) {
    var product = Get.find<RecommendedProductController>().recommendedProductList[idPage!];
    Get.find<PopularProductController>().initProduct(product, Get.find<CartController>());

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            title: Row(
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
                          right: 6,
                          top: 2,
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
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(20),
                child: Container(
                  child: Center(child: BigText(size: Dimension.font_size26,text: product.name!),),
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimension.radius20),
                        topRight: Radius.circular(Dimension.radius20),
                      )
                  ),

                )),
            backgroundColor: AppColors.yellowColor,
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(AppConstants.BASE_URL+AppConstants.UPLOAD+product.img!,
              width: double.maxFinite,
              fit: BoxFit.cover,),

            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  child: ExtendText(text: product.description!),
                  margin: EdgeInsets.only(left: Dimension.width20, right: Dimension.width20),

                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: EdgeInsets.only(
                    left: Dimension.width20*2.5,
                    right: Dimension.width20*2.5,
                    top: Dimension.height20,
                    bottom: Dimension.height20

                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: () {
                      controller.setQuantity(false);
                    },
                        child: AppIcon(iconSize: Dimension.icon24 ,color: Colors.white, colorBackGroundColor: AppColors.mainColor,iconData: Icons.remove)),
                    BigText(text: "\$ ${product.price} X  ${controller.inCartItems}", color: AppColors.mainBlackColor, size: Dimension.font_size26,),
                    GestureDetector(onTap: () {
                        controller.setQuantity(true);
                    },
                        child: AppIcon(iconSize: Dimension.icon24 ,color: Colors.white, colorBackGroundColor: AppColors.mainColor,iconData: Icons.add)),
                  ],
                )
            ),
            Container(
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
                    child: Icon(
                      Icons.favorite,
                      color: AppColors.mainColor,

                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.addItem(product);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: Dimension.height20, bottom: Dimension.height20, left: Dimension.width20, right: Dimension.width20),
                      margin: EdgeInsets.only(right: Dimension.height20),

                      child: BigText(text: "\$ ${product.price!} | Add to cart", color: Colors.white, textOverflow: TextOverflow.clip,),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimension.radius20),
                          color: AppColors.mainColor
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
