
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastMsg{
  static void successToast({required String message,BuildContext? context}){
    var theme = Theme.of(context!);
    toastification.show(
      style: ToastificationStyle.minimal,
      title: Text(message,style: theme.textTheme.titleMedium,),
      icon: Icon(Icons.check_circle_outline,color: Colors.green,),
      alignment: Alignment.topRight,
    );
  }

  static void errorToast({required String message,BuildContext? context}){
    var theme = Theme.of(context!);
    toastification.show(
      style: ToastificationStyle.minimal,
      title: Text(message,style: theme.textTheme.titleMedium,),
      icon: Icon(Icons.cancel_outlined,color: Colors.red,),
      alignment: Alignment.topRight,
    );
  }
}