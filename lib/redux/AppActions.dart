import 'package:flutter_food_app/Model/HomeEntity.dart';
import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/Model/MyFavoriteEntity.dart';

class StartInitAppState {}

class InitAppAction {
  String uid;

  InitAppAction(this.uid);
}

class InitAppState {
  List<HomeModel> dataList;
  List<CartModel> cartList;
  List<FavModel> favList;

  InitAppState(this.dataList, this.cartList, this.favList);
}

class ClearStateAppAction {}

class ClearStateAppState {}
