

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instanews_pro/db_service/db_service.dart';

import '../../news_models/db_bookmark_model/bookmark_model.dart';

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier,BookmarkState>((ref)=>BookmarkNotifier());

class BookmarkState{
  final List<BookmarkModel> bookmarks;
  final List<BookmarkModel> searchBookmarks;
  final List<BookmarkModel> filteredResult;
  final DateTime? selectedDateTime;

  BookmarkState({
    this.bookmarks = const [],
    this.searchBookmarks = const [],
    this.filteredResult = const [],
    this.selectedDateTime
  });

  BookmarkState copyWith({
    List<BookmarkModel>? bookmarks,
    List<BookmarkModel>? searchBookmarks,
    List<BookmarkModel>? filteredResult,
    DateTime? selectedDateTime,
  }){
    return BookmarkState(
        bookmarks: bookmarks ?? this.bookmarks,
        searchBookmarks: searchBookmarks ?? this.searchBookmarks,
        filteredResult: filteredResult ?? this.filteredResult,
        selectedDateTime: selectedDateTime
    );
  }
}

class BookmarkNotifier extends StateNotifier<BookmarkState>{

  BookmarkNotifier() : super(BookmarkState());

  Future<void> getAllBookMarks()async{
    final result = await DBService.getAllNews();

    state = state.copyWith(
      bookmarks: result
    );
  }

  Future<void> addToBookmark(BookmarkModel bookmarks)async{
    await DBService.insertNews(bookmarks);
    await getAllBookMarks();
  }

  Future<void> removeBookmark(String id)async{
    await DBService.removeFromBookmark(id);
    await getAllBookMarks();
  }

  Future<bool> hasBookmark(String id)async{
    return await DBService.hasBookmark(id);
  }

  Future<void> searchBookmarks(String query)async{
   if(query.isEmpty){
     state = state.copyWith(searchBookmarks: []);
   }
   else{
     final result = state.bookmarks.where((i)=>i.title.toLowerCase().startsWith(query.toLowerCase())).toList();
     state = state.copyWith(searchBookmarks: result);
   }
  }

  Future<void> filterByDate(DateTime? date)async{
    final selected = state.bookmarks.where((i){
      return i.dateTime?.day == date?.day &&
          i.dateTime?.month == date?.month &&
          i.dateTime?.year==date?.year;
    }).toList();

    state = state.copyWith(
      filteredResult: selected,
      selectedDateTime: date
    );
  }

  void clearFilter(){
   state = state.copyWith(
     filteredResult: [],
     selectedDateTime: null
   );
   getAllBookMarks();
  }
}