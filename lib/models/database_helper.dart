import 'dart:async';
import 'package:date_reminder/models/reminders_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'constants.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  Database database;

  String remindersTable = "remindersTable";
  String reminderCategory = "reminderCategory";
  String reminderName = "reminderName";
  String reminderDateYear = "reminderDateYear";
  String reminderDateMonth = "reminderDateMonth";
  String reminderDateDay = "reminderDateDay";
  String phoneNumber = "phoneNumber";
  String getNotifications = "getNotifications";
  String notificationDay = "notificationDay";
  String notificationHour = "notificationHour";
  String notificationMinute = "notificationMinute";
  String giftIdeas = "giftIdeas";

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      print("databasehelper oluşturulacak");
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      print("databasehelper varmış, kullanılacak");
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (database == null) {
      database = await initializeDatabase();
      return database;
    } else {
      return database;
    }
  }

  initializeDatabase() async {
    Directory klasor = await getApplicationDocumentsDirectory();
    String dbPath = join(klasor.path, "reminders.db");
    var remindersDB = openDatabase(dbPath, version: 3, onCreate: _crateDB);
    return remindersDB;
  }

  FutureOr<void> _crateDB(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $remindersTable ($reminderCategory TEXT, $reminderName TEXT, $reminderDateYear INTEGER, $reminderDateMonth INTEGER, $reminderDateDay INTEGER, $phoneNumber TEXT, $getNotifications TEXT, $notificationDay INTEGER, $notificationHour INTEGER, $notificationMinute INTEGER, $giftIdeas TEXT)",
    );
  }

  Future<int> addNewReminder(Reminders reminder) async {
    var db = await _getDatabase();
    var sonuc = await db.insert(remindersTable, reminder.toMap());
    print("New Reminder Added, All = $sonuc");
    return sonuc;
  }

  Future<List<Reminders>> takeAllRemindersList() async {
    var allRemindersList = await takeAllReminders();
    var reminderList = List<Reminders>();
    for (Map map in allRemindersList) {
      reminderList.add(Reminders.fromMap(map));
    }
    return reminderList;
  }

  Future<List<Map<String, dynamic>>> takeAllReminders() async {
    var db = await _getDatabase();
    var sonuc = await db.query(remindersTable);
    return sonuc;
  }

  Future updateReminder(Reminders reminders, String name) async {
    var db = await _getDatabase();
    var sonuc = await db.update(remindersTable, reminders.toMap(), where: "$reminderName = ?", whereArgs: [name]);
    print("updated, $sonuc");
    return sonuc;
  }

  Future<int> deleteSingleReminder(String name) async {
    var db = await _getDatabase();
    var res = await db.delete("remindersTable", where: "reminderName = ?", whereArgs: [name]);
    print("deleted");
    return res;
  }

  Future<int> deleteAllTable() async {
    var db = await _getDatabase();
    var sonuc = await db.delete(remindersTable);
    return sonuc;
  }

  Future readSingleReminder(String name) async {
    var db = await _getDatabase();
    var res = await db.query("remindersTable", where: "reminderName = ?", whereArgs: [name]);
    return res;
  }

  Future<bool> openNotificationBar() async {
    print("[dataBaseHelper] [openNotificationBar] func working...");

    List<Reminders> remindersList = [];

    remindersList = await takeAllRemindersList();

    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();
    // ignore: unused_local_variable
    NotificationAppLaunchDetails notificationAppLaunchDetails;

    notificationAppLaunchDetails = await flip.getNotificationAppLaunchDetails();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon_eraser');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flip.initialize(initializationSettings);

    remindersList.forEach((reminder) {
      int howManyDaysAgo = reminder.notificationDay;
      int age;
      // ignore: unused_local_variable
      bool birthdayPassedThisYear = false;
      DateTime birthdayInThatYear = DateTime(
        DateTime.now().year,
        reminder.reminderDateMonth,
        reminder.reminderDateDay,
      );

      DateTime birthdayInNextYear = DateTime(
        DateTime.now().year + 1,
        reminder.reminderDateMonth,
        reminder.reminderDateDay,
      );

      DateTime notificationDay = birthdayInThatYear.subtract(Duration(days: howManyDaysAgo));

      DateTime dateOfToday = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      if (birthdayInThatYear.isAfter(DateTime.now())) {
        birthdayPassedThisYear = false;
      } else {
        birthdayPassedThisYear = true;
      }

      if (birthdayPassedThisYear) {
        age = DateTime.now().year - reminder.reminderDateYear;
      } else {
        age = DateTime.now().year - reminder.reminderDateYear - 1;
      }

      int howManyDaysLeft =
          birthdayPassedThisYear ? birthdayInNextYear.difference(DateTime.now()).inDays : birthdayInThatYear.difference(DateTime.now()).inDays;

      if (notificationDay == dateOfToday && DateTime.now().hour == reminder.notificationHour) {
        if (reminder.getNotifications == "true") {
          if (reminder.reminderCategory == "brt") {
            showNotification(
              flip,
              "You have an upcoming reminder",
              "${reminder.reminderName} turns ${age+1} in $howManyDaysLeft days",
              "birthday_e",
            );
          } else if (reminder.reminderCategory == "wed") {
            showNotification(
              flip,
              "You have an upcoming reminder",
              "${reminder.reminderName}'s wedding is in $howManyDaysLeft days",
              "wedding_e",
            );
          } else if (reminder.reminderCategory == "fun") {
            showNotification(
              flip,
              "You have an upcoming reminder",
              "${reminder.reminderName}'s death anniversary is in $howManyDaysLeft days",
              "funeral_e",
            );
          } else if (reminder.reminderCategory == "lov") {
            showNotification(
              flip,
              "You have an upcoming reminder",
              "Your anniversary with ${reminder.reminderName} is in $howManyDaysLeft days",
              "love_e",
            );
          } else if (reminder.reminderCategory == "oth") {
            showNotification(
              flip,
              "You have an upcoming reminder",
              "${reminder.reminderName} $howManyDaysLeft days",
              "other_e",
            );
          }
        }
      }
    });

    return true;
  }

  Future<bool> openNotificationBarRu() async {
    print("[dataBaseHelper] [openNotificationBar] func working...");

    List<Reminders> remindersList = [];

    remindersList = await takeAllRemindersList();

    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();
    // ignore: unused_local_variable
    NotificationAppLaunchDetails notificationAppLaunchDetails;

    notificationAppLaunchDetails = await flip.getNotificationAppLaunchDetails();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon_eraser');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flip.initialize(initializationSettings);

    remindersList.forEach((reminder) {
      int howManyDaysAgo = reminder.notificationDay;
      int age;
      // ignore: unused_local_variable
      bool birthdayPassedThisYear = false;
      DateTime birthdayInThatYear = DateTime(
        DateTime.now().year,
        reminder.reminderDateMonth,
        reminder.reminderDateDay,
      );

      DateTime birthdayInNextYear = DateTime(
        DateTime.now().year + 1,
        reminder.reminderDateMonth,
        reminder.reminderDateDay,
      );

      DateTime notificationDay = birthdayInThatYear.subtract(Duration(days: howManyDaysAgo));

      DateTime dateOfToday = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      if (birthdayInThatYear.isAfter(DateTime.now())) {
        birthdayPassedThisYear = false;
      } else {
        birthdayPassedThisYear = true;
      }

      if (birthdayPassedThisYear) {
        age = DateTime.now().year - reminder.reminderDateYear;
      } else {
        age = DateTime.now().year - reminder.reminderDateYear - 1;
      }

      int howManyDaysLeft =
          birthdayPassedThisYear ? birthdayInNextYear.difference(DateTime.now()).inDays : birthdayInThatYear.difference(DateTime.now()).inDays;

      if (notificationDay == dateOfToday && DateTime.now().hour == reminder.notificationHour) {
        if (reminder.getNotifications == "true") {
          if (reminder.reminderCategory == "brt") {
            showNotification(
              flip,
              "У вас есть предстоящее напоминание",
              "${reminder.reminderName} исполняется ${age+1} лет за $howManyDaysLeft дней",
              "birthday_e",
            );
          } else if (reminder.reminderCategory == "wed") {
            showNotification(
              flip,
              "У вас есть предстоящее напоминание",
              "свадьба ${reminder.reminderName} через $howManyDaysLeft дней",
              "wedding_e",
            );
          } else if (reminder.reminderCategory == "fun") {
            showNotification(
              flip,
              "У вас есть предстоящее напоминание",
              "годовщина смерти ${reminder.reminderName} через $howManyDaysLeft дней",
              "funeral_e",
            );
          } else if (reminder.reminderCategory == "lov") {
            showNotification(
              flip,
              "У вас есть предстоящее напоминание",
              "годовщина с ${reminder.reminderName} через $howManyDaysLeft дней",
              "love_e",
            );
          }else if (reminder.reminderCategory == "oth") {
            showNotification(
              flip,
              "У вас есть предстоящее напоминание",
              "${reminder.reminderName} через $howManyDaysLeft дней",
              "other_e",
            );
          }
        }
      }
    });

    return true;
  }

  Future<bool> openNotificationBarTr() async {
    print("[dataBaseHelper] [openNotificationBar] func working...");

    List<Reminders> remindersList = [];

    remindersList = await takeAllRemindersList();

    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();
    // ignore: unused_local_variable
    NotificationAppLaunchDetails notificationAppLaunchDetails;

    notificationAppLaunchDetails = await flip.getNotificationAppLaunchDetails();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon_eraser');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flip.initialize(initializationSettings);

    remindersList.forEach((reminder) {
      int howManyDaysAgo = reminder.notificationDay;
      int age;
      // ignore: unused_local_variable
      bool birthdayPassedThisYear = false;
      DateTime birthdayInThatYear = DateTime(
        DateTime.now().year,
        reminder.reminderDateMonth,
        reminder.reminderDateDay,
      );

      DateTime birthdayInNextYear = DateTime(
        DateTime.now().year + 1,
        reminder.reminderDateMonth,
        reminder.reminderDateDay,
      );

      DateTime notificationDay = birthdayInThatYear.subtract(Duration(days: howManyDaysAgo));

      DateTime dateOfToday = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      if (birthdayInThatYear.isAfter(DateTime.now())) {
        birthdayPassedThisYear = false;
      } else {
        birthdayPassedThisYear = true;
      }

      if (birthdayPassedThisYear) {
        age = DateTime.now().year - reminder.reminderDateYear;
      } else {
        age = DateTime.now().year - reminder.reminderDateYear - 1;
      }

      int howManyDaysLeft =
          birthdayPassedThisYear ? birthdayInNextYear.difference(DateTime.now()).inDays : birthdayInThatYear.difference(DateTime.now()).inDays == 0 ? 1 : birthdayInThatYear.difference(DateTime.now()).inDays;

      if (notificationDay == dateOfToday && DateTime.now().hour == reminder.notificationHour) {
        if (reminder.getNotifications == "true") {
          if (reminder.reminderCategory == "brt") {
            showNotification(
              flip,
              "Yeni bir yaklaşan hatırlatıcın var",
              "${reminder.reminderName} $howManyDaysLeft gün içinde ${age+1} yaşına girecek",
              "birthday_e",
            );
          } else if (reminder.reminderCategory == "wed") {
            showNotification(
              flip,
              "Yeni bir yaklaşan hatırlatıcın var",
              "$howManyDaysLeft gün içinde ${reminder.reminderName}'n evlilik yıldönümü var",
              "wedding_e",
            );
          } else if (reminder.reminderCategory == "fun") {
            showNotification(
              flip,
              "Yeni bir yaklaşan hatırlatıcın var",
              "$howManyDaysLeft gün içinde ${reminder.reminderName}'n ölüm yıldönümü var",
              "funeral_e",
            );
          } else if (reminder.reminderCategory == "lov") {
            showNotification(
              flip,
              "Yeni bir yaklaşan hatırlatıcın var",
              "$howManyDaysLeft gün içinde ${reminder.reminderName}' ile yıldönümün var",
              "love_e",
            );
          }else if (reminder.reminderCategory == "oth") {
            showNotification(
              flip,
              "Yeni bir yaklaşan hatırlatıcın var",
              "$howManyDaysLeft gün içinde ${reminder.reminderName}'",
              "other_e",
            );
          }
        }
      }
    });

    return true;
  }

  Future showNotification(FlutterLocalNotificationsPlugin flip, String title, String content, String image) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1', 'Reminder Notifications', 'Reminder Notifications',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        color: kPrimaryColor,
        largeIcon: DrawableResourceAndroidBitmap(image),
        icon: "app_icon_eraser",
        ongoing: false);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flip.show(
      0,
      title,
      content,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
