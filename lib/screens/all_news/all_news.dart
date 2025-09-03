
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/screens/bookmarks/bookmarks.dart';
import 'package:instanews_pro/screens/explore/explore.dart';
import 'package:instanews_pro/screens/home/home.dart';
import 'package:instanews_pro/screens/more/more.dart';
import 'package:instanews_pro/utils/app_colors.dart';

final countProvider = StateProvider<int>((ref)=>0);

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

    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: [
        Home(),
        ExploreNews(initialIndex : index),
        Bookmarks(),
        More()
      ][count],

      bottomNavigationBar: NavigationBar(
         backgroundColor: theme.appBarTheme.backgroundColor,
          indicatorColor: AppColors.hintTextColor.withOpacity(0.1),
          selectedIndex: count,
          onDestinationSelected: (value){
            ref.read(countProvider.notifier).state = value;
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
    );
  }
}
