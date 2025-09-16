import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/news_models/article_model/article_model.dart';
import 'package:instanews_pro/widgets/animated_container_widget/animatedContainerWidget.dart';

import '../app_loader/app_loader.dart';

class ShortNewsTile extends StatelessWidget {
  final int index;
  final ThemeData theme;
  final String title;
  final String chipTitle;
  final String? imageUrl;
  final VoidCallback onPressed;
  final ArticleModel? articleModel;

  const ShortNewsTile({
    super.key,
    this.articleModel,
    required this.index,
    required this.theme,
    required this.title,
    required this.chipTitle,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 20.w),
          child: AnimatedContainerWidget(
            index: index,
            offset: Offset(0, 0.5),
            child: Container(
              width: double.infinity,
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top: 5.h),
                      child: GestureDetector(
                        onTap: onPressed,
                        child: Hero(
                          tag: articleModel?.id ?? 'default-hero-tag',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl!=null? imageUrl! : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                              height: 130.h,
                              width: 130.w,
                              fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Center(child: Icon(Icons.broken_image,size: 50,color: Colors.red,)),
                                placeholder: (context, url) => AppLoader.mainLoader(50)
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 5.h,),
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
                          Padding(
                            padding: EdgeInsets.only(right: 5.w,bottom: 5.h),
                            child: Align(
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

  }
}
