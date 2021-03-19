import 'package:flutter/material.dart';
import 'package:morse_code_translator/controllers/translator.dart';
import 'package:morse_code_translator/models/alphabet.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/controllers/haptic_player.dart';

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

  @override
  Widget build(BuildContext context) {
    print(isSelected);
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
                      // Add TextFormFields and ElevatedButton here.
                      ToggleButtons(
                        children: <Widget>[
                          Icon(Icons.lightbulb),
                          Icon(Icons.vibration),
                          Icon(Icons.audiotrack),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                          });
                        },
                        isSelected: isSelected,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Enter the text to translate'
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        //onFieldSubmitted: (String value){_title=value;},
                        onSaved: (value) {
                          setState(() {
                            _textToTranslate = value;
                          });
                        },
                      ),
                      Row(
                        children: [],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.

                            _formKey.currentState.save();

                            ScaffoldMessenger
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Processing Data')));
                            //print(_formKey.currentState);

                            setState(() {
                              var translated = Translator.translateToMorse(_textToTranslate, AlphabetITU());
                              print('Translated: $translated');
                              _textTranslated = translated;
                            });

                            if(isSelected[0]){

                            }

                            if(isSelected[1]){

                            }

                            if(isSelected[2]){

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
        Expanded(
          flex: 5,
          child: Container(
            // this container won't be larger than
            // half of its parent size
            child: Row(
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
                  label: Text(""),
                )
              ],
            )
          ),
        ),
      ],
    );
  }
}