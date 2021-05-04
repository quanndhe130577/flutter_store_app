import 'package:flutter/cupertino.dart';

class InheritedAppBarProvider extends InheritedWidget {
  final double opacity;
  final Widget title;

  InheritedAppBarProvider({
    Widget child,
    this.opacity,
    this.title,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedAppBarProvider oldWidget) => opacity != oldWidget.opacity;

  static InheritedAppBarProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedAppBarProvider>();
}
