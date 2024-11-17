import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_app/base/show_customer_snack_bar.dart';
import 'package:food_app/models/signup_body_model.dart';
import 'package:food_app/routes/route_helper.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/widgets/app_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../base/custom_loader.dart';
import '../../widgets/big_text.dart';
import '../../controllers/auth_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // var authController = Get.find<AuthController>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var singUpImage = [
      "g.png",
      "f.png",
      "t.png",
    ];
    void _register(AuthController authController) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();

      if (name.isEmpty) {
        showCustomerSnackBar("Type in your name", title: "Name");
        return;
      } else if (phone.isEmpty) {
        showCustomerSnackBar("Type in your phone", title: "Phone Number");
        return;
      } else if (email.isEmpty) {
        showCustomerSnackBar("Type in your email", title: "Email");
        return;
      } else if (!GetUtils.isEmail(email)) {
        showCustomerSnackBar("Invalid email", title: "Email");
        return;
      } else if (password.isEmpty) {
        showCustomerSnackBar("Type in your password", title: "Password");
        return;
      } else if (password.length < 6) {
        showCustomerSnackBar("Password must be at least 6 characters",
            title: "Password");
        return;
      } else {

        SignUpBody signUpBody = SignUpBody(
            email: email, password: password, name: name, phone: phone);
        authController.register(signUpBody).then((status) {
          if (status.isSuccess) {
            // Get.back();
            showCustomerSnackBar("Sign up successfully", isError: false,
                title: "Success");
            Get.offNamed(RouteHelper.getInitial());

          } else {
            showCustomerSnackBar(status.message, title: "Error");
          }
        });

      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (_authControllerBuilder){
        return _authControllerBuilder.isLoading?SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Dimension.screenHeight * 0.05),
              Container(
                height: Dimension.screenHeight * 0.25,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    backgroundImage: AssetImage("assets/image/logo part 1.png"),
                  ),
                ),
              ),

              AppTextField(textEditingController: emailController,
                  hintText: "Email", icon: Icons.email),
              SizedBox(height: Dimension.height10,),
              AppTextField(textEditingController: passwordController,
                  hintText: "Password", icon: Icons.password_sharp, isObscure: true),
              SizedBox(height: Dimension.height10,),
              AppTextField(textEditingController: nameController,
                  hintText: "Name", icon: Icons.person),
              SizedBox(height: Dimension.height10,),
              AppTextField(textEditingController: phoneController,
                  hintText: "Phone", icon: Icons.phone),
              SizedBox(height: Dimension.height20,),

              GestureDetector(
                onTap: () {
                  _register(_authControllerBuilder);
                },
                child: Container(
                  width: Dimension.screenWidth / 2,
                  height: Dimension.screenHeight / 13,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(Dimension.radius20),
                  ),
                  child: Center(
                    child: BigText(text: "Sign Up", color: Colors.white,
                      size: Dimension.font_size20 + Dimension.font_size20 / 2,),
                  ),

                ),
              ),
              SizedBox(height: Dimension.height10,),
              RichText(text: TextSpan(

                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.back();
                  },
                text: "Already have an account? ",
                style: TextStyle(color: Colors.grey[500],
                    fontSize: Dimension.font_size20),
              )),

              SizedBox(height: Dimension.height20,),
              RichText(text: TextSpan(
                text: "Sign up with social account",
                style: TextStyle(color: Colors.grey[500],
                    fontSize: Dimension.font_size20),
              ),
              ),
              Wrap(
                  children: List.generate(3, (index) =>
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: Dimension.radius30,
                          backgroundImage: AssetImage(
                              "assets/image/${singUpImage[index]}"),
                        ),
                      ))
              )

            ],
          ),
        ):CustomLoader();
      }),
    );
  }
}
