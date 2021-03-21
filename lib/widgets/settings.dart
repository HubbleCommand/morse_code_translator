import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//typedef ElementDurationCallback = void Function(int elementDuration);

/*
class TranslateFromMorsePage extends StatefulWidget {
  TranslateFromMorsePage({Key key}) : super(key: key);

  @override
  _TranslateFromMorsePageState createState() => _TranslateFromMorsePageState();
}

class _TranslateFromMorsePageState extends State<TranslateFromMorsePage> {
 */
class SettingsWidget extends StatefulWidget {
  final int elementDuration;
  final Function onElementDurationCallbackSelect;
  SettingsWidget({Key key, @required this.elementDuration, @required this.onElementDurationCallbackSelect}) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState(elementDuration: elementDuration, onElementDurationCallbackSelect: onElementDurationCallbackSelect);
}

class _SettingsWidgetState extends State<SettingsWidget> {
  int elementDuration;

  final _formKey = GlobalKey<FormState>();

  _SettingsWidgetState({@required elementDuration, @required onElementDurationCallbackSelect}){
    this.elementDuration = elementDuration;
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
              ElevatedButton(
                onPressed: (){
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.onElementDurationCallbackSelect(elementDuration);
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