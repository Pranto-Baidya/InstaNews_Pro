

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier,ThemeMode>((ref)=>ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode>{

  ThemeNotifier() : super(ThemeMode.system){
    loadTheme();
  }

  Future<void> loadTheme()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isDark = preferences.getBool('themeMode');
    if(isDark!=null) {
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    }
    else{
      state = ThemeMode.system;
    }
  }

  Future<void> toggleTheme(bool isDark)async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     await preferences.setBool('themeMode', isDark);
     state = isDark? ThemeMode.dark : ThemeMode.light;
  }
}