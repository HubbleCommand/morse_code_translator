import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:morse_code_translator/controllers/translator.dart';
import 'package:morse_code_translator/models/alphabet.dart';
import 'package:flutter/services.dart';

import 'package:morse_code_translator/widgets/audiovis_player.dart';
import 'package:morse_code_translator/widgets/copy_clipboard.dart';

class TranslateFromMorsePage extends StatefulWidget {
  final int elementDuration;
  final Alphabet alphabet;

  TranslateFromMorsePage({Key key, this.elementDuration, this.alphabet}) : super(key: key);

  @override
  _TranslateFromMorsePageState createState() => _TranslateFromMorsePageState();
}

class _TranslateFromMorsePageState extends State<TranslateFromMorsePage> {
  final _formKey = GlobalKey<FormState>();
  String _textToTranslate = '';
  String _textTranslated = '';

  TextEditingController textEditingController = TextEditingController();

  final FilteringTextInputFormatter morseCodeFilter = FilteringTextInputFormatter.allow(RegExp("[. -]"));

  _TranslateFromMorsePageState(){
    //This seems to fix the issue of the cursor inserting chars at the second last index instead of at the end if the user hasn't placed the cursor in the text field
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: 0, affinity: TextAffinity.upstream),
    );
  }

  String insertSymbolAtLocation(int index, String text, String symbol){
    if(index <= 0){
      return symbol += text;
    } else if (index >= text.length){
      return text += symbol;
    } else {
      String first = text.substring(0, index);
      String last = text.substring(index);
      return first + symbol + last;
    }
  }

  void updateMorseCodeString(String text){
    var start = textEditingController.selection.start;
    var startWord = textEditingController.selection.toString();
    var fullWord = textEditingController.text;
    print('TEC Selection: $start');
    print('TEC SelectionWord: $startWord');
    print('TEC FullWord: "$fullWord"');

    int currentCursorPosition = textEditingController.selection.start;

    textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, text);

    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: currentCursorPosition + text.length, affinity: TextAffinity.upstream),
    );

    print('Setting text to: ' + textEditingController.text);
    setState(() {
      _textToTranslate = textEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                TextFormField(
                  controller: textEditingController,
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
                  onChanged: (value){
                    print('Value changed to: $value');
                    setState(() {
                      _textToTranslate = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: (){
                        /*var start = textEditingController.selection.start;
                        var startWord = textEditingController.selection.toString();
                        var fullWord = textEditingController.text;
                        print('TEC Selection: $start');
                        print('TEC SelectionWord: $startWord');
                        print('TEC FullWord: "$fullWord"');
                        //int currentCursorPosition = textEditingController.selection.start < 0 ? 0 : textEditingController.selection.start;
                        int currentCursorPosition = textEditingController.selection.start;*/

                        /*if(textEditingController.text.length == 0){
                              textEditingController.text += '.';
                            } else {
                              String first = textEditingController.text.substring(0, textEditingController.selection.start);
                              String last = '';
                              if(textEditingController.selection.start <= 0) {

                              } else if(textEditingController.selection.start < textEditingController.text.length && textEditingController.text.length != 0){
                                last = textEditingController.text.substring(textEditingController.selection.start+1);
                              }

                              textEditingController.text = first + '.' + last;
                              //textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, '.');
                            }*/
                        //textEditingController.text += '.';
                        /*textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, '.');

                        textEditingController.selection = TextSelection.fromPosition(
                          //TextPosition(offset: currentCursorPosition + 1, affinity: TextAffinity.upstream),
                          TextPosition(offset: currentCursorPosition + 1),
                        );*/
                        this.updateMorseCodeString('.');
                      },
                      child: Text('.'),
                    ),
                    OutlinedButton(
                      onPressed: (){
                        /*int currentCursorPosition = textEditingController.selection.start;

                        textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, '-');

                        textEditingController.selection = TextSelection.fromPosition(
                          TextPosition(offset: currentCursorPosition + 1, affinity: TextAffinity.upstream),
                        );*/
                        this.updateMorseCodeString('-');
                      },
                      child: Text('-'),
                    ),
                    OutlinedButton(
                      onPressed: (){
                        /*int currentCursorPosition = textEditingController.selection.start;

                        textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, '   ');
                        //textEditingController.selection.start = currentCursorPosition + 1;

                        textEditingController.selection = TextSelection.fromPosition(
                          TextPosition(offset: currentCursorPosition + 3),
                        );*/
                        this.updateMorseCodeString('   ');
                      },
                      child: Text("CHAR SPACE"),
                    ),
                    OutlinedButton(
                      onPressed: (){
                        /*int currentCursorPosition = textEditingController.selection.start;

                        textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, '       ');

                        textEditingController.selection = TextSelection.fromPosition(
                          TextPosition(offset: currentCursorPosition + 7),
                        );*/
                        this.updateMorseCodeString('       ');
                      },
                      child: Text('WORD SPACE'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: AudioVisualPlayerWidget(
                      elementDuration: widget.elementDuration,
                      onPlayCallback: (){
                        print('Calling with text $_textToTranslate');
                        return _textToTranslate;
                      },
                    ),),
                    Expanded(child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.

                          _formKey.currentState.save();

                          //print(_formKey.currentState);
                          print('Trying to translate: "$_textToTranslate"');
                          try{
                            setState(() {
                              var translated = Translator.translateFromMorse(_textToTranslate, widget.alphabet);
                              print('Translated: $translated');
                              _textTranslated = translated;
                            });
                          } on TranslationError catch (e) {
                            print(e.cause);
                            _textTranslated = '';
                            ScaffoldMessenger
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Malformed morse code: ' + e.cause)));
                          }
                        }
                      },
                      child: Text('Translate'),
                    ),)
                  ],
                ),
              ]
          ),
        ),
        Divider(thickness: 2.5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$_textTranslated'),
            CopyToClipboardWidget(
              onTapCopy: (){
                return _textTranslated;
              },
            ),
          ],
        )
      ],
    );
  }
}