class ArticleModel {
  final String id;
  final String title;
  final String description;
  final List<String> categories;
  final List<String> country;
  final String imageUrl;
  final String newsUrl;
  final String sourceName;
  final String sourceIcon;
  final DateTime? dateTime;

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categories,
    required this.country,
    required this.imageUrl,
    required this.newsUrl,
    required this.sourceName,
    required this.sourceIcon,
    required this.dateTime,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    const String placeholderImage =
        "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png";

    String? rawImage = json['image_url'];
    String safeImageUrl =
    (rawImage != null && rawImage.isNotEmpty) ? rawImage : placeholderImage;

    String? rawNewsUrl = json['link'];
    String safeNewsUrl = (rawNewsUrl != null && rawNewsUrl.isNotEmpty)
        ? rawNewsUrl
        : "https://example.com";

    String? rawSourceIcon = json['source_icon'];
    String safeSourceIcon =
    (rawSourceIcon != null && rawSourceIcon.isNotEmpty)
        ? rawSourceIcon
        : "https://via.placeholder.com/24";

    return ArticleModel(
      id: json['article_id'] ?? '',
      title: json['title'] ?? 'No title available',
      description: json['description'] ?? 'No description available',
      categories: json['category'] != null
          ? List<String>.from(json['category'])
          : [],
      country:
      json['country'] != null ? List<String>.from(json['country']) : [],
      imageUrl: safeImageUrl,
      newsUrl: safeNewsUrl,
      sourceName: json['source_name'] ?? 'Unknown source',
      sourceIcon: safeSourceIcon,
      dateTime: DateTime.tryParse(json['pubDate'] ?? ''),
    );
  }
}
