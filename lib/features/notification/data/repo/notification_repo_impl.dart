import '../../../../core/di/injection_container.dart' as di;
import '/core/utils/constants.dart';
import '/core/utils/helper.dart';

import '../../../../core/utils/services/notification_service.dart';

import '../models/notification_model.dart';
import 'notification_repo.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationRepoImpl extends NotificationRepo {
  final NotificationService _notificationService = di.sl<NotificationService>();

  @pragma('vm:entry-point')
  @override
  Future<void> makeNotification() async {
    List<DateTime> prayerDateTimes = Helper.getPrayerDateTimes();
    List<bool>? boolList = Helper.getBoolList();

    if (boolList == null) return;

    if (boolList[0]) {
      await _readingSurahAlKahfAndDoaaOnFriday(
        id: 0,
        hour: prayerDateTimes[2].hour,
        minute: prayerDateTimes[2].minute,
      );
    }

    // if (boolList[1]) {
    //   await _earlyJumaa();
    // }

    if (boolList[2]) {
      await _readingSurahAlKahfAndDoaaOnFriday(
        id: 1,
        duration: 1,
        hour: prayerDateTimes[4].hour,
        minute: prayerDateTimes[4].minute,
        title: "🤲 لا تنسَ الدعاء في آخر ساعة من يوم الجمعة",
        body: "🕋 ساعة استجابة، أكثر من الدعاء وتوجه إلى الله بقلب خاشع",
      );
    }

    if (boolList[3]) {
      await _prayerOnPromptMohamed();
    }

    if (boolList[4]) {
      await _rememebrDuhaPrayer(prayerDateTimes);
    }

    if (boolList[5]) {
      await _fastingMondayAndThursday(prayerDateTimes[5]);
    }

    // if (boolList[6]) {
    //   await _rememberNightPrayerTimes();
    // }

    if (boolList[7]) {
      await _rememberDoaaBeforIqmaaAndPrayerTimes(
        prayerDateTimes: prayerDateTimes,
        id: Constants.doaaBeforIqmaaID,
        title: Constants.doaaBeforIqmaaTitle,
        body: Constants.doaaBeforIgmaaBody,
      );
    }

    if (boolList[8]) {
      await _rememebrReadingQuranEveryDay(prayerDateTimes);
    }

    if (boolList[9]) {
      await _rememebrAzkarSubhAndMasaa(prayerDateTimes);
    }

    if (boolList[10]) {
      await _rememberDoaaBeforIqmaaAndPrayerTimes(
        prayerDateTimes: prayerDateTimes,
      );
    }
  }

  // reading surah al-kahf and doaa on friday
  @pragma('vm:entry-point')
  Future<void> _readingSurahAlKahfAndDoaaOnFriday({
    int? duration,
    required int hour,
    required int minute,
    String? title,
    String? body,
    required int id,
  }) async {
    DateTime currentTime = DateTime.now();
    DateTime nextFriday;

    if (currentTime.weekday == DateTime.friday) {
      nextFriday = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        duration != null ? hour - 1 : hour - 2,
        minute,
      );

      if (currentTime.isBefore(
        nextFriday.subtract(Duration(hours: duration ?? 2)),
      )) {
        await _readingAlKahfAndDoaaNotification(
          id: id,
          date: nextFriday,
          title: title,
          body: body,
        );
      }
    } else {
      int daysUntilNextFriday = (DateTime.friday - currentTime.weekday + 7) % 7;
      DateTime nextFridayDate = currentTime.add(
        Duration(days: daysUntilNextFriday),
      );
      nextFriday = DateTime(
        nextFridayDate.year,
        nextFridayDate.month,
        nextFridayDate.day,
        duration != null ? hour - 1 : hour - 2,
        duration != null ? 0 : 30,
      );

      await _readingAlKahfAndDoaaNotification(
        id: id,
        date: nextFriday,
        title: title,
        body: body,
      );
    }
  }

  Future<void> _readingAlKahfAndDoaaNotification({
    required DateTime date,
    String? title,
    String? body,
    required int id,
  }) async {
    await _notificationService.scheduledNotification(
      NotificationModel(
        id: id,
        title: title ?? "📖 لا تنسَ قراءة سورة الكهف",
        body:
            body ??
            "✨ يُستحب قراءة سورة الكهف يوم الجمعة، استمتع ببركاتها الآن 🕌",
        date: DateTime(date.year, date.month, date.day, date.hour, date.minute),
      ),
    );
  }

  // prayer on prompt mohamed (PBUH)
  @pragma('vm:entry-point')
  Future<void> _prayerOnPromptMohamed() async {
    for (int i = 0; i < Constants.prayerOnPromptMohamedID.length; i++) {
      await _notificationService.scheduledNotification(
        NotificationModel(
          id: Constants.prayerOnPromptMohamedID[i],
          title: "🌿 أكثر من الصلاة على النبي ﷺ",
          body:
              "🕌 اجعل لسانك رطبًا بذكره، فبها تُفرّج الهموم وتُرفع الدرجات 🤍",
          scheduledDate: tz.TZDateTime.now(tz.local).add(
            Duration(
              hours: Constants.prayerOnPromptMohamedTime[i],
              minutes: i == 7 ? 30 : 0,
            ),
          ),
        ),
      );
    }
  }

  // rememebr azkar subh and masaa
  @pragma('vm:entry-point')
  Future<void> _rememebrAzkarSubhAndMasaa(
    List<DateTime> prayerDateTimes,
  ) async {
    DateTime now = DateTime.now();
    DateTime azkarSubhTime = DateTime(
      prayerDateTimes[0].year,
      prayerDateTimes[0].month,
      prayerDateTimes[0].day,
      prayerDateTimes[0].hour,
      prayerDateTimes[0].minute + 30,
    );

    DateTime azkarMasaaTime = DateTime(
      prayerDateTimes[3].year,
      prayerDateTimes[3].month,
      prayerDateTimes[3].day,
      prayerDateTimes[3].hour,
      prayerDateTimes[3].minute + 30,
    );

    if (now.isAfter(azkarSubhTime)) {
      azkarSubhTime = azkarSubhTime.add(Duration(days: 1));
    }

    if (now.isAfter(azkarMasaaTime)) {
      azkarMasaaTime = azkarMasaaTime.add(Duration(days: 1));
    }

    await _azkarSubhAndMasaaNotification(
      azkarSubhTime: azkarSubhTime,
      azkarMasaaTime: azkarMasaaTime,
    );
  }

  Future<void> _azkarSubhAndMasaaNotification({
    required DateTime azkarSubhTime,
    required DateTime azkarMasaaTime,
  }) async {
    await _notificationService.scheduledNotification(
      NotificationModel(
        id: 3,
        title: "🌅 ابدأ يومك بذكر الله",
        body: "✨ أذكار الصباح حصن لك من كل شر، لا تفوّت الأجر والبركة",
        date: azkarSubhTime,
      ),
    );
    await _notificationService.scheduledNotification(
      NotificationModel(
        id: 4,
        title: "🌙 أنِر ليلك بذكر الله",
        body: "🤲 أذكار المساء تحفظك وتمنحك راحة القلب، لا تنسَها قبل النوم",
        date: azkarMasaaTime,
      ),
    );
  }

  // rememebr duha prayer
  @pragma('vm:entry-point')
  Future<void> _rememebrDuhaPrayer(List<DateTime> prayerDateTimes) async {
    DateTime now = DateTime.now();
    DateTime duhaPrayerTime = DateTime(
      prayerDateTimes[1].year,
      prayerDateTimes[1].month,
      prayerDateTimes[1].day,
      prayerDateTimes[1].hour + 2,
      prayerDateTimes[1].minute,
    );
    if (now.isAfter(duhaPrayerTime)) {
      duhaPrayerTime = duhaPrayerTime.add(Duration(days: 1));
    }
    await _notificationService.scheduledNotification(
      NotificationModel(
        id: 5,
        title: "☀️ لا تفوّت صلاة الضحى",
        body: "🕊️ ركعتان تساويان صدقة عن كل مفصل في جسدك، لا تحرم نفسك الأجر",
        date: duhaPrayerTime,
      ),
    );
  }

  // rememebr reading quran every day
  @pragma('vm:entry-point')
  Future<void> _rememebrReadingQuranEveryDay(
    List<DateTime> prayerDateTimes,
  ) async {
    DateTime now = DateTime.now();
    DateTime readingQuranTime = DateTime(
      prayerDateTimes[5].year,
      prayerDateTimes[5].month,
      prayerDateTimes[5].day,
      prayerDateTimes[5].hour,
      prayerDateTimes[5].minute + 30,
    );
    if (now.isAfter(readingQuranTime)) {
      readingQuranTime = readingQuranTime.add(Duration(days: 1));
    }

    await _notificationService.scheduledNotification(
      NotificationModel(
        id: 6,
        title: "📖 لا تنسَ وردك اليومي من القرآن",
        body: "✨ دقائق قليلة مع القرآن تملأ قلبك بالسكينة والطمأنينة",
        date: readingQuranTime,
      ),
    );
  }

  // // early jumaa
  // @pragma('vm:entry-point')
  // Future<void> _earlyJumaa() async {
  //   List<DateTime> earlyJumaa =
  //       _earlyJumaaRepo.getEarlyJumaa()['earlyJumaaTimes'];
  //
  //   int firstAvailableIndex =
  //       earlyJumaa.indexWhere((time) => time.isAfter(DateTime.now()));
  //   if (firstAvailableIndex == -1) return;
  //
  //   for (int i = firstAvailableIndex; i < earlyJumaa.length; i++) {
  //     DateTime earlyJumaaTime = earlyJumaa[i];
  //
  //     await _notificationService.scheduledNotification(NotificationModel(
  //         id: Constants.earlyJumaaID[i],
  //         title: "🕌 فضل التبكير لصلاة الجمعة",
  //         body: Constants.earlyJumaaBody[i],
  //         date: earlyJumaaTime));
  //   }
  // }

  // fasting monday and thursday
  @pragma('vm:entry-point')
  Future<void> _fastingMondayAndThursday(DateTime date) async {
    await _mondayAndThursdayNotification(
      id: 12,
      date: date,
      day: DateTime.sunday,
    );
    await _mondayAndThursdayNotification(
      id: 13,
      date: date,
      day: DateTime.wednesday,
      body:
          "🤍 غدًا يوم الخميس، فرصة للصيام ونيل الأجر العظيم! لا تنسَ نيتك 💫",
    );
  }

  Future<void> _mondayAndThursdayNotification({
    required DateTime date,
    required int day,
    required int id,
    String? body,
  }) async {
    DateTime currentTime = DateTime.now();
    DateTime nextDay;

    if (currentTime.weekday == day) {
      nextDay = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        date.hour + 1,
        date.minute,
      );

      if (currentTime.isBefore(nextDay)) {
        await _notificationService.scheduledNotification(
          NotificationModel(
            id: id,
            title: "🌙 تذكير بصيام غدًا",
            body:
                body ??
                "🤍 غدًا يوم الإثنين، فرصة للصيام ونيل الأجر العظيم! لا تنسَ نيتك 💫",
            date: nextDay,
          ),
        );
      }
    } else {
      int daysUntilNextFriday = (day - currentTime.weekday + 7) % 7;
      DateTime nextSundayDate = currentTime.add(
        Duration(days: daysUntilNextFriday),
      );
      nextDay = DateTime(
        nextSundayDate.year,
        nextSundayDate.month,
        nextSundayDate.day,
        date.hour + 1,
        date.minute,
      );

      await _notificationService.scheduledNotification(
        NotificationModel(
          id: id,
          title: "🌙 تذكير بصيام غدًا",
          body:
              body ??
              "🤍 غدًا يوم الإثنين، فرصة للصيام ونيل الأجر العظيم! لا تنسَ نيتك 💫",
          date: nextDay,
        ),
      );
    }
  }

  // remember prayer times
  @pragma('vm:entry-point')
  Future<void> _rememberDoaaBeforIqmaaAndPrayerTimes({
    required List<DateTime> prayerDateTimes,
    List<int>? id,
    List<String>? title,
    List<String>? body,
  }) async {
    DateTime now = DateTime.now();
    final nextDay = now.add(Duration(days: 1));

    final nextDayPrayerTimesStr = Helper.getPrayersList(dateTime: nextDay);

    List<DateTime> nextDayPrayerTimes = [];
    for (int i = 0; i < nextDayPrayerTimesStr.length; i++) {
      if (i == 5) continue;
      Helper.setDateTime(nextDayPrayerTimesStr[i], nextDayPrayerTimes, nextDay);
    }

    // final nextDayPrayerTimes = Helper.getPrayerDateTimes(dateTime: nextDay);

    List<Map<String, DateTime>> prayerTimes = [
      {"الفجر": prayerDateTimes[0]},
      {"الظهر": prayerDateTimes[2]},
      {"العصر": prayerDateTimes[3]},
      {"المغرب": prayerDateTimes[4]},
      {"العشاء": prayerDateTimes[5]},
      {"الفجر": nextDayPrayerTimes[0]},
      {"الظهر": nextDayPrayerTimes[2]},
      {"العصر": nextDayPrayerTimes[3]},
      {"المغرب": nextDayPrayerTimes[4]},
      {"العشاء": nextDayPrayerTimes[5]},
    ];
    int firstAvailableIndex = prayerTimes.indexWhere(
      (time) => time.entries.first.value.isAfter(now),
    );
    if (firstAvailableIndex == -1) return;

    for (int i = firstAvailableIndex; i < prayerTimes.length; i++) {
      DateTime prayerTime = prayerTimes[i].entries.first.value;
      await _notificationService.scheduledNotification(
        NotificationModel(
          id: id?[i] ?? Constants.prayerTimesID[i],
          title: title?[i] ?? Constants.prayerTimesTitle[i],
          body: body?[i] ?? Constants.prayerTimesBody[i],
          date: id != null ? prayerTime.add(Duration(minutes: 5)) : prayerTime,
        ),
      );
    }
  }

  // // remember night prayer times
  // @pragma('vm:entry-point')
  // Future<void> _rememberNightPrayerTimes() async {
  //   List<DateTime> prayerTimes =
  //       _nightPrayerRepo.getNightPrayerData()['nightPrayers'];
  //
  //   int firstAvailableIndex =
  //       prayerTimes.indexWhere((time) => time.isAfter(DateTime.now()));
  //   if (firstAvailableIndex == -1) return;
  //
  //   for (int i = firstAvailableIndex; i < prayerTimes.length; i++) {
  //     await _notificationService.scheduledNotification(NotificationModel(
  //       id: Constants.nightPrayersID[i],
  //       title: Constants.nightPrayersTitle[i],
  //       body: Constants.nightPrayersBody[i],
  //       date: prayerTimes[i],
  //     ));
  //   }
  // }
}
