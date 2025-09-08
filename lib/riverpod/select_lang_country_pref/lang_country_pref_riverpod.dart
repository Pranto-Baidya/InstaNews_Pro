

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final langAndCountryPrefProvider = StateNotifierProvider<LangAndCountryPrefNotifier,UserPrefState>((ref)=>LangAndCountryPrefNotifier());

class UserPrefState{
 final List<String> languages;
 final List<String> countries;

  UserPrefState({
    this.languages = const [],
    this.countries = const []
  });

  UserPrefState copyWith({
    List<String>? languages,
    List<String>? countries
  }){
    return UserPrefState(
        languages: languages ?? this.languages,
        countries: countries ?? this.countries
    );
  }
}

class LangAndCountryPrefNotifier  extends StateNotifier<UserPrefState>{

  LangAndCountryPrefNotifier() : super(UserPrefState()){
     loadLanguage();
     loadCountries();
  }

  Future<void> loadLanguage()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final langs = preferences.getStringList('languages') ?? [];
    state = state.copyWith(languages: langs);
  }

  Future<void> loadCountries()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final countries = preferences.getStringList('countries') ?? [];
    state = state.copyWith(countries: countries);
  }

  Future<void> saveLanguages(List<String> languages)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> lang = List.from(languages);
    await preferences.setStringList('languages',lang);

    state = state.copyWith(languages: lang);
  }

  Future<void> saveCountries(List<String> countries)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> getCountry = [...countries];
    await preferences.setStringList('countries', getCountry);

    state = state.copyWith(countries: getCountry);
  }

}