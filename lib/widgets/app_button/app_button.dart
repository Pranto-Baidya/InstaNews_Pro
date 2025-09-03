
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? width;
  const AppButton({super.key, required this.onPressed, required this.title, this.width});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          elevation: 0,
          minimumSize: Size(width??double.infinity.w, 55.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
          backgroundColor: theme.colorScheme.primary
        ),
        child: Text(title,style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),)
    );
  }
}
