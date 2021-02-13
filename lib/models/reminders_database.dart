class Reminders {
  String reminderCategory;
  String reminderName;
  int reminderDateYear;
  int reminderDateMonth;
  int reminderDateDay;
  String phoneNumber;
  String getNotifications;
  int notificationDay;
  int notificationHour;
  int notificationMinute;
  String giftIdeas;

  Reminders(
    this.reminderCategory,
    this.reminderName,
    this.reminderDateYear,
    this.reminderDateMonth,
    this.reminderDateDay,
    this.phoneNumber,
    this.getNotifications,
    this.notificationDay,
    this.notificationHour,
    this.notificationMinute,
    this.giftIdeas,
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["reminderCategory"] = reminderCategory;
    map["reminderName"] = reminderName;
    map["reminderDateYear"] = reminderDateYear;
    map["reminderDateMonth"] = reminderDateMonth;
    map["reminderDateDay"] = reminderDateDay;
    map["phoneNumber"] = phoneNumber;
    map["getNotifications"] = getNotifications;
    map["notificationDay"] = notificationDay;
    map["notificationHour"] = notificationHour;
    map["notificationMinute"] = notificationMinute;
    map["giftIdeas"] = giftIdeas;
    return map;
  }

  Reminders.fromMap(Map<dynamic, dynamic> map) {
    this.reminderCategory = map["reminderCategory"];
    this.reminderName = map["reminderName"];
    this.reminderDateDay = map["reminderDateDay"];
    this.reminderDateMonth = map["reminderDateMonth"];
    this.reminderDateYear = map["reminderDateYear"];
    this.phoneNumber = map["phoneNumber"];
    this.getNotifications = map["getNotifications"];
    this.notificationDay = map["notificationDay"];
    this.notificationHour = map["notificationHour"];
    this.notificationMinute = map["notificationMinute"];
    this.giftIdeas = map["giftIdeas"];
  }
}
