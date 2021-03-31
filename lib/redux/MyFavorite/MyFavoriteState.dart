import 'package:flutter_food_app/Model/MyFavoriteEntity.dart';

class MyFavState {
  List<FavModel> favList;

  MyFavState({
    this.favList = const [],
  });

  MyFavState newState({
    List<FavModel> favList,
  }) {
    return MyFavState(
      favList: favList != null ? favList : this.favList,
    );
  }
}
