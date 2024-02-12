import 'package:flutter/material.dart';

showErrorAlertDialog(BuildContext context, String msg) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    content: Text(msg),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
