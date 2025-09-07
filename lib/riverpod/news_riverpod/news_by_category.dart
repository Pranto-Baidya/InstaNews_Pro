
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instanews_pro/api_service/api_service.dart';
import 'package:instanews_pro/news_models/article_model/article_model.dart';

final categoryNewsProvider = StateNotifierProvider<NewsByCategoryNotifier,NewsCategoryNotifier>((ref)=>NewsByCategoryNotifier());

class NewsCategoryNotifier{
  final List<ArticleModel> articles;
  final bool isLoading;
  final String selectedCategory;
  final String? nextPage;
  final String? error;

  NewsCategoryNotifier({
    this.articles = const [],
    this.isLoading = false,
    required this.selectedCategory,
    this.nextPage,
    this.error
  });

  NewsCategoryNotifier copyWith({
    List<ArticleModel>? articles,
    bool? isLoading,
    String? selectedCategory,
    String? nextPage,
    String? error
  }){
    return NewsCategoryNotifier(
        articles: articles?? this.articles,
        isLoading: isLoading ?? this.isLoading,
        selectedCategory: selectedCategory?? this.selectedCategory,
        nextPage: nextPage ?? this.nextPage,
        error: error ?? this.error
    );
  }
}

class NewsByCategoryNotifier extends StateNotifier<NewsCategoryNotifier>{
  NewsByCategoryNotifier() : super(NewsCategoryNotifier(selectedCategory: ''));

  Future<void> fetchCategory(String category)async {
    try {
      state = state.copyWith(isLoading: true, error: null,selectedCategory: category, articles: [], nextPage: null,);

      Map<String, dynamic> result = await ApiService.fetchNewsByCategory(
          state.selectedCategory, state.nextPage);

      state = state.copyWith(
          articles: result['articles'],
          nextPage: result['nextPage'],
          isLoading: false
      );
    }catch(e){
      state = state.copyWith(isLoading: false, error:e.toString());
    }
  }

  Future<void> fetchMoreNews()async {
    if (state.nextPage == null || state.isLoading) {
      return;
    }
    try {
      state = state.copyWith(isLoading: true, error: null);

      Map<String, dynamic> newArticles = await ApiService.fetchNewsByCategory(
          state.selectedCategory, state.nextPage);

      state = state.copyWith(
          articles: [...state.articles, ...newArticles['articles']],
          nextPage: newArticles['nextPage'],
          isLoading: false
      );
    }catch(e){
      state = state.copyWith(isLoading: false,error: e.toString());
    }
  }
}