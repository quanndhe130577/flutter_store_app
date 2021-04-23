import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'InheritedDataProvider.dart';

class LeadingAppbar extends StatefulWidget {
  final IconData iconData;

  LeadingAppbar({this.iconData});

  @override
  _LeadingAppbarState createState() => _LeadingAppbarState(this.iconData);
}

class _LeadingAppbarState extends State<LeadingAppbar> {
  final IconData iconData;
  double opacity = 0;

  _LeadingAppbarState(this.iconData);

  @override
  Widget build(BuildContext context) {
    opacity = InheritedDataProvider.of(context).data;

    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 7, top: 7),
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Icon(iconData, color: opacity <= 0.1 ? Colors.red : Colors.white, size: 20),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black26.withOpacity(opacity)),
        ),
      ),
    );
  }
}
