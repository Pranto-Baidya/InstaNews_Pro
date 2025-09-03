import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/widgets/short_news_tile/short_news_tile.dart';


final exploreTabIndexProvider = StateProvider<int>((ref) => 0);

class ExploreNews extends ConsumerStatefulWidget {
  final int initialIndex;
  const ExploreNews({required this.initialIndex, super.key,});

  @override
  _ExploreNewsState createState() => _ExploreNewsState();
}

class _ExploreNewsState extends ConsumerState<ExploreNews> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(exploreTabIndexProvider.notifier).state = widget.initialIndex;
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    int selectedIndex = ref.watch(exploreTabIndexProvider);

    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;

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
            statusBarIconBrightness: isDark? Brightness.light:Brightness.dark,
            systemNavigationBarColor: isDark ? Color(0xFF121212) : Color(0xFFFFFFFF)
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          ExploreNewsTabBar(
            theme: theme,
            ref: ref,
            selectedIndex: selectedIndex,
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                 return ShortNewsTile(
                   index: index,
                   theme: theme,
                   title: 'Fans Think Miley Cyrus New Album...',
                   chipTitle: 'Entertainment',
                   imageUrl:
                   'https://media.glamour.com/photos/5fc1429bcea2c24a2fe461f5/4:3/w_1600%2Ch_1200%2Cc_limit/miley-liam.jpg',
                   onPressed: () {},
                   iconColor: theme.iconTheme.color!,
                 );
              },
            ),
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
    List<String> fakeCategories = [
      'All News',
      'Top Stories',
      'Politics',
      'Health & Wellness',
      'Sports',
      'Science & Technology',
      'International',
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
                ...fakeCategories.asMap().entries.map((entry) {
                  int j = entry.key;
                  String i = entry.value;

                  return InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      ref.read(exploreTabIndexProvider.notifier).state = j;
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
