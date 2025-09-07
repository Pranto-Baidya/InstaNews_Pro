import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instanews_pro/api_service/api_service.dart';
import 'package:instanews_pro/news_models/article_model/article_model.dart';

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

  NewsState({
    this.articles = const [],
    this.isLoading = false,
    this.isSearching = false,
    this.query = '',
    this.nextPage,
    this.error,
  });

  NewsState copyWith({
    List<ArticleModel>? articles,
    bool? isLoading,
    bool? isSearching,
    String? query,
    String? nextPage,
    String? error,
  }) {
    return NewsState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      query: query ?? this.query,
      error: error ?? this.error,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier() : super(NewsState());

  Future<void> fetchAllNews() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      articles: [],
      nextPage: null,
      isSearching: false,
      query: '',
    );

    try {
      final result = await ApiService.fetchAllNews(null, false, '',);

      state = state.copyWith(
        articles: result['articles'],
        nextPage: result['nextPage'],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchPaginatedNews() async {
    if (state.nextPage == null || state.isLoading) {
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final result = await ApiService.fetchAllNews(state.nextPage, false, '');

      state = state.copyWith(
        articles: [...state.articles, ...result['articles']],
        nextPage: result['nextPage'],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchNewsForCarousel() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await ApiService.fetchAllNews(null, false, '',);

      state = state.copyWith(
        articles: result['articles'],
        nextPage: null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchSearchedArticles(String query) async {

    state = state.copyWith(
      isLoading: true,
      error: null,
      articles: [],
      nextPage: null,
      query: query,
      isSearching: true,
    );

    try {
      final result = await ApiService.fetchAllNews(null, true, query);

      state = state.copyWith(
        articles: result['articles'],
        nextPage: result['nextPage'],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchPaginatedSearchedArticles() async {
    if (state.nextPage == null || state.isLoading) {
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final result = await ApiService.fetchAllNews(state.nextPage, true, state.query);

      state = state.copyWith(
        articles: [...state.articles, ...result['articles']],
        nextPage: result['nextPage'],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

}
