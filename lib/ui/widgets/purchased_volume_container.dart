import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stor_paper/ui/screens/stories.dart';

import 'collection_expand_button.dart';
import 'info_button.dart';

class PurchasedVolumeContainer extends StatelessWidget {

  const PurchasedVolumeContainer({
    this.imageUrl,
    this.volumeTitle,
    this.numberOfStories,
    this.stories,
  });

  final String imageUrl;
  final String volumeTitle;
  final String numberOfStories;
  final List<Map> stories;

  @override
  CachedNetworkImage build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final containerHeight = 0.95 * screenHeight;
    final containerWidth = 0.98 * screenWidth;

    return CachedNetworkImage(
      useOldImageOnUrlChange: true,
      placeholderFadeInDuration: const Duration(
        milliseconds: 500,
      ),
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
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: 'collection wallpaper',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    height: containerHeight,
                    width: containerWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill),
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
                                key: PageStorageKey(volumeTitle),
                                volumeTitle: volumeTitle,
                                stories: stories,
                                // collection: widget.collection,
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InfoButton(
              title: volumeTitle,
              info: numberOfStories,
              context: context,
            ),
            ExpandButton(
              imageURL: imageUrl,
            )
          ],
        );
      },
    );
  }
}
