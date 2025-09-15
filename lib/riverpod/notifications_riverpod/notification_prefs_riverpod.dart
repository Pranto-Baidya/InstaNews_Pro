

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final immediateNotificationProvider = StateNotifierProvider<NotificationPrefs,bool>((ref)=> NotificationPrefs());

class NotificationPrefs extends StateNotifier<bool>{

  NotificationPrefs() : super(false){
    loadChoice();
  }

  Future<void> loadChoice()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? value = preferences.getBool('instant');
    if(value!=null){
      state = value;
    }
  }

  Future<void> saveChoice(bool value)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('instant', value);
    state = value;
  }
}