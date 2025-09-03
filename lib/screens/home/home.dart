import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/screens/explore/explore.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/app_colors.dart';
import '../../widgets/app_title/app_title.dart';
import '../../widgets/carousel_widget/carousel_widget.dart';
import '../../widgets/news_details_screen/news_details.dart';
import '../../widgets/short_news_tile/short_news_tile.dart';
import '../all_news/all_news.dart';

final selectedProvider = StateProvider<int>((ref) => 0);
final indexProvider = StateProvider<int>((ref) => 0);

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final index = ref.watch(indexProvider);
    final isDark = ref.watch(themeNotifierProvider)==ThemeMode.dark;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 70.h,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark? Brightness.light:Brightness.dark,
            systemNavigationBarColor: isDark ? Color(0xFF121212) : Color(0xFFFFFFFF)
        ),
        title: Padding(
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
                    textStyleSecond: theme.textTheme.headlineMedium!.copyWith(color: theme.colorScheme.primary),
                    textStyleThird: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),
                    cWidth: 40.w,
                    cHeight: 22.h,
                    offset: Offset(3.w, -10.h),
                  ),
                ],
              ),
              SizedBox(height: 5.h,),
              Text(DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w300) ,)
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
                onPressed: (){

                },
                icon: Icon(Icons.notifications_none,color: theme.iconTheme.color,size: 30.sp,)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildSearchBar(theme),
            ),
            SizedBox(height: 20.h),
            _buildNewsTitleRow(theme, 'Breaking News',0),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CarouselWidget(theme: theme, ref: ref,
                  title: 'Biden warns of 2020 US election interference',
                  chipTitle: 'Top Stories',
                  imageUrl: 'https://static.dw.com/image/53661398_605.jpg',
                  iconColor: theme.iconTheme.color!,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        NewsDetailPage(
                            imageUrl: 'https://live-production.wcms.abc-cdn.net.au/7b651026c8de14ceff1665a2912ead1e?impolicy=wcms_crop_resize&cropH=2813&cropW=5000&xPos=0&yPos=261&width=862&height=485',
                            category: 'Sports',
                            title: 'Indian exporters brace for introduction of US tariffs topping 50 per cent from today',
                            source: 'BBC',
                            content: 'Indian exporters are bracing for a sharp decline in US orders after trade talks collapsed and Washington confirmed steep new tariffs on goods from the South Asian nation, escalating tension between the strategic partners.',
                            onBack: () {
                              Navigator.pop(context);
                            },
                            onBookmark: () {

                            },
                            onShare: () {

                            },
                            onWatchLater: () {

                            },
                           onReadMore: () {

                           },
                          tag: 'news_details_$index',

                        )));
                  },
              ),
            ),
            SizedBox(height: 25.h),
            Center(child: _buildAnimatedSmoothIndicator(index, theme)),
            SizedBox(height: 20.h),
            _buildNewsTitleRow(theme, 'Latest News',2),
            ShortNewsTile(
              index: index,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    NewsDetailPage(
                      imageUrl: 'https://live-production.wcms.abc-cdn.net.au/7b651026c8de14ceff1665a2912ead1e?impolicy=wcms_crop_resize&cropH=2813&cropW=5000&xPos=0&yPos=261&width=862&height=485',
                      category: 'Sports',
                      title: 'Indian exporters brace for introduction of US tariffs topping 50 per cent from today',
                      source: 'BBC',
                      content: 'Indian exporters are bracing for a sharp decline in US orders after trade talks collapsed and Washington confirmed steep new tariffs on goods from the South Asian nation, escalating tension between the strategic partners.',
                      onBack: () {
                        Navigator.pop(context);
                      },
                      onBookmark: () {

                      },
                      onShare: () {

                      },
                      onWatchLater: () {

                      },
                      onReadMore: () {

                      },
                      tag: 'new_details_$index',

                    )));
              },
              theme: theme,
              title:
                  "How, and at what cost, could Canada catch up to Poland's defence spending?",
              chipTitle: 'Politics',
              imageUrl:
                  'https://i.cbc.ca/ais/1d504e03-a2cf-49ff-aed7-aa10d81c9da0,1756123971636/full/max/0/default.jpg?im=Crop%2Crect%3D%280%2C0%2C1280%2C720%29%3B',
              iconColor: theme.iconTheme.color!,
            ),
            SizedBox(height: 20.h),
            _buildNewsTitleRow(theme, 'Trending News',1),
            ShortNewsTile(
              index: index,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    NewsDetailPage(
                      imageUrl: 'https://live-production.wcms.abc-cdn.net.au/7b651026c8de14ceff1665a2912ead1e?impolicy=wcms_crop_resize&cropH=2813&cropW=5000&xPos=0&yPos=261&width=862&height=485',
                      category: 'Sports',
                      title: 'Indian exporters brace for introduction of US tariffs topping 50 per cent from today',
                      source: 'BBC',
                      content: 'Indian exporters are bracing for a sharp decline in US orders after trade talks collapsed and Washington confirmed steep new tariffs on goods from the South Asian nation, escalating tension between the strategic partners.',
                      onBack: () {
                        Navigator.pop(context);
                      },
                      onBookmark: () {

                      },
                      onShare: () {

                      },
                      onWatchLater: () {

                      },
                      onReadMore: () {

                      },
                      tag: 'new_details_$index',

                    )));
              },
              theme: theme,
              title:
                  'US makes it harder for SK Hynix, Samsung to make chips in China',
              chipTitle: 'Technology',
              imageUrl:
                  'https://images.indianexpress.com/2025/07/Tech-feature-images337.jpg',
              iconColor: theme.iconTheme.color!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
              width: double.infinity.w,
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(10.r),
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
                        hintText: 'Search for any news...',
                        hintStyle: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                      ),
                        prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.keyboard_voice,
                            color: theme.iconTheme.color,
                          ),
                        ),

                      ),
                    ),
              ),
            );
  }

  Widget _buildNewsTitleRow(ThemeData theme, String title,int exploreTabIndex) {
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
            onPressed: (){
              ref.read(exploreTabIndexProvider.notifier).state = exploreTabIndex;
              ref.read(countProvider.notifier).state = 1;
            },
            style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
            child: Text(
              'View more',
              style: theme.textTheme.titleMedium
            ),
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
