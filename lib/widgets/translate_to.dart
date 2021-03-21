import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:morse_code_translator/controllers/translator.dart';
import 'package:morse_code_translator/models/alphabet.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/widgets/audiovis_player.dart';
import 'copy_clipboard.dart';

class TranslateToMorsePage extends StatefulWidget {
  TranslateToMorsePage({Key key}) : super(key: key);

  @override
  _TranslateToMorsePageState createState() => _TranslateToMorsePageState();
}

class _TranslateToMorsePageState extends State<TranslateToMorsePage> {
  List<bool> isSelected = [false, false, false];
  final _formKey = GlobalKey<FormState>();
  String _textToTranslate = '';
  String _textTranslated = '';

  final FilteringTextInputFormatter morseCodeFilter = FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"));

  @override
  Widget build(BuildContext context) {
    print(isSelected);
    print('Translated text: $_textTranslated');
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Enter the text to translate'
                  ),
                  inputFormatters: [morseCodeFilter],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;  //MUST RETURN NULL
                  },
                  //onFieldSubmitted: (String value){_title=value;},
                  onSaved: (value) {
                    setState(() {
                      _textToTranslate = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) { // Validate returns true if the form is valid, otherwise false.
                      _formKey.currentState.save();

                      try{
                        setState(() {
                          var translated = Translator.translateToMorse(_textToTranslate, AlphabetITU());
                          print('Translated: $translated');
                          _textTranslated = translated;
                          print(isSelected);
                        });
                      } on TranslationError catch (e) {
                        setState(() {
                          _textTranslated = '';
                          print('Could not translate...' + e.cause);
                        });
                      }
                    }
                  },
                  child: Text('Translate'),
                ),
              ]
            ),
          ),
        ),
        Divider(thickness: 2.5),
        Expanded(
          flex: 5,
          child: Container(
            // this container won't be larger than
            // half of its parent size
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Translation',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text('$_textTranslated'),
                CopyToClipboardWidget(
                  onTapCopy: (){
                    return _textTranslated;
                  },
                ),
                AudioVisualPlayerWidget(
                  onPlayCallback: (){
                    return _textTranslated;
                  },
                ),
              ],
            )
          ),
        ),
      ],
    );
  }
}