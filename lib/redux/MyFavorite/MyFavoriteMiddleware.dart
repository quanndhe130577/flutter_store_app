import 'package:flutter_food_app/Model/MyFavoriteEntity.dart';
import 'package:flutter_food_app/redux/AppState.dart';

import 'package:redux/redux.dart';

import 'MyFavoriteActions.dart';

import 'package:firebase_database/firebase_database.dart';

Future<FavModel> _favoriteHandle(String uploadId, bool fav, String uid) async {
  FavModel favModel = new FavModel("imgUrl", "name", "material", 0, "description", uploadId, false);

  DatabaseReference favRef = FirebaseDatabase.instance.reference().child("Data").child(uploadId);

  await favRef.once().then((item) {
    favModel.imgUrl = item.value["imgUrl"].toString();
    favModel.name = item.value["name"].toString();
    favModel.material = item.value["material"].toString();
    favModel.price = double.parse(item.value["price"].toString());
    favModel.description = item.value["description"].toString();
    favModel.fav = fav;
  });

  favRef.child("Fav").child(uid).child("state").set(fav);

  return fav ? favModel : null;
}

void myFavStateMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  next(action);
  if (action.runtimeType.toString() == (HandleFavMyFavAction).toString()) {
    await _favoriteHandle(action.uploadId, action.isFav, store.state.uid)
        .then((item) => store.dispatch(HandleFavMyFavState(action.uploadId, item)));
  }
}
