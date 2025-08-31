import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/widgets/animated_container_widget/animatedContainerWidget.dart';

class ShortNewsTile extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final String chipTitle;
  final String imageUrl;
  final VoidCallback onPressed;
  final VoidCallback onBookmarkTap;
  final VoidCallback onReadLaterTap;
  final VoidCallback onShareTap;
  final Color iconColor;

  const ShortNewsTile({
    super.key,
    required this.theme,
    required this.title,
    required this.chipTitle,
    required this.imageUrl,
    required this.onPressed,
    required this.onReadLaterTap,
    required this.onShareTap, required this.onBookmarkTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return AnimatedContainerWidget(
          offset: Offset(0, 2),
          index: index,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      title,
                      maxLines: 2,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: onPressed,
                      child: Text(
                        'Read more...',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
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
                        Spacer(),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onBookmarkTap,
                          icon: Icon(
                            Icons.bookmark_border,
                            color: iconColor,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onReadLaterTap,
                          icon: Icon(
                            Icons.watch_later_outlined,
                            color: iconColor,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onShareTap,
                          icon: Icon(
                            Icons.share_outlined,
                            color: iconColor,
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: 10.h,),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
