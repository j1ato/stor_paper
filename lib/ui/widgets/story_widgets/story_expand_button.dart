import 'package:flutter/material.dart';
import 'package:stor_paper/ui/screens/volume_screens/story_wallpaper_download.dart';

// expand button that triggers hero animation 
// to fullscreen view of story artwork

class StoryExpandButton extends StatelessWidget {
  const StoryExpandButton({@required this.imageURL, this.storyID});

  final String imageURL;
  final String storyID;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(const Size(25, 25)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DownloadStoryWallpaper(
              storyID: storyID,
              imageString: imageURL,
            ),
          ),
        );
      },
      child: Icon(
        Icons.fullscreen,
        size: 20,
        color: Colors.white.withOpacity(0.6),
      ),
      elevation: 0,
      fillColor: Colors.black.withOpacity(0.03),
      shape: const CircleBorder(),
    );
  }
}
