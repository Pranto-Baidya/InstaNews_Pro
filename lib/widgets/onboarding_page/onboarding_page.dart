import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_title/app_title.dart';

class BuildPage extends StatelessWidget {
  final ThemeData theme;
  final int? index;
  final String title;
  final String subTitle;
  final String image;
  const BuildPage({super.key, required this.theme, required this.title, this.index, required this.subTitle, required this.image,});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50.h,),
          index==0?
              Column(
                children: [
                  Text(title, style: theme.textTheme.displaySmall),
                  SizedBox(height: 20.w,),
                  Padding(
                    padding: EdgeInsets.only(left: 20.h),
                    child: AppTitle(
                      width: 0,
                      theme: theme,
                      textStyleFirst: theme.textTheme.headlineLarge!,
                      textStyleSecond: theme.textTheme.headlineLarge!.copyWith(color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              )
              :Text(title, style: theme.textTheme.headlineMedium),
          SizedBox(height: 20.h,),
          Image.asset(image,width: 280.w,height: 280.h,),
          SizedBox(height: 20.h,),
          Text(subTitle,style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),)
        ],
      ),
    );
  }
}