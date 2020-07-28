import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:stor_paper/ui/widgets/locked_volume_container.dart';
import 'package:stor_paper/ui/widgets/purchased_volume_container.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// widget that checks if user has purchased a volume via in app purchase
// and updates the ui accordingly, also allows new purchases

class VolumeCards extends StatefulWidget {
  const VolumeCards({
    this.volumeTitle,
    this.image,
    this.numberOfStories,
    this.stories,
    this.artworks,
    this.productID,
    this.controller,
    this.state,
  });

  final String volumeTitle;
  final String image;
  final String numberOfStories;
  final List<Map> stories;
  final Map artworks;
  final String productID;
  final PageController controller;
  final bool state;

  @override
  _VolumeCardsState createState() => _VolumeCardsState();
}

class _VolumeCardsState extends State<VolumeCards> {
  String productID;
  InAppPurchaseConnection _iap;
  bool _available = true;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription _subscription;

  @override
  void initState() {
    _iap = InAppPurchaseConnection.instance;
    productID = widget.productID;
    print('Product id: ${widget.productID}');
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  Future<void> _initialize() async {
    _available = await _iap.isAvailable();
    if (_available) {
      final List<Future> productInfoFutures = [
        _getProducts(),
        _getPastPurchases()
      ];
      await Future.wait(productInfoFutures);
      _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
            _purchases.addAll(data);
            _verifyPurchase();
          }));
    }
  }

  Future<void> _getProducts() async {
    final Set<String> ids = <String>{productID};
    ProductDetailsResponse response;

    await _iap.queryProductDetails(ids).then((responseResult) {
      if (responseResult.notFoundIDs.isNotEmpty) {
        print(responseResult.notFoundIDs);
      } else {
        response = responseResult;
      }
    }).catchError((onError) => print('Details response error: $onError'));
    setState(() {
      _products = response.productDetails;
    });
  }

  Future<void> _getPastPurchases() async {
    final QueryPurchaseDetailsResponse response =
        await _iap.queryPastPurchases();
    for (final PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        await _iap.completePurchase(purchase);
      }
      setState(() {
        _purchases = response.pastPurchases;
      });
    }
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  void _verifyPurchase() {
    final PurchaseDetails purchase = _hasPurchased(productID);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Text(
                'Thank you, your purchase was successful.',
                style: buildTheme().textTheme.bodyText2,
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          );
        },
      );
    } else if (purchase.status == PurchaseStatus.pending) {
      Center(
        child: SpinKitCircle(
          color: Colors.white.withOpacity(0.6),
        ),
      );
    } else if (purchase.status == PurchaseStatus.error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Text(
                'Purchase unsuccsessful',
                style: buildTheme().textTheme.bodyText2,
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget volumeContainer;

    if (_available != true) {
      return Center(
        child: SpinKitFadingCircle(
          color: Colors.white.withOpacity(0.6),
        ),
      );
    } else if (_products.isEmpty || _purchases.isEmpty) {
      return Center(
        child: SpinKitPulse(
          color: Colors.white.withOpacity(0.6),
        ),
      );
    } else {
      for (final ProductDetails prodDetails in _products) {
        if (_hasPurchased(prodDetails.id) != null) {
          volumeContainer = PurchasedVolumeContainer(
            imageUrl: widget.image,
            volumeTitle: widget.volumeTitle,
            numberOfStories: widget.numberOfStories,
            stories: widget.stories,
            state: widget.state,
          );
          
        } else {
          volumeContainer =  LockedVolumeContainer(
            imageUrl: widget.image,
            volumeTitle: widget.volumeTitle,
            numberOfStories: widget.numberOfStories,
            stories: widget.stories,
            prodDetails: prodDetails,
            state: widget.state,
          );
        }
      }
    }
    return volumeContainer;
  }
}
