import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/widgets/app_icon.dart';
import 'package:food_app/widgets/big_text.dart';
import 'package:food_app/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../base/no_data_page.dart';
import '../../models/cart_model.dart';
import '../../routes/route_helper.dart';

class CartHistoryPage extends StatelessWidget {
  const CartHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var getCartHistoryList = Get.find<CartController>()
        .getCartHistoryList().reversed.toList();
    // if (getCartHistoryList.isEmpty) {
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     body: Center(
    //       child: BigText(text: "No cart history available", color: AppColors.mainColor),
    //     ),
    //   );
    // }

    Map<String, int> cartItemsPerOrder = {};

    for (int i = 0; i < getCartHistoryList.length; i++) {
      var time = getCartHistoryList[i].time;
      if (time != null) {
        if (cartItemsPerOrder.containsKey(time)) {
          cartItemsPerOrder.update(time, (value) => ++value);
        } else {
          cartItemsPerOrder.putIfAbsent(time, () => 1);
        }
      }
    }

    List<int> cartItemsPerToList() {
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<String> cartOrderTimeToList() {
      return cartItemsPerOrder.entries.map((e) => e.key).toList();
    }

    List<int> orderPerOrder = cartItemsPerToList();

    var listCounter = 0;

    Widget timeWidget(int index) {
      var outputDate = DateTime.now().toString();
      if (index < getCartHistoryList.length) {
        var inputDate = DateTime.parse(getCartHistoryList[listCounter].time!);
        var outputFormat = DateFormat("MM/dd/yyyy hh:mm a");
        outputDate = outputFormat.format(inputDate);
      }
      return BigText(text: outputDate, color: AppColors.titleColor);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: Dimension.height100,
            color: AppColors.mainColor,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimension.height45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BigText(text: "Cart History", color: Colors.white),
                AppIcon(
                  iconData: Icons.shopping_cart_outlined,
                  color: AppColors.mainColor,
                  colorBackGroundColor: Colors.white,
                )
              ],
            ),
          ),
          GetBuilder<CartController>(builder: (_cartController) {
             return _cartController.getCartHistoryList().isNotEmpty ? Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    top: Dimension.height20,
                    left: Dimension.width20,
                    right: Dimension.width20,
                  ),
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView(
                      children: [
                        for (int i = 0; i < orderPerOrder.length; i++)
                          Container(
                            margin: EdgeInsets.only(
                              bottom: Dimension.height20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                timeWidget(i),
                                SizedBox(height: Dimension.height10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      children: List.generate(orderPerOrder[i], (index) {
                                        if (listCounter < getCartHistoryList.length) {
                                          var item = getCartHistoryList[listCounter];
                                          listCounter++;
                                          return index <= 2
                                              ? Container(
                                            height: 80,
                                            width: 80,
                                            margin: EdgeInsets.only(right: Dimension.width10 / 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  AppConstants.BASE_URL + AppConstants.UPLOAD + (item.img ?? ''),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                              : Container();
                                        } else {
                                          return Container(); // Return an empty container if out of bounds
                                        }
                                      }),
                                    ),
                                    Container(
                                      height: 80,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SmallText(text: "Total", color: AppColors.titleColor),
                                          BigText(text: orderPerOrder[i].toString() + " Item", color: AppColors.titleColor),
                                          GestureDetector(
                                            onTap: () {
                                              var orderTime = cartOrderTimeToList()[i];
                                              // print("Order time: $orderTime");
                                              Map<int, CartModel> moreOrder = {};
                                              for (int j = 0; j < getCartHistoryList.length; j++) {
                                                if (getCartHistoryList[j].time == orderTime) {
                                                  // print("produc infor: " + getCartHistoryList[j].productsModel!.name.toString());
                                                  moreOrder.putIfAbsent(getCartHistoryList[j].id!, () =>
                                                      CartModel.fromJson(getCartHistoryList[j].toJson()));
                                                  // moreOrder.putIfAbsent(j, () => getCartHistoryList[j]);
                                                  // print("Order time2: " + orderTime);
                                                }
                                              }
                                              Get.find<CartController>().setCartHistory = moreOrder;
                                              Get.find<CartController>().addToCartHistoryList();
                                              Get.toNamed(RouteHelper.getCartPage());
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: Dimension.width10, vertical: Dimension.height5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimension.radius15 / 3),
                                                border: Border.all(width: 1, color: AppColors.mainColor),
                                              ),
                                              child: SmallText(text: "One more", color: AppColors.mainColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ):SizedBox(
               height: MediaQuery.of(context).size.height/1.5,
               child:const Center(child: NoDataPage(text: "No cart history available", imgPath: "assets/image/empty_box.png"))
             );
          },)
        ],
      ),
    );
  }
}