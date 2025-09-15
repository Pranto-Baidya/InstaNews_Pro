import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instanews_pro/notification_service/notification_service.dart';
import 'package:instanews_pro/riverpod/notifications_riverpod/notification_prefs_riverpod.dart';
import 'package:instanews_pro/riverpod/theme_riverpod/theme_riverpod.dart';
import 'package:instanews_pro/utils/app_colors.dart';
import 'package:instanews_pro/widgets/toast_msg/toast_msg.dart';

import '../../riverpod/news_riverpod/news_riverpod.dart';
import '../../riverpod/show_weather_pref_riverpod/show_weather_pref_riverpod.dart';

final tempCountrySelectionProvider = StateProvider<List<String>>((ref) => []);
final tempLanguageSelectionProvider = StateProvider<List<String>>((ref) => []);

class More extends ConsumerWidget {
  const More({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final theme = Theme.of(context);

    final themeMode = ref.watch(themeNotifierProvider);

    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    final showWeather = ref.watch(showWeatherProvider);

    final notificationState = ref.watch(immediateNotificationProvider);

    final notificationNotifier = ref.read(immediateNotificationProvider.notifier);

    void restartAppDialogue(BuildContext context){
      final theme = Theme.of(context);
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              backgroundColor: theme.cardColor,
              title: Text('Please Wait!',style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),),
              content: Text('Please restart the app and refresh for once to see the new contents based on the changes made',style: theme.textTheme.titleMedium,),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('Okay',style: theme.textTheme.titleMedium,)
                )
              ],

            );
          }
      );
    }

    void showCountryDialogue(BuildContext context, WidgetRef ref) {
      final theme = Theme.of(context);

      List<String> availableCountries = ['us', 'bd', 'in', 'pk', 'gb'];
      List<String> fullCountryName = [
        '(United States)',
        '(Bangladesh)',
        '(India)',
        '(Pakistan)',
        '(United Kingdom)'
      ];

      Map<String, String> countries = {
        for (int i = 0; i < availableCountries.length; i++)
          availableCountries[i]: fullCountryName[i],
      };

      final currentSelection = ref.watch(newsNotifierProvider).countries;
      List<String> tempSelection = List.from(currentSelection);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select Countries',
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...countries.entries.map((country) {
                        final isSelected = tempSelection.contains(country.key);

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Checkbox(
                            fillColor: theme.checkboxTheme.fillColor,
                            checkColor: Colors.white,
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  tempSelection.add(country.key);
                                } else {
                                  tempSelection.remove(country.key);
                                }
                              });
                            },
                          ),
                          title: Text(
                            '${country.key} ${country.value}',
                            style: theme.textTheme.titleMedium,
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: theme.textTheme.titleSmall),
              ),
              TextButton(
                onPressed: () {
                  ref.read(newsNotifierProvider.notifier).saveCountries(tempSelection);

                  Navigator.pop(context);
                  restartAppDialogue(context);
                },
                child: Text('Done', style: theme.textTheme.titleSmall),
              ),
            ],
          );
        },
      );
    }

    void showLanguageDialogue(BuildContext context, WidgetRef ref) {
      final theme = Theme.of(context);

      List<String> availableLanguages = ['en', 'bn', 'hi'];
      List<String> fullLangName = ['(English)', '(Bengali)', '(Hindi)'];

      Map<String, String> languages = {
        for (int i = 0; i < availableLanguages.length; i++)
          availableLanguages[i]: fullLangName[i],
      };

      final currentSelection = ref.watch(newsNotifierProvider).languages;
      List<String> tempSelection = List.from(currentSelection);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select Languages',
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...languages.entries.map((lang) {

                        final isSelected = tempSelection.contains(lang.key);

                        return ListTile(
                          leading: Checkbox(
                            fillColor: theme.checkboxTheme.fillColor,
                            checkColor: Colors.white,
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  tempSelection.add(lang.key);
                                } else {
                                  tempSelection.remove(lang.key);
                                }
                              });
                            },
                          ),
                          title: Text(
                            '${lang.key} ${lang.value}',
                            style: theme.textTheme.titleMedium,
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: theme.textTheme.titleSmall),
              ),
              TextButton(
                onPressed: () {
                  ref.read(newsNotifierProvider.notifier).saveLanguages(tempSelection);

                  Navigator.pop(context);
                  restartAppDialogue(context);
                },
                child: Text('Done', style: theme.textTheme.titleSmall),
              ),
            ],
          );
        },
      );
    }


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
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _sectionHeader(theme, Icons.filter_list, "Filter News"),
            SizedBox(height: 20.h),
            _settingsCard(
                context, 
                items: [
                  ListTile(
                    onTap: (){
                      showCountryDialogue(context,ref);
                    },
                    leading: Icon(Icons.language,color: theme.iconTheme.color,),
                    title: const Text('Read News By Country',),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    onTap: (){
                      showLanguageDialogue(context, ref);
                    },
                    leading: Icon(Icons.translate,color: theme.iconTheme.color,),
                    title: const Text('Read News By Language',),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),

                ]
            ),
            SizedBox(height: 30.h),
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
                  title: const Text("Allow Remainders"),
                  leading: Icon(Icons.watch_later_outlined,color: theme.iconTheme.color,),
                  trailing: Switch(
                    value: notificationState,
                    onChanged: (value) {
                      if(value==true){
                        notificationNotifier.saveChoice(value);
                        NotificationService.instantNotification();
                      }
                      else{
                        NotificationService.cancelAllNotifications();
                        notificationNotifier.saveChoice(value);
                      }
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

            _sectionHeader(theme, Icons.info_outline, "Other"),
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
