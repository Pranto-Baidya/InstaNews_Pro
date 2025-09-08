import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsDetailPage extends StatelessWidget {
  final String tag;
  final String imageUrl;
  final String category;
  final String title;
  final String source;
  final String content;
  final String? sourceIcon;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final VoidCallback onReadLater;
  final VoidCallback onReadMore;

  const NewsDetailPage({
    super.key,
    required this.tag,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.source,
    required this.content,
    required this.sourceIcon,
    required this.onBookmark,
    required this.onShare,
    required this.onReadLater,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 370.h,
                      child: Hero(
                        tag: tag,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 370.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 35.h,
                      left: 16.w,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 55.h,
                      left: 16.w,
                      right: 16.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(7.r),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(color: Colors.white, fontSize: 14.sp),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 350.h,
                  right: 0,
                  left: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.h,),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: sourceIcon!=null? NetworkImage(sourceIcon!) : NetworkImage('https://www.svgrepo.com/show/508699/landscape-placeholder.svg'),
                                      radius: 18.r,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      source,
                                      style: theme.textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(Icons.verified, color: theme.colorScheme.primary, size: 18.sp),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  content,
                                  style: theme.textTheme.titleMedium,
                                  maxLines: 10,
                                ),
                                TextButton(
                                  onPressed: onReadMore,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    'Read Full Article Here',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                      decorationColor: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],

                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 330.h,
                  right: 134.w,
                  child: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    radius: 22,
                    child: IconButton(
                      onPressed: onBookmark,
                      icon: Icon(Icons.bookmark_border, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 330.h,
                  right: 26.w,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: theme.colorScheme.primary,
                    child: IconButton(
                      onPressed: onShare,
                      icon: Icon(Icons.share_outlined, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 330.h,
                  right: 80.w,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: theme.colorScheme.primary,
                    child: IconButton(
                      onPressed: onReadLater,
                      icon: Icon(Icons.watch_later_outlined, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}