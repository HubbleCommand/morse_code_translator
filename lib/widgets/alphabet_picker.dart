import 'package:flutter/material.dart';
import 'package:morse_code_translator/models/alphabet.dart';

class AlphabetPickerWidget extends StatefulWidget {
  final Function onAlphabetPickedCallback;
  final String alphabetName;
  AlphabetPickerWidget({Key key, @required this.onAlphabetPickedCallback, @required this.alphabetName}) : super(key: key);

  @override
  _AlphabetPickerWidgetState createState() => _AlphabetPickerWidgetState(alphabetName: alphabetName);
}

class _AlphabetPickerWidgetState extends State<AlphabetPickerWidget> {
  List<bool> isSelected;
  List<Alphabet> alphabets = [AlphabetOriginal(), AlphabetITU(), AlphabetGerke()];

  _AlphabetPickerWidgetState({@required alphabetName}){
    isSelected = List.filled(alphabets.length, false);

    if(alphabets.length == isSelected.length){
      for(int index = 0; index < alphabets.length; index++){
        if(alphabets[index].name == alphabetName){
          isSelected[index] = true;
        }
      }
    }
  }

  _buildButtons(alphabets){
    List<Widget> alphabetButtons;
    
    for(Alphabet alphabet in alphabets) {
      String alphabetName = alphabet.name;
      alphabetButtons.add(Text('$alphabetName'));
    }
    
    return alphabetButtons;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          /*children: <Widget>[
            Text('Original),
            Text('ITU'),
            Text('Gerke'),
          ],*/
          children: _buildButtons(alphabets),
          onPressed: (int index) {
            setState(() {
              //isSelected[index] = !isSelected[index];
              //widget.onAlphabetPickedCallback(alphabets[index]);
              for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected[buttonIndex] = true;
                } else {
                  isSelected[buttonIndex] = false;
                }
              }
              widget.onAlphabetPickedCallback(alphabets[index]);
            });
          },
          isSelected: isSelected,
        ),
      ],
    );
  }
}
