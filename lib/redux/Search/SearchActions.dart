import 'package:flutter_food_app/Model/SearchEntity.dart';

class StartLoadingSearchState {
  String keyword;

  StartLoadingSearchState(this.keyword);
}

class FirstLoadSearchAction {
  String keyword;

  FirstLoadSearchAction(this.keyword);
}

class LoadMoreDataSearchAction {}

class LoadMoreDataSearchState {
  List<SearchModel> moreData;

  LoadMoreDataSearchState(this.moreData);
}

class LoadDataSearchState {
  List<SearchModel> dataList;

  LoadDataSearchState(this.dataList);
}

class ClearDataSearchAction{}
class ClearDataSearchState{}
