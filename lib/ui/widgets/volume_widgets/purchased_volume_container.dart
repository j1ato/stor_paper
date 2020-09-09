import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/providers/controller_states.dart';
import 'package:stor_paper/ui/screens/volume_screens/stories.dart';
import 'volume_expand_button.dart';
import '../shared_widgets/info_button.dart';

class PurchasedVolumeContainer extends StatefulWidget {
  const PurchasedVolumeContainer({
    this.imageUrl,
    this.volumeTitle,
    this.numberOfStories,
    this.stories,
    this.index,
    this.state,
  });

  final String imageUrl;
  final String volumeTitle;
  final String numberOfStories;
  final List<Map> stories;
  final int index;
  final bool state;

  @override
  _PurchasedVolumeContainerState createState() =>
      _PurchasedVolumeContainerState();
}

class _PurchasedVolumeContainerState extends State<PurchasedVolumeContainer> {
  @override
  CachedNetworkImage build(BuildContext context) {
    // double parallaxOffset =
    //     Provider.of<VolumeScreenState>(context).offset - widget.index;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final containerHeight =
        widget.state ? 0.7 * screenHeight : 0.65 * screenHeight;
    final containerWidth =
        widget.state ? 0.92 * screenWidth : 0.89 * screenWidth;
    final double blur = widget.state ? 5 : 0;
    final double offset = widget.state ? 2 : 0;

    return CachedNetworkImage(
      useOldImageOnUrlChange: true,
      placeholderFadeInDuration: const Duration(
        milliseconds: 500,
      ),
      placeholder: (context, placehldr) => AnimatedContainer(
        height: containerHeight,
        width: containerWidth,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutQuint,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      imageUrl: widget.imageUrl,
      imageBuilder: (context, imageProvider) {
        // print(parallaxOffset);
        return Stack(
          children: [
            Hero(
              tag: widget.volumeTitle,
              child: AnimatedContainer(
                height: containerHeight,
                width: containerWidth,
                duration: const Duration(milliseconds: 450),
                curve: Curves.decelerate,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[850].withOpacity(0.3),
                        blurRadius: blur,
                        offset: Offset(offset, offset))
                  ],
                  image: DecorationImage(
                    // alignment: Alignment(-parallaxOffset.abs(), 0),
                    image: imageProvider,
                    fit: BoxFit.cover,
                    // colorFilter: imageState
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    splashColor: Colors.white.withOpacity(0.05),
                    highlightColor: Colors.black.withOpacity(0.3),
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
        );
      },
    );
  }
}
