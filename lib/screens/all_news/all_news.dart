
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/screens/home/home.dart';
import 'package:instanews_pro/utils/app_colors.dart';
import 'package:instanews_pro/widgets/app_title/app_title.dart';
import 'package:intl/intl.dart';

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

    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
     appBar: AppBar(
       backgroundColor: theme.scaffoldBackgroundColor,
       toolbarHeight: 70.h,
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
             Text(DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),style: TextStyle(color: AppColors.lightTextPrimary,fontSize: 15,fontWeight: FontWeight.w300),)
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
      body: [
        Home(),
        Center(child: Text("Explore")),
        Center(child: Text("Categories")),
        Center(child: Text("Profile")),
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
