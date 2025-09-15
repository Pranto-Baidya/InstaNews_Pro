import 'dart:convert';

class BookmarkModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> categories;
  final List<String> countries;
  final String newsUrl;
  final String newsSource;
  final String sourceIcon;
  final DateTime? dateTime;

  BookmarkModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.categories,
    required this.countries,
    required this.newsUrl,
    required this.newsSource,
    required this.sourceIcon,
    required this.dateTime,
  });

  factory BookmarkModel.fromDbMap(Map<String, dynamic> map) {
    return BookmarkModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      categories: map['categories'] != null ? List<String>.from(jsonDecode(map['categories'])) : [],
      countries: map['countries'] != null ? List<String>.from(jsonDecode(map['countries'])) : [],
      newsUrl: map['newsUrl'] ?? '',
      newsSource: map['newsSource'] ?? '',
      sourceIcon: map['sourceIcon'] ?? '',
      dateTime: map['dateTime'] != null ? DateTime.tryParse(map['dateTime']) : null,
    );
  }

  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'categories': jsonEncode(categories), // List to String because sqflite doesn't support List
      'countries': jsonEncode(countries),
      'newsUrl': newsUrl,
      'newsSource': newsSource,
      'sourceIcon': sourceIcon,
      'dateTime': dateTime?.toIso8601String(),
    };
  }

}
