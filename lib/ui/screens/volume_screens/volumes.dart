import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/model/database_models.dart';
import 'package:stor_paper/providers/volume_screen_state.dart';
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

    return ChangeNotifierProvider<VolumeScreenState>(
      create: (context) => VolumeScreenState(_controller),
      child: SafeArea(
        child: Scaffold(
            body: Column(
          children: <Widget>[
            if (volumesList != null) ...[
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: volumesList.length,
                  itemBuilder: (context, index) {
                    double pageOffset = Provider.of<VolumeScreenState>(context).offset;
                    print(pageOffset);
                    final volume = volumesList[index];
                    final bool active = index == currentPage;
                    print(active);
                    return VolumeCards(
                      controller: _controller,
                      volumeTitle: volume.volumeTitle,
                      image: volume.image,
                      numberOfStories: volume.numberOfStories,
                      stories: volume.stories,
                      productID: volume.productID,
                      state: active,
                    );
                  },
                ),
              )
            ],
            if (volumesList == null) ...[Container()]
          ],
        )),
      ),
    );
  }
}
