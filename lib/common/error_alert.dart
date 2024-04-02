import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';

// This class builds a reusable alert dialog with custom text input.
showErrorAlertDialog(BuildContext context, String msg) {
  Widget okButton = TextButton(
    child: const Text(Constants.OK_LABEL),
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
