import 'package:flutter/material.dart';
import 'package:food_app/controllers/cart_controller.dart';
import 'package:food_app/models/cart_model.dart';
import 'package:food_app/utils/colors.dart';
import 'package:get/get.dart';

import '../data/repository/popular_product_repo.dart';
import '../models/products_model.dart';

class PopularProductController extends GetxController{
  final PopularProductRepo popularProductRepo;
  PopularProductController({required this.popularProductRepo});
  List<dynamic> _popularProductList = [];
  List<dynamic> get popularProductList => _popularProductList;
  late CartController _cart;

  bool _isLoader = false;
  bool get isLoader => _isLoader;
  int _quantity = 0;
  int get quantity => _quantity;
  int _inCartItems = 0;
  int get inCartItems => _inCartItems + _quantity;

  Future<void> getPopularProductList() async {
    Response response = await popularProductRepo.getPopularProductList();
    if (response.statusCode==200) {
      // print("iloveu");
      _popularProductList = [];
      _popularProductList.addAll(Product.fromJson(response.body).products);
      // print(_popularProductList);
      _isLoader = true;
      update();
    } else {
      print("Loi popular");
    }
  }

  void setQuantity(bool isIncrement) {
    if(isIncrement) {
      _quantity = checkQuantity(_quantity + 1);

    } else {
      _quantity = checkQuantity(_quantity - 1);

    }
    update();
  }

  int checkQuantity(int quantity) {
    if((_inCartItems+ quantity) < 0) {
      Get.snackbar("Item count", "Không thể thấp hơn 1",
      backgroundColor: AppColors.mainColor,
      colorText: Colors.white);

      // if (_quantity>0) {
      //   _quantity = - _inCartItems;
      //   return _quantity;
      // }
      return 0;
    } else if ((_inCartItems+ quantity) > 20) {
      Get.snackbar("Item count", "Không thể lớn hơn 20",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white);
      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct(ProductsModel product, CartController cart) {
    _quantity = 0;
    _inCartItems = 0;
    _cart = cart;
    var exist = false;
    exist = _cart.existInCart(product);
    print("exist $exist");
    if (exist) {
      _inCartItems = _cart.getQuantity(product);
    }
    // print(" 111 quantity $_inCartItems");
  }

  void addItem(ProductsModel product) {
    // if (_quantity>0) {
      _cart.addItem(product, _quantity);
      _quantity=0;
      _inCartItems = _cart.getQuantity(product);
      // print("decrem $_inCartItems");
      // _cart.items.forEach((key, value) {
      //   print("id ${value.id} quantity ${value.time}");
      // });
    // } else
      update();
  }

  int get totalItems {
    return _cart.totalItems;
  }

  List<CartModel> get getItems {
    return _cart.getItems;
  }
}