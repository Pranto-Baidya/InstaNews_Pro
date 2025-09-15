import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastMsg {
  static void successToast({Alignment? alignment,required String message, required BuildContext context}) {
    toastification.show(
      style: ToastificationStyle.minimal,
      title: Text(message, style: TextStyle(color: Colors.green)),
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
      alignment: alignment ?? Alignment.topRight,
      autoCloseDuration: Duration(seconds: 4),
      backgroundColor: Colors.green.shade50,
      borderSide: BorderSide.none,
      dragToClose: true,
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.none
      )
    );
  }

  static void errorToast({Alignment? alignment, required String message, required BuildContext context}) {
    toastification.show(
      primaryColor: Colors.red,
      style: ToastificationStyle.minimal,
        title: Text(message, style: TextStyle(color: Colors.red)),
      icon: const Icon(Icons.cancel_outlined, color: Colors.red),
      alignment: alignment ?? Alignment.topRight,
        autoCloseDuration: Duration(seconds: 4),
        backgroundColor: Colors.red.shade50,
        borderSide: BorderSide.none,
        dragToClose: true,
        closeButton: ToastCloseButton(
            showType: CloseButtonShowType.none
        )
    );
  }
}
