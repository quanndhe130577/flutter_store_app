import 'package:flutter_food_app/Model/HomeEntity.dart';

class HomeState {
  bool isLoading;
  //bool isLoadingMore;

  //String searchText;

  List<HomeModel> dataList;
  //List<HomeModel> searchList;

  HomeState({
    this.dataList = const [],
    //this.searchList = const [],
    this.isLoading = false,
    //this.isLoadingMore = false,
    //this.searchText = "",
  });

  HomeState newState({
    bool isLoading,
    //bool isLoadingMore,
    //String searchText,
    List<HomeModel> dataList,
    //List<HomeModel> searchList,
  }) {
    return HomeState(
      dataList: dataList != null ? dataList : this.dataList,
      //searchList: searchList != null ? searchList : this.searchList,
      isLoading: isLoading != null ? isLoading : this.isLoading,
      //isLoadingMore: isLoadingMore != null ? isLoadingMore : this.isLoadingMore,
      //searchText: searchText != null ? searchText : this.searchText,
    );
  }
}
