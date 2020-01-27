import 'package:flutter/material.dart';
import 'package:stor_paper/model/volume_class.dart';
import 'package:stor_paper/ui/widgets/volume_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stor_paper/utils/user_repository.dart';

// pageview that scrolls horizontally that displays cover art for
// a perticular volume, user can swipe betweem volumes
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
  Volume collection;

  CollectionReference collectionReference =
      Firestore.instance.collection('Volumes');

  Stream<QuerySnapshot> streamSnapshots;

  List<DocumentSnapshot> volumesList;

  int currentPage = 0;

  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    UserRepository().createFavorites();
  }

  StreamBuilder<QuerySnapshot> _buildCollections() {
    streamSnapshots = collectionReference.snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: streamSnapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          volumesList = snapshot.data.documents;
          return PageView.builder(
            controller: _controller,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final volume = snapshot.data.documents[index];
              collection = Volume.fromMap(volume.data, volume.documentID);
              return VolumesCard(
                controller: _controller,
                volumeTitle: collection.volumeTitle,
                image: collection.image,
                numberOfStories: collection.numberOfStories,
                stories: collection.stories,
                productID: collection.productID,
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: <Widget>[
          Expanded(
            child: _buildCollections(),
          )
        ],
      )),
    );
  }
}
