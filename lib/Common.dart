import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String shortenString(String word, int length) {
  return "${word != null ? (word.length > length ? word.substring(0, length) + " . . ." : word) : ""}";
}

final double heightOfAppBar = 50.0;
final numberOfFirstLoad = 5;
//final padding

void showSimpleLoadingModalDialog(context) {
  showDialog(
    barrierDismissible: false,
    barrierColor: Colors.white10,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          constraints: BoxConstraints(maxHeight: 75, maxWidth: 75),
          child: SpinKitFadingCircle(
            itemBuilder: (BuildContext context, int index) {
              return Icon(Icons.circle, color: Colors.white, size: 10);
            },
          ),
        ),
      );
    },
  );
}

void showDialogConfirm({
  BuildContext context,
  Widget title,
  Widget content,
  Function yesCallback,
  Function noCallback,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              yesCallback();
            },
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              noCallback();
            },
            child: Text("No"),
          ),
        ],
      );
    },
  );
}

double getHeightForWidget(
    BuildContext context, {
      double dividedBy = 1,
      double sub = 0,
      bool ignoreAppbar = true,
      bool ignorePaddingTop = true,
      bool ignorePaddingBottom = true,
    }) {
  double height = MediaQuery.of(context).size.height - sub;
  if (ignoreAppbar) {
    height -= heightOfAppBar;
  }
  // Height (without SafeArea)
  var padding = MediaQuery.of(context).padding;
  if (ignorePaddingTop) height -= padding.top;
  if (ignorePaddingBottom) height -= padding.bottom;

  return height / dividedBy;
}