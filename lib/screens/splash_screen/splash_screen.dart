
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/screens/onboarding/onboarding_screen.dart';
import 'package:instanews_pro/utils/app_colors.dart';

import '../../widgets/app_title/app_title.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Future.delayed(Duration(seconds: 3)).then((_){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OnboardingScreen()), (Route<dynamic>route)=>false);
      });
    });
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
           // statusBarBrightness: isDark? Brightness.light : Brightness.dark,
            statusBarColor: Colors.transparent,
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTitle(
              width: 20.w,
              theme: theme,
              textStyleFirst: theme.textTheme.displaySmall!,
              textStyleSecond: theme.textTheme.displaySmall!.copyWith(color: theme.colorScheme.primary),),
            SizedBox(height: 10.h,),
            Text('News From Around The World For You',style: theme.textTheme.titleMedium?.copyWith(color: AppColors.hintTextColor,fontWeight: FontWeight.w400),)
          ],
        ),
      ),
    );
  }
}


