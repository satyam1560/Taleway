import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initialiseSettings(
      Future<void> Function(String? value) onPressed) async {
    if (!UniversalPlatform.isWeb) {
      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      const IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings();

      const MacOSInitializationSettings initializationSettingsMacOS =
          MacOSInitializationSettings();

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onPressed,
      );
    }
  }

  Future<void> showNotification({
    required String? title,
    required String? body,
    required String? payload,
  }) async {
    final id = Random().nextInt(100);
    print('This runs notification');
    var android = const AndroidNotificationDetails(
      'id',
      'channel ',
      //  'description',
      priority: Priority.high,
      importance: Importance.max,
    );
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
      id,
      title ?? 'Hello',
      body ?? 'You may have new notifications',
      platform,
      payload: payload,
    );
  }

  Future<void> sheduledNotification({
    required DateTime time,
    required String channelId,
    required String channelName,
    required String channelDescription,
    required int id,
    required String title,
    required String message,
  }) async {
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      message,
      tz.TZDateTime.from(time, tz.local),

      //  tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          // channelDescription,
          priority: Priority.high,
          importance: Importance.max,
        ),
        iOS: const IOSNotificationDetails(
          subtitle: 'Reminder',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = const BigPictureStyleInformation(
      DrawableResourceAndroidBitmap('chat_icon'),
      largeIcon: DrawableResourceAndroidBitmap('chat_icon'),
      contentTitle: 'flutter devs',
      summaryText: 'summaryText',
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        //  'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);
    await flutterLocalNotificationsPlugin.show(
      0,
      'big text title',
      'silent body',
      platformChannelSpecifics,
      payload: 'big image notifications',
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> showNotificationMediaStyle({
    required String? title,
    required String? body,
    required String? payload,
    required String mediaUrl,
  }) async {
    final String largeIconPath =
        await _downloadAndSaveFile(mediaUrl, 'largeIcon');
    final id = Random().nextInt(100);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      channelDescription: 'media channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: const MediaStyleInformation(),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: payload);
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
