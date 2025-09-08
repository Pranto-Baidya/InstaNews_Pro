import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instanews_pro/api_service/api_service.dart';
import 'package:instanews_pro/news_models/article_model/article_model.dart';

final prefNewsProvider = StateNotifierProvider<PrefNewsNotifier,PrefNewsState>((ref)=>PrefNewsNotifier());

class PrefNewsState {
  final List<ArticleModel> prefNews;
  final bool isLoading;
  final String? nextPage;
  final String? error;
  final List<String> countries;
  final List<String> languages;

  PrefNewsState({
    this.prefNews = const [],
    this.isLoading = false,
    this.nextPage,
    this.error,
    this.countries = const [],
    this.languages = const [],
  });

  PrefNewsState copyWith({
    List<ArticleModel>? prefNews,
    bool? isLoading,
    String? nextPage,
    String? error,
    List<String>? countries,
    List<String>? languages,
  }) {
    return PrefNewsState(
      prefNews: prefNews ?? this.prefNews,
      isLoading: isLoading ?? this.isLoading,
      nextPage: nextPage ?? this.nextPage,
      error: error ?? this.error,
      countries: countries ?? this.countries,
      languages: languages ?? this.languages,
    );
  }
}

class PrefNewsNotifier extends StateNotifier<PrefNewsState> {
  PrefNewsNotifier() : super(PrefNewsState());

  Future<void> fetchAllNewsByLangAndCountry(
      List<String> countries, List<String> languages) async {
    state = state.copyWith(
      isLoading: true,
      prefNews: [],
      error: null,
      nextPage: null,
      countries: countries,
      languages: languages,
    );

    try {
      final result =
      await ApiService.fetchNewsByCountryAndLanguage(null, countries, languages);

      state = state.copyWith(
        prefNews: result['articles'],
        nextPage: result['nextPage'],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchPaginatedNewsByLangAndCountry() async {
    if (state.nextPage == null || state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await ApiService.fetchNewsByCountryAndLanguage(
        state.nextPage,
        state.countries,
        state.languages,
      );

      state = state.copyWith(
        prefNews: [...state.prefNews, ...result['articles']],
        nextPage: result['nextPage'],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
