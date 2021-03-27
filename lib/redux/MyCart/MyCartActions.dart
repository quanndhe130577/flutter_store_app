import 'package:flutter_food_app/Model/MyCartEntity.dart';

class FirstLoadCartModelMyCartAction {
  String uid;

  FirstLoadCartModelMyCartAction(this.uid);
}

class FirstLoadCartModelMyCartState {
  List<CartModel> cartList;

  FirstLoadCartModelMyCartState(this.cartList);
}
