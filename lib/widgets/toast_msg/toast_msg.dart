import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class ToastMsg {
  static void successToast({required String message, required BuildContext context}) {
    var theme = Theme.of(context);
    toastification.show(
      style: ToastificationStyle.minimal,
      title: Text(message, style: TextStyle(color: Colors.black)),
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
      alignment: Alignment.topRight,
      autoCloseDuration: Duration(seconds: 4),
      backgroundColor: Colors.green.shade50,
      borderSide: BorderSide.none,
      dragToClose: true
    );
  }

  static void errorToast({required String message, required BuildContext context}) {
    var theme = Theme.of(context);
    toastification.show(
      primaryColor: Colors.red,
      style: ToastificationStyle.minimal,
        title: Text(message, style: TextStyle(color: Colors.black)),
      icon: const Icon(Icons.cancel_outlined, color: Colors.red),
      alignment: Alignment.topRight,
        autoCloseDuration: Duration(seconds: 4),
        backgroundColor: Colors.red.shade50,
        borderSide: BorderSide.none,
        dragToClose: true
    );
  }
}
