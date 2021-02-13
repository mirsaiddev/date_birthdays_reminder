import 'package:firebase_admob/firebase_admob.dart';

class AdvertService {
  static final AdvertService _instance = AdvertService._internal();
  factory AdvertService() => _instance;

  MobileAdTargetingInfo targettingInfo;

  AdvertService._internal() {
    targettingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>["test device id"],
    );
  }
  
  showInterstitial() {
    InterstitialAd interstitialAd = InterstitialAd(
      adUnitId: "your ad id",
      targetingInfo: targettingInfo,
    );

    interstitialAd
      ..load()
      ..show();

    interstitialAd.dispose();
  }
}
