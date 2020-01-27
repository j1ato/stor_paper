import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:stor_paper/ui/widgets/volume_purchase_dialog.dart';

import 'info_button.dart';

// variation of volume container if the user hasn't purchased it 

class LockedVolumeContainer extends StatelessWidget {
  const LockedVolumeContainer(
      {this.imageUrl,
      this.volumeTitle,
      this.numberOfStories,
      this.stories,
      this.prodDetails});

  final String imageUrl;
  final String volumeTitle;
  final String numberOfStories;
  final List<Map> stories;
  final ProductDetails prodDetails;

  @override
  Stack build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final containerHeight = 0.95 * screenHeight;
    final containerWidth = 0.98 * screenWidth;

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: CachedNetworkImage(
            placeholder: (context, placehldr) => Align(
              alignment: Alignment.center,
              child: Container(
                height: containerHeight,
                width: containerWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) {
              return Container(
                height: containerHeight,
                width: containerWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: imageProvider,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.8), BlendMode.darken),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    splashColor: Colors.white.withOpacity(0.2),
                    highlightColor: Colors.black.withOpacity(0.8),
                    onTap: () => showDialog<void>(
                      context: context,
                      builder: (context) {
                        return VolumePurchaseDialog(
                          volumeTitle: volumeTitle,
                          prod: prodDetails,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        InfoButton(
          title: volumeTitle,
          info: numberOfStories,
          context: context,
        ),
        Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.lock,
            size: 30,
            color: Colors.white.withOpacity(0.6),
          ),
        )
      ],
    );
  }
}
