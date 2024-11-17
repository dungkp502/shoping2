import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_app/base/custom_loader.dart';
import 'package:food_app/pages/auth/sign_up_page.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/widgets/app_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../base/show_customer_snack_bar.dart';
import '../../routes/route_helper.dart';
import '../../widgets/big_text.dart';
import '../../controllers/auth_controller.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    var passwordController = TextEditingController();

    void _login(AuthController authController) {
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      if (phone.isEmpty) {
        showCustomerSnackBar("Type in your phone", title: "Phone");
        return;
      } else if (password.isEmpty) {
        showCustomerSnackBar("Type in your password", title: "Password");
        return;
      } else if (password.length < 6) {
        showCustomerSnackBar("Password must be at least 6 characters",
            title: "Password");
        return;
      } else {

        authController.login(phone, password).then((status) {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getInitial());
            // Get.back();
            showCustomerSnackBar("Sign in successfully", isError: false,
                title: "Success");
          } else {
            print(status.message);
            // showCustomerSnackBar("Sign in failed", title: "Error");
          }
        });

      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController) {
        return !authController.isLoading?SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Dimension.screenHeight*0.05),
              SizedBox(
                height: Dimension.screenHeight*0.25,
                child: const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    backgroundImage: AssetImage("assets/image/logo part 1.png"),
                  ),
                ),
              ),

              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(left: Dimension.width20,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sign In",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimension.font_size20*3.5,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("Sign In your account",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimension.font_size20,

                      ),
                    ),

                  ],
                ),
              ),

              AppTextField(textEditingController: phoneController, hintText: "Phone", icon: Icons.phone),
              SizedBox(height: Dimension.height10,),
              AppTextField(textEditingController: passwordController,
                  hintText: "Password", icon: Icons.password_sharp, isObscure: true),
              SizedBox(height: Dimension.height30,),



              Row(
                children: [
                  Expanded(child: Container()),
                  RichText(text: TextSpan(
                    text: "Sign up",
                    style: TextStyle(color: Colors.grey[500],
                        fontSize: Dimension.font_size20),
                  )),
                  SizedBox(width: Dimension.width20,)

                ],
              ),
              SizedBox(height: Dimension.height20,),
              GestureDetector(
                onTap: () {
                  // print("Chuyeer Sign In");
                  _login(authController);
                },
                child: Container(
                  width: Dimension.screenWidth / 2,
                  height: Dimension.screenHeight / 13,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(Dimension.radius20),
                  ),
                  child: Center(
                    child: BigText(
                      text: "Sign In",
                      color: Colors.white,
                      size: Dimension.font_size20 + Dimension.font_size20 / 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimension.height10,),

              SizedBox(height: Dimension.height10,),
              RichText(text: TextSpan(
                text: "Don't have an account?",
                style: TextStyle(color: Colors.grey[500],
                    fontSize: Dimension.font_size20),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Get.to(() => SignUpPage(), transition: Transition.fade);
                    },

                    text: " Create",
                    style: TextStyle(color: AppColors.mainBlackColor,
                        fontSize: Dimension.font_size20,
                        fontWeight: FontWeight.bold),
                  )],
              )),


            ],
          ),
        ):const CustomLoader();
      }),
    );
  }
}
