import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatelessWidget{
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.getSmartBanner(Orientation),
    request: AdRequest(),
    listener: AdListener(),
  );

  @override
  Widget build(BuildContext context){
    myBanner.load();
    
    AdWidget adWidget = AdWidget(ad: myBanner);
    
    return Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
  }
}
