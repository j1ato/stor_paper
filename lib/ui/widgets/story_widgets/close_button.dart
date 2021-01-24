import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/providers/controller_states.dart';

class PageCloseButton extends StatelessWidget {
  
  const PageCloseButton({@required this.onTap});

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    var volumeStoriesOffset =
        Provider.of<StoriesScreenState>(context).volumeStoriesOffset;

    return Positioned(
      top: 20 - volumeStoriesOffset * 0.8,
      left: 20,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          Icons.close,
          size: 25,
          color: Color(0xF042444F).withOpacity(0.3),
        ),
      ),
    );
  }
}
