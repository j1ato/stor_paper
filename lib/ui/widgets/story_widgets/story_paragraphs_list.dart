import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:stor_paper/ui/widgets/popup_dialogs/glossary_alert_dialog.dart';
import 'package:stor_paper/ui/widgets/story_widgets/read_screen_favorite_button.dart';
import 'package:stor_paper/ui/widgets/popup_dialogs/text_picker_dialog.dart';
import 'package:stor_paper/providers/all_shared_prefs.dart';

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
  double initialScroll;
  double _textSize = 16;
  ScrollController _storyController;
  AllSharedPrefs sharedPrefs = AllSharedPrefs();

  @override
  void initState() {
    super.initState();
    sharedPrefs.readOffset(widget.stories['id']).then(
      (savedOffset) {
        _storyController = ScrollController(initialScrollOffset: savedOffset);
      },
    );
    sharedPrefs.readTextSize('TextSize').then(
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
        builder: (context) => GlossaryAlertDialog(
              glossaryItems: widget.stories['glossary'],
            ));
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
      _storyController.addListener(
        () {
          if (_storyController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            final double position = _storyController.position.pixels;

            AllSharedPrefs().saveOffset(widget.stories['id'], position);
            print(position);
          } else {
            if (_storyController.position.userScrollDirection ==
                ScrollDirection.forward) {
              final double position = _storyController.position.pixels;
              AllSharedPrefs().saveOffset(widget.stories['id'], position);
              print(position);
            }
          }
        },
      );
    }

    final List<Widget> textElements = [];

    for (final String paragraph in widget.storyParagraphs) {
      textElements.add(
        Text(
          paragraph.replaceAll("\\n  ", "\n\n\n"),
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: _textSize,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
      );
      textElements.add(
        const SizedBox(
          height: 20,
        ),
      );
    }

    return Scaffold(
      floatingActionButton: ReadScreenFavoriteButton(
        storyID: widget.stories['id'],
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text(
            widget.stories['storyTitle'],
            style: buildTheme().textTheme.headline2,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
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
              itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
                PopupMenuItem<dynamic>(
                  value: 1,
                  child: Text(
                    'Text Size',
                    style: buildTheme().textTheme.bodyText2,
                  ),
                ),
                PopupMenuItem<dynamic>(
                  value: 2,
                  child: Text(
                    'Glossary',
                    style: buildTheme().textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ],
          backgroundColor: buildTheme().appBarTheme.color,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        controller: _storyController,
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
        children: textElements,
      ),
    );
  }
}
