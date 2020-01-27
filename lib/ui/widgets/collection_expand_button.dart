import 'package:flutter/material.dart';
import 'package:stor_paper/ui/screens/volume_wallpaper_download.dart';

// expand button that triggers hero animation 
// to fullscreen view of volume artwork

class ExpandButton extends StatelessWidget {
  const ExpandButton({@required this.imageURL});

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;

    return Positioned(
      bottom: pageHeight * 0.005,
      left: pageWidth * 0.02,
      child: RawMaterialButton(
        constraints: BoxConstraints.tight(const Size(25, 25)),
        onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadWallpaper(
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
      ),
    );
  }
}
