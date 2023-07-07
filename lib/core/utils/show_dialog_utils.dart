import 'package:flutter/material.dart';

class ShowDialogUtils {
  static void showAlertDialog(BuildContext context, Widget widget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return widget;
      },
    );
  }
}
