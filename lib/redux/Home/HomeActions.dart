import 'package:flutter_food_app/Model/HomeEntity.dart';

// class StartLoadingFirstHomeState {}

// class FirstLoadHomeModelHomeAction {}
//
// class FirstLoadHomeModelHomeState {
//   List<HomeModel> dataList;
//
//   FirstLoadHomeModelHomeState(this.dataList);
// }

class LoadMoreDataHomeAction {}

class StartLoadMoreHomeState {}

class LoadMoreDataHomeState {
  List<HomeModel> moreData;

  LoadMoreDataHomeState(this.moreData);
}

class SearchHomeAction {
  String keyword;

  SearchHomeAction(this.keyword);
}

class StartLoadingSearchHomeState {}

class LoadingSearchHomeState {
  String keyword;

  List<HomeModel> searchList;

  LoadingSearchHomeState(this.keyword, this.searchList);
}

class RemoveSearchHomeState {}

class StartRefreshDataHomeState {}

class RefreshDataHomeAction {}

class RefreshDataHomeState {
  List<HomeModel> dataList;

  RefreshDataHomeState(this.dataList);
}
