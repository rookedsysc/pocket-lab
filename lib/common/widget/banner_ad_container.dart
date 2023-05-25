import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pocket_lab/common/provider/payment_status_provider.dart';

class BannerAdContainer extends ConsumerStatefulWidget {
  final String adUnitId;
  BannerAdContainer({required this.adUnitId, super.key});

  @override
  ConsumerState<BannerAdContainer> createState() => _BannerAdContainerState();
}

class _BannerAdContainerState extends ConsumerState<BannerAdContainer> {
  late final BannerAd _myBanner;
  late final BannerAdListener _listener;
  late final _adWidget;

  @override
  void initState() {
    _initializeListener();
    _initializeBanner();
    _initializeAdWidget();

    super.initState();
  }

  @override
  void dispose() {
    _myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(paymentStatusProvider)) {
      return SizedBox();
    }
    return Container(
      alignment: Alignment.center,
      child: _adWidget,
      width: _myBanner.size.width.toDouble(),
      height: _myBanner.size.height.toDouble(),
    );
  }

  void _initializeListener() {
    _listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );
  }

  void _initializeBanner() {
    _myBanner = BannerAd(
      adUnitId: widget.adUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: _listener,
    );
    _myBanner.load();
  }

  void _initializeAdWidget() {
    _adWidget = AdWidget(ad: _myBanner);
  }
}
