

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/screens/all_news/all_news.dart';
import 'package:instanews_pro/screens/splash_screen/splash_screen.dart';
import 'package:instanews_pro/theme_data.dart';
import 'package:toastification/toastification.dart';

main(){
  runApp(
      ProviderScope(
        child : const MyApp()
      ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,_){
        return ToastificationWrapper(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: theme,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}



