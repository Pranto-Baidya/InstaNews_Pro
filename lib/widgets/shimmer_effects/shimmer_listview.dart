
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListview extends ConsumerWidget {
  final double? height;
  final double? width;
  final double? horizontalPadding;
  const ShimmerListview({this.width, this.horizontalPadding, this.height, super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    bool isDark = ref.watch(themeNotifierProvider)==ThemeMode.dark;
    return Shimmer.fromColors(
        baseColor: isDark? Theme.of(context).cardColor:Colors.grey[300]!,
        highlightColor: isDark? Color(0xFF2C2C2C):Colors.grey[100]!,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding!=null? horizontalPadding!: 15.w, vertical: 8.h),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            height: height ?? 150.h,
            width: width,
          ),
        ),
    );
  }
}
