import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stor_paper/ui/widgets/popup_dialogs/flushbars.dart';


// button that intiates download after checking user persmissions
// once image downloaded user is prompted to view the download

class DownloadButton extends StatefulWidget {
  const DownloadButton(
      {@required this.imageString,
      this.callback,
      this.status,
      this.requestPermission});
  final String imageString;
  final ImageDownloader callback;
  final PermissionStatus status;
  final Function requestPermission;

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  PermissionStatus _status;

  Future<void> _downloadImage() async {
    final imageId = await ImageDownloader.downloadImage(widget.imageString);
    final path = await ImageDownloader.findPath(imageId);
     await ImageDownloader.open(path);
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then(_updateStatus);
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  void _requestPermission() {
    PermissionHandler().requestPermissions([PermissionGroup.storage]).then(
        _onPermissionRequested);
  }

  void _onPermissionRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.storage];
    _updateStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: RawMaterialButton(
        constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
        onPressed: () {
          if (_status == PermissionStatus.granted) {
            Flushbars()
                .downloadStatusFlushbar(context, 'Downloading artwork...');
            try {
              _downloadImage();
            } on Exception catch (e) {
              print(e);
            }
          } else if (_status == PermissionStatus.denied) {
            _requestPermission();
          }
        },
        child: Icon(
          Icons.file_download,
          size: 20,
          color: Colors.white.withOpacity(0.9),
        ),
        fillColor: Colors.black.withOpacity(0.01),
        shape: const CircleBorder(),
      ),
      top: 5,
      right: 5,
    );
  }
}
