

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier,bool>((ref)=>OnboardingNotifier());

class OnboardingNotifier extends StateNotifier<bool>{

  OnboardingNotifier() : super(false);

  Future<void> loadPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool value = preferences.getBool('show') ?? false;
    state = value;
  }

  Future<void> showOnboardingOneTime(bool value)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('show', value);
    state = value;
  }

}