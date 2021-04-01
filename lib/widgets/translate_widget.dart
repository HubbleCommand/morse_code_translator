import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:morse_code_translator/controllers/translator.dart';
import 'package:morse_code_translator/models/alphabet.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/widgets/audiovis_player.dart';
import 'package:morse_code_translator/widgets/copy_clipboard.dart';
import 'package:morse_code_translator/widgets/morse_field.dart';

class TranslateWidget extends StatefulWidget {
  final int elementDuration;
  final Alphabet alphabet;
  TranslateWidget({Key key, this.elementDuration, this.alphabet}) : super(key: key);

  @override
  _TranslateWidgetState createState() => _TranslateWidgetState();
}

class _TranslateWidgetState extends State<TranslateWidget> {
  final _formKeyAlhpa = GlobalKey<FormState>();
  final _formKeyMorse = GlobalKey<FormState>();
  String _textToTranslate = '';
  String _textTranslated = '';
  String _morseString = '';
  String _alphaString = '';

  TextEditingController _controller = TextEditingController();
  bool _readOnly = true;

  void _insertText(String myText) {
    final text = _controller.text;
    final textSelection = _controller.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }

  void _backspace() {
    final text = _controller.text;
    final textSelection = _controller.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _controller.text = newText;
      _controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }

    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: OrientationBuilder(
        builder: (context, orientation){
          if(orientation == Orientation.portrait){
            return Stack(
              fit: StackFit.expand,
              children: [
                SizedBox(height: 50),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  style: TextStyle(fontSize: 24),
                  autofocus: true,
                  showCursor: true,
                  readOnly: _readOnly,
                ),
                IconButton(
                  icon: Icon(Icons.keyboard),
                  onPressed: () {
                    setState(() {
                      _readOnly = !_readOnly;
                    });
                  },
                ),
                Spacer(),
                MorseKeyboard(
                  onTextInput: (myText) {
                    _insertText(myText);
                  },
                  onBackspace: () {
                    _backspace();
                  },
                ),
              ],
            );
          }else{
            //return landscapeMode();
            return Stack();
          }
        },
      )
    );
  }
}
