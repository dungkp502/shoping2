import 'package:flutter/material.dart';
import 'package:food_app/data/repository/cart_repo.dart';
import 'package:food_app/models/products_model.dart';
import 'package:get/get.dart';

import '../models/cart_model.dart';
import '../utils/colors.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;
  CartController({required this.cartRepo});

  Map<int, CartModel> _items = {};
  Map<int, CartModel> get items => _items;
  // để lưu trữ là share
  List<CartModel> storageItems = [];

  void addItem(ProductsModel product, int quantity) {
    var totalQuantity = 0;
    if (_items.containsKey(product.id!)) {
      _items.update(product.id!, (value) {

        totalQuantity = value.quantity! + quantity;

        return CartModel(
          id: value.id,
          name: value.name,
          price: value.price,
          img: value.img,
          quantity: value.quantity! + quantity,
          isExit: true,
          time: DateTime.now().toString(),
          productsModel: product,
        );
      });

      if (totalQuantity <= 0) {
        _items.remove(product.id);
      }

    } else {
      if (quantity > 0) {
        _items.putIfAbsent(product.id!, () {
          _items.forEach( (key, value){
          });
          return CartModel(
            id: product.id,
            name: product.name,
            price: product.price,
            img: product.img,
            quantity: quantity,
            isExit: true,
            time: DateTime.now().toString(),
            productsModel: product,

          );} );
      } else {
        Get.snackbar("Item count", "Số lượng không thể nhỏ hơn 0",
            backgroundColor: AppColors.mainColor,
            colorText: Colors.white);
      }
    }
    cartRepo.addToCartList(getItems);
    update();
  }

  bool existInCart(ProductsModel product) {
    if (_items.containsKey(product.id)) {
      return true;
    }
    return false;
  }

  int getQuantity(ProductsModel product) {
    var quantity = 0;
    if (_items.containsKey(product.id)) {
      _items.forEach((key, value) {
        if (key == product.id) {
          quantity = value.quantity!;
        }
      });
    }
    return quantity;
  }

  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity = totalQuantity + value.quantity!;

    });

    return totalQuantity;
  }

  List<CartModel> get getItems {
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  int get totalAmount {
    var total = 0;
    _items.forEach((key, value) {
      total += value.quantity!*value.price!;
    });
    return total;
  }
  // lấy dữ liệu từ cart (sharedPreferences) đã được lưu
  List <CartModel> getCartData() {
    setCart  = cartRepo.getCartList();
    return storageItems;
  }

  set setCart(List<CartModel> items) {
    storageItems=items;
    print("Length cart items " + storageItems.length.toString());
    for (int i = 0; i<storageItems.length; i++) {
      _items.putIfAbsent(storageItems[i].productsModel!.id!, () => storageItems[i]);
    }
  }

//   lấy dữ liệu từ cart (sharedPreferences) vào cart histpry
  void getCartHistory() {
    cartRepo.addToCartHistoryList();
    clear();
  }
  void clear() {
    _items={};
    update();
  }

  List<CartModel> getCartHistoryList() {
    return cartRepo.getCartHistoryList();
  }

  set setCartHistory(Map<int, CartModel> items) {
    _items= {};
    _items=items;
  }

  void addToCartHistoryList() {
    cartRepo.addToCartList(getItems);
    update();
  }

  void clearCartHistory() {
    cartRepo.clearCartHistory();
    update();
  }

}