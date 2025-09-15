// themes.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instanews_pro/utils/app_colors.dart';

/// Light Theme
ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.mainColor,
    secondary: AppColors.mainColor,
    surface: AppColors.lightSurface,
    background: AppColors.lightBackground,
    error: AppColors.lightError,
    onPrimary: Colors.white,
    onSecondary: AppColors.lightTextPrimary,
    onSurface: AppColors.lightTextPrimary,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    labelSmall: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 11, fontWeight: FontWeight.w700),
    labelMedium: GoogleFonts.lato(
        color: AppColors.lightTextSecondary, fontSize: 12, fontWeight: FontWeight.w700),
    labelLarge: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 14, fontWeight: FontWeight.w700),
    titleSmall: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 14, fontWeight: FontWeight.w700),
    titleMedium: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 16, fontWeight: FontWeight.w700),
    titleLarge: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 22, fontWeight: FontWeight.w700),
    displaySmall: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 36, fontWeight: FontWeight.w700),
    displayMedium: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 45, fontWeight: FontWeight.w700),
    displayLarge: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 57, fontWeight: FontWeight.w700),
    headlineSmall: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontWeight: FontWeight.w700),
    headlineMedium: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontWeight: FontWeight.w700),
    headlineLarge: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontWeight: FontWeight.w700),
    bodySmall: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 12, fontWeight: FontWeight.w700),
    bodyMedium: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 14, fontWeight: FontWeight.w700),
    bodyLarge: GoogleFonts.lato(
        color: AppColors.lightTextPrimary, fontSize: 16, fontWeight: FontWeight.w700),
  ),

  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: AppColors.lightTextPrimary, width: 2.w),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: AppColors.lightSurface,
    iconColor: AppColors.lightTextPrimary,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.mainColor),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightSurface,
    selectedItemColor: AppColors.mainColor,
    unselectedItemColor: AppColors.lightTextSecondary,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: AppColors.lightSurface,
    iconColor: AppColors.lightTextPrimary,
    textStyle: TextStyle(
        color: AppColors.lightTextPrimary, fontSize: 14.sp, fontWeight: FontWeight.bold),
  ),
  iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
  cardColor: AppColors.lightSurface,
  dialogTheme: DialogThemeData(
    titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary, fontSize: 28.sp, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(
        color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
    backgroundColor: AppColors.lightBackground,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.lightSurface,
    indicatorColor: AppColors.mainColor,
    surfaceTintColor: Colors.transparent,

  ),
  searchBarTheme: SearchBarThemeData(
    backgroundColor: WidgetStatePropertyAll(AppColors.lightSurface),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: AppColors.lightSurface,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide.none
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide.none
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide.none
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: AppColors.lightBackground,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.lightSurface,
    foregroundColor: AppColors.lightTextPrimary,
    scrolledUnderElevation: 0,
  ),
);

/// Dark Theme
ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: AppColors.mainColor,
    secondary: AppColors.mainColor,
    surface: AppColors.darkSurface,
    background: AppColors.darkBackground,
    error: AppColors.darkError,
    onPrimary: Colors.white,
    onSecondary: AppColors.darkTextPrimary,
    onSurface: AppColors.darkTextPrimary,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    foregroundColor: AppColors.darkTextPrimary,
    scrolledUnderElevation: 0,
  ),
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    labelSmall: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 11, fontWeight: FontWeight.w700),
    labelMedium: GoogleFonts.lato(
        color: AppColors.darkTextSecondary, fontSize: 12, fontWeight: FontWeight.w700),
    labelLarge: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 14, fontWeight: FontWeight.w700),
    titleSmall: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 14, fontWeight: FontWeight.w700),
    titleMedium: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 16, fontWeight: FontWeight.w700),
    titleLarge: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 22, fontWeight: FontWeight.w700),
    displaySmall: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 36, fontWeight: FontWeight.w700),
    displayMedium: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 45, fontWeight: FontWeight.w700),
    displayLarge: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 57, fontWeight: FontWeight.w700),
    headlineSmall: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontWeight: FontWeight.w700),
    headlineMedium: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontWeight: FontWeight.w700),
    headlineLarge: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontWeight: FontWeight.w700),
    bodySmall: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 12, fontWeight: FontWeight.w700),
    bodyMedium: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 14, fontWeight: FontWeight.w700),
    bodyLarge: GoogleFonts.lato(
        color: AppColors.darkTextPrimary, fontSize: 16, fontWeight: FontWeight.w700),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: AppColors.darkBackground,
  ),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: AppColors.darkTextPrimary, width: 2.w),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: AppColors.darkSurface,
    iconColor: AppColors.darkTextPrimary,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.mainColor),
  popupMenuTheme: PopupMenuThemeData(
    color: AppColors.darkSurface,
    iconColor: AppColors.darkTextPrimary,
    textStyle: TextStyle(
        color: AppColors.darkTextPrimary, fontSize: 14.sp, fontWeight: FontWeight.bold),
  ),
  iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
  cardColor: AppColors.darkSurface,
  dialogTheme: DialogThemeData(
    titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary, fontSize: 28.sp, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(
        color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
    backgroundColor: AppColors.darkSurface,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    selectedItemColor: AppColors.mainColor,
    unselectedItemColor: AppColors.darkTextSecondary,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    indicatorColor: AppColors.mainColor,
    surfaceTintColor: Colors.transparent,
    elevation: 1
  ),
  searchBarTheme: SearchBarThemeData(
    backgroundColor: WidgetStatePropertyAll(AppColors.darkSurface),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: AppColors.darkSurface,
    filled: true,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide.none
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide.none
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide.none
    ),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.darkSurface),
    ),
  ),
);
