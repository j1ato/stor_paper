import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../theme.dart';

// dialog that shows up when a locked volume is tapped
// asking user if they would like to purchase and unlock volume

class VolumePurchaseDialog extends StatelessWidget {
  const VolumePurchaseDialog({@required this.volumeTitle, this.prod});
  final String volumeTitle;
  final ProductDetails prod;
  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

    void _buyProduct(ProductDetails prod) {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }

    return AlertDialog(
      elevation: 50,
      backgroundColor: const Color(0xF0111114).withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        height: 60,
        width: pageWidth * 0.7,
        child: Center(
          child: Text(
            'Would you like to purchase this collection?',
            style: buildTheme().textTheme.bodyText2,
          ),
        ),
      ),
      actions: <Widget>[
        RawMaterialButton(
          constraints: const BoxConstraints(minWidth: 60, minHeight: 30),
          onPressed: () {},
          child: Text(
            'NO',
            style: buildTheme().textTheme.button,
          ),
        ),
        RawMaterialButton(
          constraints: const BoxConstraints(minWidth: 60, minHeight: 30),
          onPressed: () {
            _buyProduct(prod);
            Navigator.pop(context);
          },
          child: Text(
            'YES',
            style: buildTheme().textTheme.button,
          ),
        ),
      ],
    );
  }
}
