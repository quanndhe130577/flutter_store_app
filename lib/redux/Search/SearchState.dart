import 'package:flutter_food_app/Model/SearchEntity.dart';

class SearchState {
  bool isLoading;

  //bool isLoadingMore;

  String searchText;

  List<SearchModel> dataList;

  SearchState({
    this.dataList = const [],
    this.isLoading = false,
    //this.isLoadingMore = false,
    this.searchText = "",
  });

  SearchState newState({
    bool isLoading,
    //bool isLoadingMore,
    String searchText,
    List<SearchModel> dataList,
  }) {
    return SearchState(
      dataList: dataList != null ? dataList : this.dataList,
      isLoading: isLoading != null ? isLoading : this.isLoading,
      //isLoadingMore: isLoadingMore != null ? isLoadingMore : this.isLoadingMore,
      searchText: searchText != null ? searchText : this.searchText,
    );
  }
}
