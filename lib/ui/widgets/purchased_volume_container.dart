import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stor_paper/ui/screens/stories.dart';

import 'collection_expand_button.dart';
import 'info_button.dart';

class PurchasedVolumeContainer extends StatefulWidget {
  const PurchasedVolumeContainer({
    this.imageUrl,
    this.volumeTitle,
    this.numberOfStories,
    this.stories,
    this.state,
  });

  final String imageUrl;
  final String volumeTitle;
  final String numberOfStories;
  final List<Map> stories;
  final bool state;

  @override
  _PurchasedVolumeContainerState createState() =>
      _PurchasedVolumeContainerState();
}

class _PurchasedVolumeContainerState extends State<PurchasedVolumeContainer> {
  @override
  CachedNetworkImage build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final containerHeight =
        widget.state ? 0.75 * screenHeight : 0.65 * screenHeight;
    final containerWidth =
        widget.state ? 0.92 * screenWidth : 0.9 * screenWidth;
    final double blur = widget.state ? 30 : 0;
    final double offset = widget.state ? 5 : 0;
    final imageState = widget.state
        ? null
        : const ColorFilter.mode(Color(0xF0454141), BlendMode.darken);

    return CachedNetworkImage(
      useOldImageOnUrlChange: true,
      placeholderFadeInDuration: const Duration(
        milliseconds: 500,
      ),
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
          child: Stack(
            children: [
              Hero(
                tag: widget.volumeTitle,
                child: AnimatedContainer(
                  height: containerHeight,
                  width: containerWidth,
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.decelerate,
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
                        fit: BoxFit.fill,
                        colorFilter: imageState),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      splashColor: Colors.white.withOpacity(0.2),
                      highlightColor: Colors.black.withOpacity(0.8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return StoriesScreen(
                              key: PageStorageKey(widget.volumeTitle),
                              stories: widget.stories,
                              volumeTitle: widget.volumeTitle,
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),
              ),
              InfoButton(
                title: widget.volumeTitle,
                info: widget.numberOfStories,
                context: context,
              ),
              ExpandButton(
                imageURL: widget.imageUrl,
                volumeTitle: widget.volumeTitle,
              )
            ],
          ),
        );
      },
    );
  }
}
