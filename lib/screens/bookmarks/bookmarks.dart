
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/utils/app_colors.dart';
import 'package:instanews_pro/widgets/animated_container_widget/animatedContainerWidget.dart';

class Bookmarks extends ConsumerStatefulWidget {
  const Bookmarks({super.key});

  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends ConsumerState<Bookmarks> {

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Bookmarks',
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
          SizedBox(height: 10.h,),
          _buildSearchBar(theme),
          SizedBox(height: 20.h,),
          Expanded(
             child: ListView.builder(
                 physics: BouncingScrollPhysics(),
                 itemCount: 10,
                 itemBuilder: (context,index){
                   return AnimatedContainerWidget(
                     index: index,
                     offset: Offset(0, 0.5),
                     child: BookmarkWidget(
                         theme: theme,
                         imageUrl: 'https://d3i6fh83elv35t.cloudfront.net/static/2025/09/HighStakes-1024x683.jpg',
                         title: 'Somebody but nobody gets the title of fancy awards 2025 in LA ',
                         chipTitle: 'Celebrity',
                         onPressed: () {

                         },
                         onBookmark: () {

                         },
                     ),
                   );
                 }
             )
         )
        ],
      ),
    );
  }
  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:20.w ),
      child: Container(
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
              prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
              hintText: 'Find in bookmarks',
              hintStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.tune,
                  color: theme.iconTheme.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookmarkWidget extends StatelessWidget {
  final ThemeData theme;
  final String imageUrl;
  final String title;
  final String chipTitle;
  final VoidCallback onPressed;
  final VoidCallback onBookmark;
  final bool? isMarked;

  const BookmarkWidget({
    super.key,
    required this.theme,
    required this.imageUrl,
    required this.title,
    required this.chipTitle,
    required this.onPressed,
    required this.onBookmark,
    this.isMarked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:20.w ,vertical: 12.h),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 150.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.65),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 12,
                        right: 15,
                        child: GestureDetector(
                          onTap: onBookmark,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.bookmark_border,color: AppColors.lightTextPrimary,),
                          ),
                        )
                    )
                  ],
                ),
              SizedBox(height: 5.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
                child: Text(title,maxLines: 2,style: theme.textTheme.titleMedium,overflow: TextOverflow.ellipsis,),

              ),
             Padding(
                 padding: EdgeInsets.symmetric(horizontal: 15.w,),
                 child: TextButton(
                     onPressed: onPressed,
                     style: TextButton.styleFrom(
                       padding: EdgeInsets.zero
                     ),
                     child: Text('Read more...',style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),)
                 ),
             ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w,),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  padding: const EdgeInsets.all(10),
                  side: BorderSide.none,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  label: Text(
                    chipTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h,),

          ],
        ),
      ),
    );
  }
}
