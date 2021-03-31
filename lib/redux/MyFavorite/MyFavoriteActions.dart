import 'package:flutter_food_app/Model/MyFavoriteEntity.dart';

class HandleFavMyFavAction {
  String uploadId;
  bool isFav;

  HandleFavMyFavAction(this.uploadId, this.isFav);
}

class HandleFavMyFavState {
  String uploadId;
  FavModel item;

  HandleFavMyFavState(this.uploadId, this.item);
}
