import 'package:flutter/cupertino.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:redux/redux.dart';


class InheritedAppBarProvider extends InheritedWidget {
  final double opacity;
  final Widget title;
  final Store<AppState> reduxStore;

  InheritedAppBarProvider({
    Widget child,
    @required this.opacity,
    this.title,
    @required this.reduxStore,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedAppBarProvider oldWidget) => opacity != oldWidget.opacity;

  static InheritedAppBarProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedAppBarProvider>();
}
