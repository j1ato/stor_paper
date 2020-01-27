import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:stor_paper/ui/widgets/glossary_alert_dialog.dart';
import 'package:stor_paper/ui/widgets/read_screen_favorite_button.dart';
import 'package:stor_paper/ui/widgets/text_picker_dialog.dart';
import 'package:stor_paper/utils/all_shared_prefs.dart';

// where user reads story and scroll location is saved and retrieved
// textsize preference is also saved and retrieved between app
// restarts

class StoryParagraphs extends StatefulWidget {
  const StoryParagraphs({this.storyParagraphs, this.stories});

  final List<dynamic> storyParagraphs;
  final Map stories;

  @override
  _StoryParagraphsState createState() => _StoryParagraphsState();
}

class _StoryParagraphsState extends State<StoryParagraphs> {
  ScrollController _storyController;
  double initialScroll;
  double _textSize = 16;
  bool _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = true;
    AllSharedPrefs().readOffset(widget.stories['id']).then((value) {
      _storyController = ScrollController(initialScrollOffset: value);
    });
    AllSharedPrefs().readTextSize('TextSize').then(
      (savedTextSize) {
        setState(
          () {
            _textSize = savedTextSize;
          },
        );
      },
    );
  }

  Future<double> _showGlossaryDialog() async {
    final glossary = await showDialog<double>(
      context: context,
      builder: (context) =>
      GlossaryAlertDialog(glossaryItems: widget.stories['glossary'],)
    );
    return glossary;
  }

  void _showFontSizePickerDialog() {
    showDialog<double>(
      barrierDismissible: false,
      context: context,
      builder: (context) => ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 100),
          child: TextSizePickerDialog(
            initialFontSize: _textSize,
            storyKey: widget.stories['id'],
          )),
    ).then(
      (newFontSize) {
        setState(
          () {
            _textSize = newFontSize;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_storyController != null) {
      _storyController.addListener(() {
        if (_storyController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          final double position = _storyController.position.pixels;

          AllSharedPrefs().saveOffset(widget.stories['id'], position);
          print(position);
          if (_isVisible == true) {
            setState(() {
              _isVisible = false;
            });
          }
        } else {
          if (_storyController.position.userScrollDirection ==
              ScrollDirection.forward) {
            final double position = _storyController.position.pixels;
            AllSharedPrefs().saveOffset(widget.stories['id'], position);
            print(position);

            if (_isVisible == false) {
              setState(() {
                _isVisible = true;
              });
            }
          }
        }
      });
    }

    final List<Widget> textElements = [];
    for (final paragraph in widget.storyParagraphs) {
      textElements.add(
        Text(
          paragraph,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: _textSize,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      );
      textElements.add(
        const SizedBox(
          height: 10,
        ),
      );
    }
    return Scaffold(
      floatingActionButton: Visibility(
          visible: _isVisible,
          child: ReadScreenFavoriteButton(
            storyID: widget.stories['id'],
          )),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Visibility(
          visible: _isVisible,
          child: AppBar(
            title: Text(
              widget.stories['storyTitle'],
              style: buildTheme().textTheme.display2,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
                // user.getFavorites();
              },
            ),
            actions: <Widget>[
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 1) {
                    _showFontSizePickerDialog();
                  } else if (value == 2) {
                    _showGlossaryDialog();
                  }
                },
                onCanceled: null,
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<dynamic>>[
                  PopupMenuItem<dynamic>(
                    value: 1,
                    child: Text(
                      'Text Size',
                      style: buildTheme().textTheme.body2,
                    ),
                  ),
                  PopupMenuItem<dynamic>(
                    value: 2,
                    child: Text(
                      'Glossary',
                      style: buildTheme().textTheme.body2,
                    ),
                  ),
                ],
              ),
            ],
            backgroundColor: buildTheme().appBarTheme.color,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics()),
        controller: _storyController,
        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
        children: textElements,
      ),
    );
  }
}
