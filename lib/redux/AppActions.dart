import 'package:flutter_food_app/Model/HomeEntity.dart';
import 'package:flutter_food_app/Model/MyCartEntity.dart';

class StartInitAppState {}

class InitAppAction {
  String uid;

  InitAppAction(this.uid);
}

class InitAppState {
  List<HomeModel> dataList;
  List<CartModel> cartList;

  InitAppState(this.dataList, this.cartList);
}

class ClearStateAppAction {}

class ClearStateAppState {}
