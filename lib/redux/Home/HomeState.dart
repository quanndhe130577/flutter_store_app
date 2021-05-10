import 'package:flutter_food_app/Model/HomeEntity.dart';

class HomeState {
  bool isLoading;

  List<HomeModel> dataList;

  HomeState({
    this.dataList = const [],
    this.isLoading = false,
  });

  HomeState newState({
    bool isLoading,
    List<HomeModel> dataList,
  }) {
    return HomeState(
      dataList: dataList != null ? dataList : this.dataList,
      isLoading: isLoading != null ? isLoading : this.isLoading,
    );
  }
}
