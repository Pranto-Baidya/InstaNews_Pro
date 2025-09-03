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
  final VoidCallback onBack;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final VoidCallback onWatchLater;
  final VoidCallback onReadMore;

  const NewsDetailPage({
    super.key,
    required this.tag,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.source,
    required this.content,
    required this.onBack,
    required this.onBookmark,
    required this.onShare,
    required this.onWatchLater,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Hero(
        tag: tag,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 350.h,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 350.h,
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
                            onPressed: onBack,
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 35.h,
                        right: 112.w,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            onPressed: onBookmark,
                            icon: Icon(Icons.bookmark_border, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 35.h,
                        right: 16.w,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            onPressed: onShare,
                            icon: Icon(Icons.share_outlined, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 35.h,
                        right: 64.w,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            onPressed: onWatchLater,
                            icon: Icon(Icons.watch_later_outlined, color: Colors.white),
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
                    top: 320.h,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 18.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  source,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Icon(Icons.verified, color: Colors.blue, size: 18.sp),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              content,
                              style: TextStyle(fontSize: 15.sp, height: 1.5),
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}