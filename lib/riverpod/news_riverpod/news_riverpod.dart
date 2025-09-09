import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instanews_pro/api_service/api_service.dart';
import 'package:instanews_pro/news_models/article_model/article_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final newsNotifierProvider = StateNotifierProvider<NewsNotifier, NewsState>(
      (ref) => NewsNotifier(),
);

class NewsState {
  final List<ArticleModel> articles;
  final bool isLoading;
  final bool isSearching;
  final String query;
  final String? nextPage;
  final String? error;
  final String selectedCategory;
  final List<String> countries;
  final List<String> languages;

  NewsState({
    this.articles = const [],
    this.isLoading = false,
    this.isSearching = false,
    this.query = '',
    this.nextPage,
    this.error,
    this.selectedCategory = '',
    this.countries = const [],
    this.languages = const [],
  });

  NewsState copyWith({
    List<ArticleModel>? articles,
    bool? isLoading,
    bool? isSearching,
    String? query,
    String? nextPage,
    String? error,
    String? selectedCategory,
    List<String>? countries,
    List<String>? languages,
  }) {
    return NewsState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      query: query ?? this.query,
      error: error ?? this.error,
      nextPage: nextPage ?? this.nextPage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      countries: countries ?? this.countries,
      languages: languages ?? this.languages,
    );
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier() : super(NewsState()) {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCountries = prefs.getStringList('countries') ?? [];
    final savedLanguages = prefs.getStringList('languages') ?? [];

    state = state.copyWith(countries: savedCountries, languages: savedLanguages);

    await fetchNewsByCountryAndLanguage();
  }

  Future<void> saveCountries(List<String> countries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('countries', countries);
    state = state.copyWith(countries: countries);

    await fetchNewsByCountryAndLanguage();
  }

  Future<void> saveLanguages(List<String> languages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('languages', languages);
    state = state.copyWith(languages: languages);

    await fetchNewsByCountryAndLanguage();
  }


  Future<void> fetchSearchedArticles(String query) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      articles: [],
      nextPage: null,
      query: query,
      isSearching: true,
      selectedCategory: '',
    );

    try {
      final result = await ApiService.fetchNewsByCountryAndLanguage(null, state.countries,state.languages,true, query);
      state = state.copyWith(
        articles: result['articles'],
        nextPage: result['nextPage'],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchPaginatedSearchedArticles() async {
    if (state.nextPage == null || state.isLoading) return;

    try {
      state = state.copyWith(isLoading: true, error: null);
      final result =
      await ApiService.fetchNewsByCountryAndLanguage(state.nextPage,state.languages,state.countries, true, state.query);
      state = state.copyWith(
        articles: [...state.articles, ...result['articles']],
        nextPage: result['nextPage'],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchCategory(String category) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      articles: [],
      nextPage: null,
      selectedCategory: category,
      isSearching: false,
      query: '',
    );

    try {
      final result = await ApiService.fetchNewsByCategory(category, null,state.languages,state.countries);
      state = state.copyWith(
        articles: result['articles'],
        nextPage: result['nextPage'],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchMoreCategoryNews() async {
    if (state.nextPage == null || state.isLoading) return;

    try {
      state = state.copyWith(isLoading: true, error: null);
      final result = await ApiService.fetchNewsByCategory(
          state.selectedCategory, state.nextPage,state.countries,state.languages);
      state = state.copyWith(
        articles: [...state.articles, ...result['articles']],
        nextPage: result['nextPage'],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchNewsByCountryAndLanguage() async {
    final countries = state.countries;
    final languages = state.languages;

    state = state.copyWith(
      isLoading: true,
      error: null,
      articles: [],
      nextPage: null,
      isSearching: false,
      query: '',
      selectedCategory: '',
    );

    try {
      final result = await ApiService.fetchNewsByCountryAndLanguage(
          null, countries, languages,false,'');
      state = state.copyWith(
        articles: result['articles'],
        nextPage: result['nextPage'],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchMorePersonalizedNews() async {
    if (state.nextPage == null || state.isLoading) return;

    try {
      state = state.copyWith(isLoading: true, error: null);
      final result = await ApiService.fetchNewsByCountryAndLanguage(
        state.nextPage,
        state.countries,
        state.languages,
        false,
        ''
      );
      state = state.copyWith(
        articles: [...state.articles, ...result['articles']],
        nextPage: result['nextPage'],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
