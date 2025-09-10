
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/riverpod/news_riverpod/news_riverpod.dart';
import 'package:instanews_pro/riverpod/speech_to_text_riverpod/speech_to_text_riverpod.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/riverpod/weather_riverpod/weather_riverpod.dart';
import 'package:instanews_pro/screens/explore/explore.dart';
import 'package:instanews_pro/widgets/app_loader/app_loader.dart';
import 'package:instanews_pro/widgets/shimmer_effects/shimmer_listview.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../riverpod/show_weather_pref_riverpod/show_weather_pref_riverpod.dart';
import '../../utils/app_colors.dart';
import '../../widgets/app_title/app_title.dart';
import '../../widgets/carousel_widget/carousel_widget.dart';
import '../../widgets/news_details_screen/news_details.dart';
import '../../widgets/short_news_tile/short_news_tile.dart';
import '../../widgets/weather_lite/weather_lite.dart';
import '../all_news/all_news.dart';

final selectedProvider = StateProvider<int>((ref) => 0);
final indexProvider = StateProvider<int>((ref) => 0);

final breakingNewsProvider = StateNotifierProvider<NewsNotifier,NewsState>((ref)=>NewsNotifier()..fetchCategory('top'));
final worldNewsProvider = StateNotifierProvider<NewsNotifier,NewsState>((ref)=>NewsNotifier()..fetchCategory('world'));

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Delay the initial fetch to ensure preferences are loaded
    Future.microtask(() {
      final newsNotifier = ref.read(newsNotifierProvider.notifier);
      // Check if preferences are loaded before fetching
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          newsNotifier.fetchNewsByCountryAndLanguage();
          ref.read(breakingNewsProvider.notifier).fetchCategory('top');
          ref.read(worldNewsProvider.notifier).fetchCategory('world');
          ref.read(weatherProvider.notifier).fetchCurrentWeather();
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    final index = ref.watch(indexProvider);
    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;
    final newsState = ref.watch(newsNotifierProvider);
    final weatherState = ref.watch(weatherProvider);
    final showWeather = ref.watch(showWeatherProvider);

    final breakingNews = ref.watch(breakingNewsProvider);
    final worldNews = ref.watch(worldNewsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 70.h,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: isDark
              ? Color(0xFF121212)
              : Color(0xFFFFFFFF),
        ),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppTitle(
                        width: 0,
                        theme: theme,
                        textStyleFirst: theme.textTheme.headlineMedium!,
                        textStyleSecond: theme.textTheme.headlineMedium!
                            .copyWith(color: theme.colorScheme.primary),
                        textStyleThird: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                        cWidth: 40.w,
                        cHeight: 22.h,
                        offset: Offset(3.w, -10.h),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            showWeather ? Spacer() : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Visibility(
                visible: showWeather,
                replacement: SizedBox.shrink(),
                child: WeatherLite(theme: theme, weatherState: weatherState),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: _buildSearchBar(theme, ref),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: newsState.isSearching
                ? Builder(
                    builder: (context) {
                      if (newsState.isLoading && newsState.articles.isEmpty) {
                        return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (_, _) {
                            return ShimmerListview(height: 150.h);
                          },
                        );
                      } else if (newsState.articles.isEmpty) {
                        return Center(child: Text('No news to show'));
                      } else if (newsState.error != null) {
                        return Center(child: Text('Something went wrong'));
                      }

                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100 && !newsState.isLoading) {
                            ref.read(newsNotifierProvider.notifier).fetchPaginatedSearchedArticles();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: newsState.articles.length + 1,
                          itemBuilder: (context, index) {
                            if (index < newsState.articles.length) {
                              final article = newsState.articles[index];
                              return ShortNewsTile(
                                index: index,
                                theme: theme,
                                title: article.title,
                                chipTitle: article.categories
                                    .take(1)
                                    .map((i) => i.toUpperCase())
                                    .join(''),
                                imageUrl: article.imageUrl,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NewsDetailPage(
                                        tag: article.id,
                                        imageUrl: article.imageUrl,
                                        category: article.categories
                                            .take(1)
                                            .map((i) => i.toUpperCase())
                                            .join(''),
                                        title: article.title,
                                        source: article.sourceName,
                                        content: article.description,
                                        sourceIcon: article.sourceIcon,
                                        onBookmark: () {},
                                        onShare: () {},
                                        onReadLater: () {},
                                        onReadMore: () {},
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return newsState.isLoading
                                  ? Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: AppLoader.mainLoader(null),
                                    )
                                  : const SizedBox.shrink();
                            }
                          },
                        ),
                      );
                    },
                  )
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        _buildNewsTitleRow(theme, 'Breaking News', 1),
                        SizedBox(height: 15.h),
                        breakingNews.isLoading
                            ? SizedBox(
                                height: 200.h,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    children: List.generate(
                                      5,
                                      (index) => Padding(
                                        padding: EdgeInsets.only(right: 12.w),
                                        child: ShimmerListview(
                                          height: 200.h,
                                          width: 344.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : CarouselWidget(
                                theme: theme,
                                ref: ref,
                                articles: breakingNews.articles,
                                iconColor: theme.iconTheme.color!,
                                onPressed: (index) {
                                  final article = breakingNews.articles[index];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NewsDetailPage(
                                        imageUrl: article.imageUrl,
                                        category: article.categories.join(', '),
                                        title: article.title,
                                        source: article.sourceName,
                                        content: article.description,
                                        sourceIcon: '',
                                        onBookmark: () {},
                                        onShare: () {},
                                        onReadLater: () {},
                                        onReadMore: () {},
                                        tag: 'breaking_${article.id}',
                                      ),
                                    ),
                                  );
                                },
                              ),
                        SizedBox(height: 25.h),
                        Center(
                          child: _buildAnimatedSmoothIndicator(index, theme),
                        ),
                        SizedBox(height: 20.h),
                        _buildNewsTitleRow(theme, 'Recent News', 0),
                        newsState.isLoading
                            ? buildShimmer()
                            : buildRecentNewsListView(newsState, theme),
                        SizedBox(height: 20.h),
                        _buildNewsTitleRow(theme, 'International News', 2),
                        worldNews.isLoading
                            ? buildShimmer()
                            : buildWorldNewsListView(theme, worldNews),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildRecentNewsListView(NewsState newsState, ThemeData theme) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: newsState.articles.length,
      itemBuilder: (context, index) {
        final articles = newsState.articles[index];
        return ShortNewsTile(
          index: index,
          theme: theme,
          title: articles.title,
          chipTitle: articles.categories
              .take(1)
              .map((i) => i.toUpperCase())
              .join(''),
          imageUrl: articles.imageUrl,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewsDetailPage(
                  tag: articles.id,
                  imageUrl: articles.imageUrl,
                  category: articles.categories
                      .take(1)
                      .map((i) => i.toUpperCase())
                      .join(''),
                  title: articles.title,
                  source: articles.sourceName,
                  content: articles.description,
                  sourceIcon: articles.sourceIcon,
                  onBookmark: () {},
                  onShare: () {},
                  onReadLater: () {},
                  onReadMore: () {},
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildWorldNewsListView(
    ThemeData theme,
    NewsState categoryState,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categoryState.articles.length,
      itemBuilder: (context, index) {
        final article = categoryState.articles[index];
        return ShortNewsTile(
          index: index,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailPage(
                  imageUrl: article.imageUrl,
                  category: article.categories
                      .take(1)
                      .map((i) => i.toUpperCase())
                      .join(''),
                  title: article.title,
                  source: article.sourceName,
                  content: article.description,
                  sourceIcon: article.sourceIcon,
                  onBookmark: () {},
                  onShare: () {},
                  onReadLater: () {},
                  onReadMore: () {},
                  tag: article.id,
                ),
              ),
            );
          },
          theme: theme,
          title: article.title,
          chipTitle: article.categories
              .take(1)
              .map((i) => i.toUpperCase())
              .join(''),
          imageUrl: article.imageUrl,
        );
      },
    );
  }

  Widget buildShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, _) {
        return ShimmerListview(height: 150.h);
      },
    );
  }

  Widget _buildSearchBar(ThemeData theme, WidgetRef ref) {
    final speechState = ref.watch(speechStateProvider);
    final speechNotifier = ref.read(speechStateProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (speechState.isListening && speechState.recognizedWords.isNotEmpty) {
        _searchController.text = speechState.recognizedWords;
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: speechState.recognizedWords.length),
        );
      }
    });

    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: _searchController,
          cursorColor: theme.colorScheme.primary,
          decoration: InputDecoration(
            hintText: speechState.isListening? 'Say something...' : 'Search for any news...',
            hintStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),

            suffixIcon: IconButton(
              onPressed: () {
                if (speechState.isListening) {
                  speechNotifier.stopListening();
                } else {
                  speechNotifier.startListening();
                }
              },
              icon: speechState.isListening ? Icon(Icons.mic, color: theme.colorScheme.primary) : Icon(Icons.mic_off, color: theme.iconTheme.color)
            ),
          ),

          onSubmitted: (value) {
            if (value.isEmpty) {
              ref.read(newsNotifierProvider.notifier).fetchNewsByCountryAndLanguage();
              ref.read(breakingNewsProvider.notifier).fetchCategory('top');
              ref.read(worldNewsProvider.notifier).fetchCategory('world');
            } else {
              ref.read(newsNotifierProvider.notifier).fetchSearchedArticles(value);
            }
          },
        ),
      ),
    );
  }



  Widget _buildNewsTitleRow(
    ThemeData theme,
    String title,
    int exploreTabIndex,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: () {
              ref.read(exploreTabIndexProvider.notifier).state =
                  exploreTabIndex;
              ref.read(countProvider.notifier).state = 1;

              if (exploreTabIndex == 0) {
                ref.read(selectedCategory.notifier).state = '';
                ref.read(newsNotifierProvider.notifier).fetchNewsByCountryAndLanguage();
              } else if (exploreTabIndex == 1) {
                ref.read(selectedCategory.notifier).state = 'top';
                ref.read(newsNotifierProvider.notifier).fetchCategory('top');
              } else if (exploreTabIndex == 2) {
                ref.read(selectedCategory.notifier).state = 'world';
                ref.read(newsNotifierProvider.notifier).fetchCategory('world');
              }
            },
            style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
            child: Text('View more', style: theme.textTheme.titleMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSmoothIndicator(int index, ThemeData theme) {
    return AnimatedSmoothIndicator(
      activeIndex: index,
      count: 5,
      effect: ExpandingDotsEffect(
        activeDotColor: theme.colorScheme.primary,
        dotColor: AppColors.lightTextPrimary,
        dotHeight: 10.h,
        dotWidth: 10.h,
      ),
    );
  }
}

