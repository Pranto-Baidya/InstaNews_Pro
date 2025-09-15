import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../riverpod/weather_riverpod/weather_riverpod.dart';
import '../app_loader/app_loader.dart';
import '../app_title/app_title.dart';

class WeatherLite extends StatelessWidget {
  const WeatherLite({
    super.key,
    required this.theme,
    required this.weatherState,
  });

  final ThemeData theme;
  final WeatherState weatherState;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  showDragHandle: true,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        width: double.infinity.w,
                        height: 650.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Weather Lite By - ',
                                    style: theme.textTheme.titleLarge,
                                  ),
                                  SizedBox(width: 2.w),
                                  AppTitle(
                                    width: 0,
                                    theme: theme,
                                    textStyleFirst:
                                        theme.textTheme.headlineSmall!,
                                    textStyleSecond: theme
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          color: theme.colorScheme.primary,
                                        ),
                                    textStyleThird: theme.textTheme.titleSmall
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                        ),
                                    cWidth: 40.w,
                                    cHeight: 22.h,
                                    offset: Offset(3.w, -12.h),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: buildTodayWeatherListView(),
                            ),
                            SizedBox(height: 30.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                'Next 3 Days Weather Forecast',
                                style: theme.textTheme.titleLarge,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Expanded(child: buildForecastListView()),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: 100.w,
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: weatherState.isLoading
                    ? Center(child: AppLoader.mainLoader(25))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weatherState.weather != null
                                ? "${weatherState.weather!.tempC.toStringAsFixed(0)}°C"
                                : '',
                            style: theme.textTheme.titleSmall,
                          ),
                          SizedBox(width: 10.w),
                          AvatarGlow(
                            repeat: false,
                            duration: const Duration(seconds: 5),
                            glowRadiusFactor: 0.5,
                            glowColor: theme.colorScheme.primary,
                            glowCount: 2,
                            child: CachedNetworkImage(
                              imageUrl: weatherState.weather != null
                                  ? weatherState.weather!.icon
                                  : '',
                              fit: BoxFit.cover,
                              width: 30.w,
                              height: 30.h,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildTodayWeatherListView() {
    return ListView.builder(
      itemCount: 1,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          width: double.infinity.w,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12.r),
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
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      weatherState.weather != null
                          ? '${weatherState.weather!.tempC.toStringAsFixed(0)} °'
                          : '',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    Spacer(),
                    CachedNetworkImage(
                      imageUrl: weatherState.weather != null
                          ? weatherState.weather!.icon
                          : '',
                      fit: BoxFit.cover,
                      width: 80.w,
                      height: 80.h,
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    Text(
                      weatherState.weather != null
                          ? weatherState.weather!.condition
                          : '',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text('Today', style: theme.textTheme.titleMedium),
                SizedBox(height: 10.h),
                Text(
                  weatherState.weather != null
                      ? 'Last Updated At : ${weatherState.weather!.lastUpdatedAt}'
                      : '',
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: 10.h),
                Text(
                  weatherState.weather != null
                      ? '${weatherState.weather!.name}, ${weatherState.weather!.country}'
                      : '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildForecastListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: weatherState.weather?.forecast?.forecastDay.length ?? 0,
      itemBuilder: (context, index) {
        final data = weatherState.weather!.forecast!.forecastDay[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Container(
            width: double.infinity.w,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12.r),
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
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CachedNetworkImage(
                      imageUrl: data.icon,
                      fit: BoxFit.cover,
                      width: 60.w,
                      height: 60.h,
                    ),
                    Flex(
                      direction: Axis.vertical,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       Padding(
                         padding: const EdgeInsets.only(right: 10),
                         child: Flexible(
                            child: Text(
                              data.condition,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                       ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text('Date :  ${data.date}'),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text('Precip :  ${data.totalPrecip} %'),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text('Chances Of Rain :  ${data.dailyChanceOfRain}%'),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    'Max / Min Temperature :  ${data.maxTemp} °C / ${data.minTemp} °C',
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
