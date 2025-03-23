import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:math';

class NotificationService {
  final List<String> titles = [
    '에모티와의 저녁 루틴 🌙',
    '오늘 하루 어땠나요? 😊',
    '에모티가 기다리고 있어요 💌',
    '나만의 감정 일기 시간 ✍️',
    '하루 정리할 시간이에요 📔',
    '마음을 적어볼까요? 💭',
    '오늘도 수고했어요 🍀',
    '감정을 기록해봐요 📒',
    '잠들기 전, 나를 돌아봐요 🌛',
    '하루 끝, 에모티와 함께 💫',
    '마음 산책 시간이에요 🐾',
    '작은 감정도 소중하게 🎈',
    '감정도 체크가 필요해요 🧸',
    '에모티가 보고 싶대요 🐰',
    '감정 온도 체크하러 가요 🌡️',
    '오늘의 기분은 어땠나요? 🌈',
    '에모티와 조용한 시간 가져요 🕯️',
    '하루 마무리, 같이 해요 ☕',
    '에모티와 이야기해요 📮',
    '마음을 쓰다듬는 시간 🍃',
  ];

  final List<String> bodies = [
    '오늘 감정은 어땠는지 돌아볼까요?',
    '마음 정리, 지금이 딱 좋아요!',
    '나만의 시간을 가져봐요 🌿',
    '에모티와 함께 감정을 기록해요.',
    '하루를 따뜻하게 마무리해봐요 ☁️',
    '기분을 살짝 적어보는 건 어때요?',
    '나를 위한 조용한 시간이에요 ⏳',
    '감정을 놓치지 말고 적어보세요 ✨',
    '마음 한 구석을 들여다보는 시간 🕊️',
    '오늘의 나, 잘 지냈는지 확인해요 🍎',
    '힘들었던 일도 가볍게 적어봐요 💌',
    '기쁜 일도 슬픈 일도 괜찮아요 🌷',
    '지금 기분을 솔직하게 남겨보세요 ✍️',
    '오늘 하루, 나에게 어떤 의미였나요?',
    '하루 정리, 에모티가 함께할게요 🐣',
    '감정에게도 휴식이 필요해요 🛌',
    '나의 감정, 그대로 괜찮아요 🍡',
    '작은 기분 변화도 소중해요 🎀',
    '마음을 조용히 마주해봐요 🐻',
    '지금 이 순간, 나를 이해해봐요 💫',
  ];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService() : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 타임존 데이터 초기화
    tz_data.initializeTimeZones();

    // Android용 초기화 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // iOS용 초기화 설정
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 전체 플랫폼 초기화 설정
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await _configureLocalTimeZone(); // 타임존 설정

  }

  // 타임존 설정 함수
  Future<void> _configureLocalTimeZone() async {
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> scheduleNotification(bool isOn) async {
    if (isOn) {
      final random = Random();
      final title = titles[random.nextInt(titles.length)];
      final body = bodies[random.nextInt(bodies.length)];

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );

      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      await _configureLocalTimeZone(); // 타임존을 다시 확인

      // 매일 22시(KST)에 알림 설정
      final now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        22,
        00,
      );

      // 이미 오늘 22시가 지난 경우, 내일로 설정
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }
}