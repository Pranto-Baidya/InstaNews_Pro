
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService{

  static final localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> initNotification()async{

    tz.initializeTimeZones();
    final String currentTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimezone));

   AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

   InitializationSettings initializationSettings = InitializationSettings(
     android: androidInitializationSettings
   );

   await localNotifications.initialize(initializationSettings);

  }

  static Future<void> requestPermission()async{
    localNotifications.resolvePlatformSpecificImplementation
    <AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
        'news_reminder',
        'InstaNews',
        channelDescription: 'InstaNews is an online newspaper application, developed by Pranto',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
    )
  );

  static Future<void> instantNotification()async{
    await localNotifications.show(
        0,
        'InstaNews Reminder',
        'You can now set up news remainders',
        notificationDetails,
    );
  }

  static Future<void> showNotificationAt({
    required int id,
    required String title,
    required String description,
    required DateTime date,
    required TimeOfDay time
  })async{

    var scheduledDate = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute
    );
    
    if(scheduledDate.isBefore(tz.TZDateTime.now(tz.local))){
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    await localNotifications.zonedSchedule(
        id,
        title,
        description,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle
    );

  }

  static Future<void> cancelAllNotifications()async{
    localNotifications.cancelAll();
  }

}