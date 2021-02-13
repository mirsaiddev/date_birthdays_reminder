import 'package:date_reminder/models/database_helper.dart';
import 'package:workmanager/workmanager.dart';

// Arka planda calisacak task
void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    var db = DatabaseHelper();
    await db.openNotificationBarTr();
    return Future.value(true);
  });
}

class BackGroundProcessesTr {
  static final BackGroundProcessesTr _backGroundProcesses = BackGroundProcessesTr._initializeTasks();

  factory BackGroundProcessesTr() => _backGroundProcesses;

  BackGroundProcessesTr._initializeTasks() {
    Workmanager.cancelAll();
    Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    Workmanager.registerPeriodicTask(
      "1", // id
      "notificationsCheck", // task name
      frequency: Duration(minutes: 15),
    );
    print("[backgroundProcesses Turkish] start...");
  }
}
