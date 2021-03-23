import 'package:flutter_food_app/Model/HomeEntity.dart';

class StartLoadingFirstState {}

class FirstLoadHomeModelAction {}

class FirstLoadHomeModelState {
  List<HomeModel> dataList;

  FirstLoadHomeModelState(this.dataList);
}

class LoadMoreDataAction {}

class StartLoadMoreState {}

class LoadMoreDataState {
  List<HomeModel> moreData;

  LoadMoreDataState(this.moreData);
}

class SearchAction {
  String keyword;

  SearchAction(this.keyword);
}

class StartLoadingSearchState {}

class LoadingSearchState {
  String keyword;

  List<HomeModel> searchList;

  LoadingSearchState(this.keyword, this.searchList);
}

class RemoveSearchState {}

class RefreshDataAction {}
