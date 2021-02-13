import 'package:date_reminder/models/database_helper.dart';
import 'package:workmanager/workmanager.dart';

// Arka planda calisacak task
void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    var db = DatabaseHelper();
    await db.openNotificationBar();
    return Future.value(true);
  });
}

class BackGroundProcesses {
  static final BackGroundProcesses _backGroundProcesses = BackGroundProcesses._initializeTasks();

  factory BackGroundProcesses() => _backGroundProcesses;

  BackGroundProcesses._initializeTasks() {
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
    print("[backgroundProcesses English] start...");
  }
}
