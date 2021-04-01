import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/models/alphabet.dart';
import 'package:morse_code_translator/widgets/alphabet_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsWidget extends StatefulWidget {
  final int elementDuration;
  final Alphabet alphabet;
  final Function onElementDurationCallback;
  final Function onAlphabetCallback;
  SettingsWidget({Key key, @required this.elementDuration, @required this.alphabet, @required this.onElementDurationCallback, @required this.onAlphabetCallback}) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState(elementDuration: elementDuration, alphabet: alphabet);
}

class _SettingsWidgetState extends State<SettingsWidget> {
  int elementDuration;
  Alphabet alphabet;
  List<bool> selectedAlphabet = [false, false, false];

  final _formKey = GlobalKey<FormState>();

  _SettingsWidgetState({@required elementDuration, @required alphabet}){
    this.elementDuration = elementDuration ?? 240;
    this.alphabet = alphabet ?? AlphabetITU();
    switch(alphabet.name){
      case 'ITU':
        selectedAlphabet[0] = true;
      break;
      case 'Original':
        selectedAlphabet[1] = true;
      break;
      case 'Gerke':
        selectedAlphabet[2] = true;
      break;
      default:
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //padding: const EdgeInsets.all(40.0),
        child: new Form(
          key: _formKey,
          child: Column(
            children: [
              new TextFormField(
                controller: new TextEditingController(text: '$elementDuration'),
                decoration: new InputDecoration(labelText: "Element duration (ms)"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                validator: (value){
                  if (value.isEmpty) {
                    return 'Please enter a number';
                  }
                  if(int.parse(value) <= 0) {
                    return 'Please enter a positive non-null value';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    elementDuration = int.parse(value);
                  });
                },
              ),
              AlphabetPickerWidget(
                  onAlphabetPickedCallback: (Alphabet alphabet){
                    setState(() {
                      this.alphabet = alphabet;
                    });
                  },
                  alphabetName: alphabet.name
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.onElementDurationCallback(elementDuration);
                    widget.onAlphabetCallback(alphabet);
                    
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setInt('elementDuration', elementDuration);
                    prefs.setString('alphabet', alphabet.name);
                  }
                },
                child: Text('Apply'),
              )
            ],
          ),
        )
    );
  }
}
