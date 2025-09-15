import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/riverpod/onboarding_pref_riverpod/onboarding_pref_riverpod.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/screens/all_news/all_news.dart';
import 'package:instanews_pro/utils/app_colors.dart';
import 'package:instanews_pro/widgets/app_button/app_button.dart';
import 'package:instanews_pro/widgets/app_title/app_title.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/onboarding_page/onboarding_page_widget.dart';

final isLastPageProvider = StateProvider<bool>((ref) => false);
final currentIndexProvider = StateProvider<int>((ref)=>0);

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(onboardingProvider.notifier).loadPref();
    });
    pageController = PageController();

  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    bool lastPage = ref.watch(isLastPageProvider);
    int currentIndex = ref.watch(currentIndexProvider);

    final onBoardingNotifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark? Brightness.light:Brightness.dark,
            systemNavigationBarColor: isDark ? Color(0xFF121212) : Color(0xFFFFFFFF)
        ),
        actions: [
          if (!lastPage)
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: () {
                  pageController.jumpToPage(4);
                },
                child: Text(
                  'Skip',
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 20,color: theme.colorScheme.primary),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 0),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  ref.read(isLastPageProvider.notifier).state = (index == 4);
                  ref.read(currentIndexProvider.notifier).state=index;
                },
                children: [
                  BuildPage(
                    theme: theme,
                    title: 'Welcome To The',
                    index: pageController.initialPage,
                    subTitle: 'Stay informed. anytime, anywhere.',
                    image: 'assets/news_one.png',
                  ),
                  BuildPage(
                      theme: theme,
                      title: 'Your Feed, Your Way',
                      subTitle: 'Read news according to your choice',
                      image: 'assets/news_second.png'
                  ),
                  BuildPage(
                      theme: theme,
                      title: 'Read Anywhere',
                      subTitle: 'Read articles even when offline.',
                      image: 'assets/news_third.png'
                  ),
                  BuildPage(
                      theme: theme,
                      title: 'Receive Notifications Daily',
                      subTitle: 'Never miss an update about latest news.',
                      image: 'assets/news_fourth.png'
                  ),
                  BuildPage(
                      theme: theme,
                      title: 'Simple & Beautiful',
                      subTitle: 'Clean UI for a smooth experience.',
                      image: 'assets/news_fifth.png'
                  ),
                ],
              ),
            ),
           SmoothPageIndicator(
               controller: pageController,
               count: 5,
               effect: ExpandingDotsEffect(
                 activeDotColor: theme.colorScheme.primary,
                 dotColor: AppColors.lightTextPrimary,
                 dotHeight: 10.h,
                 dotWidth: 10.h
               ),
           ), SizedBox(height: 40.h,),
      currentIndex == 0 ?
      Padding(
      padding: EdgeInsets.only(bottom: 60.h),
      child: AppButton(
        onPressed: () {
            pageController.nextPage(
              duration: Duration(milliseconds: 400),
              curve: Curves.decelerate,
             );
            },
        title: lastPage ? 'Explore Now' : 'Next',
      ),
    )
        : Padding(
        padding: EdgeInsets.only(bottom: 60.h),
          child: Column(
            children: [
              Row(
                children: [
              GestureDetector(
                onTap: () {
                  pageController.previousPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.decelerate,
                  );
                },
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    radius: 25,
                    child: Icon(Icons.arrow_back, color: Colors.white,size: 30,),
                  ),
                ),
              ),
              Spacer(),
              AppButton(
                onPressed: () {
                  if (lastPage) {
                    onBoardingNotifier.showOnboardingOneTime(true);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AllNews()),
                          (Route<dynamic> route) => false,
                    );
                  } else {
                    pageController.nextPage(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.decelerate,
                    );
                  }
                },
                title: lastPage ? 'Explore Now' : 'Next',
                width: 260.w,
              ),
                ],
              ),
            ],
          ),
        )
          ],
        ),
      ),
    );
  }
}


