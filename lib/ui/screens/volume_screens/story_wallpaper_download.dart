import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:stor_paper/ui/widgets/popup_dialogs/flushbars.dart';
import 'package:stor_paper/ui/widgets/shared_widgets/wallpaper_download_button.dart';

// fullscreen view of story artwork where you can download the images
// flushbar indicates download has begun and ended and code also 
// checks user permsission to allow access to storage

class DownloadStoryWallpaper extends StatefulWidget {
  const DownloadStoryWallpaper({
    this.imageString,
    this.storyID,
  });
  final String imageString;
  final String storyID;
  @override
  _DownloadStoryWallpaperState createState() => _DownloadStoryWallpaperState();
}

class _DownloadStoryWallpaperState extends State<DownloadStoryWallpaper> {
  Function onSetWallpaperPressed;
  Function onBackPressed;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        _progress = progress;
        if (_progress == 100) {
          Flushbars().downloadStatusFlushbar(context, 'Download complete!');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.imageString,
            imageBuilder: (context, imageProvider) {
              return Hero(
                tag: widget.storyID,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
          Positioned(
            child: RawMaterialButton(
              constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 25,
                color: Colors.white.withOpacity(0.9),
              ),
              fillColor: Colors.black.withOpacity(0.001),
              shape: const CircleBorder(),
            ),
            top: 5,
            left: 5,
          ),
          DownloadButton(
            imageString: widget.imageString,
          ),
        ],
      ),
    );
  }
}

