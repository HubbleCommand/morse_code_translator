import 'package:flutter/foundation.dart';
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

  final FilteringTextInputFormatter morseCodeFilter = FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"));

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
                        inputFormatters: [morseCodeFilter],
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
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            setState(() {
                              var translated = Translator.translateToMorse(_textToTranslate, AlphabetITU());
                              print('Translated: $translated');
                              _textTranslated = translated;
                              print(isSelected);
                            });

                            HapticPlayer hapticPlayer = new HapticPlayer();

                            if(isSelected[0]){
                              print('Turning on light...');
                              hapticPlayer.addPlayer(new HapticPlayerLightDecorator());
                            }

                            if(isSelected[1]){
                              print('Turning on vibrations...');
                              hapticPlayer.addPlayer(new HapticPlayerVibrateDecorator());
                            }

                            if(isSelected[2]){
                              print('Turning on audio...');
                              hapticPlayer.addPlayer(new HapticPlayerAudioDecorator());
                            }

                            //await compute(hapticPlayer.playText, _textTranslated);
                            //compute(hapticPlayer.playText, _textTranslated);
                            if(hapticPlayer.players.isNotEmpty){  //If there are players, play
                              hapticPlayer.playText(_textTranslated);
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
                Text(
                  'Translation',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text('$_textTranslated'),
                TextButton.icon(
                  onPressed: () async {
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