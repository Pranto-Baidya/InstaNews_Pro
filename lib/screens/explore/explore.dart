import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/news_models/db_bookmark_model/bookmark_model.dart';
import 'package:instanews_pro/riverpod/internet_riverpod/internet_riverpod.dart';
import 'package:instanews_pro/riverpod/news_riverpod/news_riverpod.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/screens/all_news/all_news.dart';
import 'package:instanews_pro/widgets/news_details_screen/news_details.dart';
import 'package:instanews_pro/widgets/news_webview/news_webview.dart';
import 'package:instanews_pro/widgets/shimmer_effects/shimmer_listview.dart';
import 'package:instanews_pro/widgets/short_news_tile/short_news_tile.dart';
import 'package:instanews_pro/widgets/toast_msg/toast_msg.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/app_loader/app_loader.dart';


final exploreTabIndexProvider = StateProvider<int>((ref) => 0);
final selectedCategory = StateProvider<String>((ref)=>'');

class ExploreNews extends ConsumerStatefulWidget {
  final int initialIndex;
  const ExploreNews({required this.initialIndex, super.key});

  @override
  _ExploreNewsState createState() => _ExploreNewsState();
}

class _ExploreNewsState extends ConsumerState<ExploreNews> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exploreTabIndexProvider.notifier).state = widget.initialIndex;
        ref.read(newsNotifierProvider.notifier).fetchNewsByCountryAndLanguage();
    });

  }

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    int selectedIndex = ref.watch(exploreTabIndexProvider);

    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    final newsState = ref.watch(newsNotifierProvider);
    final newsNotifier = ref.read(newsNotifierProvider.notifier);

    final category = ref.watch(selectedCategory);

    final categoryState = ref.watch(newsNotifierProvider);
    final categoryNotifier = ref.read(newsNotifierProvider.notifier);

    final checkInternet = ref.watch(internetProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Explore All News',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 70.h,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF),
        ),
      ),
      body: !checkInternet.isConnected?
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 100.h,),
            Center(child: Image.asset('assets/internet.png',fit: BoxFit.cover,width: 250.w,height: 250.h,)),
            SizedBox(height: 15.h,),
            Text('No Internet Connection',style: theme.textTheme.titleMedium,),
            SizedBox(height: 10.h,),
            Text('Please check your wifi and try again' ,style: theme.textTheme.titleMedium,),
            SizedBox(height: 20.h,),
            ElevatedButton(
                onPressed: (){
                  ref.read(countProvider.notifier).state = 2;
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    minimumSize: Size(100.w, 45.h)
                ),
                child: Text('View Bookmarks',style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),)
            )
          ],
        ),
      ):Column(
        children: [
          SizedBox(height: 10.h),
          ExploreNewsTabBar(
            theme: theme,
            ref: ref,
            selectedIndex: selectedIndex,
          ),
          SizedBox(height: 15.h),
          selectedIndex==0?
           Expanded(
               child: RefreshIndicator(
                   onRefresh: ()=> newsNotifier.fetchNewsByCountryAndLanguage(),
                   backgroundColor: theme.cardColor,
                   color: theme.colorScheme.primary,
                   child: Builder(
                       builder: (context){
                         if(newsState.isLoading && newsState.articles.isEmpty){
                           return ListView.builder(
                               itemCount: 5,
                               itemBuilder: (_,_){
                                 return ShimmerListview();
                               }
                           );
                         }
                         else if(newsState.articles.isEmpty){
                           return Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Center(child: Image.asset('assets/empty.png',fit: BoxFit.cover,width: 250.w,height: 250.h,)),
                               SizedBox(height: 15.h,),
                               Center(child: Text('Oops! No news to show',style: theme.textTheme.titleMedium,)),
                             ],
                           );
                         }
                           return NotificationListener<ScrollNotification>(
                             onNotification: (scrollInfo){
                               if(scrollInfo.metrics.pixels>=scrollInfo.metrics.maxScrollExtent-100 && !newsState.isLoading){
                                 newsNotifier.fetchMorePersonalizedNews();
                               }
                               return false;
                             },
                               child: ListView.builder(
                                   physics: ClampingScrollPhysics(),
                                   shrinkWrap: true,
                                   itemCount: newsState.articles.length+1,
                                   itemBuilder: (context,index){
                                     if(index < newsState.articles.length) {
                                       final articles = newsState.articles[index];
                                       final bookmarkModel = BookmarkModel(
                                           id: articles.id,
                                           title: articles.title,
                                           description: articles.description,
                                           imageUrl: articles.imageUrl,
                                           categories: articles.categories,
                                           countries: articles.country,
                                           newsUrl: articles.newsUrl,
                                           newsSource: articles.sourceName,
                                           sourceIcon: articles.sourceIcon,
                                           dateTime: articles.dateTime
                                       );
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
                                           Navigator.push(context, MaterialPageRoute(
                                             builder: (_) => NewsDetailPage(
                                               tag: articles.id,
                                               imageUrl: articles.imageUrl,
                                               category: articles.categories.take(1).map((i) => i.toUpperCase()).join(''),
                                               title: articles.title,
                                               source: articles.sourceName,
                                               content: articles.description,
                                               sourceIcon: articles.sourceIcon,
                                               model: bookmarkModel,
                                               dateTime: articles.dateTime!,
                                               onShare: () {
                                                 SharePlus.instance.share(
                                                   ShareParams(
                                                     uri: Uri.parse(articles.newsUrl)
                                                   )
                                                 );
                                               },
                                               onReadLater: () {},
                                               onReadMore: () {
                                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsWebview(newsUrl: articles.newsUrl)));
                                               },
                                             ),
                                           ));
                                         },

                                       );
                                     }
                                     else{
                                       return newsState.isLoading? Padding(
                                         padding: const EdgeInsets.all(16),
                                         child: AppLoader.mainLoader(null),
                                       ):SizedBox.shrink();
                                     }
                                   }
                               )

                           );
                       }
                   ),
               )
           ) :Expanded(
              child: RefreshIndicator(
                 backgroundColor: theme.cardColor,
                 color: theme.colorScheme.primary,
                  onRefresh: ()=> categoryNotifier.fetchCategory(category),
                  child: Builder(
                      builder: (context){
                        if(categoryState.isLoading && categoryState.articles.isEmpty){
                          return ListView.builder(
                             itemCount: 5,
                              itemBuilder: (context,index){
                                return ShimmerListview();
                              }
                          );
                        }
                        if(categoryState.articles.isEmpty){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: Image.asset('assets/empty.png',fit: BoxFit.cover,width: 250.w,height: 250.h,)),
                              SizedBox(height: 15.h,),
                              Center(child: Text('Oops! No news to show',style: theme.textTheme.titleMedium,)),
                            ],
                          );
                        }
                        return NotificationListener<ScrollNotification>(
                          onNotification: (scrollInfo){
                             if(scrollInfo.metrics.pixels>=scrollInfo.metrics.maxScrollExtent-100 && !categoryState.isLoading){
                               categoryNotifier.fetchMoreCategoryNews();
                             }
                             return false;
                          },
                            child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: categoryState.articles.length + 1,
                                itemBuilder: (context,index){
                                  if(index<categoryState.articles.length){
                                    final article = categoryState.articles[index];
                                    final bookmarkModel = BookmarkModel(
                                        id: article.id,
                                        title: article.title,
                                        description: article.description,
                                        imageUrl: article.imageUrl,
                                        categories: article.categories,
                                        countries: article.country,
                                        newsUrl: article.newsUrl,
                                        newsSource: article.sourceName,
                                        sourceIcon: article.sourceIcon,
                                        dateTime: article.dateTime
                                    );
                                    return ShortNewsTile(
                                        index: index,
                                        theme: theme,
                                        title: article.title,
                                        chipTitle: article.categories.map((i)=>i.toString().toUpperCase()).take(1).join(''),
                                        imageUrl: article.imageUrl,
                                        onPressed: (){
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                              NewsDetailPage(
                                                  tag: article.id,
                                                  imageUrl: article.imageUrl,
                                                  category: article.categories.map((i)=>i.toString().toUpperCase()).take(1).join(''),
                                                  title: article.title,
                                                  source: article.sourceName,
                                                  content: article.description,
                                                  sourceIcon: article.sourceIcon,
                                                  model: bookmarkModel ,
                                                  dateTime: article.dateTime!,
                                                  onShare: (){
                                                    SharePlus.instance.share(
                                                      ShareParams(
                                                        uri: Uri.parse(article.newsUrl)
                                                      )
                                                    );
                                                  },
                                                  onReadLater: (){},
                                                  onReadMore: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsWebview(newsUrl: article.newsUrl)));
                                                  }
                                              )));
                                        },

                                    );
                                  }
                                  else {
                                    return categoryState.isLoading
                                        ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Center(child: AppLoader.mainLoader(null)),
                                    )
                                        : const SizedBox.shrink();
                                  }
                                }
                            )
                        );
                      }
                  ),
              )
          ),
        ],
      ),
    );
  }
}


class ExploreNewsTabBar extends StatelessWidget {
  const ExploreNewsTabBar({
    super.key,
    required this.theme,
    required this.ref,
    required this.selectedIndex,
  });

  final ThemeData theme;
  final WidgetRef ref;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'All News',
      'Top Stories',
      'World',
      'Politics',
      'Entertainment',
      'Sports',
      'Crime',
      'Health',
      'Food',
      'Technology',
      'Science',
      'Education',
      'Other'
    ];
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(60.r),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...categories.asMap().entries.map((entry) {
                  int j = entry.key;
                  String i = entry.value;

                  return InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      ref.read(exploreTabIndexProvider.notifier).state = j;
                      if (i != 'All News') {
                        String words = i.split(' ').take(1).map((i)=>i.toLowerCase()).join('');
                        ref.read(selectedCategory.notifier).state = words;
                        ref.read(newsNotifierProvider.notifier).fetchCategory(words);
                      } else {
                        ref.read(selectedCategory.notifier).state = '';
                        ref.read(newsNotifierProvider.notifier).fetchNewsByCountryAndLanguage();
                      }
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedIndex == j
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.w,
                      ),
                      child: Text(
                        i,
                        style: selectedIndex == j
                            ? theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                        )
                            : theme.textTheme.titleSmall,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
