import 'package:flutter_food_app/Model/HomeEntity.dart';
import 'package:flutter_food_app/Model/MyCartEntity.dart';
import 'package:flutter_food_app/Model/MyFavoriteEntity.dart';

class AppState {
  bool isLoading;
  bool isLoadingMore;

  String searchText;

  List<HomeModel> dataList;
  List<HomeModel> searchList;

  List<CartModel> cartList;

  List<MyFavoriteModel> favList;

  AppState({
    this.dataList = const [],
    this.searchList = const [],
    this.cartList = const [],
    this.favList = const [],
    this.isLoading = false,
    this.isLoadingMore = false,

    this.searchText = "",
  });
}
