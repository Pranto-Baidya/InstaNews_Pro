
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/screens/bookmarks/bookmarks.dart';
import 'package:instanews_pro/screens/explore/explore.dart';
import 'package:instanews_pro/screens/home/home.dart';
import 'package:instanews_pro/screens/more/more.dart';
import 'package:instanews_pro/utils/app_colors.dart';

import '../../widgets/toast_msg/toast_msg.dart';

final countProvider = StateProvider<int>((ref)=>0);

final tipProvider = StateProvider<bool>((ref)=>false);

class AllNews extends ConsumerStatefulWidget {
  const AllNews({super.key});

  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends ConsumerState<AllNews> {
  @override
  Widget build(BuildContext context) {
    var count = ref.watch(countProvider);
    final index = ref.watch(exploreTabIndexProvider);

    final isDark = ref.watch(themeNotifierProvider)==ThemeMode.dark;

    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: count,
        children: [
            Home(),
            ExploreNews(initialIndex : index),
            Bookmarks(),
            More()
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: isDark? Colors.grey.shade800 :Colors.grey.shade300,width: 0.5)
          )
        ),
        child: NavigationBar(
           backgroundColor: theme.appBarTheme.backgroundColor,
            indicatorColor: AppColors.hintTextColor.withOpacity(0.1),
            selectedIndex: count,
            onDestinationSelected: (value){
              ref.read(countProvider.notifier).state = value;
              final tipShown = ref.read(tipProvider);
              if(value==1) {
                if (!tipShown) {
                  ref.read(tipProvider.notifier).state = true;

                  ToastMsg.showTip(
                      message: 'Swipe left to see more categories',
                      context: context,
                      alignment: Alignment.topCenter
                  );

                }
              }
            },
            destinations: [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined,color: theme.iconTheme.color,size: 28.sp,),
                  selectedIcon: Icon(Icons.home,color: theme.colorScheme.primary,size: 28.sp,),
                  label: 'Home'
              ),
              NavigationDestination(
                  icon: Icon(Icons.explore_outlined,color: theme.iconTheme.color,size: 28.sp,),
                  selectedIcon: Icon(Icons.explore,color: theme.colorScheme.primary,size: 28.sp,),
                  label: 'Explore'
              ),
              NavigationDestination(
                  icon: Icon(Icons.bookmark_border,color: theme.iconTheme.color,size: 28.sp,),
                  selectedIcon: Icon(Icons.bookmark,color: theme.colorScheme.primary,size: 28.sp,),
                  label: 'Bookmarks'
              ),
              NavigationDestination(
                  icon: Icon(Icons.more_outlined,color: theme.iconTheme.color,size: 28.sp,),
                  selectedIcon: Icon(Icons.more,color: theme.colorScheme.primary,size: 28.sp,),
                  label: 'More'
              ),
            ]
        ),
      ),
    );
  }
}
