import 'package:flutter/cupertino.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:redux/redux.dart';

class InheritedAppBarProvider extends InheritedWidget {
  final double opacity;
  final Widget title;
  final List<Widget> actions;

  InheritedAppBarProvider({
    Widget child,
    @required this.opacity,
    this.title,
    this.actions
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedAppBarProvider oldWidget) => opacity != oldWidget.opacity;

  static InheritedAppBarProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedAppBarProvider>();
}
