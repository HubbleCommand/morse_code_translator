import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/widgets/alphabet_picker.dart';
import 'package:morse_code_translator/widgets/settings_container.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({super.key});

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final List<bool> selectedAlphabet = [false, false, false];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final settingsContainer = SettingsContainer.of(context);

    switch(settingsContainer.settingsService.alphabet.name){
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

    return Container(
        child: new Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: new TextEditingController(text: '${settingsContainer.settingsService.elementDuration}'),
                decoration: new InputDecoration(labelText: "Element duration (milliseconds)"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                validator: (value){
                  if (value != null && value.isEmpty) {
                    return "Please enter a number";
                  }
                  if(value != null && int.parse(value) <= 0) {
                    return "Please enter a positive non-null value";
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value == null) {
                    return;
                  }

                  int? duration = int.tryParse(value);
                  if (duration == null) {
                    return;
                  }
                  settingsContainer.settingsService.setDuration(duration);
                },
              ),
              AlphabetPickerWidget(),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    settingsContainer.settingsService.writeToPreferences();
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Apply"),
              )
            ],
          ),
        )
    );
  }
}
