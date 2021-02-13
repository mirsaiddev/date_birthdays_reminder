import 'package:date_reminder/models/database_helper.dart';
import 'package:workmanager/workmanager.dart';

// Arka planda calisacak task
void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    var db = DatabaseHelper();
    await db.openNotificationBarRu();
    return Future.value(true);
  });
}

class BackGroundProcessesRu {
  static final BackGroundProcessesRu _backGroundProcesses = BackGroundProcessesRu._initializeTasks();

  factory BackGroundProcessesRu() => _backGroundProcesses;

  BackGroundProcessesRu._initializeTasks() {
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
    print("[backgroundProcesses Russian] start...");
  }
}
