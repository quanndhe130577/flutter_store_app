import 'package:flutter_food_app/Model/MyCartEntity.dart';

class RemoveFromCartMyCartAction {
  String productId;

  RemoveFromCartMyCartAction(this.productId);
}

class RemoveFromCartMyCartState {
  String productId;

  RemoveFromCartMyCartState(this.productId);
}

class HandleQuantityMyCartAction {
  int type;
  String uploadId;

  HandleQuantityMyCartAction(this.uploadId, this.type);
}

class HandleQuantityMyCartState {
  int type;
  String uploadId;

  HandleQuantityMyCartState(this.uploadId, this.type);
}

class AddToCartMyCartAction {
  String uploadId;

  AddToCartMyCartAction(this.uploadId);
}

class AddToCartMyCartState {
  CartModel item;

  AddToCartMyCartState(this.item);
}
