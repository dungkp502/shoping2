import 'dart:convert';

import 'package:food_app/models/cart_model.dart';
import 'package:food_app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  final SharedPreferences sharedPreferences;
  CartRepo({required this.sharedPreferences});

  List<String> cart=[];
  List<String> cartHistory=[];
  var time = DateTime.now().toString();

  void addToCartList(List<CartModel> cartList) {
    // sharedPreferences.remove(AppConstants.CART_LIST);
    // sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    // sharedPreferences.remove(AppConstants.TOKEN);
    // sharedPreferences.remove(AppConstants.PHONE);
    // sharedPreferences.remove(AppConstants.PASSWORD);
    cart = [];
    cartList.forEach((action) {
      action.time = time;
      return cart.add(jsonEncode(action));
    });
    
    // cartList.forEach((action)=> cart.add(jsonEncode(action)));
    
    sharedPreferences.setStringList(AppConstants.CART_LIST, cart);
    // getCartList();
    // print(sharedPreferences.getStringList(AppConstants.CART_LIST));
  }

  // Lấy dữ liệu cart đã lưu
  List<CartModel> getCartList() {
    List<String> carts = [];
    if (sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST)!;
      // print("getCartList: " + carts.toString());
    }
    
    List<CartModel> cartList = [];
    carts.forEach((action) {
      // Map<String, dynamic> cartMap = jsonDecode(action);
      cartList.add(CartModel.fromJson(jsonDecode(action)));
    });

    return cartList;
  }

  List<CartModel> getCartHistoryList() {
    if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory=[];
      cartHistory = sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }

    List<CartModel> cartHistoryList = [];
    cartHistory.forEach((action) {
      cartHistoryList.add(CartModel.fromJson(jsonDecode(action)));
    });

    return cartHistoryList;
  }

  void addToCartHistoryList() {
    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory = sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    for (int i=0; i<cart.length; i++) {
      // print("cart history " + cart[i]);
      cartHistory.add(cart[i]);
    }
    removeCart();
    sharedPreferences.setStringList(AppConstants.CART_HISTORY_LIST, cartHistory);
    print("History list length " + getCartHistoryList().length.toString());
    for(int i=0; i<getCartHistoryList().length; i++) {
      print("Time " + getCartHistoryList()[i].time.toString());
    }
  }
  
  void removeCart() {
    cart = [];
    sharedPreferences.remove(AppConstants.CART_LIST);
    // sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);

  }

  void clearCartHistory() {
    removeCart();
    cartHistory = [];
    sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
  }
}