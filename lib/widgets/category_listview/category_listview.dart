import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../screens/home/home.dart';

class CategoryListview extends StatelessWidget {
  const CategoryListview({
    super.key,
    required this.fakeCategories,
    required this.isSelected,
    required this.ref,
    required this.theme,
  });

  final List<String> fakeCategories;
  final int isSelected;
  final WidgetRef ref;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: double.infinity.w,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: fakeCategories.length,
          itemBuilder: (context,index){
            final value = fakeCategories[index];
            final selected = isSelected==index;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: (){
                  ref.read(selectedProvider.notifier).state = index;
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selected? theme.colorScheme.primary:theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(child: Text(value,style: theme.textTheme.titleSmall?.copyWith(color: selected? Colors.white: theme.colorScheme.primary),)),
                ),
              ),
            );
          }
      ),
    );
  }
}