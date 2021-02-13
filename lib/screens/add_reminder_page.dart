import 'package:date_reminder/components/default_button2.dart';
import 'package:date_reminder/components/notification_time.dart';
import 'package:date_reminder/components/add_reminder_page_appbar.dart';
import 'package:date_reminder/components/select_date_widget.dart';
import 'package:date_reminder/models/advert_services.dart';
import 'package:date_reminder/models/constants.dart';
import 'package:date_reminder/models/database_helper.dart';
import 'package:date_reminder/models/localizations.dart';
import 'package:date_reminder/models/reminders_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smart_select/smart_select.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';

import 'main_menu.dart';

class AddReminderPage extends StatefulWidget {
  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DatabaseHelper databaseHelper = DatabaseHelper();

  // ignore: unused_field
  PhoneContact _phoneContact;

  String datePicked;

  DateTime dateTime;

  TimeOfDay notificationTime;

  bool getNotification = false;

  String name;
  TextEditingController _nameTextEditingController = TextEditingController();

  String phone;
  TextEditingController _phoneEditingController = TextEditingController();

  bool showWarningText = false;

  TextEditingController _giftIdeasEditingController = TextEditingController();
  String giftIdeas;

  String categorieValue = "brt";
  String timeValue = "1";

  final AdvertService _advertService = AdvertService();

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    // ignore: unused_local_variable
    DateTimePickerLocale locale = DateTimePickerLocale.en_us;

    if (myLocale.languageCode == "en") {
      locale = DateTimePickerLocale.en_us;
    } else if (myLocale.languageCode == "tr") {
      locale = DateTimePickerLocale.tr;
    } else if (myLocale.languageCode == "ru") {
      locale = DateTimePickerLocale.ru;
    }

    databaseHelper.initializeDatabase();
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    void pickDate() async {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        currentFocus.focusedChild.unfocus();
      }
      var date = await DatePicker.showSimpleDatePicker(context,
          initialDate: dateTime == null ? DateTime.now() : dateTime,
          firstDate: DateTime(1950),
          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
          dateFormat: "dd-MMMM-yyyy",
          titleText: AppLocalizations.of(context).translate("Select Date"),
          cancelText: AppLocalizations.of(context).translate("Cancel"),
          confirmText: AppLocalizations.of(context).translate("Ok"),
          locale: locale,
          looping: false,
          backgroundColor: themeIsLight ? Colors.white : Colors.black,
          textColor: themeIsLight ? Colors.black : Colors.white);
      setState(() {
        datePicked = "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        dateTime = date;
      });
    }

    // ignore: unused_local_variable
    String text = "";

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: reminderPageAppBar(context),
      body: ListView(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SmartSelect<String>.single(
                modalType: S2ModalType.popupDialog,
                modalTitle: AppLocalizations.of(context).translate('Select Category'),
                choiceStyle: S2ChoiceStyle(activeColor: kPrimaryColor, titleStyle: TextStyle(color: themeIsLight ? Colors.black : Colors.white)),
                title: AppLocalizations.of(context).translate('Reminder Category'),
                modalHeaderStyle: S2ModalHeaderStyle(
                  backgroundColor: themeIsLight ? Colors.white : Colors.black26,
                  textStyle: TextStyle(color: themeIsLight ? Colors.black : Colors.white),
                ),
                value: categorieValue,
                choiceItems: [
                  S2Choice<String>(value: 'brt', title: AppLocalizations.of(context).translate('Categories Birthday')),
                  S2Choice<String>(value: 'wed', title: AppLocalizations.of(context).translate('Categories Wedding')),
                  S2Choice<String>(value: 'fun', title: AppLocalizations.of(context).translate('Categories Death anniversary')),
                  S2Choice<String>(value: 'lov', title: AppLocalizations.of(context).translate('Categories Love')),
                  S2Choice<String>(value: 'oth', title: AppLocalizations.of(context).translate('Other')),
                ],
                onChange: (state) => setState(() => categorieValue = state.value),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                child: TextFormField(
                  maxLength: 22,
                  controller: _nameTextEditingController,
                  onChanged: (value) {
                    //if (value.length <= 24) {
                    setState(() {
                      name = value;
                    });
                    /*} else {
                      setState(() {
                        print(_nameTextEditingController.text);
                        _nameTextEditingController.text = name;
                      });
                    }*/
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    labelText: AppLocalizations.of(context).translate('Name or Topic'),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SelectDateWidget(datePicked: datePicked, method: pickDate, category: categorieValue),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                child: TextField(
                  controller: _phoneEditingController,
                  inputFormatters: [
                    PhoneInputFormatter(),
                  ],
                  maxLength: 12,
                  maxLengthEnforced: false,
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: AppLocalizations.of(context).translate("Phone Number with address code"),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      phone = value;
                    });
                  },
                ),
              ),
              categorieValue == "brt"
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                      child: TextFormField(
                        controller: _giftIdeasEditingController,
                        onChanged: (value) {
                          setState(() {
                            text = value;
                          });
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          labelText: AppLocalizations.of(context).translate("Gift Ideas"),
                          labelStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  : SizedBox(),
              Divider(),
              SwitchListTile(
                title: Text(
                  AppLocalizations.of(context).translate("Get Notifications"),
                  style: TextStyle(
                      color: getNotification
                          ? themeIsLight
                              ? Colors.black87
                              : Colors.white
                          : Colors.grey),
                ),
                value: getNotification,
                activeColor: kPrimaryColor,
                onChanged: (bool value) {
                  setState(() {
                    getNotification = value;
                  });
                },
              ),
              getNotification
                  ? Column(
                      children: [
                        SmartSelect<String>.single(
                          modalType: S2ModalType.popupDialog,
                          modalTitle: AppLocalizations.of(context).translate("Select Notification Day"),
                          choiceStyle:
                              S2ChoiceStyle(activeColor: kPrimaryColor, titleStyle: TextStyle(color: themeIsLight ? Colors.black : Colors.white)),
                          title: AppLocalizations.of(context).translate("Notification Day"),
                          modalHeaderStyle: S2ModalHeaderStyle(
                            backgroundColor: themeIsLight ? Colors.white : Colors.black,
                            textStyle: TextStyle(color: themeIsLight ? Colors.black : Colors.white),
                          ),
                          value: timeValue,
                          choiceItems: [
                            S2Choice<String>(value: '1', title: AppLocalizations.of(context).translate("1 day ago")),
                            S2Choice<String>(value: '2', title: AppLocalizations.of(context).translate("2 days ago")),
                            S2Choice<String>(value: '3', title: AppLocalizations.of(context).translate("3 days ago")),
                            S2Choice<String>(value: '4', title: AppLocalizations.of(context).translate("4 days ago")),
                            S2Choice<String>(value: '5', title: AppLocalizations.of(context).translate("5 days ago")),
                            S2Choice<String>(value: '6', title: AppLocalizations.of(context).translate("6 days ago")),
                            S2Choice<String>(value: '7', title: AppLocalizations.of(context).translate("7 days ago")),
                          ],
                          onChange: (state) => setState(() => timeValue = state.value),
                        ),
                        InkWell(
                          onTap: () async {
                            notificationTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: notificationTime == null ? 8 : notificationTime.hour,
                                minute: notificationTime == null ? 0 : notificationTime.minute,
                              ),
                            );
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(30),
                              vertical: ScreenUtil().setWidth(30),
                            ),
                            alignment: Alignment.centerLeft,
                            child: NotificationTime(notificationTime: notificationTime),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
          Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(50),),
              showWarningText
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context).translate("pleaseFill"),
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    )
                  : Container(),
              DefaultButton2(
                func: addFromContactMethod,
                buttonColor: themeIsLight ? Colors.grey[300] : Colors.grey[900],
                textColor: themeIsLight ? Colors.black : Colors.white,
                text: AppLocalizations.of(context).translate("Add from Contacts"),
              ),
              DefaultButton2(
                func: addReminder,
                buttonColor: kPrimaryColor,
                textColor: Colors.white,
                text: AppLocalizations.of(context).translate("Add the Reminder"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future addFromContactMethod() async {
    if (await FlutterContactPicker.hasPermission()) {
      final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
      print(contact);
      setState(() {
        _phoneContact = contact;
        _nameTextEditingController.text = contact.fullName;
        name = contact.fullName;
        if (contact.phoneNumber.toString().contains("+")) {
          _phoneEditingController.text = "+" + toNumericString(contact.phoneNumber.toString());
          phone = "+" + toNumericString(contact.phoneNumber.toString());
        } else {
          _phoneEditingController.text = toNumericString(contact.phoneNumber.toString());
          phone = toNumericString(contact.phoneNumber.toString());
        }
      });
    } else {
      await FlutterContactPicker.requestPermission();
      if (await FlutterContactPicker.hasPermission()) {
        final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
        print(contact);
        setState(() {
          _phoneContact = contact;
          _nameTextEditingController.text = contact.fullName;
          name = contact.fullName;
          if (contact.phoneNumber.toString().contains("+")) {
            _phoneEditingController.text = "+" + toNumericString(contact.phoneNumber.toString());
            phone = "+" + toNumericString(contact.phoneNumber.toString());
          } else {
            _phoneEditingController.text = toNumericString(contact.phoneNumber.toString());
            phone = toNumericString(contact.phoneNumber.toString());
          }
        });
      }
    }
  }

  Future addReminder() async {
    if (getNotification) {
      if (categorieValue != "" &&
          categorieValue != null &&
          _nameTextEditingController.text != "" &&
          _nameTextEditingController.text != null &&
          dateTime != null &&
          getNotification != null &&
          timeValue != "" &&
          timeValue != null &&
          notificationTime != null) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text(AppLocalizations.of(context).translate("Warning")),
                  content: new Text(AppLocalizations.of(context).translate("areYouSureAdd")),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(AppLocalizations.of(context).translate("Cancel"), style: TextStyle(color: kPrimaryColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(AppLocalizations.of(context).translate("Add"), style: TextStyle(color: kPrimaryColor)),
                      onPressed: () async {
                        await databaseHelper.addNewReminder(
                          Reminders(
                            categorieValue,
                            _nameTextEditingController.text,
                            dateTime.year,
                            dateTime.month,
                            dateTime.day,
                            phone,
                            "true",
                            int.parse(timeValue),
                            notificationTime.hour,
                            notificationTime.minute,
                            categorieValue == "brt" ? _giftIdeasEditingController.text : "",
                          ),
                        );
                        setState(() {
                          showWarningText = false;
                        });

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainMenu()));
                      },
                    )
                  ],
                ));
      } else {
        setState(() {
          showWarningText = true;
        });
      }
    } else {
      if (categorieValue != "" &&
          categorieValue != null &&
          _nameTextEditingController.text != "" &&
          _nameTextEditingController.text != null &&
          dateTime != null &&
          getNotification != null) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text(AppLocalizations.of(context).translate("Warning")),
                  content: new Text(AppLocalizations.of(context).translate("areYouSureAdd")),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(AppLocalizations.of(context).translate("Cancel"), style: TextStyle(color: kPrimaryColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(AppLocalizations.of(context).translate("Add"), style: TextStyle(color: kPrimaryColor)),
                      onPressed: () async {
                        await databaseHelper.addNewReminder(
                          Reminders(
                            categorieValue,
                            _nameTextEditingController.text,
                            dateTime.year,
                            dateTime.month,
                            dateTime.day,
                            phone,
                            "false",
                            0,
                            0,
                            0,
                            categorieValue == "brt" ? _giftIdeasEditingController.text : "x",
                          ),
                        );
                        setState(() {
                          showWarningText = false;
                        });
                        _advertService.showInterstitial();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => MainMenu()),
                        );
                      },
                    )
                  ],
                ));
      } else {
        setState(() {
          showWarningText = true;
        });
      }
    }
  }
}
