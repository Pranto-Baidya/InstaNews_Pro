import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/news_models/article_model/article_model.dart';
import 'package:intl/intl.dart';
import '../../screens/home/home.dart';


class CarouselWidget extends StatelessWidget {
  final ThemeData theme;
  final WidgetRef ref;
  final List<ArticleModel> articles;
  final void Function(int index) onPressed;
  final Color iconColor;
  final bool? isBookmarked;

  const CarouselWidget({
    super.key,
    required this.theme,
    required this.ref,
    required this.articles,
    required this.iconColor,
    required this.onPressed,
    this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: CarouselSlider.builder(
        itemCount: articles.length,
        itemBuilder: (context, index, _) {
          final article = articles[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
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
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => onPressed(index),
              child: Hero(
                tag: 'breaking_${article.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: article.imageUrl,
                        fit: BoxFit.cover,
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
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(7.r),
                              ),
                              child: Text(
                                article.categories.take(1).map((i)=>i.toUpperCase()).join(''),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(article.sourceName,style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                SizedBox(width: 5.w,),
                                Icon(Icons.verified,color: theme.colorScheme.primary,size: 15,),
                              ],
                            ),
                            SizedBox(height: 5.h,),
                            Text('${article.dateTime != null ? DateFormat('dd/MM/yyyy hh:mm a').format(article.dateTime!): 'Unknown'}',
                              style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
                            ),
                            SizedBox(height: 5.h,),
                            Text(
                              article.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        options: CarouselOptions(
          autoPlayCurve: Curves.decelerate,
          clipBehavior: Clip.none,
          viewportFraction: 1,
          scrollPhysics: const BouncingScrollPhysics(),
          autoPlay: true,
          height: 200.h,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          onPageChanged: (index, _) {
            ref.read(indexProvider.notifier).state = index;
          },
        ),
      ),
    );
  }
}
