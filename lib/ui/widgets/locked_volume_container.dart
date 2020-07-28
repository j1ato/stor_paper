import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:stor_paper/ui/widgets/volume_purchase_dialog.dart';

import 'info_button.dart';

// variation of volume container if the user hasn't purchased it

class LockedVolumeContainer extends StatefulWidget {
  const LockedVolumeContainer({
    this.imageUrl,
    this.volumeTitle,
    this.numberOfStories,
    this.stories,
    this.prodDetails,
    this.state,
  });

  final String imageUrl;
  final String volumeTitle;
  final String numberOfStories;
  final List<Map> stories;
  final ProductDetails prodDetails;
  final bool state;

  @override
  _LockedVolumeContainerState createState() => _LockedVolumeContainerState();
}

class _LockedVolumeContainerState extends State<LockedVolumeContainer> {
  @override
  Stack build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final containerHeight =
        widget.state ? 0.75 * screenHeight : 0.65 * screenHeight;
    final containerWidth =
        widget.state ? 0.92 * screenWidth : 0.9 * screenWidth;
    final double blur = widget.state ? 30 : 0;
    final double offset = widget.state ? 5 : 0;

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: CachedNetworkImage(
            placeholder: (context, placehldr) => Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                height: containerHeight,
                width: containerWidth,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutQuint,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            imageUrl: widget.imageUrl,
            imageBuilder: (context, imageProvider) {
              return Center(
                child: Container(
                  height: containerHeight,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[850].withOpacity(0.5),
                          blurRadius: blur,
                          offset: Offset(offset, offset))
                    ],
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
                            volumeTitle: widget.volumeTitle,
                            prod: widget.prodDetails,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        InfoButton(
          title: widget.volumeTitle,
          info: widget.numberOfStories,
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
