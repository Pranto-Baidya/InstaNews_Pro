

import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instanews_pro/utils/app_colors.dart';

class AppLoader{
  static Widget mainLoader(double? size){
    return SpinKitFoldingCube(
      size: size ?? 45,
      color: AppColors.mainColor,
    );
  }
}