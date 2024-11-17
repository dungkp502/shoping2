import 'package:flutter/material.dart';
import 'package:food_app/pages/account/account_page.dart';
import 'package:food_app/pages/auth/sign_up_page.dart';
import 'package:food_app/pages/cart/cart_history_page.dart';
import 'package:food_app/pages/cart/cart_page.dart';
import 'package:food_app/pages/home/main_food_page.dart';
import 'package:food_app/utils/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/route_helper.dart';
import '../auth/sign_in_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List pages = [
    MainFoodPage(),
    // SignInPage(),
    Container(
    ),
    CartHistoryPage(),
    // Get.toNamed(RouteHelper.getCartPage()),
    // CartPage(),
    AccountPage(),

  ];

  void onTapNav(int index) {
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: Colors.amberAccent,
          showSelectedLabels: false,
          showUnselectedLabels: true,
          onTap: onTapNav,
          currentIndex: _selectedIndex,
          selectedFontSize: 0.0,
          unselectedFontSize: 0.0,
          items: const [
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.home_outlined),
                label: "home"
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.archive_outlined),
                label: "history"
            ),BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.shopping_cart_outlined),
                label: "cart"
            ),BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.person_2_outlined),
                label: "me"
            ),
          ]),
    );
  }
}
