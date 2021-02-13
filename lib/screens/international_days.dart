import 'dart:convert';
import 'package:date_reminder/components/international_days_card.dart';
import 'package:date_reminder/models/advert_services.dart';
import 'package:date_reminder/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

int adsCounter = 2;

class InternationalDaysPage extends StatefulWidget {
  const InternationalDaysPage({
    Key key,
  }) : super(key: key);

  @override
  _InternationalDaysPageState createState() => _InternationalDaysPageState();
}

class _InternationalDaysPageState extends State<InternationalDaysPage> {
  List<InternationalDayCard> internationalsWithSortList;
  final AdvertService _advertService = AdvertService();

  @override
  void initState() {
    super.initState();
    internationalsWithSortList = List<InternationalDayCard>();
    if (adsCounter % 3 == 0) {
      _advertService.showInterstitial();
    }
    adsCounter++;
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    // ignore: unused_local_variable
    String jsonString;
    if (myLocale.languageCode == "en") {
      jsonString = "json/international_days.json";
    } else if (myLocale.languageCode == "tr") {
      jsonString = "json/international_tr.json";
    } else if (myLocale.languageCode == "ru") {
      jsonString = "json/international_ru.json";
    }
    int maxContent = 52;
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString(jsonString),
        builder: (context, snapshot) {
          var mydata = json.decode(snapshot.data.toString());
          if (mydata == null) {
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(kPrimaryColor),
            ));
          } else {
            internationalsWithSortList = [];
            for (var i = 0; i < maxContent; i++) {
              bool datePassedThisYear = false;
              DateTime dateOfThisYear = DateTime(
                DateTime.now().year,
                int.parse(mydata["$i"]["date_month"]),
                int.parse(mydata["$i"]["date_day"]),
              );

              DateTime dateOfNextYear = DateTime(
                DateTime.now().year + 1,
                int.parse(mydata["$i"]["date_month"]),
                int.parse(mydata["$i"]["date_day"]),
              );

              if (dateOfThisYear.isAfter(DateTime.now())) {
                datePassedThisYear = false;
              } else {
                datePassedThisYear = true;
              }
              //if (internationalsWithSortList.any((element) => element.name == mydata["$i"]["name"]))

              internationalsWithSortList.add(
                InternationalDayCard(
                  name: mydata["$i"]["name"],
                  color: mydata["$i"]["color"],
                  imageUrl: mydata["$i"]["image_link"],
                  dateText: "${mydata["$i"]["month_name"]} ${mydata["$i"]["date_day"]}",
                  daysLeft: datePassedThisYear ? dateOfNextYear.difference(DateTime.now()).inDays : dateOfThisYear.difference(DateTime.now()).inDays,
                ),
              );
            }
            internationalsWithSortList.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InternationalDayCard(
                  name: internationalsWithSortList[index].name,
                  color: internationalsWithSortList[index].color,
                  imageUrl: internationalsWithSortList[index].imageUrl,
                  dateText: internationalsWithSortList[index].dateText,
                  daysLeft: internationalsWithSortList[index].daysLeft,
                );
              },
              itemCount: maxContent,
            );
          }
        },
      ),
    );
  }
}
