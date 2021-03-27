import 'package:flutter_food_app/Model/MyCartEntity.dart';

class MyCartState {
  List<CartModel> cartList;

  MyCartState({
    this.cartList = const [],
  });

  MyCartState newState({
    List<CartModel> cartList,
  }) {
    return MyCartState(
      cartList: cartList != null ? cartList : this.cartList,
    );
  }
}
