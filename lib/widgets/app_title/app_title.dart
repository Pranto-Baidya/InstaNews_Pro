import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTitle extends StatelessWidget {
  final ThemeData theme;
  final TextStyle textStyleFirst;
  final TextStyle textStyleSecond;
  final TextStyle? textStyleThird;
  final double? width;
  final double? cWidth;
  final double? cHeight;
  final Offset? offset;

  const AppTitle({super.key, required this.theme, required this.textStyleFirst, required this.textStyleSecond, this.width, this.cWidth, this.cHeight, this.textStyleThird, this.offset});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: width),
        RichText(
          text: TextSpan(
              text: 'Insta',
              style: textStyleFirst,
              children: [
                TextSpan(
                    text: 'News',
                    style: textStyleSecond
                ),
                WidgetSpan(
                    child: Transform.translate(
                      offset: offset?? Offset(3, -18) ,
                      child: Container(
                          width: cWidth??50.h,
                          height: cHeight??30.h,
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: theme.colorScheme.primary,width: 2,),
                                right: BorderSide(color: theme.colorScheme.primary,width: 2),
                                left: BorderSide(color: theme.colorScheme.primary,width: 2),
                                bottom: BorderSide(color: theme.colorScheme.primary,width: 2),),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Center(child: Text('PRO',style: textStyleThird??theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),textScaler: TextScaler.linear(1),))
                      ),
                    )
                ),
              ]
          ),
        ),
      ],
    );
  }
}