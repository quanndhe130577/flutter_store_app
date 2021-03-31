import 'package:flutter_food_app/Model/MyFavoriteEntity.dart';
import 'package:flutter_food_app/redux/MyFavorite/MyFavoriteState.dart';

import 'MyFavoriteActions.dart';

MyFavState myFavReducers(MyFavState state, dynamic action) {
  if (action.runtimeType.toString() == (HandleFavMyFavState).toString()) {
    List<FavModel> list = []..addAll(state.favList);
    if (action.item == null) {
      list.removeWhere((element) => element.uploadId == action.uploadId);
    } else {
      list.add(action.item);
    }
    return state.newState(
      favList: list,
    );
  }
  return state;
}
