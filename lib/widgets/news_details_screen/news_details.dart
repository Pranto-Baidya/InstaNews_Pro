import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/news_models/db_bookmark_model/bookmark_model.dart';
import 'package:instanews_pro/riverpod/db_riverpod/db_riverpod.dart';
import 'package:instanews_pro/widgets/toast_msg/toast_msg.dart';

import '../app_loader/app_loader.dart';

class NewsDetailPage extends ConsumerWidget {
  final String tag;
  final String imageUrl;
  final String category;
  final String title;
  final String source;
  final String content;
  final String? sourceIcon;
  final BookmarkModel model;
  final VoidCallback onShare;
  final VoidCallback onReadLater;
  final VoidCallback onReadMore;
  final DateTime dateTime;

  const NewsDetailPage({
    super.key,
    required this.tag,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.source,
    required this.content,
    required this.sourceIcon,
    required this.model,
    required this.onShare,
    required this.onReadLater,
    required this.onReadMore,
    required this.dateTime
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);

    final bookmarkState = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarkState.bookmarks.any((b) => b.id == model.id);

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
                            errorWidget: (context, url, error) => Center(child: Icon(Icons.broken_image,size: 50,color: Colors.red,)),
                            placeholder: (context, url) => AppLoader.mainLoader(50)
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: sourceIcon != null
                                      ? NetworkImage(sourceIcon!)
                                      : const NetworkImage('https://www.svgrepo.com/show/508699/landscape-placeholder.svg'),
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
                    ),
                  ),
                ),

                Positioned(
                  top: 330.h,
                  right: 82.w,
                  child: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    radius: 22,
                    child: IconButton(
                      onPressed: () async {
                        final notifier = ref.read(bookmarkProvider.notifier);
                        if (isBookmarked) {
                          await notifier.removeBookmark(model.id);
                          ToastMsg.errorToast(message: 'Removed From Bookmark', context: context);
                        } else {
                          await notifier.addToBookmark(model);
                          ToastMsg.successToast(message: 'Added To Bookmark', context: context);
                        }
                      },
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                      ),
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
                      icon: const Icon(Icons.share_outlined, color: Colors.white),
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
