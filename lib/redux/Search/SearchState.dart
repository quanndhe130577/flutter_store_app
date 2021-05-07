import 'package:flutter_food_app/Model/SearchEntity.dart';

class SearchState {
  bool isLoading;

  //bool isLoadingMore;

  String searchText;

  List<SearchModel> searchList;

  SearchState({
    this.searchList = const [],
    this.isLoading = false,
    //this.isLoadingMore = false,
    this.searchText = "",
  });

  SearchState newState({
    bool isLoading,
    //bool isLoadingMore,
    String searchText,
    List<SearchModel> searchList,
  }) {
    return SearchState(
      searchList: searchList != null ? searchList : this.searchList,
      isLoading: isLoading != null ? isLoading : this.isLoading,
      //isLoadingMore: isLoadingMore != null ? isLoadingMore : this.isLoadingMore,
      searchText: searchText != null ? searchText : this.searchText,
    );
  }
}
