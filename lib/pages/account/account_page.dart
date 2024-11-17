import 'package:flutter/material.dart';
import 'package:food_app/base/custom_loader.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/controllers/location_controller.dart';
import 'package:food_app/controllers/user_controller.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/widgets/account_widget.dart';
import 'package:food_app/widgets/app_icon.dart';
import 'package:food_app/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/route_helper.dart';
import '../../utils/dimension.dart';
import '../../controllers/auth_controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  Future<void> _showSharedData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Lấy tất cả các khóa và giá trị từ SharedPreferences
    Map<String, dynamic> allPrefs = {};
    for (String key in prefs.getKeys()) {
      allPrefs[key] = prefs.get(key);
    }

    // Chuyển đổi Map thành một chuỗi để hiển thị
    StringBuffer dataBuffer = StringBuffer();
    allPrefs.forEach((key, value) {
      dataBuffer.writeln('$key: $value');
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Shared Data"),
          content: Text(dataBuffer.isNotEmpty ? dataBuffer.toString() : "No data found"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    bool userIsLoggedIn = Get.find<AuthController>().userIsLoggedIn();
    if (userIsLoggedIn) {
      Get.find<UserController>().getUserData();
      print("User is logged in");
      // _showSharedData(context);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: BigText(text: "Profile", size: 24, color: Colors.white,),
      ),
      body: GetBuilder<UserController>(builder: (userController) {
        return userIsLoggedIn ? (!userController.isLoading ? Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: Dimension.height20),
          child: Column(
            children: [
              //profile
              AppIcon(iconData: Icons.person, size: Dimension.height50 * 3, color: Colors.white, iconSize: Dimension.height80, colorBackGroundColor: AppColors.mainColor,),
              SizedBox(height: Dimension.height20,),
              //Name
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //name
                      AccountWidget(
                          appIcon: AppIcon(iconData: Icons.person, size: Dimension.height50, color: Colors.white, iconSize: Dimension.height20, colorBackGroundColor: AppColors.mainColor,),
                          bigText: BigText(text: userController.userModel.name)),
                      SizedBox(height: Dimension.height20,),
                      //phone
                      AccountWidget(
                          appIcon: AppIcon(iconData: Icons.phone, size: Dimension.height50, color: Colors.white, iconSize: Dimension.height20, colorBackGroundColor: AppColors.yellowColor,),
                          bigText: BigText(text: userController.userModel.phone)),
                      SizedBox(height: Dimension.height20,),
                      //email
                      AccountWidget(
                          appIcon: AppIcon(iconData: Icons.email, size: Dimension.height50, color: Colors.white, iconSize: Dimension.height20, colorBackGroundColor: AppColors.yellowColor,),
                          bigText: BigText(text: userController.userModel.email)),
                      SizedBox(height: Dimension.height20,),
                      //address
                      GetBuilder<LocationController>(builder: (locationController) {
                        if (locationController.addressList.isNotEmpty) {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteHelper.getAddressPage());
                            },
                            child: AccountWidget(
                                appIcon: AppIcon(iconData: Icons.location_on, size: Dimension.height50, color: Colors.white, iconSize: Dimension.height20, colorBackGroundColor: AppColors.yellowColor,),
                                bigText: BigText(text: "Fill Address")),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteHelper.getAddressPage());
                            },
                            child: AccountWidget(
                                appIcon: AppIcon(iconData: Icons.location_on, size: Dimension.height50, color: Colors.white, iconSize: Dimension.height20, colorBackGroundColor: AppColors.yellowColor,),
                                bigText: BigText(text: "Your address")),
                          );
                        }
                      }),
                      SizedBox(height: Dimension.height20,),
                      //mess
                      AccountWidget(
                          appIcon: AppIcon(iconData: Icons.message_outlined, size: Dimension.height50, color: Colors.white, iconSize: Dimension.height20, colorBackGroundColor: Colors.red,),
                          bigText: BigText(text: "Message")),
                      SizedBox(height: Dimension.height20,),

                      GestureDetector(
                        onTap: () {
                          _showSharedData(context);
                        },
                        child: AccountWidget(
                            appIcon: AppIcon(iconData: Icons.message_outlined, size: Dimension.height50, color: Colors.white, iconSize: Dimension.height20, colorBackGroundColor: Colors.red,),
                            bigText: BigText(text: "Xem Dữ liệu")),
                      ),
                      SizedBox(height: Dimension.height20,),

                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>().userIsLoggedIn()) {
                            Get.find<AuthController>().clearSharedPref();
                            Get.find<CartController>().clear();
                            Get.find<CartController>().clearCartHistory();
                            // Get.find<LocationController>().clearAddress();
                            Get.offNamed(RouteHelper.getSignInPage());
                          } else {
                            Get.snackbar("Error", "You are not logged in");
                          }
                        },
                        child: AccountWidget(
                            appIcon: AppIcon(iconData: Icons.logout, size: Dimension.height50, color: Colors.white, iconSize: Dimension.height20, colorBackGroundColor: Colors.red,),
                            bigText: BigText(text: "Logout")),
                      ),
                      SizedBox(height: Dimension.height20,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ) : Container(
          child: // Add this inside the Column widget where you want to place the button
          GestureDetector(
            onTap: () {
              // Define the action to be performed on button tap
              _showSharedData(context);
            },
            child: Container(
              width: Dimension.width100 * 3,
              height: Dimension.height20 * 5,
              margin: EdgeInsets.only(left: Dimension.width20, right: Dimension.width20),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(Dimension.radius20),
              ),
              child: Center(
                child: BigText(
                  text: "Xem dữ liệu",
                  color: Colors.white,
                  size: Dimension.font_size20 + Dimension.font_size20 / 2,
                ),
              ),
            ),
          ),
        ))
            : Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: Dimension.height20*8,
                        margin: EdgeInsets.only(left: Dimension.width20, right: Dimension.width20),
                        decoration: BoxDecoration(
                          // color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(Dimension.radius20),
                          image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/image/sign5.png"),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimension.height20,),
                      GestureDetector(
                        onTap: () {
                          Get.offNamed(RouteHelper.getSignInPage());
                        },
                        child: Container(
                          width: Dimension.width100*3,
                          height: Dimension.height20*5,
                          margin: EdgeInsets.only(left: Dimension.width20, right: Dimension.width20),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(Dimension.radius20),

                          ),
                          child: Center(child: BigText(text: "Sign In", color: Colors.white, size: Dimension.font_size20 + Dimension.font_size20 / 2,)),
                        ),
                      ),

                    ],
                  )
                ),
        );
      }),
    );
  }
}
