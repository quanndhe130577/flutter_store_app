import 'package:flutter_food_app/Model/MyCartEntity.dart';

class FirstLoadCartModelMyCartAction {
  String uid;

  FirstLoadCartModelMyCartAction(this.uid);
}

class FirstLoadCartModelMyCartState {
  List<CartModel> cartList;

  FirstLoadCartModelMyCartState(this.cartList);
}

class RemoveFromCartMyCartAction {
  String productId;

  RemoveFromCartMyCartAction(this.productId);
}

class RemoveFromCartMyCartState {
  String productId;

  RemoveFromCartMyCartState(this.productId);
}

class HandleQuantityCartAction{
  int type;
  String uploadId;

  HandleQuantityCartAction(this.uploadId, this.type);
}

class HandleQuantityCartState{
  int type;
  String uploadId;

  HandleQuantityCartState(this.uploadId, this.type);
}