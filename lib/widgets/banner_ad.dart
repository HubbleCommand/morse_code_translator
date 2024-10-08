import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatelessWidget{
  final BannerAd myBanner;

  BannerAdWidget() :
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-7633712286971439/3516266468',
      size: AdSize.banner,  //AdSize.fullBanner
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.')
      ),
    );

  @override
  Widget build(BuildContext context){
    myBanner.load();
    
    AdWidget adWidget = AdWidget(ad: myBanner);
    
    return Container(
      alignment: Alignment.bottomCenter,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
  }
}
