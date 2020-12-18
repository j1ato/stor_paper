import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/providers/controller_states.dart';
import 'package:stor_paper/ui/screens/volume_screens/stories.dart';
import '../../theme.dart';
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
  double opacityLevel = 0.0;

  void _changeOpacity() {
    setState(() {
      opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;
    });
  }

  @override
  CachedNetworkImage build(BuildContext context) {

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
          borderRadius: BorderRadius.circular(30),
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      imageUrl: widget.imageUrl,
      imageBuilder: (context, imageProvider) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return StoriesScreen(
                    key: PageStorageKey(widget.volumeTitle),
                    stories: widget.stories,
                    volumeTitle: widget.volumeTitle,
                  );
                },
              ),
            );
          },
          child: Hero(
            tag: widget.volumeTitle,
            child: AnimatedContainer(
              height: containerHeight,
              width: containerWidth,
              duration: const Duration(milliseconds: 450),
              curve: Curves.decelerate,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[850].withOpacity(0.3),
                      blurRadius: blur,
                      offset: Offset(offset, offset))
                ],
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: AnimatedOpacity(
                      curve: Curves.linear,
                      opacity: opacityLevel,
                      duration: Duration(milliseconds: 500),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: containerHeight,
                          width: containerWidth,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.9),
                              )
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: AnimatedOpacity(
                      curve: Curves.linear,
                      opacity: opacityLevel,
                      duration: Duration(
                          milliseconds: opacityLevel == 0 ? 500 : 800),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.numberOfStories,
                                  style: buildTheme().textTheme.bodyText2),
                            ]),
                      ),
                    ),
                  ),
                  InfoButton(
                    title: widget.volumeTitle,
                    info: widget.numberOfStories,
                    context: context,
                    onPressed: () => _changeOpacity(),
                  ),
                  ExpandButton(
                    imageURL: widget.imageUrl,
                    volumeTitle: widget.volumeTitle,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
