import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:morse_code_translator/controllers/translator.dart';
import 'package:morse_code_translator/models/alphabet.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/widgets/audiovis_player.dart';
import 'package:morse_code_translator/widgets/copy_clipboard.dart';

class TranslateToMorsePage extends StatefulWidget {
  final int elementDuration;
  final Alphabet alphabet;
  TranslateToMorsePage({Key key, this.elementDuration, this.alphabet}) : super(key: key);

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
    //https://api.flutter.dev/flutter/widgets/Expanded-class.html
    return Expanded(
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white/*.withOpacity(0.5)*/,
                  borderRadius: BorderRadius.circular(5)
              ),
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
                          print(widget.alphabet.name);
                          if (_formKey.currentState.validate()) { // Validate returns true if the form is valid, otherwise false.
                            _formKey.currentState.save();

                            try{
                              setState(() {
                                var translated = Translator.translateToMorse(_textToTranslate, widget.alphabet);
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
            )
          ),
          //Divider(thickness: 2.5),
          Expanded(
            flex: 5,
            child: Container(
              // this container won't be larger than
              // half of its parent size
                /*decoration: BoxDecoration(
                    color: Colors.blueAccent/*.withOpacity(0.5)*/,
                    borderRadius: BorderRadius.circular(5)
                ),*/
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*Text(
                      'Translation',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),*/
                    Padding(
                        padding: EdgeInsets.all(10),
                        child:Text(
                          '$_textTranslated',
                          style: TextStyle(color: Colors.black),
                        ),
                    ),
                    CopyToClipboardWidget(
                      onTapCopy: (){
                        return _textTranslated;
                      },
                    ),
                    AudioVisualPlayerWidget(
                      elementDuration: widget.elementDuration,
                      onPlayCallback: (){
                        return _textTranslated;
                      },
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}