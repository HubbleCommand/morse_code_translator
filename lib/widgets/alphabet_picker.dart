import 'package:flutter/material.dart';
import 'package:morse_code_translator/models/alphabet.dart';
import 'package:morse_code_translator/widgets/settings_container.dart';

class AlphabetPickerWidget extends StatefulWidget {
  AlphabetPickerWidget({super.key});

  @override
  _AlphabetPickerWidgetState createState() => _AlphabetPickerWidgetState();
}

class _AlphabetPickerWidgetState extends State<AlphabetPickerWidget> {
  final List<bool> isSelected = List.filled(3, false);
  final List<Alphabet> alphabets = [AlphabetOriginal(), AlphabetITU(), AlphabetGerke()];

  _buildButtons(alphabets){
    List<Widget> alphabetButtons = [];
    
    for(Alphabet alphabet in alphabets) {
      String alphabetName = alphabet.name;
      alphabetButtons.add(
        Padding(
          padding: EdgeInsets.all(20),
          child:Text(
              '$alphabetName',
              //style: TextStyle(fontSize: 22)
          )
        ),
      );
    }
    
    return alphabetButtons;
  }


  @override
  Widget build(BuildContext context) {
    final settingsContainer = SettingsContainer.of(context);

    if(alphabets.length == isSelected.length){
      for(int index = 0; index < alphabets.length; index++){
        if(alphabets[index].name == settingsContainer.settingsService.alphabet.name){
          isSelected[index] = true;
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          borderRadius: BorderRadius.circular((20)),
          renderBorder: false,
          children: _buildButtons(alphabets),
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected[buttonIndex] = true;
                } else {
                  isSelected[buttonIndex] = false;
                }
              }
              settingsContainer.settingsService.setAlphabet(alphabets[index]);
            });
          },
          isSelected: isSelected,
        ),
      ],
    );
  }
}
