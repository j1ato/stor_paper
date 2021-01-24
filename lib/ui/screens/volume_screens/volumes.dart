import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/model/database_models.dart';
import 'package:stor_paper/providers/controller_states.dart';
import 'package:stor_paper/ui/widgets/shared_widgets/responsive_screen_title.dart';
import 'package:stor_paper/ui/widgets/volume_widgets/volume_cards.dart';

// pageview that scrolls horizontally that displays cover art for
// a particular volume, user can swipe betweem volumes
// volumes consist of custom container widgets

class VolumesCardList extends StatefulWidget {
  const VolumesCardList({
    Key key,
  }) : super(key: key);
  static String id = 'collectionChooser';

  @override
  _VolumesCardListState createState() => _VolumesCardListState();
}

class _VolumesCardListState extends State<VolumesCardList> {
  int currentPage = 0;

  final PageController _controller = PageController(viewportFraction: 0.93);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final int nextPage = _controller.page.round();
      print("This is the next page: $nextPage");
      if (currentPage != nextPage) {
        setState(() {
          currentPage = nextPage;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final volumesList = Provider.of<List<Volume>>(context);
    final volumeState = Provider.of<VolumeScreenState>(context, listen: false);

    Volume currentVolume;

    return Stack(
      children: [
        if (volumeState.volumeTitle != null) ...[
          ResponsiveTitle(
            title: volumeState.volumeTitle,
          ),
        ],
        if (volumeState.volumeTitle == null) ...[
          ResponsiveTitle(
            title: "I",
          ),
        ],
        if (volumesList != null) ...[
          PageView.builder(
            controller: _controller,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: volumesList.length,
            itemBuilder: (context, index) {
              print("current page view index: $index");
              final volume = volumesList[index];
              currentVolume = volume;
              volumeState.updateVolumeTitle(volume.volumeTitle);
              final bool active = index == currentPage;
              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: VolumeCards(
                    controller: _controller,
                    volumeTitle: volume.volumeTitle,
                    image: volume.image,
                    numberOfStories: volume.numberOfStories,
                    stories: volume.stories,
                    productID: volume.productID,
                    index: index,
                    state: active,
                  ),
                ),
              );
            },
          ),
          // ),
        ],
        if (volumesList == null) ...[],
      ],
    );
  }
}
