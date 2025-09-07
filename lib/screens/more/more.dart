import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/riverpod/settings_riverpod/settings_riverpod.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/utils/app_colors.dart';
import 'package:instanews_pro/widgets/toast_msg/toast_msg.dart';

class More extends ConsumerWidget {
  const More({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeNotifierProvider);

    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    final showWeather = ref.watch(showWeatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 70.h,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark? Brightness.light:Brightness.dark,
            systemNavigationBarColor: isDark ? Color(0xFF121212) : Color(0xFFFFFFFF)
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _sectionHeader(theme, Icons.tune, "General"),
            SizedBox(height: 20.h),
            _settingsCard(
              context,
              items: [
                ListTile(
                  title: const Text("Dark Mode"),
                  leading: Icon(Icons.dark_mode_outlined,color: theme.iconTheme.color,),
                  trailing: Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      ref.read(themeNotifierProvider.notifier).toggleTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Notifications"),
                  leading: Icon(Icons.notifications_none,color: theme.iconTheme.color,),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {

                    },
                  ),
                ),
                ListTile(
                  title: const Text("Show Weather"),
                  leading: Icon(Icons.wb_sunny_outlined,color: theme.iconTheme.color,),
                  trailing: Switch(
                    value: showWeather,
                    onChanged: (value) {
                      ref.read(showWeatherProvider.notifier).saveWeather(value);
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.h),

            _sectionHeader(theme, Icons.read_more_sharp, "Other"),
            SizedBox(height: 20.h),
            _settingsCard(
              context,
              items: [
                ListTile(
                  title: const Text("About Developer"),
                  leading: Icon(Icons.person_outline_outlined,color: theme.iconTheme.color,),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ToastMsg.successToast(
                      message: "Tapped About Developer",
                      context: context,
                    );
                  },
                ),
                ListTile(
                  title: const Text("Source Code"),
                  leading: Icon(Icons.code,color: theme.iconTheme.color,),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ToastMsg.successToast(
                      message: "Tapped Source Code",
                      context: context,
                    );
                  },
                ),
                ListTile(
                  title: const Text("Share App"),
                  leading: Icon(Icons.share_outlined,color: theme.iconTheme.color,),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ToastMsg.successToast(
                      message: "Tapped Exit App",
                      context: context,
                    );
                  },
                ),
                ListTile(
                  title: const Text("Exit App"),
                  leading: Icon(Icons.power_settings_new_outlined,color: theme.iconTheme.color,),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ToastMsg.successToast(
                      message: "Tapped Exit App",
                      context: context,
                    );
                  },
                ),
                
              ],
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(ThemeData theme, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: theme.iconTheme.color),
        SizedBox(width: 10.w),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _settingsCard(BuildContext context, {required List<Widget> items}) {
    var theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(15),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => items[index],
        separatorBuilder: (context, index) => Divider(
          thickness: 0.5,
          color: AppColors.hintTextColor.withOpacity(0.5),
        ),
        itemCount: items.length,
      ),
    );
  }
}
