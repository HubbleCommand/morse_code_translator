import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:morse_code_translator/controllers/translator.dart';
import 'package:morse_code_translator/models/alphabet.dart';
import 'package:flutter/services.dart';

class TranslateFromMorsePage extends StatefulWidget {
  TranslateFromMorsePage({Key key}) : super(key: key);

  @override
  _TranslateFromMorsePageState createState() => _TranslateFromMorsePageState();
}

class _TranslateFromMorsePageState extends State<TranslateFromMorsePage> {
  final _formKey = GlobalKey<FormState>();
  String _textToTranslate = '';
  String _textTranslated = '';

  TextEditingController textEditingController = TextEditingController();

  final FilteringTextInputFormatter morseCodeFilter = FilteringTextInputFormatter.allow(RegExp("[. -]"));

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Align(
            alignment: Alignment.topCenter,
            child:
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlineButton(
                          onPressed: (){
                            var start = textEditingController.selection.start;
                            print('TEC Selection: $start');
                            int currentCursorPosition = textEditingController.selection.start;

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
                            textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, '.');

                            textEditingController.selection = TextSelection.fromPosition(
                              TextPosition(offset: currentCursorPosition + 1),
                            );
                          },
                          child: Text('.'),
                        ),
                        OutlineButton(
                          onPressed: (){
                            int currentCursorPosition = textEditingController.selection.start;

                            textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, '-');

                            textEditingController.selection = TextSelection.fromPosition(
                              TextPosition(offset: currentCursorPosition + 1),
                            );
                          },
                          child: Text('-'),
                        ),
                        OutlineButton(
                          onPressed: (){
                            int currentCursorPosition = textEditingController.selection.start;

                            textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, '   ');
                            //textEditingController.selection.start = currentCursorPosition + 1;

                            textEditingController.selection = TextSelection.fromPosition(
                              TextPosition(offset: currentCursorPosition + 3),
                            );
                          },
                          child: Text("CHAR SPACE"),
                        ),
                        OutlineButton(
                          onPressed: (){
                            int currentCursorPosition = textEditingController.selection.start;

                            textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, '       ');

                            textEditingController.selection = TextSelection.fromPosition(
                              TextPosition(offset: currentCursorPosition + 7),
                            );
                          },
                          child: Text('WORD SPACE'),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.

                          _formKey.currentState.save();

                          //print(_formKey.currentState);
                          print('Trying to translate: $_textToTranslate');
                          try{
                            setState(() {
                              var translated = Translator.translateFromMorse(_textToTranslate, AlphabetITU());
                              print('Translated: $translated');
                              _textTranslated = translated;
                            });
                          } on TranslationError catch (e) {
                            print(e.cause);
                            _textTranslated = '';
                            ScaffoldMessenger
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Malformed morse code')));
                          }
                        }
                      },
                      child: Text('Translate'),
                    ),
                  ]
              ),
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
                  Text('$_textTranslated'),
                  TextButton.icon(
                    onPressed: () async {
                      // Respond to button press
                      ClipboardData data = ClipboardData(text: '$_textTranslated');
                      await Clipboard.setData(data);

                      ScaffoldMessenger
                          .of(context)
                          .showSnackBar(SnackBar(content: Text('Morse Code copied to clipboard')));
                    },
                    icon: Icon(Icons.sticky_note_2, size: 18),
                    label: Text("Copy to Clipboard"),
                  )
                ],
              )
          ),
        ),
      ],
    );
  }
}