import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/app_colors.dart';
import '../../widgets/carousel_widget/carousel_widget.dart';
import '../../widgets/category_listview/category_listview.dart';
import '../../widgets/short_news_tile/short_news_tile.dart';

final selectedProvider = StateProvider<int>((ref) => 0);
final indexProvider = StateProvider<int>((ref) => 0);

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  List<String> fakeCategories = [
    'All News',
    'Top Stories',
    'Politics',
    'Health & Wellness',
    'Sports',
    'Science & Technology',
    'International',
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final isSelected = ref.watch(selectedProvider);
    final index = ref.watch(indexProvider);

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Container(
              width: double.infinity.w,
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                color: AppColors.hintTextColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.search, color: AppColors.hintTextColor,),
                  SizedBox(width: 10.w),
                  Text(
                    'Search for any news...',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.hintTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.keyboard_voice,
                      color: AppColors.hintTextColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),
            CategoryListview(
              fakeCategories: fakeCategories,
              isSelected: isSelected,
              ref: ref,
              theme: theme,
            ),
            SizedBox(height: 25.h),
            CarouselWidget(theme: theme, ref: ref,
                title: 'Biden warns of 2020 US election interference',
                chipTitle: 'Top Stories',
                imageUrl: 'https://static.dw.com/image/53661398_605.jpg',
                onPressed: () {

                },
                onBookmarkTap: () {

                },
                onReadLaterTap: () {

                },
                onShareTap: () {

                },
                iconColor: theme.iconTheme.color!,
            ),
            SizedBox(height: 20.h),
            Center(child: _buildAnimatedSmoothIndicator(index, theme)),
            SizedBox(height: 20.h),
            _buildNewsTitleRow(theme, 'Latest News'),
            ShortNewsTile(
              onPressed: () {},
              onBookmarkTap: () {},
              onReadLaterTap: () {},
              onShareTap: () {},
              theme: theme,
              title:
                  "How, and at what cost, could Canada catch up to Poland's defence spending?",
              chipTitle: 'Politics',
              imageUrl:
                  'https://i.cbc.ca/ais/1d504e03-a2cf-49ff-aed7-aa10d81c9da0,1756123971636/full/max/0/default.jpg?im=Crop%2Crect%3D%280%2C0%2C1280%2C720%29%3B',
              iconColor: theme.iconTheme.color!,
            ),
            SizedBox(height: 20.h),
            _buildNewsTitleRow(theme, 'Trending News'),
            ShortNewsTile(
              onPressed: () {},
              onBookmarkTap: () {},
              onReadLaterTap: () {},
              onShareTap: () {},
              theme: theme,
              title:
                  'US makes it harder for SK Hynix, Samsung to make chips in China',
              chipTitle: 'Technology',
              imageUrl:
                  'https://images.indianexpress.com/2025/07/Tech-feature-images337.jpg',
              iconColor: theme.iconTheme.color!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsTitleRow(ThemeData theme, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
          child: Text(
            'View more',
            style: theme.textTheme.titleMedium
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedSmoothIndicator(int index, ThemeData theme) {
    return AnimatedSmoothIndicator(
      activeIndex: index,
      count: 5,
      effect: ExpandingDotsEffect(
        activeDotColor: theme.colorScheme.primary,
        dotColor: AppColors.lightTextPrimary,
        dotHeight: 10.h,
        dotWidth: 10.h,
      ),
    );
  }
}
