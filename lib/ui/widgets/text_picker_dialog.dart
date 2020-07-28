import 'package:flutter/material.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:stor_paper/utils/all_shared_prefs.dart';

// dialog that allows user to select the text size they would like 
// to read at

class TextSizePickerDialog extends StatefulWidget {
  const TextSizePickerDialog({Key key, this.initialFontSize, this.storyKey})
      : super(key: key);
  final double initialFontSize;
  final String storyKey;

  @override
  _TextSizePickerDialogState createState() => _TextSizePickerDialogState();
}

class _TextSizePickerDialogState extends State<TextSizePickerDialog> {
  double _textSize;

  @override
  void initState() {
    super.initState();
    _textSize = widget.initialFontSize;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const SizedBox(
          height: 40,
        ),
        Text(
          'A',
          style: TextStyle(
            fontSize: _textSize,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white.withOpacity(0.8),
              inactiveTrackColor: const Color(0xFF8D8E98).withOpacity(0.6),
              thumbColor: const Color(0xF0373F51),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              overlayColor: const Color(0xF0373F51).withOpacity(0.5)),
          child: Slider(
            value: _textSize,
            min: 15,
            max: 40,
            onChanged: (double newValue) {
              AllSharedPrefs().saveTextSize('TextSize', newValue);
              setState(() {
                _textSize = newValue;
              });
            },
          ),
        ),
      ]),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              // Use the second argument of Navigator.pop(...) to pass
              // back a result to the page that opened the dialog
              Navigator.pop(context, _textSize);
            },
            child: Text(
              'SET',
              style: buildTheme().textTheme.bodyText2,
            ))
      ],
    );
  }
}
