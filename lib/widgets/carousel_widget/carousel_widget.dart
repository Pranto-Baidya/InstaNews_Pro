
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../screens/home/home.dart';
import '../../utils/app_colors.dart';

class CarouselWidget extends StatelessWidget {
  final ThemeData theme;
  final WidgetRef ref;
  final String title;
  final String chipTitle;
  final String imageUrl;
  final VoidCallback onPressed;
  final VoidCallback onBookmarkTap;
  final VoidCallback onReadLaterTap;
  final VoidCallback onShareTap;
  final Color iconColor;
  final bool? isBookmarked;

  const CarouselWidget({
    super.key,
    required this.theme,
    required this.ref,
    required this.title,
    required this.chipTitle,
    required this.imageUrl,
    required this.onPressed,
    required this.onBookmarkTap,
    required this.onReadLaterTap,
    required this.onShareTap,
    required this.iconColor,
    this.isBookmarked,
  });


  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: 5,
        itemBuilder: (context,index,_){
          return Container(
            width: 250.w,
            height: 200.h,
            decoration: BoxDecoration(
                color: theme.appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(15.r)
            ),
            child: Stack(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(15.r),topLeft: Radius.circular(15.r)),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 250.w,
                        height: 130.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        bottom: 80.h,
                        left: 200.w,
                        right: 10,
                        child: GestureDetector(
                          onTap: onBookmarkTap,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Center(child: isBookmarked??false?
                            Icon(Icons.bookmark,color: theme.colorScheme.primary,) :Icon(Icons.bookmark_border,color: AppColors.lightTextPrimary,)),
                          ),
                        )
                    )
                  ],
                ),
                SizedBox(height: 10.h,),
                Positioned(
                  right: 10.w,
                  left: 10.w,
                  bottom: 20.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,style: theme.textTheme.titleMedium,maxLines: 2),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero,),
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
                          Chip(
                            padding: EdgeInsets.all(10),
                            side: BorderSide.none,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            label: Text(chipTitle,style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: onReadLaterTap,
                              icon: Icon(Icons.watch_later_outlined,color: iconColor)
                          ),
                          IconButton(
                              onPressed: onShareTap,
                              icon: Icon(Icons.share_outlined,color: iconColor)
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
        options: CarouselOptions(
            viewportFraction: 0.8,
            scrollPhysics: BouncingScrollPhysics(),
            autoPlay: true,
            height: 300.h,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            onPageChanged: (index,_){
              ref.read(indexProvider.notifier).state = index;
            }
        )
    );
  }
}